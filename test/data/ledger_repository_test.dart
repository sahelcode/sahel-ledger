import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/data/repositories/audit_log.dart';
import 'package:sahel_ledger/data/repositories/ledger_repository.dart';
import 'package:sahel_ledger/data/repositories/reports_repository.dart';
import 'package:sahel_ledger/domain/access/access.dart';
import 'package:sahel_ledger/domain/ledger/balances.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';
import 'package:sahel_ledger/domain/ledger/posting_engine.dart';

import '../support/test_ledger.dart';

void main() {
  late TestLedger t;
  setUp(() async => t = await TestLedger.create());
  tearDown(() => t.db.close());

  group('onboarding', () {
    test('creates self, personal fund, cash and system accounts', () async {
      final persons = await t.db.select(t.db.persons).get();
      expect(persons.where((p) => p.isSelf), hasLength(1));
      final funds = await t.db.select(t.db.funds).get();
      expect(funds.where((f) => f.kind == FundKind.personal), hasLength(1));
      final accts = await t.master.allAccounts();
      for (final id in SystemAccounts.all.keys) {
        expect(accts.any((a) => a.id == id), isTrue, reason: id);
      }
      await t.master.completeOnboarding(selfName: 'Again');
      expect(await t.db.select(t.db.persons).get(), hasLength(persons.length));
    });

    test('only the last 4 digits of an account number are stored', () async {
      final bank = (await t.master.allAccounts()).firstWhere(
        (a) => a.id == t.bank,
      );
      expect(bank.numberHint, '7890');
    });
  });

  group('posting and balances', () {
    test('dashboard separates personal and entrusted money', () async {
      await t.income(tk(30000), to: t.bank);
      await t.post(
        TxInput(
          type: TxType.fundDeposit,
          amount: tk(50000),
          toAccountId: t.bank,
          fundId: t.sisterFund,
          personId: t.sister,
        ),
      );
      await t.post(
        TxInput(
          type: TxType.transfer,
          amount: tk(10000),
          fromAccountId: t.bank,
          toAccountId: t.bkash,
          fundId: t.personal,
        ),
      );
      await t.post(
        TxInput(
          type: TxType.loanGiven,
          amount: tk(5000),
          fromAccountId: t.bkash,
          fundId: t.personal,
          personId: t.friend,
        ),
      );
      await t.expense(tk(1200.50), from: t.bkash, date: 20261002);
      final d = await t.reports.dashboard(monthKey: 202610);
      expect(d.totalStorage, tk(30000) + tk(50000) - tk(5000) - tk(1200.50));
      expect(d.entrustedStorage, tk(50000));
      expect(d.entrustedNet, tk(50000));
      expect(
        d.personalNet,
        tk(30000) - tk(1200.50),
        reason: 'loan is still mine',
      );
      expect(d.receivables, tk(5000));
      expect(d.payables, 0);
      expect(
        d.monthIncome,
        tk(30000),
        reason: 'deposit + transfer are not income',
      );
      expect(d.monthExpense, tk(1200.50));
    });

    test('SQL balances agree with the reference calculator', () async {
      await t.income(tk(1000));
      await t.expense(tk(250));
      await t.post(
        TxInput(
          type: TxType.interFundLoan,
          amount: tk(100),
          fromAccountId: t.cash,
          fundId: t.personal,
          toFundId: t.sisterFund,
        ),
      );
      final lines = await t.db.select(t.db.transactionLines).get();
      final accounts = {for (final a in await t.master.allAccounts()) a.id: a};
      final ref = computePosition(
        lines.map((l) => l.toSpec()),
        (id) => AccountRef(id, accounts[id]!.kind, accounts[id]!.accountClass),
      );
      final balances = await t.reports.accountBalances();
      for (final b in balances) {
        expect(b.balance, ref.storage(b.account.id), reason: b.account.name);
      }
      for (final f in await t.reports.fundBalances()) {
        expect(f.net, ref.fundNet(f.fund.id), reason: f.fund.name);
      }
    });

    test('invalid input is rejected and nothing is written', () async {
      final before = await t.db.select(t.db.ledgerTransactions).get();
      await expectLater(
        t.ledger.save(
          TxDraft(
            dateKey: 20261001,
            input: const TxInput(type: TxType.expense, amount: 100),
          ),
          target: TxStatus.posted,
        ),
        throwsA(isA<TxValidationException>()),
      );
      expect(
        await t.db.select(t.db.ledgerTransactions).get(),
        hasLength(before.length),
      );
    });

    test('drafts store incomplete facts and do not affect balances', () async {
      final draft = TxDraft(
        dateKey: 20261001,
        input: const TxInput(
          type: TxType.expense,
          amount: 50000,
          description: 'Unknown fund',
        ),
      );
      await t.ledger.save(draft, target: TxStatus.draft);
      expect((await t.reports.dashboard()).draftCount, 1);
      expect((await t.reports.dashboard()).totalStorage, 0);
      // Complete and post the same draft (same id, no duplicate).
      await t.income(tk(1000));
      final completed = TxDraft(
        id: draft.id,
        dateKey: 20261001,
        input: TxInput(
          type: TxType.expense,
          amount: 50000,
          fromAccountId: t.cash,
          fundId: t.personal,
          categoryId: 'cat.exp.food',
        ),
      );
      final r = await t.ledger.save(completed, target: TxStatus.posted);
      expect(r.outcome, SaveOutcome.updated);
      final d = await t.reports.dashboard();
      expect(d.draftCount, 0);
      expect(d.totalStorage, tk(1000) - 50000);
      await expectLater(
        t.ledger.deleteDraft(draft.id),
        throwsA(isA<LedgerStateException>()),
      );
    });

    test('pending entries are excluded until posted', () async {
      await t.income(tk(500));
      final id = await t.expense(tk(200));
      final pendingId = await t.post(
        TxInput(
          type: TxType.expense,
          amount: tk(100),
          fromAccountId: t.cash,
          fundId: t.personal,
          categoryId: 'cat.exp.food',
        ),
        status: TxStatus.pending,
      );
      expect(id, isNot(pendingId));
      expect((await t.reports.dashboard()).totalStorage, tk(300));
      await t.ledger.postPending(pendingId);
      expect((await t.reports.dashboard()).totalStorage, tk(200));
    });

    test('double submission of the same form is idempotent', () async {
      final d = TxDraft(
        dateKey: 20261001,
        input: TxInput(
          type: TxType.income,
          amount: tk(100),
          toAccountId: t.cash,
          fundId: t.personal,
          categoryId: 'cat.inc.gift',
        ),
      );
      final a = await t.ledger.save(d, target: TxStatus.posted);
      final b = await t.ledger.save(d, target: TxStatus.posted);
      expect(a.outcome, SaveOutcome.created);
      expect(b.outcome, SaveOutcome.alreadyExists);
      expect((await t.reports.dashboard()).totalStorage, tk(100));
    });

    test('possible duplicates are reported before saving', () async {
      await t.expense(tk(300), date: 20261005);
      await t.income(tk(1000));
      final dupes = await t.ledger.possibleDuplicates(
        TxDraft(
          dateKey: 20261005,
          input: TxInput(
            type: TxType.expense,
            amount: tk(300),
            fromAccountId: t.cash,
            fundId: t.personal,
            categoryId: 'cat.exp.food',
          ),
        ),
      );
      expect(dupes, hasLength(1));
      await t.expense(tk(300), date: 20261005);
      final diag = await t.reports.diagnostics();
      expect(
        diag.any((d) => d.kind == DiagnosticKind.possibleDuplicate),
        isTrue,
      );
    });
  });

  group('database integrity triggers', () {
    late String id;
    setUp(() async {
      await t.income(tk(1000));
      id = await t.expense(tk(400));
    });

    test('posted amount cannot be changed', () async {
      await expectLater(
        t.db.customStatement(
          'UPDATE ledger_transactions SET amount = 1 WHERE id = ?',
          [id],
        ),
        throwsA(anything),
      );
      await expectLater(
        t.db.customStatement(
          "UPDATE ledger_transactions SET status = 'draft' WHERE id = ?",
          [id],
        ),
        throwsA(anything),
      );
    });

    test('posted lines cannot be changed, added or deleted', () async {
      await expectLater(
        t.db.customStatement(
          'UPDATE transaction_lines SET amount = amount * 2 WHERE tx_id = ?',
          [id],
        ),
        throwsA(anything),
      );
      await expectLater(
        t.db.customStatement('DELETE FROM transaction_lines WHERE tx_id = ?', [
          id,
        ]),
        throwsA(anything),
      );
      await expectLater(
        t.db.customStatement(
          "INSERT INTO transaction_lines (tx_id, line_no, account_id, fund_id, amount) VALUES (?, 9, ?, ?, 5)",
          [id, t.cash, t.personal],
        ),
        throwsA(anything),
      );
    });

    test('posted transactions cannot be deleted', () async {
      await expectLater(
        t.db.customStatement('DELETE FROM ledger_transactions WHERE id = ?', [
          id,
        ]),
        throwsA(anything),
      );
    });

    test('unbalanced lines can never be posted', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await t.db.customStatement(
        "INSERT INTO ledger_transactions (id, type, status, date_key, amount, created_by, modified_by, created_at, updated_at, sort_key) VALUES ('bad', 'expense', 'staging', 20261001, 100, 'x', 'x', $now, $now, 1)",
      );
      await t.db.customStatement(
        "INSERT INTO transaction_lines (tx_id, line_no, account_id, fund_id, amount) VALUES ('bad', 0, ?, ?, 100), ('bad', 1, 'cat.exp.food', ?, -99)",
        [t.cash, t.personal, t.personal],
      );
      await expectLater(
        t.db.customStatement(
          "UPDATE ledger_transactions SET status = 'posted' WHERE id = 'bad'",
        ),
        throwsA(anything),
      );
      // Cross-fund leak: balanced overall but not per fund.
      await t.db.customStatement(
        "DELETE FROM transaction_lines WHERE tx_id = 'bad'",
      );
      await t.db.customStatement(
        "INSERT INTO transaction_lines (tx_id, line_no, account_id, fund_id, amount) VALUES ('bad', 0, ?, ?, 100), ('bad', 1, ?, ?, -100)",
        [t.cash, t.personal, t.bank, t.sisterFund],
      );
      await expectLater(
        t.db.customStatement(
          "UPDATE ledger_transactions SET status = 'posted' WHERE id = 'bad'",
        ),
        throwsA(anything),
      );
    });

    test('committed rows cannot be inserted directly', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await expectLater(
        t.db.customStatement(
          "INSERT INTO ledger_transactions (id, type, status, date_key, amount, created_by, modified_by, created_at, updated_at, sort_key) VALUES ('x', 'expense', 'posted', 20261001, 100, 'x', 'x', $now, $now, 1)",
        ),
        throwsA(anything),
      );
    });

    test('audit log is append-only and hash chained', () async {
      final audit = AuditLog(t.db);
      expect(await audit.verifyChain(), isNull);
      await expectLater(
        t.db.customStatement(
          "UPDATE audit_events SET action = 'nothing' WHERE seq = 1",
        ),
        throwsA(anything),
      );
      await expectLater(
        t.db.customStatement('DELETE FROM audit_events'),
        throwsA(anything),
      );
      // Simulate tampering that bypasses triggers: detection still works.
      await t.db.customStatement('DROP TRIGGER audit_no_update');
      await t.db.customStatement(
        "UPDATE audit_events SET details = '{}' WHERE seq = 2",
      );
      expect(await audit.verifyChain(), 2);
    });
  });

  group('reversal and correction', () {
    test('reverse keeps the original and nets to zero', () async {
      await t.income(tk(1000));
      final id = await t.expense(tk(400));
      final revId = await t.ledger.reverse(
        id,
        reason: 'Entered twice',
        dateKey: 20261003,
      );
      final orig = (await t.ledger.getWithLines(id))!;
      expect(orig.tx.status, TxStatus.posted);
      expect(orig.tx.reversedByTxId, revId);
      final rev = (await t.ledger.getWithLines(revId))!;
      expect(rev.tx.type, TxType.reversal);
      expect(rev.tx.reversesTxId, id);
      expect((await t.reports.dashboard()).totalStorage, tk(1000));
      await expectLater(
        t.ledger.reverse(id, reason: 'again'),
        throwsA(isA<LedgerStateException>()),
      );
      await expectLater(
        t.ledger.reverse(revId, reason: 'undo'),
        throwsA(isA<LedgerStateException>()),
      );
    });

    test(
      'reverse with replacement corrects a wrong amount atomically',
      () async {
        await t.income(tk(1000));
        final id = await t.expense(tk(400));
        await t.ledger.reverse(
          id,
          reason: 'Amount was 340',
          replacement: TxDraft(
            dateKey: 20261001,
            input: TxInput(
              type: TxType.expense,
              amount: tk(340),
              fromAccountId: t.cash,
              fundId: t.personal,
              categoryId: 'cat.exp.food',
            ),
          ),
        );
        expect((await t.reports.dashboard()).totalStorage, tk(660));
        final all = await t.db.select(t.db.ledgerTransactions).get();
        final replacement = all.firstWhere((x) => x.replacesTxId == id);
        expect(replacement.amount, tk(340));
      },
    );

    test('failed replacement rolls back the reversal too', () async {
      await t.income(tk(1000));
      final id = await t.expense(tk(400));
      await expectLater(
        t.ledger.reverse(
          id,
          reason: 'fix',
          replacement: TxDraft(
            dateKey: 20261001,
            input: const TxInput(type: TxType.expense, amount: 1),
          ),
        ),
        throwsA(isA<TxValidationException>()),
      );
      final orig = (await t.ledger.getWithLines(id))!;
      expect(orig.tx.reversedByTxId, isNull);
      expect((await t.reports.dashboard()).totalStorage, tk(600));
    });
  });

  group('loans and obligations', () {
    test(
      'loan auto-creates an obligation which settles on full repayment',
      () async {
        await t.income(tk(10000));
        final loanTx = await t.post(
          TxInput(
            type: TxType.loanGiven,
            amount: tk(5000),
            fromAccountId: t.cash,
            fundId: t.personal,
            personId: t.friend,
            description: 'For his shop',
          ),
        );
        final obligationId = (await t.ledger.getWithLines(loanTx))!
            .tx
            .obligationId!;
        var list = await t.reports.obligations();
        expect(list.single.outstanding, tk(5000));
        expect(list.single.principal, tk(5000));
        await t.post(
          TxInput(
            type: TxType.loanRepaymentReceived,
            amount: tk(2000),
            toAccountId: t.bkash,
            obligationId: obligationId,
          ),
        );
        list = await t.reports.obligations();
        expect(list.single.outstanding, tk(3000));
        expect(list.single.obligation.status, ObligationStatus.open);
        final last = await t.post(
          TxInput(
            type: TxType.loanRepaymentReceived,
            amount: tk(3000),
            toAccountId: t.cash,
            obligationId: obligationId,
          ),
        );
        list = await t.reports.obligations();
        expect(list.single.outstanding, 0);
        expect(list.single.obligation.status, ObligationStatus.settled);
        // Reversing the last repayment reopens it.
        await t.ledger.reverse(last, reason: 'Cheque bounced');
        list = await t.reports.obligations();
        expect(list.single.outstanding, tk(3000));
        expect(list.single.obligation.status, ObligationStatus.open);
        final person = (await t.reports.personSummary(t.friend))!;
        expect(person.loanReceivable, tk(3000));
      },
    );

    test('overpayment is flagged, not hidden', () async {
      await t.income(tk(1000));
      final loanTx = await t.post(
        TxInput(
          type: TxType.loanGiven,
          amount: tk(500),
          fromAccountId: t.cash,
          fundId: t.personal,
          personId: t.friend,
        ),
      );
      final o = (await t.ledger.getWithLines(loanTx))!.tx.obligationId!;
      await t.post(
        TxInput(
          type: TxType.loanRepaymentReceived,
          amount: tk(600),
          toAccountId: t.cash,
          obligationId: o,
        ),
      );
      final diag = await t.reports.diagnostics();
      expect(
        diag.any(
          (d) =>
              d.kind == DiagnosticKind.overpaidObligation &&
              d.amount == -tk(100),
        ),
        isTrue,
      );
    });
  });

  group('statements', () {
    test('running balance with opening balance and same-day entries', () async {
      await t.income(tk(1000), date: 20260915);
      await t.expense(tk(100), date: 20261001);
      await t.income(tk(50), date: 20261001, category: 'cat.inc.gift');
      await t.expense(tk(25), date: 20261001);
      await t.expense(tk(10), date: 20261102);
      final s = await t.reports.statement(
        StatementSpec(
          StatementKind.account,
          t.cash,
          from: 20261001,
          to: 20261031,
        ),
      );
      expect(s.opening, tk(1000));
      expect(s.rows.map((r) => r.running), [tk(900), tk(950), tk(925)]);
      expect(s.totalDebit, tk(50));
      expect(s.totalCredit, tk(125));
      expect(s.closing, tk(925));
      expect(s.rows.first.counterAccountName, 'Food & groceries');
    });

    test(
      'transfer fee appears once per transaction in the account statement',
      () async {
        await t.income(tk(1000), to: t.bkash);
        await t.post(
          TxInput(
            type: TxType.transfer,
            amount: tk(500),
            fee: tk(9),
            fromAccountId: t.bkash,
            toAccountId: t.cash,
            fundId: t.personal,
          ),
        );
        final s = await t.reports.statement(
          StatementSpec(StatementKind.account, t.bkash),
        );
        expect(s.rows, hasLength(2));
        expect(s.rows.last.credit, tk(509));
        expect(s.closing, tk(491));
      },
    );

    test('fund statement for an entrusted fund', () async {
      await t.post(
        TxInput(
          type: TxType.fundDeposit,
          amount: tk(20000),
          toAccountId: t.bank,
          fundId: t.sisterFund,
          personId: t.sister,
        ),
      );
      await t.post(
        TxInput(
          type: TxType.fundWithdrawal,
          amount: tk(5000),
          fromAccountId: t.bank,
          fundId: t.sisterFund,
          personId: t.sister,
        ),
      );
      final s = await t.reports.statement(
        StatementSpec(StatementKind.fund, t.sisterFund),
      );
      expect(s.rows.map((r) => r.running), [tk(20000), tk(15000)]);
      final p = (await t.reports.personSummary(t.sister))!;
      expect(p.heldForPerson, tk(15000));
      expect(p.netOwedToPerson, tk(15000));
    });

    test('category totals exclude transfers', () async {
      await t.income(tk(2000), to: t.bank);
      await t.post(
        TxInput(
          type: TxType.transfer,
          amount: tk(1000),
          fromAccountId: t.bank,
          toAccountId: t.cash,
          fundId: t.personal,
        ),
      );
      await t.expense(tk(300));
      final inc = await t.reports.categoryTotals(
        income: true,
        from: 20261001,
        to: 20261031,
      );
      final exp = await t.reports.categoryTotals(
        income: false,
        from: 20261001,
        to: 20261031,
      );
      expect(inc.single.total, tk(2000));
      expect(exp.single.total, tk(300));
      final trend = await t.reports.monthlyTrend(months: 2, endMonth: 202610);
      expect(trend.last, (202610, tk(2000), tk(300)));
    });
  });

  group('permissions', () {
    test(
      'a member only sees transactions and balances of permitted funds',
      () async {
        await t.income(tk(9000));
        await t.post(
          TxInput(
            type: TxType.fundDeposit,
            amount: tk(4000),
            toAccountId: t.bank,
            fundId: t.sisterFund,
            personId: t.sister,
          ),
        );
        final member = t.as(
          ActorContext(
            actorId: 'uid-ruma',
            role: HouseholdRole.member,
            allowedFundIds: {t.sisterFund},
          ),
        );
        final txs = await member.ledger.page(const TxFilter());
        expect(txs, hasLength(1));
        expect(txs.single.fundId, t.sisterFund);
        final d = await member.reports.dashboard();
        expect(d.totalStorage, tk(4000));
        expect(d.personalNet, 0);
        final funds = await member.reports.fundBalances();
        expect(funds.map((f) => f.fund.id), [t.sisterFund]);
        final hidden = txs.single.id;
        expect(await member.ledger.getWithLines(hidden), isNotNull);
        final personalTx = (await t.ledger.page(const TxFilter()))
            .firstWhere((x) => x.fundId == t.personal);
        expect(await member.ledger.getWithLines(personalTx.id), isNull);
      },
    );

    test('members cannot write; admins need delegated permissions', () async {
      final member = t.as(
        const ActorContext(actorId: 'm', role: HouseholdRole.member),
      );
      await expectLater(member.income(100), throwsA(isA<PermissionDenied>()));
      final admin = t.as(
        const ActorContext(
          actorId: 'a',
          role: HouseholdRole.admin,
          delegated: {Permission.writeTransactions},
        ),
      );
      final id = await admin.income(100);
      await expectLater(
        admin.ledger.reverse(id, reason: 'x'),
        throwsA(isA<PermissionDenied>()),
      );
      await expectLater(
        admin.master.createPerson(name: 'X'),
        throwsA(isA<PermissionDenied>()),
      );
    });
  });

  group('history paging', () {
    test('keyset pagination returns every row exactly once', () async {
      for (var i = 0; i < 23; i++) {
        await t.income(100 + i, date: 20261001 + (i % 5));
      }
      final seen = <String>{};
      TxCursor? cursor;
      while (true) {
        final page = await t.ledger.page(
          const TxFilter(),
          limit: 7,
          after: cursor,
        );
        if (page.isEmpty) break;
        for (final r in page) {
          expect(seen.add(r.id), isTrue);
        }
        final last = page.last;
        cursor = TxCursor.of(last);
      }
      expect(seen, hasLength(23));
    });

    test('filters by account, person, search and date', () async {
      await t.income(tk(100), date: 20261001);
      await t.income(tk(100), to: t.bank, date: 20261010);
      await t.post(
        TxInput(
          type: TxType.loanGiven,
          amount: tk(10),
          fromAccountId: t.cash,
          fundId: t.personal,
          personId: t.friend,
          description: 'Rickshaw repair',
        ),
        date: 20261011,
      );
      expect(await t.ledger.page(TxFilter(accountId: t.bank)), hasLength(1));
      expect(await t.ledger.page(TxFilter(personId: t.friend)), hasLength(1));
      expect(
        await t.ledger.page(const TxFilter(search: 'rickshaw')),
        hasLength(1),
      );
      expect(
        await t.ledger.page(
          const TxFilter(fromDate: 20261005, toDate: 20261010),
        ),
        hasLength(1),
      );
    });
  });

  test('every mutation is queued in the outbox', () async {
    final id = await t.income(tk(1));
    final entries = await t.db.select(t.db.outbox).get();
    expect(
      entries.any((e) => e.entityType == 'tx' && e.entityId == id),
      isTrue,
    );
    expect(entries.any((e) => e.entityType == 'person'), isTrue);
    final row = await (t.db.select(
      t.db.ledgerTransactions,
    )..where((x) => x.id.equals(id))).getSingle();
    expect(row.syncStatus, SyncStatus.pending);
    expect(row.contentHash, isNotNull);
  });
}
