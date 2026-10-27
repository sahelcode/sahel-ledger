import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../db/database.dart';

/// Canonical JSON: keys sorted recursively, so hashes are stable.
String canonicalJson(Object? value) {
  Object? norm(Object? v) {
    if (v is Map) {
      final keys = v.keys.map((k) => k.toString()).toList()..sort();
      return {for (final k in keys) k: norm(v[k])};
    }
    if (v is List) return v.map(norm).toList();
    return v;
  }

  return jsonEncode(norm(value));
}

String sha256Hex(String input) => sha256.convert(utf8.encode(input)).toString();

/// Append-only audit trail. Each event stores the hash of the previous one,
/// so any edit or removal of history is detectable by [verifyChain].
class AuditLog {
  AuditLog(this.db);

  final AppDatabase db;
  static const genesis =
      '0000000000000000000000000000000000000000000000000000000000000000';

  Future<void> append({
    required String actorId,
    required String entityType,
    required String entityId,
    required String action,
    Map<String, Object?>? details,
  }) async {
    final last =
        await (db.select(db.auditEvents)
              ..orderBy([(t) => OrderingTerm.desc(t.seq)])
              ..limit(1))
            .getSingleOrNull();
    final prev = last?.hash ?? genesis;
    final at = DateTime.now();
    final eventId = const Uuid().v4();
    final detailsJson = details == null ? null : canonicalJson(details);
    final hash = _hash(
      prev,
      eventId,
      at,
      actorId,
      entityType,
      entityId,
      action,
      detailsJson,
    );
    await db
        .into(db.auditEvents)
        .insert(
          AuditEventsCompanion.insert(
            eventId: eventId,
            at: at,
            actorId: actorId,
            entityType: entityType,
            entityId: entityId,
            action: action,
            details: Value(detailsJson),
            prevHash: prev,
            hash: hash,
          ),
        );
  }

  static String _hash(
    String prev,
    String eventId,
    DateTime at,
    String actor,
    String type,
    String id,
    String action,
    String? details,
  ) => sha256Hex(
    canonicalJson({
      'prev': prev,
      'eventId': eventId,
      // Seconds precision: the database stores DateTime as unix seconds.
      'at': at.millisecondsSinceEpoch ~/ 1000,
      'actor': actor,
      'type': type,
      'id': id,
      'action': action,
      'details': details,
    }),
  );

  /// Returns the sequence number of the first tampered event, or null if
  /// the whole chain is intact.
  Future<int?> verifyChain() async {
    final rows = await (db.select(
      db.auditEvents,
    )..orderBy([(t) => OrderingTerm.asc(t.seq)])).get();
    var prev = genesis;
    for (final r in rows) {
      final expected = _hash(
        prev,
        r.eventId,
        r.at,
        r.actorId,
        r.entityType,
        r.entityId,
        r.action,
        r.details,
      );
      if (r.prevHash != prev || r.hash != expected) return r.seq;
      prev = r.hash;
    }
    return null;
  }

  Future<List<AuditRow>> forEntity(String entityType, String entityId) =>
      (db.select(db.auditEvents)
            ..where(
              (t) =>
                  t.entityType.equals(entityType) & t.entityId.equals(entityId),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.seq)]))
          .get();

  Future<List<AuditRow>> recent({int limit = 100}) =>
      (db.select(db.auditEvents)
            ..orderBy([(t) => OrderingTerm.desc(t.seq)])
            ..limit(limit))
          .get();
}
