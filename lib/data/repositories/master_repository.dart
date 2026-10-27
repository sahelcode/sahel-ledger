import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../domain/ledger/posting_engine.dart';
import '../db/database.dart';
import 'audit_log.dart';
import 'ledger_repository.dart';
import 'outbox_repository.dart';

/// People, funds, accounts, categories, samities and budgets.
class MasterRepository {
  MasterRepository(this.db, {required this.actor})
    : audit = AuditLog(db),
      outbox = OutboxRepository(db);

  final AppDatabase db;
  final ActorContext actor;
  final AuditLog audit;
  final OutboxRepository outbox;

  String _id() => const Uuid().v4();

  Future<void> _logged(
    String type,
    String id,
    String action, [
    Map<String, Object?>? details,
  ]) async {
    await audit.append(
      actorId: actor.actorId,
      entityType: type,
      entityId: id,
      action: action,
      details: details,
    );
    await outbox.enqueue(type, id);
  }

  // ---------------------------------------------------------------- setup

  Future<bool> isOnboarded() async => (await db.getKv(Kv.onboarded)) == 'true';

  /// First-run setup: the user's own person record, personal fund and a
  /// cash wallet. Safe to call twice.
  Future<void> completeOnboarding({
    required String selfName,
    int openingCash = 0,
  }) async {
    await db.transaction(() async {
      if (await isOnboarded()) return;
      final now = DateTime.now();
      await db.setKv(Kv.deviceId, (await db.getKv(Kv.deviceId)) ?? _id());
      final selfId = _id();
      final fundId = _id();
      final cashId = _id();
      await db
          .into(db.persons)
          .insert(
            PersonsCompanion.insert(
              id: selfId,
              name: selfName,
              relation: const Value('self'),
              isSelf: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.funds)
          .insert(
            FundsCompanion.insert(
              id: fundId,
              name: 'Personal',
              kind: FundKind.personal,
              ownerPersonId: Value(selfId),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.ledgerAccounts)
          .insert(
            LedgerAccountsCompanion.insert(
              id: cashId,
              kind: LedgerAccountKind.storage,
              accountClass: AccountClass.asset,
              storageType: const Value(StorageType.cash),
              name: 'Cash',
              nameBn: const Value('নগদ'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.setKv(Kv.selfPersonId, selfId);
      await db.setKv(Kv.personalFundId, fundId);
      for (final (t, id) in [
        ('person', selfId),
        ('fund', fundId),
        ('account', cashId),
      ]) {
        await _logged(t, id, 'created');
      }
      if (openingCash > 0) {
        await LedgerRepository(db, actor: actor).save(
          TxDraft(
            dateKey: DateKey.today(),
            input: TxInput(
              type: TxType.openingBalance,
              amount: openingCash,
              toAccountId: cashId,
              fundId: fundId,
              description: 'Opening cash',
            ),
          ),
          target: TxStatus.posted,
        );
      }
      await db.setKv(Kv.onboarded, 'true');
    });
  }

  /// Setup for a device that joins an existing household (a second phone
  /// or an invited member): nothing is seeded locally, everything arrives
  /// through sync. Seeding here would create a duplicate personal fund.
  Future<void> completeOnboardingForJoin() async {
    await db.transaction(() async {
      if (await isOnboarded()) return;
      await db.setKv(Kv.deviceId, (await db.getKv(Kv.deviceId)) ?? _id());
      await db.setKv(Kv.onboarded, 'true');
    });
  }

  Future<String?> selfPersonId() => db.getKv(Kv.selfPersonId);
  Future<String?> personalFundId() => db.getKv(Kv.personalFundId);

  // --------------------------------------------------------------- people

  Future<String> createPerson({
    required String name,
    String relation = 'other',
    String? phone,
    String? notes,
    bool createEntrustedFund = false,
  }) async {
    actor.require(Permission.manageMasterData);
    return db.transaction(() async {
      final id = _id();
      final now = DateTime.now();
      await db
          .into(db.persons)
          .insert(
            PersonsCompanion.insert(
              id: id,
              name: name.trim(),
              relation: Value(relation),
              phone: Value(phone),
              notes: Value(notes),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _logged('person', id, 'created');
      if (createEntrustedFund) {
        await createFund(
          name: name.trim(),
          kind: FundKind.entrusted,
          ownerPersonId: id,
        );
      }
      return id;
    });
  }

  Future<void> updatePerson(
    String id, {
    required int expectedVersion,
    String? name,
    String? relation,
    String? phone,
    String? notes,
    bool? archived,
  }) async {
    actor.require(Permission.manageMasterData);
    await db.transaction(() async {
      final n =
          await (db.update(db.persons)..where(
                (p) => p.id.equals(id) & p.version.equals(expectedVersion),
              ))
              .write(
                PersonsCompanion(
                  name: name == null
                      ? const Value.absent()
                      : Value(name.trim()),
                  relation: relation == null
                      ? const Value.absent()
                      : Value(relation),
                  phone: Value.absentIfNull(phone),
                  notes: Value.absentIfNull(notes),
                  archived: Value.absentIfNull(archived),
                  version: Value(expectedVersion + 1),
                  updatedAt: Value(DateTime.now()),
                  syncStatus: const Value(SyncStatus.pending),
                ),
              );
      if (n == 0) throw LedgerStateException('stale_version');
      await _logged('person', id, 'updated');
    });
  }

  Stream<List<PersonRow>> watchPersons({bool includeArchived = false}) {
    final q = db.select(db.persons)
      ..orderBy([
        (p) => OrderingTerm.desc(p.isSelf),
        (p) => OrderingTerm.asc(p.name),
      ]);
    if (!includeArchived) q.where((p) => p.archived.equals(false));
    return q.watch();
  }

  Future<PersonRow?> person(String id) =>
      (db.select(db.persons)..where((p) => p.id.equals(id))).getSingleOrNull();

  // ---------------------------------------------------------------- funds

  Future<String> createFund({
    required String name,
    required FundKind kind,
    String? ownerPersonId,
    String? description,
  }) async {
    actor.require(Permission.manageMasterData);
    if (kind == FundKind.personal) {
      throw LedgerStateException('single_personal_fund');
    }
    if ((kind == FundKind.entrusted || kind == FundKind.purpose) &&
        ownerPersonId == null) {
      throw TxValidationException({'person': PostingError.required});
    }
    return db.transaction(() async {
      final id = _id();
      final now = DateTime.now();
      await db
          .into(db.funds)
          .insert(
            FundsCompanion.insert(
              id: id,
              name: name.trim(),
              kind: kind,
              ownerPersonId: Value(ownerPersonId),
              description: Value(description),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _logged('fund', id, 'created', {'kind': kind.name});
      return id;
    });
  }

  Stream<List<FundRow>> watchFunds({bool includeArchived = false}) {
    final q = db.select(db.funds)
      ..orderBy([
        (f) => OrderingTerm.asc(f.kind),
        (f) => OrderingTerm.asc(f.name),
      ]);
    if (!includeArchived) q.where((f) => f.archived.equals(false));
    final scope = actor.fundScope;
    if (scope != null) q.where((f) => f.id.isIn(scope));
    return q.watch();
  }

  Future<List<FundRow>> funds() => watchFunds().first;

  Future<void> archiveFund(String id, {required bool archived}) async {
    actor.require(Permission.manageMasterData);
    await db.transaction(() async {
      final f = await (db.select(
        db.funds,
      )..where((x) => x.id.equals(id))).getSingle();
      if (f.kind == FundKind.personal) {
        throw LedgerStateException('personal_fund');
      }
      await (db.update(db.funds)..where((x) => x.id.equals(id))).write(
        FundsCompanion(
          archived: Value(archived),
          version: Value(f.version + 1),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await _logged('fund', id, archived ? 'archived' : 'unarchived');
    });
  }

  // ------------------------------------------------------------- accounts

  /// Creates a storage account (cash, bank, bKash, Nagad...). If
  /// [openingBalance] is given it is posted as an opening-balance entry in
  /// [openingFundId] (default: personal fund).
  Future<String> createStorageAccount({
    required String name,
    required StorageType type,
    String? institution,
    String? numberHint,
    int openingBalance = 0,
    String? openingFundId,
    int? openingDate,
  }) async {
    actor.require(Permission.manageMasterData);
    if (numberHint != null &&
        numberHint.replaceAll(RegExp(r'\D'), '').length > 4) {
      // Never store full account numbers on device or in the cloud.
      numberHint = numberHint.replaceAll(RegExp(r'\D'), '');
      numberHint = numberHint.substring(numberHint.length - 4);
    }
    return db.transaction(() async {
      final id = _id();
      final now = DateTime.now();
      final count = await db
          .select(db.ledgerAccounts)
          .get()
          .then(
            (l) => l.where((a) => a.kind == LedgerAccountKind.storage).length,
          );
      await db
          .into(db.ledgerAccounts)
          .insert(
            LedgerAccountsCompanion.insert(
              id: id,
              kind: LedgerAccountKind.storage,
              accountClass: AccountClass.asset,
              storageType: Value(type),
              name: name.trim(),
              institution: Value(institution),
              numberHint: Value(numberHint),
              sortOrder: Value(count),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _logged('account', id, 'created');
      if (openingBalance > 0) {
        await LedgerRepository(db, actor: actor).save(
          TxDraft(
            dateKey: openingDate ?? DateKey.today(),
            input: TxInput(
              type: TxType.openingBalance,
              amount: openingBalance,
              toAccountId: id,
              fundId: openingFundId ?? await personalFundId(),
              description: 'Opening balance',
            ),
          ),
          target: TxStatus.posted,
        );
      }
      return id;
    });
  }

  Future<String> createCategory({
    required bool income,
    required String name,
    String? nameBn,
  }) async {
    actor.require(Permission.manageMasterData);
    return db.transaction(() async {
      final id = 'cat.${income ? 'inc' : 'exp'}.${_id().substring(0, 8)}';
      final now = DateTime.now();
      await db
          .into(db.ledgerAccounts)
          .insert(
            LedgerAccountsCompanion.insert(
              id: id,
              kind: income
                  ? LedgerAccountKind.incomeCategory
                  : LedgerAccountKind.expenseCategory,
              accountClass: income ? AccountClass.income : AccountClass.expense,
              name: name.trim(),
              nameBn: Value(nameBn),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _logged('account', id, 'created');
      return id;
    });
  }

  Future<void> updateAccount(
    String id, {
    required int expectedVersion,
    String? name,
    String? institution,
    String? numberHint,
    bool? archived,
  }) async {
    actor.require(Permission.manageMasterData);
    await db.transaction(() async {
      final n =
          await (db.update(db.ledgerAccounts)..where(
                (a) =>
                    a.id.equals(id) &
                    a.version.equals(expectedVersion) &
                    a.isSystem.equals(false),
              ))
              .write(
                LedgerAccountsCompanion(
                  name: name == null
                      ? const Value.absent()
                      : Value(name.trim()),
                  institution: Value.absentIfNull(institution),
                  numberHint: Value.absentIfNull(numberHint),
                  archived: Value.absentIfNull(archived),
                  version: Value(expectedVersion + 1),
                  updatedAt: Value(DateTime.now()),
                  syncStatus: const Value(SyncStatus.pending),
                ),
              );
      if (n == 0) throw LedgerStateException('stale_version');
      await _logged('account', id, 'updated');
    });
  }

  Stream<List<LedgerAccountRow>> watchAccounts(
    Set<LedgerAccountKind> kinds, {
    bool includeArchived = false,
  }) {
    final q = db.select(db.ledgerAccounts)
      ..where((a) => a.kind.isIn(kinds.map((k) => k.name)))
      ..orderBy([
        (a) => OrderingTerm.asc(a.sortOrder),
        (a) => OrderingTerm.asc(a.name),
      ]);
    if (!includeArchived) q.where((a) => a.archived.equals(false));
    return q.watch();
  }

  Future<List<LedgerAccountRow>> allAccounts() =>
      db.select(db.ledgerAccounts).get();

  // ------------------------------------------------------------- samities

  Future<String> createSamity({
    required String name,
    required SamityMode mode,
    required int contributionAmount,
    String frequency = 'monthly',
    required int startOn,
    List<String> memberIds = const [],
    String? notes,
  }) async {
    actor.require(Permission.manageMasterData);
    return db.transaction(() async {
      final id = _id();
      final now = DateTime.now();
      String? fundId;
      if (mode == SamityMode.managed) {
        fundId = await createFund(
          name: name,
          kind: FundKind.samity,
          description: 'Samity pool',
        );
      }
      await db
          .into(db.samities)
          .insert(
            SamitiesCompanion.insert(
              id: id,
              name: name.trim(),
              mode: mode,
              fundId: Value(fundId),
              contributionAmount: Value(contributionAmount),
              frequency: Value(frequency),
              startOn: startOn,
              notes: Value(notes),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _logged('samity', id, 'created');
      for (final m in memberIds) {
        await addSamityMember(id, m, joinedOn: startOn);
      }
      return id;
    });
  }

  Future<void> addSamityMember(
    String samityId,
    String personId, {
    int shares = 1,
    required int joinedOn,
  }) async {
    actor.require(Permission.manageMasterData);
    final now = DateTime.now();
    await db
        .into(db.samityMembers)
        .insertOnConflictUpdate(
          SamityMembersCompanion.insert(
            samityId: samityId,
            personId: personId,
            shares: Value(shares),
            joinedOn: joinedOn,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _logged('samity', samityId, 'member_added', {'person': personId});
  }

  Stream<List<SamityRow>> watchSamities() =>
      (db.select(db.samities)
            ..where((s) => s.archived.equals(false))
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .watch();

  Future<List<SamityMemberRow>> samityMembers(String samityId) => (db.select(
    db.samityMembers,
  )..where((m) => m.samityId.equals(samityId))).get();

  // ---------------------------------------------------------- obligations

  Stream<List<ObligationRow>> watchObligations({Set<ObligationKind>? kinds}) {
    final q = db.select(db.obligations)
      ..orderBy([
        (o) => OrderingTerm.asc(o.status),
        (o) => OrderingTerm.desc(o.openedOn),
      ]);
    if (kinds != null) q.where((o) => o.kind.isIn(kinds.map((k) => k.name)));
    final scope = actor.fundScope;
    if (scope != null) q.where((o) => o.fundId.isIn(scope));
    return q.watch();
  }

  Future<void> setObligationDueDate(String id, int? dueOn) async {
    actor.require(Permission.writeTransactions);
    await db.transaction(() async {
      final o = await (db.select(
        db.obligations,
      )..where((x) => x.id.equals(id))).getSingle();
      await (db.update(db.obligations)..where((x) => x.id.equals(id))).write(
        ObligationsCompanion(
          dueOn: Value(dueOn),
          version: Value(o.version + 1),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      await _logged('obligation', id, 'due_date_set', {'dueOn': dueOn});
    });
  }

  // -------------------------------------------------------------- budgets

  Future<void> setBudget(int monthKey, String categoryId, int limit) async {
    actor.require(Permission.manageMasterData);
    await db.transaction(() async {
      final existing =
          await (db.select(db.budgets)..where(
                (b) =>
                    b.monthKey.equals(monthKey) &
                    b.categoryId.equals(categoryId),
              ))
              .getSingleOrNull();
      final now = DateTime.now();
      if (existing == null) {
        final id = _id();
        await db
            .into(db.budgets)
            .insert(
              BudgetsCompanion.insert(
                id: id,
                monthKey: monthKey,
                categoryId: categoryId,
                limitAmount: limit,
                createdAt: now,
                updatedAt: now,
              ),
            );
        await _logged('budget', id, 'created');
      } else {
        await (db.update(
          db.budgets,
        )..where((b) => b.id.equals(existing.id))).write(
          BudgetsCompanion(
            limitAmount: Value(limit),
            version: Value(existing.version + 1),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatus.pending),
          ),
        );
        await _logged('budget', existing.id, 'updated');
      }
    });
  }
}
