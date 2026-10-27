import 'dart:async';

import 'package:drift/drift.dart';

import '../../domain/ledger/ledger_types.dart';
import '../../domain/ledger/posting_engine.dart';
import '../db/database.dart';
import '../repositories/audit_log.dart';
import '../repositories/ledger_repository.dart';
import '../repositories/outbox_repository.dart';
import 'household_directory.dart';
import 'remote_store.dart';

class SyncReport {
  int pushed = 0;
  int alreadyPresent = 0;
  int failed = 0;
  int conflicts = 0;
  int pulled = 0;
  int rejected = 0;
  final errors = <String>[];

  bool get clean => failed == 0 && conflicts == 0 && rejected == 0;

  @override
  String toString() =>
      'SyncReport(pushed: $pushed, present: $alreadyPresent, failed: $failed, '
      'conflicts: $conflicts, pulled: $pulled, rejected: $rejected)';
}

/// Collections in dependency order (master data before ledger entries).
const syncCollections = {
  'person': 'persons',
  'fund': 'funds',
  'account': 'accounts',
  'obligation': 'obligations',
  'samity': 'samities',
  'budget': 'budgets',
  'tx': 'transactions',
  'recon': 'recon',
};

/// Moves data between the local database and the cloud.
///
/// Guarantees:
/// * The outbox entry is deleted only after the server confirmed the write
///   (a Firestore transaction commit); failures are retried with backoff.
/// * Uploads are idempotent: documents are keyed by the client-generated
///   UUID and compared by content hash, so duplicate delivery after a crash
///   or retry never creates a second entry.
/// * Posted entries are never overwritten. Diverging content becomes an
///   explicit conflict that stays queued until a person resolves it.
/// * Incoming entries are re-validated (balanced overall and per fund)
///   before they are written locally.
class SyncEngine {
  SyncEngine({
    required this.db,
    required this.remote,
    required this.householdId,
    required this.viewer,
    required this.directory,
  }) : outbox = OutboxRepository(db),
       audit = AuditLog(db);

  final AppDatabase db;
  final RemoteStore remote;
  final String householdId;
  final MemberInfo viewer;
  final HouseholdDirectory directory;
  final OutboxRepository outbox;
  final AuditLog audit;

  bool _running = false;

  /// Push, then pull, then push anything the pull unblocked.
  Future<SyncReport> syncNow() async {
    if (_running) return SyncReport();
    _running = true;
    try {
      final report = SyncReport();
      await push(report);
      await pull(report);
      await push(report);
      return report;
    } finally {
      _running = false;
    }
  }

  // ------------------------------------------------------------------ push

  Future<SyncReport> push([SyncReport? r, DateTime? now]) async {
    final report = r ?? SyncReport();
    final due = await outbox.due(now: now);
    // Master data first so ledger entries never reference unknown ids.
    final order = syncCollections.keys.toList();
    due.sort((a, b) {
      final c = order
          .indexOf(a.entityType)
          .compareTo(order.indexOf(b.entityType));
      return c != 0 ? c : a.seq.compareTo(b.seq);
    });
    for (final entry in due) {
      try {
        final doc = await _localDoc(entry.entityType, entry.entityId);
        if (doc == null) {
          // Entity no longer exists (e.g. a deleted draft): nothing to send.
          await outbox.complete(entry.seq);
          continue;
        }
        final collection = syncCollections[entry.entityType];
        if (collection == null) {
          await outbox.complete(entry.seq);
          continue;
        }
        final result = entry.entityType == 'tx'
            ? await remote.putTransaction(householdId, doc)
            : await remote.putEntity(
                householdId,
                collection,
                entry.entityId,
                doc,
              );
        switch (result.outcome) {
          case WriteOutcome.written:
          case WriteOutcome.alreadyPresent:
            await db.transaction(() async {
              await _setSyncStatus(
                entry.entityType,
                entry.entityId,
                SyncStatus.synced,
              );
              await outbox.complete(entry.seq);
            });
            if (result.outcome == WriteOutcome.written) {
              report.pushed++;
            } else {
              report.alreadyPresent++;
            }
          case WriteOutcome.conflict:
            await db.transaction(() async {
              await _setSyncStatus(
                entry.entityType,
                entry.entityId,
                SyncStatus.conflict,
              );
              await outbox.markConflict(entry.seq, 'server copy differs');
              await audit.append(
                actorId: viewer.uid,
                entityType: entry.entityType,
                entityId: entry.entityId,
                action: 'sync_conflict',
                details: {
                  'remoteHash': result.remote?['contentHash'],
                  'localHash': doc['contentHash'],
                },
              );
            });
            report.conflicts++;
        }
      } on RemoteDenied catch (e) {
        await outbox.fail(entry.seq, 'denied: ${e.message}', now: now);
        await _setSyncStatus(
          entry.entityType,
          entry.entityId,
          SyncStatus.failed,
        );
        report.failed++;
        report.errors.add('${entry.entityType}/${entry.entityId}: denied');
      } catch (e) {
        await outbox.fail(entry.seq, '$e', now: now);
        await _setSyncStatus(
          entry.entityType,
          entry.entityId,
          SyncStatus.failed,
        );
        report.failed++;
        report.errors.add('${entry.entityType}/${entry.entityId}: $e');
        if (e is RemoteUnavailable) break; // offline: stop hammering
      }
    }
    return report;
  }

  Future<void> _setSyncStatus(String type, String id, SyncStatus s) async {
    switch (type) {
      case 'tx':
        await (db.update(db.ledgerTransactions)..where((t) => t.id.equals(id)))
            .write(LedgerTransactionsCompanion(syncStatus: Value(s)));
      case 'person':
        await (db.update(db.persons)..where((t) => t.id.equals(id))).write(
          PersonsCompanion(syncStatus: Value(s)),
        );
      case 'fund':
        await (db.update(db.funds)..where((t) => t.id.equals(id))).write(
          FundsCompanion(syncStatus: Value(s)),
        );
      case 'account':
        await (db.update(db.ledgerAccounts)..where((t) => t.id.equals(id)))
            .write(LedgerAccountsCompanion(syncStatus: Value(s)));
      case 'obligation':
        await (db.update(db.obligations)..where((t) => t.id.equals(id))).write(
          ObligationsCompanion(syncStatus: Value(s)),
        );
      case 'samity':
        await (db.update(db.samities)..where((t) => t.id.equals(id))).write(
          SamitiesCompanion(syncStatus: Value(s)),
        );
      case 'budget':
        await (db.update(db.budgets)..where((t) => t.id.equals(id))).write(
          BudgetsCompanion(syncStatus: Value(s)),
        );
      case 'recon':
        await (db.update(db.reconSessions)..where((t) => t.id.equals(id)))
            .write(ReconSessionsCompanion(syncStatus: Value(s)));
    }
  }

  Map<String, Object?> _clean(Map<String, dynamic> json) =>
      Map<String, Object?>.from(json)..remove('syncStatus');

  /// Current local state of an entity as a cloud document, or null.
  Future<Map<String, Object?>?> _localDoc(String type, String id) async {
    switch (type) {
      case 'tx':
        final t = await (db.select(
          db.ledgerTransactions,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        // Drafts and in-flight rows stay on the device.
        if (t == null ||
            t.status == TxStatus.draft ||
            t.status == TxStatus.staging) {
          return null;
        }
        final lines =
            await (db.select(db.transactionLines)
                  ..where((l) => l.txId.equals(id))
                  ..orderBy([(l) => OrderingTerm.asc(l.lineNo)]))
                .get();
        return txToDoc(t, lines, directory);
      case 'person':
        final p = await (db.select(
          db.persons,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (p == null) return null;
        final related = await (db.select(
          db.funds,
        )..where((f) => f.ownerPersonId.equals(id))).get();
        return _clean(p.toJson())
          ..['readerUids'] = directory.readersForPerson(id, {
            for (final f in related) f.id,
          });
      case 'fund':
        final f = await (db.select(
          db.funds,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (f == null) return null;
        return _clean(f.toJson())
          ..['readerUids'] = directory.readersForFunds({f.id});
      case 'account':
        final a = await (db.select(
          db.ledgerAccounts,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (a == null || a.isSystem) return null;
        return _clean(a.toJson())..['readerUids'] = directory.allReaders();
      case 'obligation':
        final o = await (db.select(
          db.obligations,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (o == null) return null;
        return _clean(o.toJson())
          ..['readerUids'] = directory.readersForFunds({o.fundId});
      case 'samity':
        final s = await (db.select(
          db.samities,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (s == null) return null;
        final members = await (db.select(
          db.samityMembers,
        )..where((m) => m.samityId.equals(id))).get();
        return _clean(s.toJson())
          ..['members'] = [
            for (final m in members)
              {
                'personId': m.personId,
                'shares': m.shares,
                'joinedOn': m.joinedOn,
              },
          ]
          ..['readerUids'] = s.fundId == null
              ? directory.readersForFunds(const {})
              : directory.readersForFunds({s.fundId!});
      case 'budget':
        final b = await (db.select(
          db.budgets,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (b == null) return null;
        return _clean(b.toJson())
          ..['readerUids'] = directory.readersForFunds(const {});
      case 'recon':
        final s = await (db.select(
          db.reconSessions,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (s == null) return null;
        return _clean(s.toJson())
          ..['readerUids'] = directory.readersForFunds(const {});
    }
    return null;
  }

  // ------------------------------------------------------------------ pull

  Future<SyncReport> pull([SyncReport? r]) async {
    final report = r ?? SyncReport();
    for (final entry in syncCollections.entries) {
      final key = '${Kv.pullCursorPrefix}${entry.value}';
      var cursor = RemoteCursor.decode(await db.getKv(key));
      while (true) {
        final List<RemoteDoc> docs;
        try {
          docs = await remote.changes(
            householdId,
            entry.value,
            after: cursor,
            viewerUid: viewer.uid,
            viewerReadsAll: viewer.readsAll,
          );
        } catch (e) {
          report.errors.add('pull ${entry.value}: $e');
          report.failed++;
          return report; // keep cursors; resume next time
        }
        if (docs.isEmpty) break;
        for (final d in docs) {
          try {
            await db.transaction(() async {
              final applied = await _apply(entry.key, d.id, d.data);
              if (applied == _Applied.rejected) report.rejected++;
              if (applied == _Applied.conflict) report.conflicts++;
              if (applied == _Applied.changed) report.pulled++;
              cursor = RemoteCursor(d.updatedAtMs, d.id);
              await db.setKv(key, cursor!.encode());
            });
          } catch (e) {
            // Keep the cursor before this document so it is retried.
            report.errors.add('apply ${entry.value}/${d.id}: $e');
            report.failed++;
            return report;
          }
        }
        if (docs.length < 200) break;
      }
    }
    return report;
  }

  Future<_Applied> _apply(
    String type,
    String id,
    Map<String, Object?> data,
  ) async {
    final json = Map<String, Object?>.from(data)
      ..remove('readerUids')
      ..remove('updatedAtServer')
      ..['syncStatus'] = SyncStatus.synced.name;
    switch (type) {
      case 'tx':
        return _applyTx(id, data);
      case 'person':
        return _upsertVersioned(
          await (db.select(
            db.persons,
          )..where((x) => x.id.equals(id))).getSingleOrNull(),
          (r) => (r as PersonRow).version,
          (r) => (r as PersonRow).syncStatus,
          () => db
              .into(db.persons)
              .insertOnConflictUpdate(PersonRow.fromJson(json)),
          json,
          type,
          id,
        );
      case 'fund':
        return _upsertVersioned(
          await (db.select(
            db.funds,
          )..where((x) => x.id.equals(id))).getSingleOrNull(),
          (r) => (r as FundRow).version,
          (r) => (r as FundRow).syncStatus,
          () =>
              db.into(db.funds).insertOnConflictUpdate(FundRow.fromJson(json)),
          json,
          type,
          id,
        );
      case 'account':
        return _upsertVersioned(
          await (db.select(
            db.ledgerAccounts,
          )..where((x) => x.id.equals(id))).getSingleOrNull(),
          (r) => (r as LedgerAccountRow).version,
          (r) => (r as LedgerAccountRow).syncStatus,
          () => db
              .into(db.ledgerAccounts)
              .insertOnConflictUpdate(LedgerAccountRow.fromJson(json)),
          json,
          type,
          id,
        );
      case 'obligation':
        return _upsertVersioned(
          await (db.select(
            db.obligations,
          )..where((x) => x.id.equals(id))).getSingleOrNull(),
          (r) => (r as ObligationRow).version,
          (r) => (r as ObligationRow).syncStatus,
          () => db
              .into(db.obligations)
              .insertOnConflictUpdate(ObligationRow.fromJson(json)),
          json,
          type,
          id,
        );
      case 'samity':
        final members = (json.remove('members') as List?) ?? const [];
        return _upsertVersioned(
          await (db.select(
            db.samities,
          )..where((x) => x.id.equals(id))).getSingleOrNull(),
          (r) => (r as SamityRow).version,
          (r) => (r as SamityRow).syncStatus,
          () async {
            await db
                .into(db.samities)
                .insertOnConflictUpdate(SamityRow.fromJson(json));
            final now = DateTime.now();
            for (final m in members.cast<Map>()) {
              await db
                  .into(db.samityMembers)
                  .insertOnConflictUpdate(
                    SamityMembersCompanion.insert(
                      samityId: id,
                      personId: m['personId'] as String,
                      shares: Value((m['shares'] as num).toInt()),
                      joinedOn: (m['joinedOn'] as num).toInt(),
                      createdAt: now,
                      updatedAt: now,
                      syncStatus: const Value(SyncStatus.synced),
                    ),
                  );
            }
          },
          json,
          type,
          id,
        );
      case 'budget':
        return _upsertVersioned(
          await (db.select(
            db.budgets,
          )..where((x) => x.id.equals(id))).getSingleOrNull(),
          (r) => (r as BudgetRow).version,
          (r) => (r as BudgetRow).syncStatus,
          () => db
              .into(db.budgets)
              .insertOnConflictUpdate(BudgetRow.fromJson(json)),
          json,
          type,
          id,
        );
      case 'recon':
        final existing = await (db.select(
          db.reconSessions,
        )..where((x) => x.id.equals(id))).getSingleOrNull();
        if (existing != null && existing.syncStatus != SyncStatus.synced) {
          return _Applied.unchanged;
        }
        await db
            .into(db.reconSessions)
            .insertOnConflictUpdate(ReconSessionRow.fromJson(json));
        return _Applied.changed;
    }
    return _Applied.unchanged;
  }

  Future<_Applied> _upsertVersioned(
    Object? local,
    int Function(Object) versionOf,
    SyncStatus Function(Object) statusOf,
    Future<void> Function() write,
    Map<String, Object?> json,
    String type,
    String id,
  ) async {
    final rv = (json['version'] as num?)?.toInt() ?? 0;
    if (local == null) {
      await write();
      return _Applied.changed;
    }
    final lv = versionOf(local);
    if (rv <= lv) return _Applied.unchanged;
    if (statusOf(local) == SyncStatus.pending ||
        statusOf(local) == SyncStatus.failed) {
      // Both sides changed: keep local, flag for a decision.
      await _setSyncStatus(type, id, SyncStatus.conflict);
      await audit.append(
        actorId: viewer.uid,
        entityType: type,
        entityId: id,
        action: 'sync_conflict',
        details: {'remoteVersion': rv, 'localVersion': lv},
      );
      return _Applied.conflict;
    }
    await write();
    return _Applied.changed;
  }

  Future<_Applied> _applyTx(String id, Map<String, Object?> data) async {
    final lines = [
      for (final l in (data['lines'] as List? ?? const []).cast<Map>())
        LineSpec.fromJson(Map<String, Object?>.from(l)),
    ];
    final status = TxStatus.values.byName(data['status']! as String);
    final local = await (db.select(
      db.ledgerTransactions,
    )..where((x) => x.id.equals(id))).getSingleOrNull();

    final json = Map<String, Object?>.from(data)
      ..remove('lines')
      ..remove('readerUids')
      ..remove('fundIds')
      ..remove('totalDebit')
      ..remove('totalCredit')
      ..remove('updatedAtServer')
      ..['syncStatus'] = SyncStatus.synced.name;

    if (local == null) {
      // Re-verify the server copy: never import an unbalanced entry, and
      // check its hash matches its content.
      final problem = LedgerInvariants.describe(lines);
      final row = TxRow.fromJson({...json, 'status': TxStatus.staging.name});
      if (problem != null ||
          LedgerRepository.contentHashOf(row, lines) != data['contentHash']) {
        await audit.append(
          actorId: viewer.uid,
          entityType: 'tx',
          entityId: id,
          action: 'sync_rejected',
          details: {'reason': problem ?? 'hash_mismatch'},
        );
        return _Applied.rejected;
      }
      await db
          .into(db.ledgerTransactions)
          .insert(row.copyWith(reversedByTxId: const Value(null)));
      for (var i = 0; i < lines.length; i++) {
        final l = lines[i];
        await db
            .into(db.transactionLines)
            .insert(
              TransactionLinesCompanion.insert(
                txId: id,
                lineNo: i,
                accountId: l.accountId,
                fundId: l.fundId,
                amount: l.amount,
                personId: Value(l.personId),
                counterFundId: Value(l.counterFundId),
              ),
            );
      }
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        LedgerTransactionsCompanion(
          status: Value(status),
          reversedByTxId: Value(data['reversedByTxId'] as String?),
        ),
      );
      await audit.append(
        actorId: viewer.uid,
        entityType: 'tx',
        entityId: id,
        action: 'sync_received',
        details: {'hash': data['contentHash'], 'status': status.name},
      );
      return _Applied.changed;
    }

    if (local.contentHash != data['contentHash']) {
      if (local.status == TxStatus.pending || local.status == TxStatus.draft) {
        final rv = (data['version'] as num?)?.toInt() ?? 0;
        if (local.syncStatus == SyncStatus.synced && rv > local.version) {
          // Another device edited a pending entry we had not touched.
          final incoming = TxRow.fromJson({
            ...json,
            'status': TxStatus.staging.name,
          });
          if (LedgerInvariants.describe(lines) != null ||
              LedgerRepository.contentHashOf(incoming, lines) !=
                  data['contentHash']) {
            return _Applied.rejected;
          }
          await (db.update(
            db.ledgerTransactions,
          )..where((x) => x.id.equals(id))).write(
            const LedgerTransactionsCompanion(status: Value(TxStatus.staging)),
          );
          return _replaceStaged(id, json, lines, status);
        }
      }
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        const LedgerTransactionsCompanion(
          syncStatus: Value(SyncStatus.conflict),
        ),
      );
      await audit.append(
        actorId: viewer.uid,
        entityType: 'tx',
        entityId: id,
        action: 'sync_conflict',
        details: {
          'remoteHash': data['contentHash'],
          'localHash': local.contentHash,
        },
      );
      return _Applied.conflict;
    }

    // Same content: move status forward and add a reversal link if needed.
    var changed = false;
    final remoteRev = data['reversedByTxId'] as String?;
    if (local.status == TxStatus.pending &&
        (status == TxStatus.posted || status == TxStatus.cancelled)) {
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        LedgerTransactionsCompanion(
          status: Value(status),
          version: Value((data['version'] as num).toInt()),
          postedAt: Value(status == TxStatus.posted ? DateTime.now() : null),
        ),
      );
      changed = true;
    }
    if (remoteRev != null && local.reversedByTxId == null) {
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        LedgerTransactionsCompanion(
          reversedByTxId: Value(remoteRev),
          version: Value((data['version'] as num).toInt()),
        ),
      );
      changed = true;
    }
    if (remoteRev != null &&
        local.reversedByTxId != null &&
        remoteRev != local.reversedByTxId) {
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        const LedgerTransactionsCompanion(
          syncStatus: Value(SyncStatus.conflict),
        ),
      );
      return _Applied.conflict;
    }
    return changed ? _Applied.changed : _Applied.unchanged;
  }

  Future<_Applied> _replaceStaged(
    String id,
    Map<String, Object?> json,
    List<LineSpec> lines,
    TxStatus status,
  ) async {
    if (LedgerInvariants.describe(lines) != null) return _Applied.rejected;
    await (db.delete(
      db.transactionLines,
    )..where((l) => l.txId.equals(id))).go();
    final row = TxRow.fromJson({...json, 'status': TxStatus.staging.name});
    await (db.update(
      db.ledgerTransactions,
    )..where((x) => x.id.equals(id))).write(row.toCompanion(false));
    for (var i = 0; i < lines.length; i++) {
      final l = lines[i];
      await db
          .into(db.transactionLines)
          .insert(
            TransactionLinesCompanion.insert(
              txId: id,
              lineNo: i,
              accountId: l.accountId,
              fundId: l.fundId,
              amount: l.amount,
              personId: Value(l.personId),
              counterFundId: Value(l.counterFundId),
            ),
          );
    }
    await (db.update(db.ledgerTransactions)..where((x) => x.id.equals(id)))
        .write(LedgerTransactionsCompanion(status: Value(status)));
    return _Applied.changed;
  }
}

enum _Applied { changed, unchanged, conflict, rejected }

/// Cloud representation of a transaction.
Map<String, Object?> txToDoc(
  TxRow t,
  List<LineRow> lines,
  HouseholdDirectory directory,
) {
  final specs = [for (final l in lines) l.toSpec()];
  final fundIds = {for (final l in lines) l.fundId};
  return Map<String, Object?>.from(t.toJson())
    ..remove('syncStatus')
    ..['lines'] = [for (final s in specs) s.toJson()]
    ..['fundIds'] = (fundIds.toList()..sort())
    ..['totalDebit'] = LedgerInvariants.totalDebit(specs)
    ..['totalCredit'] = LedgerInvariants.totalCredit(specs)
    ..['readerUids'] = directory.readersForFunds(fundIds);
}
