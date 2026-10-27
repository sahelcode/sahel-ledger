import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'remote_store.dart';

/// [RemoteStore] backed by Cloud Firestore.
///
/// Writes run inside Firestore transactions, which only complete once the
/// server has committed, so a returned [WriteOutcome.written] is a real
/// server confirmation (offline, the call fails and the outbox retries).
class FirestoreRemoteStore implements RemoteStore {
  FirestoreRemoteStore(
    this.firestore, {
    this.timeout = const Duration(seconds: 30),
  });

  final FirebaseFirestore firestore;
  final Duration timeout;

  CollectionReference<Map<String, dynamic>> _col(String hid, String c) =>
      firestore.collection('households').doc(hid).collection(c);

  Future<T> _guard<T>(Future<T> Function() op) async {
    try {
      return await op().timeout(timeout);
    } on TimeoutException {
      throw RemoteUnavailable('timeout');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw RemoteDenied(e.message ?? e.code);
      }
      if (const {
        'unavailable',
        'deadline-exceeded',
        'aborted',
        'resource-exhausted',
        'internal',
      }.contains(e.code)) {
        throw RemoteUnavailable(e.code);
      }
      rethrow;
    }
  }

  Map<String, Object?> _plain(Map<String, dynamic> data) {
    Object? conv(Object? v) {
      if (v is Timestamp) return v.millisecondsSinceEpoch;
      if (v is Map) {
        return {for (final e in v.entries) '${e.key}': conv(e.value)};
      }
      if (v is List) return v.map(conv).toList();
      return v;
    }

    return {for (final e in data.entries) e.key: conv(e.value)};
  }

  @override
  Future<RemoteWriteResult> putTransaction(
    String householdId,
    Map<String, Object?> doc,
  ) => _guard(() async {
    final ref = _col(householdId, 'transactions').doc(doc['id']! as String);
    return firestore.runTransaction((t) async {
      final snap = await t.get(ref);
      final remote = snap.exists ? _plain(snap.data()!) : null;
      switch (decideTxWrite(remote, doc)) {
        case TxWriteDecision.create:
        case TxWriteDecision.overwrite:
          t.set(ref, {...doc, 'updatedAtServer': FieldValue.serverTimestamp()});
          return const RemoteWriteResult(WriteOutcome.written);
        case TxWriteDecision.updateMutable:
          t.update(ref, {
            for (final k in txMutableFields)
              if (doc.containsKey(k)) k: doc[k],
            'updatedAtServer': FieldValue.serverTimestamp(),
          });
          return const RemoteWriteResult(WriteOutcome.written);
        case TxWriteDecision.noop:
          return const RemoteWriteResult(WriteOutcome.alreadyPresent);
        case TxWriteDecision.conflict:
          return RemoteWriteResult(WriteOutcome.conflict, remote: remote);
      }
    });
  });

  @override
  Future<RemoteWriteResult> putEntity(
    String householdId,
    String collection,
    String id,
    Map<String, Object?> doc,
  ) => _guard(() async {
    final ref = _col(householdId, collection).doc(id);
    return firestore.runTransaction((t) async {
      final snap = await t.get(ref);
      final remote = snap.exists ? _plain(snap.data()!) : null;
      switch (decideEntityWrite(remote, doc)) {
        case EntityWriteDecision.create:
        case EntityWriteDecision.update:
          t.set(ref, {...doc, 'updatedAtServer': FieldValue.serverTimestamp()});
          return const RemoteWriteResult(WriteOutcome.written);
        case EntityWriteDecision.noop:
          return const RemoteWriteResult(WriteOutcome.alreadyPresent);
        case EntityWriteDecision.conflict:
          return RemoteWriteResult(WriteOutcome.conflict, remote: remote);
      }
    });
  });

  @override
  Future<List<RemoteDoc>> changes(
    String householdId,
    String collection, {
    RemoteCursor? after,
    required String viewerUid,
    required bool viewerReadsAll,
    int limit = 200,
  }) => _guard(() async {
    Query<Map<String, dynamic>> q = _col(householdId, collection);
    if (!viewerReadsAll) {
      // Required by the security rules for non-owner reads.
      q = q.where('readerUids', arrayContains: viewerUid);
    }
    q = q.orderBy('updatedAtServer').orderBy(FieldPath.documentId);
    if (after != null) {
      q = q.startAfter([
        Timestamp.fromMillisecondsSinceEpoch(after.updatedAtMs),
        after.id,
      ]);
    }
    final snap = await q
        .limit(limit)
        .get(const GetOptions(source: Source.server));
    return [
      for (final d in snap.docs)
        if (d.data()['updatedAtServer'] is Timestamp)
          RemoteDoc(
            d.id,
            _plain(d.data()),
            (d.data()['updatedAtServer'] as Timestamp).millisecondsSinceEpoch,
          ),
    ];
  });
}
