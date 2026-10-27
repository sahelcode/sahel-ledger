import 'dart:convert';

import 'package:sahel_ledger/data/sync/remote_store.dart';

/// In-memory stand-in for Firestore with fault injection.
class FakeRemoteStore implements RemoteStore {
  final Map<String, Map<String, Map<String, Object?>>> collections = {};
  final Map<String, Map<String, int>> _updatedAt = {};
  int _clock = 1000;

  /// When true every call throws [RemoteUnavailable].
  bool offline = false;

  /// Number of upcoming writes that commit on the server but whose
  /// acknowledgement is lost (the client sees an error).
  int loseAcks = 0;

  /// Number of upcoming writes that fail before reaching the server.
  int failWrites = 0;

  int writeCalls = 0;

  Map<String, Object?>? doc(String collection, String id) =>
      collections[collection]?[id];

  void _store(String collection, String id, Map<String, Object?> data) {
    // Round-trip through JSON like a real network would.
    collections.putIfAbsent(collection, () => {})[id] =
        jsonDecode(jsonEncode(data)) as Map<String, Object?>;
    _updatedAt.putIfAbsent(collection, () => {})[id] = ++_clock;
  }

  void _guard() {
    if (offline) throw RemoteUnavailable('offline');
  }

  void _beforeWrite() {
    writeCalls++;
    _guard();
    if (failWrites > 0) {
      failWrites--;
      throw RemoteUnavailable('connection reset');
    }
  }

  void _afterWrite() {
    if (loseAcks > 0) {
      loseAcks--;
      throw RemoteUnavailable('deadline exceeded after commit');
    }
  }

  @override
  Future<RemoteWriteResult> putTransaction(
    String householdId,
    Map<String, Object?> doc,
  ) async {
    _beforeWrite();
    const c = 'transactions';
    final id = doc['id']! as String;
    final remote = collections[c]?[id];
    final result = switch (decideTxWrite(remote, doc)) {
      TxWriteDecision.create || TxWriteDecision.overwrite => () {
        _store(c, id, doc);
        return const RemoteWriteResult(WriteOutcome.written);
      }(),
      TxWriteDecision.updateMutable => () {
        final merged = Map<String, Object?>.from(remote!);
        for (final k in txMutableFields) {
          if (doc.containsKey(k)) merged[k] = doc[k];
        }
        _store(c, id, merged);
        return const RemoteWriteResult(WriteOutcome.written);
      }(),
      TxWriteDecision.noop => const RemoteWriteResult(
        WriteOutcome.alreadyPresent,
      ),
      TxWriteDecision.conflict => RemoteWriteResult(
        WriteOutcome.conflict,
        remote: remote,
      ),
    };
    _afterWrite();
    return result;
  }

  @override
  Future<RemoteWriteResult> putEntity(
    String householdId,
    String collection,
    String id,
    Map<String, Object?> doc,
  ) async {
    _beforeWrite();
    final remote = collections[collection]?[id];
    final result = switch (decideEntityWrite(remote, doc)) {
      EntityWriteDecision.create || EntityWriteDecision.update => () {
        _store(collection, id, doc);
        return const RemoteWriteResult(WriteOutcome.written);
      }(),
      EntityWriteDecision.noop => const RemoteWriteResult(
        WriteOutcome.alreadyPresent,
      ),
      EntityWriteDecision.conflict => RemoteWriteResult(
        WriteOutcome.conflict,
        remote: remote,
      ),
    };
    _afterWrite();
    return result;
  }

  @override
  Future<List<RemoteDoc>> changes(
    String householdId,
    String collection, {
    RemoteCursor? after,
    required String viewerUid,
    required bool viewerReadsAll,
    int limit = 200,
  }) async {
    _guard();
    final docs = collections[collection] ?? {};
    final times = _updatedAt[collection] ?? {};
    final out = <RemoteDoc>[];
    final ids = docs.keys.toList()
      ..sort((a, b) {
        final c = times[a]!.compareTo(times[b]!);
        return c != 0 ? c : a.compareTo(b);
      });
    for (final id in ids) {
      final t = times[id]!;
      if (after != null &&
          (t < after.updatedAtMs ||
              (t == after.updatedAtMs && id.compareTo(after.id) <= 0))) {
        continue;
      }
      final d = docs[id]!;
      // Mirrors the security rule: members only see docs listing them.
      if (!viewerReadsAll &&
          !((d['readerUids'] as List?) ?? const []).contains(viewerUid)) {
        continue;
      }
      out.add(
        RemoteDoc(id, jsonDecode(jsonEncode(d)) as Map<String, Object?>, t),
      );
      if (out.length >= limit) break;
    }
    return out;
  }
}
