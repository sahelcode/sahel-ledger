import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../domain/ledger/posting_engine.dart';
import '../db/database.dart';
import 'audit_log.dart';
import 'ledger_repository.dart';
import 'outbox_repository.dart';
import 'reports_repository.dart';

abstract final class ReconStatus {
  static const matched = 'matched';
  static const unresolved = 'unresolved';
  static const pendingApproval = 'pendingApproval';
  static const adjusted = 'adjusted';
}

/// Compares counted balances with the ledger. A difference is never
/// auto-corrected: it stays visible until someone records an explained
/// adjustment, which an authorised person must approve.
class ReconciliationRepository {
  ReconciliationRepository(this.db, {required this.actor})
    : ledger = LedgerRepository(db, actor: actor),
      reports = ReportsRepository(db, actor: actor),
      audit = AuditLog(db),
      outbox = OutboxRepository(db);

  final AppDatabase db;
  final ActorContext actor;
  final LedgerRepository ledger;
  final ReportsRepository reports;
  final AuditLog audit;
  final OutboxRepository outbox;

  /// Ledger balance of [accountId] (optionally only [fundId]'s share).
  Future<int> expectedBalance(
    String accountId, {
    String? fundId,
    int? asOf,
  }) async {
    final balances = await reports.accountBalances(
      asOf: asOf,
      includeArchived: true,
    );
    final b = balances.where((x) => x.account.id == accountId).firstOrNull;
    if (b == null) return 0;
    return fundId == null ? b.balance : (b.byFund[fundId] ?? 0);
  }

  Future<ReconSessionRow> start({
    required String accountId,
    String? fundId,
    required int actualBalance,
    int? asOf,
    String? notes,
  }) async {
    actor.require(Permission.writeTransactions);
    // The expected balance is only meaningful if the actor can see every
    // fund that has money in the account (or the single fund reconciled).
    final scope = actor.fundScope;
    if (scope != null && (fundId == null || !scope.contains(fundId))) {
      throw PermissionDenied(Permission.readAll);
    }
    return db.transaction(() async {
      final day = asOf ?? DateKey.today();
      final expected = await expectedBalance(
        accountId,
        fundId: fundId,
        asOf: day,
      );
      final id = const Uuid().v4();
      final status = expected == actualBalance
          ? ReconStatus.matched
          : ReconStatus.unresolved;
      await db
          .into(db.reconSessions)
          .insert(
            ReconSessionsCompanion.insert(
              id: id,
              accountId: accountId,
              fundId: Value(fundId),
              asOfDateKey: day,
              expectedBalance: expected,
              actualBalance: actualBalance,
              status: status,
              notes: Value(notes),
              createdBy: actor.actorId,
              createdAt: DateTime.now(),
            ),
          );
      await audit.append(
        actorId: actor.actorId,
        entityType: 'recon',
        entityId: id,
        action: 'started',
        details: {
          'expected': expected,
          'actual': actualBalance,
          'status': status,
        },
      );
      await outbox.enqueue('recon', id);
      return (await get(id))!;
    });
  }

  Future<ReconSessionRow?> get(String id) => (db.select(
    db.reconSessions,
  )..where((s) => s.id.equals(id))).getSingleOrNull();

  Stream<List<ReconSessionRow>> watchAll() => (db.select(
    db.reconSessions,
  )..orderBy([(s) => OrderingTerm.desc(s.createdAt)])).watch();

  /// Records an explained correction for an unresolved session.
  ///
  /// If the actor may approve adjustments it is posted immediately;
  /// otherwise it is saved as a *pending* entry (excluded from balances)
  /// awaiting [approve].
  ///
  /// [fundId] says whose money the difference belongs to; it defaults to the
  /// session's fund, then the personal fund. The UI always asks.
  Future<String> proposeAdjustment(
    String sessionId, {
    required String reason,
    String? fundId,
  }) async {
    actor.require(Permission.writeTransactions);
    if (reason.trim().length < 5) {
      throw TxValidationException({'reason': PostingError.required});
    }
    return db.transaction(() async {
      final s = await get(sessionId);
      if (s == null || s.status != ReconStatus.unresolved) {
        throw LedgerStateException('not_unresolved');
      }
      final diff = s.actualBalance - s.expectedBalance;
      final targetFund =
          fundId ?? s.fundId ?? await db.getKv(Kv.personalFundId);
      final canApprove = actor.can(Permission.approveAdjustments);
      final draft = TxDraft(
        dateKey: s.asOfDateKey,
        reconSessionId: sessionId,
        input: TxInput(
          type: TxType.adjustment,
          amount: diff.abs(),
          increase: diff > 0,
          fromAccountId: s.accountId,
          fundId: targetFund,
          description: reason.trim(),
        ),
      );
      await ledger.save(
        draft,
        target: canApprove ? TxStatus.posted : TxStatus.pending,
      );
      await (db.update(
        db.reconSessions,
      )..where((x) => x.id.equals(sessionId))).write(
        ReconSessionsCompanion(
          status: Value(
            canApprove ? ReconStatus.adjusted : ReconStatus.pendingApproval,
          ),
          adjustmentTxId: Value(draft.id),
          notes: Value(reason.trim()),
          approvedBy: Value(canApprove ? actor.actorId : null),
          approvedAt: Value(canApprove ? DateTime.now() : null),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await audit.append(
        actorId: actor.actorId,
        entityType: 'recon',
        entityId: sessionId,
        action: canApprove ? 'adjusted' : 'adjustment_proposed',
        details: {'difference': diff, 'tx': draft.id, 'reason': reason.trim()},
      );
      await outbox.enqueue('recon', sessionId);
      return draft.id;
    });
  }

  Future<void> approve(String sessionId) async {
    actor.require(Permission.approveAdjustments);
    await db.transaction(() async {
      final s = await get(sessionId);
      if (s == null ||
          s.status != ReconStatus.pendingApproval ||
          s.adjustmentTxId == null) {
        throw LedgerStateException('not_pending_approval');
      }
      if (s.createdBy == actor.actorId && actor.role != HouseholdRole.owner) {
        // Four-eyes rule for delegated approvers.
        throw PermissionDenied(Permission.approveAdjustments);
      }
      await ledger.postPending(s.adjustmentTxId!);
      await (db.update(
        db.reconSessions,
      )..where((x) => x.id.equals(sessionId))).write(
        ReconSessionsCompanion(
          status: const Value(ReconStatus.adjusted),
          approvedBy: Value(actor.actorId),
          approvedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await audit.append(
        actorId: actor.actorId,
        entityType: 'recon',
        entityId: sessionId,
        action: 'approved',
      );
      await outbox.enqueue('recon', sessionId);
    });
  }

  Future<void> reject(String sessionId, String reason) async {
    actor.require(Permission.approveAdjustments);
    await db.transaction(() async {
      final s = await get(sessionId);
      if (s == null || s.status != ReconStatus.pendingApproval) {
        throw LedgerStateException('not_pending_approval');
      }
      await ledger.cancelPending(s.adjustmentTxId!, reason);
      await (db.update(
        db.reconSessions,
      )..where((x) => x.id.equals(sessionId))).write(
        const ReconSessionsCompanion(
          status: Value(ReconStatus.unresolved),
          adjustmentTxId: Value(null),
          syncStatus: Value(SyncStatus.pending),
        ),
      );
      await audit.append(
        actorId: actor.actorId,
        entityType: 'recon',
        entityId: sessionId,
        action: 'rejected',
        details: {'reason': reason},
      );
      await outbox.enqueue('recon', sessionId);
    });
  }
}
