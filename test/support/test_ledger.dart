import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:sahel_ledger/data/db/database.dart';
import 'package:sahel_ledger/data/repositories/ledger_repository.dart';
import 'package:sahel_ledger/data/repositories/master_repository.dart';
import 'package:sahel_ledger/data/repositories/reports_repository.dart';
import 'package:sahel_ledger/domain/access/access.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';
import 'package:sahel_ledger/domain/ledger/posting_engine.dart';

AppDatabase openTestDb() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

int tk(num taka) => (taka * 100).round();

/// A seeded household for repository tests.
class TestLedger {
  TestLedger._(this.db, this.actor);

  final AppDatabase db;
  final ActorContext actor;
  late final ledger = LedgerRepository(db, actor: actor);
  late final master = MasterRepository(db, actor: actor);
  late final reports = ReportsRepository(db, actor: actor);

  late String me;
  late String personal;
  late String cash;
  late String bank;
  late String bkash;
  late String sister;
  late String sisterFund;
  late String friend;

  static Future<TestLedger> create({
    AppDatabase? db,
    ActorContext actor = ActorContext.localOwner,
  }) async {
    final t = TestLedger._(db ?? openTestDb(), actor);
    await t.master.completeOnboarding(selfName: 'Sahel');
    t.me = (await t.master.selfPersonId())!;
    t.personal = (await t.master.personalFundId())!;
    t.cash = (await t.master.allAccounts())
        .firstWhere((a) => a.storageType == StorageType.cash)
        .id;
    t.bank = await t.master.createStorageAccount(
      name: 'Dutch-Bangla Bank',
      type: StorageType.bank,
      numberHint: '1234567890',
    );
    t.bkash = await t.master.createStorageAccount(
      name: 'bKash',
      type: StorageType.mobileWallet,
    );
    t.sister = await t.master.createPerson(name: 'Ruma', relation: 'sister');
    t.sisterFund = await t.master.createFund(
      name: "Ruma's savings",
      kind: FundKind.entrusted,
      ownerPersonId: t.sister,
    );
    t.friend = await t.master.createPerson(name: 'Karim', relation: 'friend');
    return t;
  }

  /// Same database seen by a different actor.
  TestLedger as(ActorContext other) {
    final t = TestLedger._(db, other)
      ..me = me
      ..personal = personal
      ..cash = cash
      ..bank = bank
      ..bkash = bkash
      ..sister = sister
      ..sisterFund = sisterFund
      ..friend = friend;
    return t;
  }

  Future<String> post(
    TxInput input, {
    int? date,
    TxStatus status = TxStatus.posted,
    String? id,
  }) async {
    final d = TxDraft(id: id, input: input, dateKey: date ?? 20261001);
    await ledger.save(d, target: status);
    return d.id;
  }

  Future<String> income(
    int amount, {
    String? to,
    String? fund,
    int? date,
    String category = 'cat.inc.salary',
  }) => post(
    TxInput(
      type: TxType.income,
      amount: amount,
      toAccountId: to ?? cash,
      fundId: fund ?? personal,
      categoryId: category,
    ),
    date: date,
  );

  Future<String> expense(
    int amount, {
    String? from,
    String? fund,
    int? date,
    String category = 'cat.exp.food',
  }) => post(
    TxInput(
      type: TxType.expense,
      amount: amount,
      fromAccountId: from ?? cash,
      fundId: fund ?? personal,
      categoryId: category,
    ),
    date: date,
  );
}
