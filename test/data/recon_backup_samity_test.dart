import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/data/backup/backup_service.dart';
import 'package:sahel_ledger/data/repositories/audit_log.dart';
import 'package:sahel_ledger/data/repositories/reconciliation_repository.dart';
import 'package:sahel_ledger/data/repositories/reports_repository.dart';
import 'package:sahel_ledger/domain/access/access.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';
import 'package:sahel_ledger/domain/ledger/posting_engine.dart';

import '../support/test_ledger.dart';

void main() {
  late TestLedger t;
  setUp(() async => t = await TestLedger.create());
  tearDown(() => t.db.close());

  group('reconciliation', () {
    test('matching count needs no adjustment', () async {
      await t.income(tk(1500));
      final recon = ReconciliationRepository(t.db, actor: t.actor);
      final s = await recon.start(
        accountId: t.cash,
        actualBalance: tk(1500),
        asOf: 20261031,
      );
      expect(s.status, ReconStatus.matched);
      expect(s.expectedBalance, tk(1500));
    });

    test('difference stays visible until an explained adjustment', () async {
      await t.income(tk(1500));
      final recon = ReconciliationRepository(t.db, actor: t.actor);
      final s = await recon.start(
        accountId: t.cash,
        actualBalance: tk(1450),
        asOf: 20261031,
      );
      expect(s.status, ReconStatus.unresolved);
      // Nothing was auto-corrected.
      expect((await t.reports.dashboard()).totalStorage, tk(1500));
      final diag = await t.reports.diagnostics();
      expect(
        diag.any(
          (d) =>
              d.kind == DiagnosticKind.unresolvedReconciliation &&
              d.amount == -tk(50),
        ),
        isTrue,
      );
      await expectLater(
        recon.proposeAdjustment(s.id, reason: 'x'),
        throwsA(isA<Exception>()),
      );
      final txId = await recon.proposeAdjustment(
        s.id,
        reason: 'Counted cash after Eid shopping; receipt lost',
      );
      expect((await recon.get(s.id))!.status, ReconStatus.adjusted);
      expect((await t.reports.dashboard()).totalStorage, tk(1450));
      final tx = (await t.ledger.getWithLines(txId))!;
      expect(tx.tx.type, TxType.adjustment);
      expect(tx.tx.reconSessionId, s.id);
    });

    test('a delegated admin proposal needs approval by someone else', () async {
      await t.income(tk(1000));
      final admin = t.as(
        const ActorContext(
          actorId: 'admin',
          role: HouseholdRole.admin,
          delegated: {Permission.writeTransactions, Permission.readAll},
        ),
      );
      final adminRecon = ReconciliationRepository(t.db, actor: admin.actor);
      final s = await adminRecon.start(
        accountId: t.cash,
        actualBalance: tk(1100),
        asOf: 20261031,
      );
      await adminRecon.proposeAdjustment(s.id, reason: 'Found money in drawer');
      expect((await adminRecon.get(s.id))!.status, ReconStatus.pendingApproval);
      expect(
        (await t.reports.dashboard()).totalStorage,
        tk(1000),
        reason: 'not approved yet',
      );
      await expectLater(
        adminRecon.approve(s.id),
        throwsA(isA<PermissionDenied>()),
      );
      await ReconciliationRepository(t.db, actor: t.actor).approve(s.id);
      expect((await t.reports.dashboard()).totalStorage, tk(1100));
      final events = await AuditLog(t.db).forEntity('recon', s.id);
      expect(events.map((e) => e.action), [
        'started',
        'adjustment_proposed',
        'approved',
      ]);
    });

    test('rejecting a proposal cancels the pending entry', () async {
      await t.income(tk(1000));
      final admin = t.as(
        const ActorContext(
          actorId: 'admin',
          role: HouseholdRole.admin,
          delegated: {Permission.writeTransactions, Permission.readAll},
        ),
      );
      final r = ReconciliationRepository(t.db, actor: admin.actor);
      final s = await r.start(accountId: t.cash, actualBalance: tk(900));
      final txId = await r.proposeAdjustment(s.id, reason: 'Missing 100 taka');
      await ReconciliationRepository(
        t.db,
        actor: t.actor,
      ).reject(s.id, 'Recount first');
      expect((await r.get(s.id))!.status, ReconStatus.unresolved);
      expect(
        (await t.ledger.getWithLines(txId))!.tx.status,
        TxStatus.cancelled,
      );
      expect((await t.reports.dashboard()).totalStorage, tk(1000));
    });
  });

  group('samity', () {
    test('managed samity tracks per-member dues', () async {
      final m2 = await t.master.createPerson(name: 'Jahanara');
      final samity = await t.master.createSamity(
        name: 'Para Samity',
        mode: SamityMode.managed,
        contributionAmount: tk(500),
        startOn: 20260801,
        memberIds: [t.sister, m2],
      );
      for (final d in [20260805, 20260905, 20261005]) {
        await t.post(
          TxInput(
            type: TxType.samityContribution,
            amount: tk(500),
            fromAccountId: t.cash,
            samityId: samity,
            personId: t.sister,
          ),
          date: d,
        );
      }
      await t.post(
        TxInput(
          type: TxType.samityContribution,
          amount: tk(500),
          fromAccountId: t.cash,
          samityId: samity,
          personId: m2,
        ),
        date: 20260806,
      );
      final status = await t.reports.samityStatus(samity, asOf: 20261015);
      final sister = status.firstWhere((s) => s.personId == t.sister);
      final other = status.firstWhere((s) => s.personId == m2);
      expect(sister.expected, tk(1500));
      expect(sister.due, 0);
      expect(other.due, tk(1000));
      final funds = await t.reports.fundBalances();
      final pool = funds.firstWhere((f) => f.fund.kind == FundKind.samity);
      expect(pool.net, tk(2000));
      final d = await t.reports.dashboard();
      expect(d.personalNet, 0, reason: 'samity pool is not my money');
      expect(d.entrustedStorage, tk(2000));
    });

    test('reversed contribution is no longer counted as paid', () async {
      final samity = await t.master.createSamity(
        name: 'S',
        mode: SamityMode.managed,
        contributionAmount: tk(100),
        startOn: 20261001,
        memberIds: [t.sister],
      );
      final id = await t.post(
        TxInput(
          type: TxType.samityContribution,
          amount: tk(100),
          fromAccountId: t.cash,
          samityId: samity,
          personId: t.sister,
        ),
      );
      await t.ledger.reverse(id, reason: 'wrong member', dateKey: 20261002);
      final status = await t.reports.samityStatus(samity, asOf: 20261015);
      expect(status.single.paid, 0);
    });
  });

  test('an admin without read-all cannot reconcile a shared account', () async {
    final admin = t.as(
      const ActorContext(
        actorId: 'a',
        role: HouseholdRole.admin,
        delegated: {Permission.writeTransactions},
      ),
    );
    await expectLater(
      ReconciliationRepository(
        t.db,
        actor: admin.actor,
      ).start(accountId: t.cash, actualBalance: 1),
      throwsA(isA<PermissionDenied>()),
    );
  });

  test('budget status uses only expenses of the month', () async {
    await t.income(tk(10000));
    await t.master.setBudget(202610, 'cat.exp.food', tk(3000));
    await t.expense(tk(1200), date: 20261003);
    await t.expense(tk(900), date: 20261020);
    await t.expense(tk(5000), date: 20261101);
    final b = await t.reports.budgetStatus(202610);
    expect(b.single.spent, tk(2100));
    expect(b.single.ratio, closeTo(0.7, 1e-9));
  });

  group('backup and restore', () {
    Future<void> populate() async {
      await t.income(tk(1000));
      final id = await t.expense(tk(250));
      await t.ledger.reverse(id, reason: 'mistake');
      await t.post(
        TxInput(
          type: TxType.fundDeposit,
          amount: tk(700),
          toAccountId: t.bank,
          fundId: t.sisterFund,
          personId: t.sister,
        ),
      );
    }

    test('round trip reproduces balances, history and audit chain', () async {
      await populate();
      final svc = BackupService(t.db);
      final json = await svc.exportJson();
      final before = await t.reports.dashboard();
      final info = svc.inspect(json);
      expect(info.transactionCount, 4);

      // Restore into a brand new database.
      final other = openTestDb();
      addTearDown(other.close);
      await other.select(other.keyValues).get(); // runs onCreate
      await BackupService(other).restore(json);
      final restored = ReportsRepository(other, actor: t.actor);
      final after = await restored.dashboard();
      expect(after.totalStorage, before.totalStorage);
      expect(after.personalNet, before.personalNet);
      expect(after.entrustedNet, before.entrustedNet);
      expect(await AuditLog(other).verifyChain(), isNull);
      // Integrity triggers are active again after restore.
      final posted = await (other.select(
        other.ledgerTransactions,
      )..where((x) => x.status.equalsValue(TxStatus.posted))).get();
      await expectLater(
        other.customStatement(
          'UPDATE ledger_transactions SET amount = 1 WHERE id = ?',
          [posted.first.id],
        ),
        throwsA(anything),
      );
    });

    test('a tampered backup is refused', () async {
      await populate();
      final svc = BackupService(t.db);
      final map = jsonDecode(await svc.exportJson()) as Map<String, Object?>;
      final tables = map['tables']! as Map<String, Object?>;
      final lines = tables['transaction_lines']! as List;
      (lines.first as Map)['amount'] = 999999;
      expect(
        () => svc.inspect(jsonEncode(map)),
        throwsA(isA<BackupException>()),
      );
      expect(() => svc.inspect('not json'), throwsA(isA<BackupException>()));
      expect(
        () => svc.inspect('{"format":"other"}'),
        throwsA(isA<BackupException>()),
      );
    });

    test(
      'an internally inconsistent backup rolls back and keeps current data',
      () async {
        await populate();
        final svc = BackupService(t.db);
        final before = await t.reports.dashboard();
        final map = jsonDecode(await svc.exportJson()) as Map<String, Object?>;
        final tables = map['tables']! as Map<String, Object?>;
        final lines = tables['transaction_lines']! as List;
        (lines.first as Map)['amount'] =
            ((lines.first as Map)['amount'] as int) + 1;
        // Re-sign the checksum so only the deep verification can catch it.
        map['checksum'] = sha256Hex(canonicalJson(tables));
        await expectLater(
          svc.restore(jsonEncode(map)),
          throwsA(isA<BackupException>()),
        );
        final after = await t.reports.dashboard();
        expect(after.totalStorage, before.totalStorage);
        expect(await t.db.select(t.db.ledgerTransactions).get(), hasLength(4));
        await expectLater(
          t.db.customStatement('DELETE FROM ledger_transactions'),
          throwsA(anything),
          reason: 'triggers survived the rollback',
        );
      },
    );
  });
}
