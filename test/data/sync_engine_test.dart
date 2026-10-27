import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/data/db/database.dart';
import 'package:sahel_ledger/data/repositories/ledger_repository.dart';
import 'package:sahel_ledger/data/repositories/master_repository.dart';
import 'package:sahel_ledger/data/repositories/reports_repository.dart';
import 'package:sahel_ledger/data/sync/household_directory.dart';
import 'package:sahel_ledger/data/sync/remote_store.dart';
import 'package:sahel_ledger/data/sync/sync_engine.dart';
import 'package:sahel_ledger/domain/access/access.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';
import 'package:sahel_ledger/domain/ledger/posting_engine.dart';

import '../support/fake_remote_store.dart';
import '../support/test_ledger.dart';

const hid = 'household-1';
const ownerUid = 'uid-owner';
const memberUid = 'uid-ruma';

void main() {
  late FakeRemoteStore remote;
  late TestLedger a; // owner's phone
  late AppDatabase bDb; // owner's second device
  late HouseholdDirectory directory;
  late MemberInfo owner;

  const ownerActor = ActorContext(actorId: ownerUid, role: HouseholdRole.owner);

  SyncEngine engineFor(AppDatabase db, MemberInfo viewer) => SyncEngine(
    db: db,
    remote: remote,
    householdId: hid,
    viewer: viewer,
    directory: directory,
  );

  setUp(() async {
    remote = FakeRemoteStore();
    a = await TestLedger.create(actor: ownerActor);
    bDb = openTestDb();
    await bDb.select(bDb.keyValues).get();
    owner = const MemberInfo(uid: ownerUid, role: HouseholdRole.owner);
    directory = HouseholdDirectory([
      owner,
      MemberInfo(
        uid: memberUid,
        role: HouseholdRole.member,
        fundIds: {a.sisterFund},
        personIds: {a.sister},
      ),
    ]);
  });
  tearDown(() async {
    await a.db.close();
    await bDb.close();
  });

  Future<int> outboxSize(AppDatabase db) async =>
      (await db.select(db.outbox).get()).length;

  test('a second device receives an identical ledger', () async {
    await a.income(tk(5000), to: a.bank);
    await a.post(
      TxInput(
        type: TxType.fundDeposit,
        amount: tk(2000),
        toAccountId: a.bank,
        fundId: a.sisterFund,
        personId: a.sister,
      ),
    );
    final id = await a.expense(tk(300), from: a.bank);
    await a.ledger.reverse(id, reason: 'duplicate');
    final r1 = await engineFor(a.db, owner).syncNow();
    expect(r1.clean, isTrue, reason: '$r1 ${r1.errors}');
    expect(await outboxSize(a.db), 0);

    final r2 = await engineFor(bDb, owner).syncNow();
    expect(r2.clean, isTrue, reason: '$r2 ${r2.errors}');
    final da = await a.reports.dashboard();
    final db = await ReportsRepository(bDb, actor: ownerActor).dashboard();
    expect(db.totalStorage, da.totalStorage);
    expect(db.personalNet, da.personalNet);
    expect(db.entrustedNet, da.entrustedNet);
    final reversed = await (bDb.select(
      bDb.ledgerTransactions,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(reversed.reversedByTxId, isNotNull);
    expect(reversed.syncStatus, SyncStatus.synced);
  });

  test('offline: nothing is lost, retries back off, then succeeds', () async {
    await a.income(tk(100));
    remote.offline = true;
    final now = DateTime.now();
    final r = await engineFor(a.db, owner).push(null, now);
    expect(r.failed, greaterThan(0));
    final entries = await a.db.select(a.db.outbox).get();
    expect(entries, isNotEmpty);
    final failed = entries.where((e) => e.state == 'failed').toList();
    expect(failed, isNotEmpty);
    expect(failed.first.nextAttemptAt.isAfter(now), isTrue);
    // Back online: untried entries go now, the failed one waits its backoff.
    remote.offline = false;
    await engineFor(a.db, owner).push(null, now);
    final waiting = await a.db.select(a.db.outbox).get();
    expect(waiting.map((e) => e.seq), failed.map((e) => e.seq));
    // Later it goes through.
    final later = await engineFor(
      a.db,
      owner,
    ).push(null, now.add(const Duration(hours: 2)));
    expect(later.failed, 0, reason: '${later.errors}');
    expect(await outboxSize(a.db), 0);
    final tx = await a.db.select(a.db.ledgerTransactions).get();
    expect(tx.every((t) => t.syncStatus == SyncStatus.synced), isTrue);
  });

  test('a lost acknowledgement never creates a duplicate', () async {
    final id = await a.income(tk(100));
    remote.loseAcks = 100; // every write commits but the client sees an error
    await engineFor(a.db, owner).push();
    expect(
      await outboxSize(a.db),
      greaterThan(0),
      reason: 'not confirmed, so kept',
    );
    remote.loseAcks = 0;
    final later = DateTime.now().add(const Duration(hours: 2));
    final r = await engineFor(a.db, owner).push(null, later);
    expect(r.alreadyPresent, greaterThan(0));
    expect(await outboxSize(a.db), 0);
    expect(
      remote.collections['transactions']!.keys.where((k) => k == id),
      hasLength(1),
    );
  });

  test('restart mid-sync resumes from the durable outbox', () async {
    await a.income(tk(100));
    await a.expense(tk(10));
    remote.failWrites = 4; // the first few uploads die (e.g. app killed)
    await engineFor(a.db, owner).push();
    // "Restart": brand new engine instances on the same database, retried
    // as the scheduler would, until the queue drains.
    var t = DateTime.now();
    for (var i = 0; i < 10 && await outboxSize(a.db) > 0; i++) {
      t = t.add(const Duration(hours: 2));
      await engineFor(a.db, owner).push(null, t);
    }
    expect(await outboxSize(a.db), 0);
    expect(remote.failWrites, 0);
    expect(remote.collections['transactions'], hasLength(2));
  });

  test('re-delivered documents are applied once', () async {
    await a.income(tk(100));
    await engineFor(a.db, owner).syncNow();
    await engineFor(bDb, owner).pull();
    // Forget the cursors: the server sends everything again.
    await (bDb.delete(
      bDb.keyValues,
    )..where((k) => k.key.like('pull_cursor.%'))).go();
    final again = await engineFor(bDb, owner).pull();
    expect(again.pulled, 0);
    expect(await bDb.select(bDb.ledgerTransactions).get(), hasLength(1));
  });

  test('entries made offline on two devices merge without loss', () async {
    await engineFor(a.db, owner).syncNow();
    await engineFor(bDb, owner).syncNow();
    final bLedger = LedgerRepository(bDb, actor: ownerActor);
    await a.income(tk(100));
    await bLedger.save(
      TxDraft(
        dateKey: 20261002,
        input: TxInput(
          type: TxType.income,
          amount: tk(250),
          toAccountId: a.cash,
          fundId: a.personal,
          categoryId: 'cat.inc.gift',
        ),
      ),
      target: TxStatus.posted,
    );
    await engineFor(a.db, owner).syncNow();
    await engineFor(bDb, owner).syncNow();
    await engineFor(a.db, owner).syncNow();
    final ta = (await a.reports.dashboard()).totalStorage;
    final tb = (await ReportsRepository(
      bDb,
      actor: ownerActor,
    ).dashboard()).totalStorage;
    expect(ta, tk(350));
    expect(tb, tk(350));
  });

  test(
    'the same entry reversed differently on two devices is a conflict',
    () async {
      await a.income(tk(1000));
      final id = await a.expense(tk(100));
      await engineFor(a.db, owner).syncNow();
      await engineFor(bDb, owner).syncNow();
      final bLedger = LedgerRepository(bDb, actor: ownerActor);
      await a.ledger.reverse(id, reason: 'wrong amount');
      await bLedger.reverse(id, reason: 'wrong category');
      final ra = await engineFor(a.db, owner).syncNow();
      expect(ra.clean, isTrue);
      final rb = await engineFor(bDb, owner).syncNow();
      expect(rb.conflicts, greaterThan(0));
      final local = await (bDb.select(
        bDb.ledgerTransactions,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(local.syncStatus, SyncStatus.conflict);
      // The conflict is parked, never discarded.
      final parked = await (bDb.select(
        bDb.outbox,
      )..where((o) => o.state.equals('conflict'))).get();
      expect(parked, isNotEmpty);
      final diag = await ReportsRepository(
        bDb,
        actor: ownerActor,
      ).diagnostics();
      expect(diag.any((d) => d.kind == DiagnosticKind.syncConflict), isTrue);
    },
  );

  test(
    'a pending entry posted on one device and cancelled on another conflicts',
    () async {
      await a.income(tk(1000));
      final pid = await a.post(
        TxInput(
          type: TxType.expense,
          amount: tk(50),
          fromAccountId: a.cash,
          fundId: a.personal,
          categoryId: 'cat.exp.food',
        ),
        status: TxStatus.pending,
      );
      await engineFor(a.db, owner).syncNow();
      await engineFor(bDb, owner).syncNow();
      await a.ledger.postPending(pid);
      await LedgerRepository(
        bDb,
        actor: ownerActor,
      ).cancelPending(pid, 'not paid');
      await engineFor(a.db, owner).syncNow();
      final rb = await engineFor(bDb, owner).syncNow();
      expect(rb.conflicts, greaterThan(0));
    },
  );

  test('pending posted elsewhere is caught up locally', () async {
    await a.income(tk(1000));
    final pid = await a.post(
      TxInput(
        type: TxType.expense,
        amount: tk(50),
        fromAccountId: a.cash,
        fundId: a.personal,
        categoryId: 'cat.exp.food',
      ),
      status: TxStatus.pending,
    );
    await engineFor(a.db, owner).syncNow();
    await engineFor(bDb, owner).syncNow();
    await a.ledger.postPending(pid);
    await engineFor(a.db, owner).syncNow();
    await engineFor(bDb, owner).syncNow();
    final local = await (bDb.select(
      bDb.ledgerTransactions,
    )..where((t) => t.id.equals(pid))).getSingle();
    expect(local.status, TxStatus.posted);
    expect(
      (await ReportsRepository(
        bDb,
        actor: ownerActor,
      ).dashboard()).totalStorage,
      tk(950),
    );
  });

  test('a member device only receives permitted documents', () async {
    await a.income(tk(9000));
    await a.post(
      TxInput(
        type: TxType.fundDeposit,
        amount: tk(4000),
        toAccountId: a.bank,
        fundId: a.sisterFund,
        personId: a.sister,
      ),
    );
    await a.post(
      TxInput(
        type: TxType.loanGiven,
        amount: tk(100),
        fromAccountId: a.cash,
        fundId: a.personal,
        personId: a.friend,
      ),
    );
    await engineFor(a.db, owner).syncNow();
    final memberDb = openTestDb();
    addTearDown(memberDb.close);
    await memberDb.select(memberDb.keyValues).get();
    final member = directory.members.firstWhere((m) => m.uid == memberUid);
    final r = await engineFor(memberDb, member).pull();
    expect(r.failed, 0, reason: '${r.errors}');
    final txs = await memberDb.select(memberDb.ledgerTransactions).get();
    expect(txs, hasLength(1));
    expect(txs.single.fundId, a.sisterFund);
    final persons = await memberDb.select(memberDb.persons).get();
    expect(persons.map((p) => p.id), [
      a.sister,
    ], reason: 'no friend, no owner record');
    final funds = await memberDb.select(memberDb.funds).get();
    expect(funds.map((f) => f.id), [a.sisterFund]);
    final d = await ReportsRepository(
      memberDb,
      actor: member.toActor(),
    ).dashboard();
    expect(d.totalStorage, tk(4000));
  });

  test('a tampered or unbalanced server document is rejected', () async {
    final id = await a.income(tk(100));
    await engineFor(a.db, owner).syncNow();
    final doc = remote.doc('transactions', id)!;
    final lines = (doc['lines']! as List).cast<Map<String, Object?>>();
    lines.first['amount'] = (lines.first['amount']! as int) + 1;
    final r = await engineFor(bDb, owner).pull();
    expect(r.rejected, 1);
    expect(await bDb.select(bDb.ledgerTransactions).get(), isEmpty);
    // Balanced but with altered amounts: hash mismatch.
    lines.first['amount'] = 999;
    lines.last['amount'] = -999;
    await (bDb.delete(
      bDb.keyValues,
    )..where((k) => k.key.like('pull_cursor.%'))).go();
    final r2 = await engineFor(bDb, owner).pull();
    expect(r2.rejected, 1);
  });

  test('concurrent master-data edits are flagged, not overwritten', () async {
    await engineFor(a.db, owner).syncNow();
    await engineFor(bDb, owner).syncNow();
    final pa = (await a.master.person(a.friend))!;
    await a.master.updatePerson(
      a.friend,
      expectedVersion: pa.version,
      name: 'Karim Uddin',
    );
    // Device B edits the same person from the same base version.
    final bMaster = MasterRepository(bDb, actor: ownerActor);
    await bMaster.updatePerson(
      a.friend,
      expectedVersion: pa.version,
      name: 'Karim Bhai',
    );
    await (bDb.update(bDb.persons)..where((p) => p.id.equals(a.friend))).write(
      PersonsCompanion(
        name: const Value('Karim Bhai'),
        version: Value(pa.version + 1),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
    await engineFor(a.db, owner).syncNow();
    final rb = await engineFor(bDb, owner).syncNow();
    expect(rb.conflicts, greaterThan(0));
    final local = await (bDb.select(
      bDb.persons,
    )..where((p) => p.id.equals(a.friend))).getSingle();
    expect(local.name, 'Karim Bhai', reason: 'local edit kept for review');
  });

  test(
    'a joining device seeds nothing and ends with one personal fund',
    () async {
      await a.income(tk(100));
      await engineFor(a.db, owner).syncNow();
      final joined = openTestDb();
      addTearDown(joined.close);
      await MasterRepository(
        joined,
        actor: ownerActor,
      ).completeOnboardingForJoin();
      expect(await joined.select(joined.funds).get(), isEmpty);
      expect(await joined.select(joined.persons).get(), isEmpty);
      final r = await engineFor(joined, owner).syncNow();
      expect(r.clean, isTrue, reason: '${r.errors}');
      final personal = (await joined.select(joined.funds).get()).where(
        (f) => f.kind == FundKind.personal,
      );
      expect(personal.map((f) => f.id), [a.personal]);
      expect(await outboxSize(joined), 0, reason: 'nothing local to upload');
    },
  );

  test('write decisions', () {
    final base = {
      'contentHash': 'h',
      'status': 'posted',
      'version': 1,
      'readerUids': ['a'],
    };
    expect(decideTxWrite(null, base), TxWriteDecision.create);
    expect(decideTxWrite(base, base), TxWriteDecision.noop);
    expect(
      decideTxWrite(base, {...base, 'contentHash': 'x', 'version': 5}),
      TxWriteDecision.conflict,
    );
    expect(
      decideTxWrite(
        {...base, 'status': 'pending'},
        {...base, 'contentHash': 'x', 'version': 2, 'status': 'pending'},
      ),
      TxWriteDecision.overwrite,
    );
    expect(
      decideTxWrite({...base, 'status': 'pending'}, base),
      TxWriteDecision.updateMutable,
    );
    expect(
      decideTxWrite(base, {...base, 'status': 'pending'}),
      TxWriteDecision.noop,
    );
    expect(
      decideTxWrite(base, {...base, 'status': 'cancelled'}),
      TxWriteDecision.conflict,
    );
    expect(
      decideTxWrite(base, {...base, 'reversedByTxId': 'r1'}),
      TxWriteDecision.updateMutable,
    );
    expect(
      decideTxWrite(
        {...base, 'reversedByTxId': 'r1'},
        {...base, 'reversedByTxId': 'r2'},
      ),
      TxWriteDecision.conflict,
    );
    expect(
      decideTxWrite(base, {
        ...base,
        'readerUids': ['a', 'b'],
      }),
      TxWriteDecision.updateMutable,
    );
  });
}
