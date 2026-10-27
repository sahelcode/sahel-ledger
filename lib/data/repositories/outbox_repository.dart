import 'dart:math';

import 'package:drift/drift.dart';

import '../db/database.dart';

/// Durable queue of entities whose current state must reach the cloud.
///
/// The outbox stores *which* entity changed, not a payload snapshot: the
/// sync engine always uploads the entity's latest local state, so repeated
/// changes collapse into one idempotent upload.
class OutboxRepository {
  OutboxRepository(this.db);

  final AppDatabase db;

  static const maxBackoff = Duration(hours: 1);

  Future<void> enqueue(String entityType, String entityId) async {
    final existing =
        await (db.select(db.outbox)..where(
              (o) =>
                  o.entityType.equals(entityType) &
                  o.entityId.equals(entityId) &
                  o.state.isIn(['pending', 'failed']),
            ))
            .getSingleOrNull();
    if (existing != null) {
      // Make it due again right away; keep attempt history.
      await (db.update(db.outbox)..where((o) => o.seq.equals(existing.seq)))
          .write(OutboxCompanion(nextAttemptAt: Value(DateTime.now())));
      return;
    }
    final now = DateTime.now();
    await db
        .into(db.outbox)
        .insert(
          OutboxCompanion.insert(
            entityType: entityType,
            entityId: entityId,
            operation: 'upsert',
            createdAt: now,
            nextAttemptAt: now,
          ),
        );
  }

  /// Entries due for an attempt, oldest first (preserves causal order).
  Future<List<OutboxRow>> due({DateTime? now, int limit = 100}) {
    final t = now ?? DateTime.now();
    return (db.select(db.outbox)
          ..where(
            (o) =>
                o.state.isIn(['pending', 'failed']) &
                o.nextAttemptAt.isSmallerOrEqualValue(t),
          )
          ..orderBy([(o) => OrderingTerm.asc(o.seq)])
          ..limit(limit))
        .get();
  }

  /// Removes an entry. Only call after the server confirmed the write.
  Future<void> complete(int seq) =>
      (db.delete(db.outbox)..where((o) => o.seq.equals(seq))).go();

  /// Records a transient failure and schedules a retry with exponential
  /// backoff (2^attempts seconds, capped at [maxBackoff], with jitter).
  Future<void> fail(
    int seq,
    String error, {
    DateTime? now,
    Random? random,
  }) async {
    final row = await (db.select(
      db.outbox,
    )..where((o) => o.seq.equals(seq))).getSingle();
    final attempts = row.attempts + 1;
    final base = Duration(seconds: 1 << min(attempts, 12));
    final capped = base > maxBackoff ? maxBackoff : base;
    final jitterMs = (random ?? Random()).nextInt(1000);
    final next = (now ?? DateTime.now()).add(
      capped + Duration(milliseconds: jitterMs),
    );
    await (db.update(db.outbox)..where((o) => o.seq.equals(seq))).write(
      OutboxCompanion(
        attempts: Value(attempts),
        lastError: Value(error.length > 500 ? error.substring(0, 500) : error),
        nextAttemptAt: Value(next),
        state: const Value('failed'),
      ),
    );
  }

  /// Parks an entry that needs human resolution. It is kept, never dropped.
  Future<void> markConflict(int seq, String detail) =>
      (db.update(db.outbox)..where((o) => o.seq.equals(seq))).write(
        OutboxCompanion(
          state: const Value('conflict'),
          lastError: Value(detail),
        ),
      );

  /// Re-queues a conflicted or failed entry, e.g. after the user resolved it.
  Future<void> retry(int seq) =>
      (db.update(db.outbox)..where((o) => o.seq.equals(seq))).write(
        OutboxCompanion(
          state: const Value('pending'),
          nextAttemptAt: Value(DateTime.now()),
        ),
      );

  Stream<int> watchPendingCount() {
    final c = db.outbox.seq.count();
    final q = db.selectOnly(db.outbox)..addColumns([c]);
    return q.watchSingle().map((r) => r.read(c) ?? 0);
  }

  Future<List<OutboxRow>> all() =>
      (db.select(db.outbox)..orderBy([(o) => OrderingTerm.asc(o.seq)])).get();
}
