import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../domain/ledger/posting_engine.dart';
import '../db/database.dart';
import 'audit_log.dart';
import 'outbox_repository.dart';

/// Everything needed to save a transaction, in any status.
class TxDraft {
  TxDraft({
    String? id,
    required this.input,
    required this.dateKey,
    this.notes,
    this.referenceNo,
    this.reconSessionId,
  }) : id = id ?? const Uuid().v4();

  /// Generated when the entry form opens. Re-submitting the same draft is
  /// idempotent, which prevents accidental duplicates from double taps.
  final String id;
  final TxInput input;
  final int dateKey;
  final String? notes;
  final String? referenceNo;
  final String? reconSessionId;
}

class TxValidationException implements Exception {
  TxValidationException(this.errors);
  final Map<String, String> errors;
  @override
  String toString() => 'TxValidationException($errors)';
}

class LedgerStateException implements Exception {
  LedgerStateException(this.code);
  final String code;
  @override
  String toString() => 'LedgerStateException($code)';
}

enum SaveOutcome { created, updated, alreadyExists }

class SaveResult {
  const SaveResult(this.id, this.outcome);
  final String id;
  final SaveOutcome outcome;
}

class TxWithLines {
  const TxWithLines(this.tx, this.lines);
  final TxRow tx;
  final List<LineRow> lines;

  List<LineSpec> get specs => [for (final l in lines) l.toSpec()];
}

extension LineRowX on LineRow {
  LineSpec toSpec() => LineSpec(
    accountId: accountId,
    fundId: fundId,
    amount: amount,
    personId: personId,
    counterFundId: counterFundId,
  );
}

/// Filter for transaction history.
class TxFilter {
  const TxFilter({
    this.fromDate,
    this.toDate,
    this.types,
    this.statuses,
    this.accountId,
    this.fundId,
    this.personId,
    this.categoryId,
    this.obligationId,
    this.samityId,
    this.search,
    this.fundScope,
  });

  final int? fromDate;
  final int? toDate;
  final Set<TxType>? types;
  final Set<TxStatus>? statuses;
  final String? accountId;
  final String? fundId;
  final String? personId;
  final String? categoryId;
  final String? obligationId;
  final String? samityId;
  final String? search;

  /// Funds the viewer may see (null = all).
  final Set<String>? fundScope;

  TxFilter copyWith({
    int? fromDate,
    int? toDate,
    Set<TxType>? types,
    Set<TxStatus>? statuses,
    String? accountId,
    String? fundId,
    String? personId,
    String? categoryId,
    String? search,
    Set<String>? fundScope,
  }) => TxFilter(
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    types: types ?? this.types,
    statuses: statuses ?? this.statuses,
    accountId: accountId ?? this.accountId,
    fundId: fundId ?? this.fundId,
    personId: personId ?? this.personId,
    categoryId: categoryId ?? this.categoryId,
    obligationId: obligationId,
    samityId: samityId,
    search: search ?? this.search,
    fundScope: fundScope ?? this.fundScope,
  );
}

/// Keyset pagination cursor for newest-first history.
class TxCursor {
  const TxCursor(this.dateKey, this.sortKey, this.id);
  TxCursor.of(TxRow r) : this(r.dateKey, r.sortKey, r.id);
  final int dateKey;
  final int sortKey;
  final String id;
}

/// Creates, posts, reverses and queries ledger transactions.
///
/// Every mutation runs inside one SQLite transaction together with its audit
/// event and outbox entry, so a crash can never leave a posted entry that
/// is not queued for sync or not audited.
class LedgerRepository {
  LedgerRepository(
    this.db, {
    required this.actor,
    AuditLog? audit,
    OutboxRepository? outbox,
  }) : audit = audit ?? AuditLog(db),
       outbox = outbox ?? OutboxRepository(db);

  final AppDatabase db;
  final ActorContext actor;
  final AuditLog audit;
  final OutboxRepository outbox;

  Future<MapLedgerLookup> loadLookup() async {
    final accounts = await db.select(db.ledgerAccounts).get();
    final funds = await db.select(db.funds).get();
    final samities = await db.select(db.samities).get();
    final obligations = await db.select(db.obligations).get();
    return MapLedgerLookup(
      accounts: [
        for (final a in accounts) AccountRef(a.id, a.kind, a.accountClass),
      ],
      funds: [
        for (final f in funds)
          FundRef(f.id, f.kind, ownerPersonId: f.ownerPersonId),
      ],
      samities: [
        for (final s in samities) SamityRef(s.id, s.mode, fundId: s.fundId),
      ],
      obligations: [
        for (final o in obligations)
          ObligationRef(o.id, o.kind, o.personId, o.fundId, status: o.status),
      ],
    );
  }

  /// Validates [draft] without saving. Returns field errors (empty = valid).
  Future<PostingPlan> preview(TxDraft draft) async =>
      PostingEngine(await loadLookup()).plan(draft.input);

  /// Saves [draft] with the requested [target] status.
  ///
  /// * [TxStatus.draft]: stored as entered; no lines, no effect on balances.
  /// * [TxStatus.pending] / [TxStatus.posted]: must validate, else
  ///   [TxValidationException] is thrown and nothing is written.
  ///
  /// Saving an id that is already committed returns
  /// [SaveOutcome.alreadyExists] without writing anything.
  Future<SaveResult> save(TxDraft draft, {required TxStatus target}) async {
    assert(
      target == TxStatus.draft ||
          target == TxStatus.pending ||
          target == TxStatus.posted,
    );
    actor.require(Permission.writeTransactions);
    if (draft.input.type == TxType.reversal) {
      throw LedgerStateException('use_reverse');
    }
    return db.transaction(() async {
      final existing = await _tx(draft.id);
      if (existing != null &&
          existing.status != TxStatus.draft &&
          existing.status != TxStatus.pending) {
        return SaveResult(draft.id, SaveOutcome.alreadyExists);
      }
      if (existing?.status == TxStatus.pending && target == TxStatus.draft) {
        throw LedgerStateException('pending_to_draft');
      }
      if (target == TxStatus.draft) {
        await _writeRow(draft, TxStatus.draft, existing);
        await audit.append(
          actorId: actor.actorId,
          entityType: 'tx',
          entityId: draft.id,
          action: existing == null ? 'draft_created' : 'draft_updated',
        );
        return SaveResult(
          draft.id,
          existing == null ? SaveOutcome.created : SaveOutcome.updated,
        );
      }

      final lookup = await loadLookup();
      final plan = PostingEngine(lookup).plan(draft.input);
      if (!plan.isComplete) throw TxValidationException(plan.errors);

      var obligationId = draft.input.obligationId;
      final kind = PostingEngine.obligationKindFor(draft.input.type);
      final opensObligation = const {
        TxType.loanGiven,
        TxType.loanTaken,
        TxType.advancePaid,
      }.contains(draft.input.type);
      if (obligationId == null && opensObligation && kind != null) {
        obligationId = const Uuid().v4();
        final now = DateTime.now();
        await db
            .into(db.obligations)
            .insert(
              ObligationsCompanion.insert(
                id: obligationId,
                kind: kind,
                personId: plan.personId!,
                fundId: plan.fundId!,
                title: Value(draft.input.description),
                openedOn: draft.dateKey,
                createdAt: now,
                updatedAt: now,
              ),
            );
        await outbox.enqueue('obligation', obligationId);
      }

      final resolved = draft.input.copyWith(
        fundId: plan.fundId,
        personId: plan.personId,
        obligationId: obligationId,
      );
      await _commit(
        TxDraft(
          id: draft.id,
          input: resolved,
          dateKey: draft.dateKey,
          notes: draft.notes,
          referenceNo: draft.referenceNo,
          reconSessionId: draft.reconSessionId,
        ),
        plan.lines,
        target,
        existing,
      );
      if (obligationId != null) await _refreshObligationStatus(obligationId);
      return SaveResult(
        draft.id,
        existing == null ? SaveOutcome.created : SaveOutcome.updated,
      );
    });
  }

  Future<void> _commit(
    TxDraft d,
    List<LineSpec> lines,
    TxStatus target,
    TxRow? existing, {
    String? reversesTxId,
    String? replacesTxId,
    TxType? typeOverride,
  }) async {
    await _writeRow(
      d,
      TxStatus.staging,
      existing,
      reversesTxId: reversesTxId,
      replacesTxId: replacesTxId,
      typeOverride: typeOverride,
    );
    await (db.delete(
      db.transactionLines,
    )..where((t) => t.txId.equals(d.id))).go();
    for (var i = 0; i < lines.length; i++) {
      final l = lines[i];
      await db
          .into(db.transactionLines)
          .insert(
            TransactionLinesCompanion.insert(
              txId: d.id,
              lineNo: i,
              accountId: l.accountId,
              fundId: l.fundId,
              amount: l.amount,
              personId: Value(l.personId),
              counterFundId: Value(l.counterFundId),
            ),
          );
    }
    final row = (await _tx(d.id))!;
    final hash = contentHashOf(row, lines);
    final now = DateTime.now();
    await (db.update(
      db.ledgerTransactions,
    )..where((t) => t.id.equals(d.id))).write(
      LedgerTransactionsCompanion(
        status: Value(target),
        contentHash: Value(hash),
        postedAt: Value(target == TxStatus.posted ? now : null),
        updatedAt: Value(now),
      ),
    );
    await audit.append(
      actorId: actor.actorId,
      entityType: 'tx',
      entityId: d.id,
      action: target == TxStatus.posted ? 'posted' : 'pending',
      details: {
        'type': (typeOverride ?? d.input.type).name,
        'amount': d.input.amount,
        'hash': hash,
        'reverses': ?reversesTxId,
        'replaces': ?replacesTxId,
      },
    );
    await outbox.enqueue('tx', d.id);
  }

  Future<void> _writeRow(
    TxDraft d,
    TxStatus status,
    TxRow? existing, {
    String? reversesTxId,
    String? replacesTxId,
    TxType? typeOverride,
  }) async {
    final i = d.input;
    final now = DateTime.now();
    final deviceId = await db.getKv(Kv.deviceId);
    final companion = LedgerTransactionsCompanion(
      id: Value(d.id),
      type: Value(typeOverride ?? i.type),
      status: Value(status),
      dateKey: Value(d.dateKey),
      amount: Value(i.amount),
      fee: Value(i.fee),
      increase: Value(i.increase),
      description: Value(i.description),
      notes: Value(d.notes),
      referenceNo: Value(d.referenceNo),
      categoryId: Value(i.categoryId),
      personId: Value(i.personId),
      fundId: Value(i.fundId),
      toFundId: Value(i.toFundId),
      fromAccountId: Value(i.fromAccountId),
      toAccountId: Value(i.toAccountId),
      obligationId: Value(i.obligationId),
      samityId: Value(i.samityId),
      reconSessionId: Value(d.reconSessionId),
      reversesTxId: Value(reversesTxId),
      replacesTxId: Value(replacesTxId),
      createdBy: Value(existing?.createdBy ?? actor.actorId),
      modifiedBy: Value(actor.actorId),
      createdAt: Value(existing?.createdAt ?? now),
      sortKey: Value(existing?.sortKey ?? now.microsecondsSinceEpoch),
      updatedAt: Value(now),
      version: Value((existing?.version ?? 0) + 1),
      syncStatus: Value(
        status == TxStatus.draft ? SyncStatus.localOnly : SyncStatus.pending,
      ),
      deviceId: Value(deviceId),
    );
    if (existing == null) {
      await db.into(db.ledgerTransactions).insert(companion);
    } else {
      await (db.update(
        db.ledgerTransactions,
      )..where((t) => t.id.equals(d.id))).write(companion);
    }
  }

  /// Stable hash of the immutable financial content of a transaction.
  static String contentHashOf(TxRow t, List<LineSpec> lines) => sha256Hex(
    canonicalJson({
      'id': t.id,
      'type': t.type.name,
      'dateKey': t.dateKey,
      'amount': t.amount,
      'currency': t.currency,
      'fee': t.fee,
      'increase': t.increase,
      'description': t.description,
      'categoryId': t.categoryId,
      'personId': t.personId,
      'fundId': t.fundId,
      'toFundId': t.toFundId,
      'fromAccountId': t.fromAccountId,
      'toAccountId': t.toAccountId,
      'obligationId': t.obligationId,
      'samityId': t.samityId,
      'reversesTxId': t.reversesTxId,
      'createdBy': t.createdBy,
      'lines': [for (final l in lines) l.toJson()],
    }),
  );

  /// Confirms a pending transaction.
  Future<void> postPending(String id) async {
    actor.require(Permission.writeTransactions);
    await db.transaction(() async {
      final t = await _tx(id);
      if (t == null || t.status != TxStatus.pending) {
        throw LedgerStateException('not_pending');
      }
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        LedgerTransactionsCompanion(
          status: const Value(TxStatus.posted),
          postedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          modifiedBy: Value(actor.actorId),
          version: Value(t.version + 1),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await audit.append(
        actorId: actor.actorId,
        entityType: 'tx',
        entityId: id,
        action: 'posted',
      );
      await outbox.enqueue('tx', id);
    });
  }

  Future<void> cancelPending(String id, String reason) async {
    actor.require(Permission.writeTransactions);
    await db.transaction(() async {
      final t = await _tx(id);
      if (t == null || t.status != TxStatus.pending) {
        throw LedgerStateException('not_pending');
      }
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        LedgerTransactionsCompanion(
          status: const Value(TxStatus.cancelled),
          updatedAt: Value(DateTime.now()),
          modifiedBy: Value(actor.actorId),
          version: Value(t.version + 1),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await audit.append(
        actorId: actor.actorId,
        entityType: 'tx',
        entityId: id,
        action: 'cancelled',
        details: {'reason': reason},
      );
      await outbox.enqueue('tx', id);
    });
  }

  Future<void> deleteDraft(String id) async {
    actor.require(Permission.writeTransactions);
    await db.transaction(() async {
      final t = await _tx(id);
      if (t == null) return;
      if (t.status != TxStatus.draft) throw LedgerStateException('not_draft');
      await (db.delete(db.attachments)..where((a) => a.txId.equals(id))).go();
      await (db.delete(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).go();
      await audit.append(
        actorId: actor.actorId,
        entityType: 'tx',
        entityId: id,
        action: 'draft_deleted',
      );
    });
  }

  /// Corrects a posted transaction by appending an exact reversal and,
  /// optionally, a replacement entry. The original is never modified except
  /// for the link to its reversal.
  Future<String> reverse(
    String id, {
    required String reason,
    int? dateKey,
    TxDraft? replacement,
  }) async {
    actor.require(Permission.reverseTransactions);
    if (reason.trim().isEmpty)
      throw TxValidationException({'reason': PostingError.required});
    return db.transaction(() async {
      final orig = await getWithLines(id);
      if (orig == null || orig.tx.status != TxStatus.posted) {
        throw LedgerStateException('not_posted');
      }
      if (orig.tx.reversedByTxId != null)
        throw LedgerStateException('already_reversed');
      if (orig.tx.type == TxType.reversal)
        throw LedgerStateException('reverse_reversal');
      final revId = const Uuid().v4();
      final t = orig.tx;
      final lines = PostingEngine.buildReversal(orig.specs);
      await _commit(
        TxDraft(
          id: revId,
          dateKey: dateKey ?? DateKey.today(),
          input: TxInput(
            type: t.type,
            amount: t.amount,
            fundId: t.fundId,
            toFundId: t.toFundId,
            personId: t.personId,
            categoryId: t.categoryId,
            fromAccountId: t.fromAccountId,
            toAccountId: t.toAccountId,
            obligationId: t.obligationId,
            samityId: t.samityId,
            description: reason.trim(),
          ),
        ),
        lines,
        TxStatus.posted,
        null,
        reversesTxId: id,
        typeOverride: TxType.reversal,
      );
      await (db.update(
        db.ledgerTransactions,
      )..where((x) => x.id.equals(id))).write(
        LedgerTransactionsCompanion(
          reversedByTxId: Value(revId),
          updatedAt: Value(DateTime.now()),
          modifiedBy: Value(actor.actorId),
          version: Value(t.version + 1),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await audit.append(
        actorId: actor.actorId,
        entityType: 'tx',
        entityId: id,
        action: 'reversed',
        details: {'reversal': revId, 'reason': reason.trim()},
      );
      await outbox.enqueue('tx', id);
      if (t.obligationId != null)
        await _refreshObligationStatus(t.obligationId!);
      if (replacement != null) {
        final plan = PostingEngine(await loadLookup()).plan(replacement.input);
        if (!plan.isComplete) throw TxValidationException(plan.errors);
        await _commit(
          replacement,
          plan.lines,
          TxStatus.posted,
          null,
          replacesTxId: id,
        );
      }
      return revId;
    });
  }

  /// Marks an obligation settled when its outstanding balance reaches zero
  /// and reopens it if a later entry (e.g. a reversal) changes that.
  Future<void> _refreshObligationStatus(String obligationId) async {
    final outstanding = await obligationOutstanding(obligationId);
    final o = await (db.select(
      db.obligations,
    )..where((x) => x.id.equals(obligationId))).getSingleOrNull();
    if (o == null) return;
    final status = outstanding == 0
        ? ObligationStatus.settled
        : ObligationStatus.open;
    if (status != o.status) {
      await (db.update(
        db.obligations,
      )..where((x) => x.id.equals(obligationId))).write(
        ObligationsCompanion(
          status: Value(status),
          updatedAt: Value(DateTime.now()),
          version: Value(o.version + 1),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await outbox.enqueue('obligation', obligationId);
    }
  }

  /// Outstanding amount of an obligation, always >= 0 when not overpaid.
  /// Receivables: what the person still owes. Payables: what I still owe.
  Future<int> obligationOutstanding(String obligationId) async {
    final row = await db
        .customSelect(
          '''SELECT o.kind AS kind, COALESCE(SUM(l.amount), 0) AS bal
             FROM obligations o
             LEFT JOIN ledger_transactions t ON t.obligation_id = o.id AND t.status = 'posted'
             LEFT JOIN transaction_lines l ON l.tx_id = t.id
               AND l.account_id IN (?, ?, ?)
             WHERE o.id = ? GROUP BY o.id''',
          variables: [
            Variable(SystemAccounts.loansReceivable),
            Variable(SystemAccounts.advancesReceivable),
            Variable(SystemAccounts.loansPayable),
            Variable(obligationId),
          ],
        )
        .getSingleOrNull();
    if (row == null) return 0;
    final bal = row.read<int>('bal');
    return row.read<String>('kind') == ObligationKind.loanTaken.name
        ? -bal
        : bal;
  }

  Future<TxRow?> _tx(String id) => (db.select(
    db.ledgerTransactions,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<TxWithLines?> getWithLines(String id) async {
    final t = await _tx(id);
    if (t == null) return null;
    final lines =
        await (db.select(db.transactionLines)
              ..where((l) => l.txId.equals(id))
              ..orderBy([(l) => OrderingTerm.asc(l.lineNo)]))
            .get();
    if (actor.fundScope != null &&
        lines.any((l) => !actor.canReadFund(l.fundId))) {
      return null;
    }
    return TxWithLines(t, lines);
  }

  Stream<TxRow?> watchTx(String id) => (db.select(
    db.ledgerTransactions,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Newest-first page of transactions matching [filter].
  Future<List<TxRow>> page(TxFilter filter, {int limit = 50, TxCursor? after}) {
    final q = _filtered(filter);
    if (after != null) {
      final c = after;
      q.where(
        (t) =>
            t.dateKey.isSmallerThanValue(c.dateKey) |
            (t.dateKey.equals(c.dateKey) &
                (t.sortKey.isSmallerThanValue(c.sortKey) |
                    (t.sortKey.equals(c.sortKey) &
                        t.id.isSmallerThanValue(c.id)))),
      );
    }
    q
      ..orderBy([
        (t) => OrderingTerm.desc(t.dateKey),
        (t) => OrderingTerm.desc(t.sortKey),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(limit);
    return q.get();
  }

  Stream<List<TxRow>> watchPage(TxFilter filter, {int limit = 50}) {
    final q = _filtered(filter)
      ..orderBy([
        (t) => OrderingTerm.desc(t.dateKey),
        (t) => OrderingTerm.desc(t.sortKey),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(limit);
    return q.watch();
  }

  SimpleSelectStatement<$LedgerTransactionsTable, TxRow> _filtered(TxFilter f) {
    final q = db.select(db.ledgerTransactions);
    q.where((t) => t.status.isNotValue(TxStatus.staging.name));
    if (f.fromDate != null)
      q.where((t) => t.dateKey.isBiggerOrEqualValue(f.fromDate!));
    if (f.toDate != null)
      q.where((t) => t.dateKey.isSmallerOrEqualValue(f.toDate!));
    if (f.types != null)
      q.where((t) => t.type.isIn(f.types!.map((e) => e.name)));
    if (f.statuses != null) {
      q.where((t) => t.status.isIn(f.statuses!.map((e) => e.name)));
    }
    if (f.personId != null) {
      final p = f.personId!;
      q.where(
        (t) =>
            t.personId.equals(p) |
            existsQuery(
              db.select(db.transactionLines)
                ..where((l) => l.txId.equalsExp(t.id) & l.personId.equals(p)),
            ),
      );
    }
    if (f.categoryId != null)
      q.where((t) => t.categoryId.equals(f.categoryId!));
    if (f.obligationId != null)
      q.where((t) => t.obligationId.equals(f.obligationId!));
    if (f.samityId != null) q.where((t) => t.samityId.equals(f.samityId!));
    if (f.accountId != null) {
      final a = f.accountId!;
      q.where(
        (t) =>
            t.fromAccountId.equals(a) |
            t.toAccountId.equals(a) |
            existsQuery(
              db.select(db.transactionLines)
                ..where((l) => l.txId.equalsExp(t.id) & l.accountId.equals(a)),
            ),
      );
    }
    if (f.fundId != null) {
      final fid = f.fundId!;
      q.where(
        (t) =>
            t.fundId.equals(fid) |
            t.toFundId.equals(fid) |
            existsQuery(
              db.select(db.transactionLines)
                ..where((l) => l.txId.equalsExp(t.id) & l.fundId.equals(fid)),
            ),
      );
    }
    final scope = f.fundScope ?? actor.fundScope;
    if (scope != null) {
      // Hide any transaction touching a fund outside the viewer's scope.
      q.where(
        (t) =>
            t.fundId.isIn(scope) &
            notExistsQuery(
              db.select(
                db.transactionLines,
              )..where((l) => l.txId.equalsExp(t.id) & l.fundId.isNotIn(scope)),
            ),
      );
    }
    if (f.search != null && f.search!.trim().isNotEmpty) {
      final s = '%${f.search!.trim()}%';
      q.where(
        (t) => t.description.like(s) | t.notes.like(s) | t.referenceNo.like(s),
      );
    }
    return q;
  }

  /// Committed transactions that look like [draft]: same type, amount and
  /// day, and the same main account. Used to warn before saving.
  Future<List<TxRow>> possibleDuplicates(TxDraft draft) async {
    final i = draft.input;
    if (i.amount == null) return [];
    final q = db.select(db.ledgerTransactions)
      ..where(
        (t) =>
            t.id.isNotValue(draft.id) &
            t.type.equalsValue(i.type) &
            t.amount.equals(i.amount!) &
            t.dateKey.equals(draft.dateKey) &
            t.status.isIn([TxStatus.posted.name, TxStatus.pending.name]) &
            t.reversedByTxId.isNull(),
      );
    final rows = await q.get();
    return rows
        .where(
          (t) =>
              (i.fromAccountId == null || t.fromAccountId == i.fromAccountId) &&
              (i.toAccountId == null || t.toAccountId == i.toAccountId) &&
              (i.personId == null || t.personId == i.personId),
        )
        .toList();
  }

  Future<int> countByStatus(TxStatus s) async {
    final c = db.ledgerTransactions.id.count();
    final q = db.selectOnly(db.ledgerTransactions)
      ..addColumns([c])
      ..where(db.ledgerTransactions.status.equalsValue(s));
    return (await q.getSingle()).read(c) ?? 0;
  }
}
