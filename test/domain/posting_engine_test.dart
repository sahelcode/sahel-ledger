import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/domain/ledger/balances.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';
import 'package:sahel_ledger/domain/ledger/posting_engine.dart';

/// Scenario fixture: one household with real-world accounts and funds.
class Fixture {
  static const bankA = 'acct.bankA';
  static const bankB = 'acct.bankB';
  static const cash = 'acct.cash';
  static const bkash = 'acct.bkash';
  static const nagad = 'acct.nagad';
  static const salary = 'cat.inc.salary';
  static const gift = 'cat.inc.gift';
  static const food = 'cat.exp.food';
  static const education = 'cat.exp.education';

  static const me = 'p.me';
  static const sister = 'p.sister';
  static const friend = 'p.friend';
  static const brother = 'p.brother';
  static const uncle = 'p.uncle';
  static const member2 = 'p.member2';

  static const personal = 'f.personal';
  static const sisterFund = 'f.sister';
  static const uncleEdu = 'f.uncle_edu';
  static const samityFund = 'f.samity';

  static const managedSamity = 's.managed';
  static const externalSamity = 's.external';

  final accounts = <AccountRef>[
    for (final id in [bankA, bankB, cash, bkash, nagad])
      AccountRef(id, LedgerAccountKind.storage, AccountClass.asset),
    const AccountRef(
      salary,
      LedgerAccountKind.incomeCategory,
      AccountClass.income,
    ),
    const AccountRef(
      gift,
      LedgerAccountKind.incomeCategory,
      AccountClass.income,
    ),
    const AccountRef(
      food,
      LedgerAccountKind.expenseCategory,
      AccountClass.expense,
    ),
    const AccountRef(
      education,
      LedgerAccountKind.expenseCategory,
      AccountClass.expense,
    ),
    const AccountRef(
      SystemAccounts.transferFees,
      LedgerAccountKind.expenseCategory,
      AccountClass.expense,
    ),
    for (final e in SystemAccounts.all.entries)
      AccountRef(e.key, LedgerAccountKind.system, e.value),
  ];

  final funds = const [
    FundRef(personal, FundKind.personal, ownerPersonId: me),
    FundRef(sisterFund, FundKind.entrusted, ownerPersonId: sister),
    FundRef(uncleEdu, FundKind.purpose, ownerPersonId: uncle),
    FundRef(samityFund, FundKind.samity),
  ];

  late final lookup = MapLedgerLookup(
    accounts: accounts,
    funds: funds,
    samities: const [
      SamityRef(managedSamity, SamityMode.managed, fundId: samityFund),
      SamityRef(externalSamity, SamityMode.external),
    ],
    obligations: const [
      ObligationRef('o.loan', ObligationKind.loanGiven, friend, personal),
    ],
  );

  late final engine = PostingEngine(lookup);
  final posted = <LineSpec>[];

  List<LineSpec> post(TxInput input) {
    final plan = engine.plan(input);
    expect(plan.errors, isEmpty, reason: 'unexpected errors for ${input.type}');
    posted.addAll(plan.lines);
    return plan.lines;
  }

  LedgerPosition get position => computePosition(
    posted,
    (id) => accounts.where((a) => a.id == id).firstOrNull,
  );
}

int tk(num taka) => (taka * 100).round();

void main() {
  late Fixture f;
  setUp(() => f = Fixture());

  group('ownership vs location', () {
    test('sister money in my bank stays the sister\'s', () {
      f.post(
        TxInput(
          type: TxType.fundDeposit,
          amount: tk(50000),
          toAccountId: Fixture.bankA,
          fundId: Fixture.sisterFund,
          personId: Fixture.sister,
        ),
      );
      final p = f.position;
      expect(p.storage(Fixture.bankA), tk(50000));
      expect(p.fundNet(Fixture.sisterFund), tk(50000));
      expect(p.fundNet(Fixture.personal), 0, reason: 'not my money');
      expect(
        p.capitalByFundPerson[(Fixture.sisterFund, Fixture.sister)],
        tk(50000),
      );
      expect(p.incomeTotal, 0, reason: 'entrusted money is not income');
    });

    test('a deposit into the personal fund is refused (it is income)', () {
      final plan = f.engine.plan(
        const TxInput(
          type: TxType.fundDeposit,
          amount: 100,
          toAccountId: Fixture.bankA,
          fundId: Fixture.personal,
          personId: Fixture.me,
        ),
      );
      expect(plan.errors['fund'], PostingError.personalFundNotAllowed);
    });

    test('withdrawal returns money to the owner', () {
      f.post(
        TxInput(
          type: TxType.fundDeposit,
          amount: tk(50000),
          toAccountId: Fixture.bankA,
          fundId: Fixture.sisterFund,
          personId: Fixture.sister,
        ),
      );
      f.post(
        TxInput(
          type: TxType.fundWithdrawal,
          amount: tk(20000),
          fromAccountId: Fixture.bankA,
          fundId: Fixture.sisterFund,
          personId: Fixture.sister,
        ),
      );
      expect(f.position.fundNet(Fixture.sisterFund), tk(30000));
      expect(f.position.storage(Fixture.bankA), tk(30000));
    });
  });

  group('income, expense and transfers', () {
    test('transfer bank -> bKash is not income or expense', () {
      f.post(
        TxInput(
          type: TxType.income,
          amount: tk(40000),
          toAccountId: Fixture.bankA,
          fundId: Fixture.personal,
          categoryId: Fixture.salary,
        ),
      );
      f.post(
        TxInput(
          type: TxType.transfer,
          amount: tk(10000),
          fromAccountId: Fixture.bankA,
          toAccountId: Fixture.bkash,
          fundId: Fixture.personal,
        ),
      );
      final p = f.position;
      expect(p.storage(Fixture.bankA), tk(30000));
      expect(p.storage(Fixture.bkash), tk(10000));
      expect(p.incomeTotal, tk(40000), reason: 'transfer must not add income');
      expect(p.expenseTotal, 0);
      expect(p.fundNet(Fixture.personal), tk(40000));
    });

    test('transfer fee is an expense charged to the source', () {
      f.post(
        TxInput(
          type: TxType.openingBalance,
          amount: tk(1000),
          toAccountId: Fixture.bkash,
          fundId: Fixture.personal,
        ),
      );
      f.post(
        TxInput(
          type: TxType.transfer,
          amount: tk(500),
          fee: tk(9.25),
          fromAccountId: Fixture.bkash,
          toAccountId: Fixture.cash,
          fundId: Fixture.personal,
        ),
      );
      final p = f.position;
      expect(p.storage(Fixture.bkash), tk(1000) - tk(500) - tk(9.25));
      expect(p.storage(Fixture.cash), tk(500));
      expect(p.expenseTotal, tk(9.25));
    });

    test('transfer to the same account is rejected', () {
      final plan = f.engine.plan(
        const TxInput(
          type: TxType.transfer,
          amount: 100,
          fromAccountId: Fixture.cash,
          toAccountId: Fixture.cash,
          fundId: Fixture.personal,
        ),
      );
      expect(plan.errors['toAccount'], PostingError.sameAccount);
    });

    test('gift is personal income', () {
      f.post(
        TxInput(
          type: TxType.income,
          amount: tk(2000),
          toAccountId: Fixture.cash,
          fundId: Fixture.personal,
          categoryId: Fixture.gift,
          personId: Fixture.uncle,
        ),
      );
      expect(f.position.fundNet(Fixture.personal), tk(2000));
      expect(f.position.incomeTotal, tk(2000));
    });

    test('expense category must be an expense category', () {
      final plan = f.engine.plan(
        const TxInput(
          type: TxType.expense,
          amount: 100,
          fromAccountId: Fixture.cash,
          fundId: Fixture.personal,
          categoryId: Fixture.salary,
        ),
      );
      expect(plan.errors['category'], PostingError.wrongCategory);
    });

    test('purpose fund spending reduces only that fund', () {
      f.post(
        TxInput(
          type: TxType.fundDeposit,
          amount: tk(10000),
          toAccountId: Fixture.bankB,
          fundId: Fixture.uncleEdu,
          personId: Fixture.uncle,
        ),
      );
      f.post(
        TxInput(
          type: TxType.expense,
          amount: tk(3500),
          fromAccountId: Fixture.bankB,
          fundId: Fixture.uncleEdu,
          categoryId: Fixture.education,
        ),
      );
      expect(f.position.fundNet(Fixture.uncleEdu), tk(6500));
      expect(f.position.fundNet(Fixture.personal), 0);
    });
  });

  group('loans and advances', () {
    test('lending is a receivable, not an expense; partial repayment', () {
      f.post(
        TxInput(
          type: TxType.openingBalance,
          amount: tk(20000),
          toAccountId: Fixture.cash,
          fundId: Fixture.personal,
        ),
      );
      f.post(
        TxInput(
          type: TxType.loanGiven,
          amount: tk(5000),
          fromAccountId: Fixture.cash,
          fundId: Fixture.personal,
          personId: Fixture.friend,
        ),
      );
      var p = f.position;
      expect(p.expenseTotal, 0);
      expect(p.loansReceivableByPerson[Fixture.friend], tk(5000));
      expect(
        p.fundNet(Fixture.personal),
        tk(20000),
        reason: 'net worth unchanged',
      );
      f.post(
        TxInput(
          type: TxType.loanRepaymentReceived,
          amount: tk(2000),
          toAccountId: Fixture.bkash,
          obligationId: 'o.loan',
        ),
      );
      p = f.position;
      expect(p.loansReceivableByPerson[Fixture.friend], tk(3000));
      expect(p.storage(Fixture.cash), tk(15000));
      expect(p.storage(Fixture.bkash), tk(2000));
      expect(p.incomeTotal, 0, reason: 'repayment is not income');
    });

    test('obligation fills in person and fund; mismatches are caught', () {
      final plan = f.engine.plan(
        const TxInput(
          type: TxType.loanRepaymentReceived,
          amount: 100,
          toAccountId: Fixture.cash,
          obligationId: 'o.loan',
        ),
      );
      expect(plan.personId, Fixture.friend);
      expect(plan.fundId, Fixture.personal);
      final wrongPerson = f.engine.plan(
        const TxInput(
          type: TxType.loanRepaymentReceived,
          amount: 100,
          toAccountId: Fixture.cash,
          obligationId: 'o.loan',
          personId: Fixture.sister,
        ),
      );
      expect(wrongPerson.errors['person'], PostingError.mismatch);
      final wrongKind = f.engine.plan(
        const TxInput(
          type: TxType.loanRepaymentPaid,
          amount: 100,
          fromAccountId: Fixture.cash,
          obligationId: 'o.loan',
        ),
      );
      expect(wrongKind.errors['obligation'], PostingError.mismatch);
    });

    test('borrowing is a payable', () {
      f.post(
        TxInput(
          type: TxType.loanTaken,
          amount: tk(8000),
          toAccountId: Fixture.bankA,
          fundId: Fixture.personal,
          personId: Fixture.uncle,
        ),
      );
      f.post(
        TxInput(
          type: TxType.loanRepaymentPaid,
          amount: tk(3000),
          fromAccountId: Fixture.bankA,
          fundId: Fixture.personal,
          personId: Fixture.uncle,
        ),
      );
      final p = f.position;
      expect(p.loansPayableByPerson[Fixture.uncle], tk(5000));
      expect(p.storage(Fixture.bankA), tk(5000));
      expect(
        p.fundNet(Fixture.personal),
        0,
        reason: 'borrowed money is not wealth',
      );
    });

    test(
      'paying for someone else creates an advance; reimbursement clears it',
      () {
        f.post(
          TxInput(
            type: TxType.openingBalance,
            amount: tk(5000),
            toAccountId: Fixture.cash,
            fundId: Fixture.personal,
          ),
        );
        f.post(
          TxInput(
            type: TxType.advancePaid,
            amount: tk(3000),
            fromAccountId: Fixture.cash,
            fundId: Fixture.personal,
            personId: Fixture.brother,
          ),
        );
        expect(
          f.position.advancesReceivableByPerson[Fixture.brother],
          tk(3000),
        );
        expect(f.position.expenseTotal, 0);
        f.post(
          TxInput(
            type: TxType.reimbursementReceived,
            amount: tk(3000),
            toAccountId: Fixture.nagad,
            fundId: Fixture.personal,
            personId: Fixture.brother,
          ),
        );
        final p = f.position;
        expect(p.advancesReceivableByPerson[Fixture.brother], 0);
        expect(p.storage(Fixture.nagad), tk(3000));
        expect(p.fundNet(Fixture.personal), tk(5000));
      },
    );
  });

  group('samity', () {
    test('managed samity: member contributions belong to the samity pool', () {
      f.post(
        TxInput(
          type: TxType.samityContribution,
          amount: tk(1000),
          fromAccountId: Fixture.cash,
          samityId: Fixture.managedSamity,
          personId: Fixture.member2,
        ),
      );
      f.post(
        TxInput(
          type: TxType.samityContribution,
          amount: tk(1000),
          fromAccountId: Fixture.cash,
          samityId: Fixture.managedSamity,
          personId: Fixture.sister,
        ),
      );
      var p = f.position;
      expect(p.fundNet(Fixture.samityFund), tk(2000));
      expect(p.fundNet(Fixture.personal), 0);
      expect(
        p.capitalByFundPerson[(Fixture.samityFund, Fixture.member2)],
        tk(1000),
      );
      f.post(
        TxInput(
          type: TxType.samityPayout,
          amount: tk(2000),
          toAccountId: Fixture.cash,
          samityId: Fixture.managedSamity,
          personId: Fixture.member2,
        ),
      );
      p = f.position;
      expect(p.fundNet(Fixture.samityFund), 0);
      expect(
        p.capitalByFundPerson[(Fixture.samityFund, Fixture.member2)],
        -tk(1000),
      );
    });

    test('external samity: my contribution remains my asset', () {
      f.post(
        TxInput(
          type: TxType.openingBalance,
          amount: tk(3000),
          toAccountId: Fixture.cash,
          fundId: Fixture.personal,
        ),
      );
      f.post(
        TxInput(
          type: TxType.samityContribution,
          amount: tk(500),
          fromAccountId: Fixture.cash,
          fundId: Fixture.personal,
          samityId: Fixture.externalSamity,
        ),
      );
      final p = f.position;
      expect(p.externalSavingsByFund[Fixture.personal], tk(500));
      expect(p.fundNet(Fixture.personal), tk(3000));
      expect(p.expenseTotal, 0);
    });

    test('managed samity requires the contributing member', () {
      final plan = f.engine.plan(
        const TxInput(
          type: TxType.samityContribution,
          amount: 100,
          fromAccountId: Fixture.cash,
          samityId: Fixture.managedSamity,
        ),
      );
      expect(plan.errors['person'], PostingError.required);
    });
  });

  group('inter-fund', () {
    test('using sister money personally is recorded as a due, not hidden', () {
      f.post(
        TxInput(
          type: TxType.fundDeposit,
          amount: tk(50000),
          toAccountId: Fixture.bankA,
          fundId: Fixture.sisterFund,
          personId: Fixture.sister,
        ),
      );
      f.post(
        TxInput(
          type: TxType.interFundLoan,
          amount: tk(10000),
          fromAccountId: Fixture.bankA,
          fundId: Fixture.sisterFund,
          toFundId: Fixture.personal,
        ),
      );
      f.post(
        TxInput(
          type: TxType.expense,
          amount: tk(10000),
          fromAccountId: Fixture.bankA,
          fundId: Fixture.personal,
          categoryId: Fixture.food,
        ),
      );
      var p = f.position;
      expect(
        p.fundNet(Fixture.sisterFund),
        tk(50000),
        reason: 'sister still owed all',
      );
      expect(
        p.fundNet(Fixture.personal),
        -tk(10000),
        reason: 'I owe my sister',
      );
      expect(p.storage(Fixture.bankA), tk(40000));
      expect(p.storageInFund(Fixture.bankA, Fixture.sisterFund), tk(40000));
      f.post(
        TxInput(
          type: TxType.income,
          amount: tk(10000),
          toAccountId: Fixture.cash,
          fundId: Fixture.personal,
          categoryId: Fixture.salary,
        ),
      );
      f.post(
        TxInput(
          type: TxType.interFundRepayment,
          amount: tk(10000),
          fromAccountId: Fixture.cash,
          toAccountId: Fixture.bankA,
          fundId: Fixture.personal,
          toFundId: Fixture.sisterFund,
        ),
      );
      p = f.position;
      expect(p.fundNet(Fixture.personal), 0);
      expect(p.fundNet(Fixture.sisterFund), tk(50000));
      expect(p.storageInFund(Fixture.bankA, Fixture.sisterFund), tk(50000));
      expect(p.storage(Fixture.cash), 0);
    });
  });

  group('drafts, reversal and adjustments', () {
    test('missing facts produce errors instead of guesses', () {
      final plan = f.engine.plan(
        const TxInput(type: TxType.expense, amount: 500),
      );
      expect(plan.isComplete, isFalse);
      expect(plan.lines, isEmpty);
      expect(
        plan.errors.keys,
        containsAll(['fromAccount', 'fund', 'category']),
      );
      final noAmount = f.engine.plan(const TxInput(type: TxType.income));
      expect(noAmount.errors['amount'], PostingError.required);
    });

    test('reversal exactly cancels the original', () {
      final lines = f.post(
        TxInput(
          type: TxType.expense,
          amount: tk(750.50),
          fromAccountId: Fixture.cash,
          fundId: Fixture.personal,
          categoryId: Fixture.food,
        ),
      );
      f.posted.addAll(PostingEngine.buildReversal(lines));
      final p = f.position;
      expect(p.storage(Fixture.cash), 0);
      expect(p.expenseTotal, 0);
    });

    test('adjustment needs a reason and moves the difference account', () {
      final noReason = f.engine.plan(
        const TxInput(
          type: TxType.adjustment,
          amount: 100,
          fromAccountId: Fixture.cash,
          fundId: Fixture.personal,
          increase: false,
        ),
      );
      expect(noReason.errors['reason'], PostingError.required);
      f.post(
        const TxInput(
          type: TxType.adjustment,
          amount: 100,
          fromAccountId: Fixture.cash,
          fundId: Fixture.personal,
          increase: false,
          description: 'Counted cash is 1 taka short',
        ),
      );
      expect(f.position.storage(Fixture.cash), -100);
    });

    test('every template balances overall and per fund', () {
      for (final type in TxType.userSelectable) {
        final plan = f.engine.plan(
          TxInput(
            type: type,
            amount: 12345,
            fromAccountId: Fixture.bankA,
            toAccountId: Fixture.bkash,
            fundId: type == TxType.fundDeposit || type == TxType.fundWithdrawal
                ? Fixture.sisterFund
                : Fixture.personal,
            toFundId: Fixture.sisterFund,
            personId: Fixture.friend,
            categoryId: type == TxType.income ? Fixture.salary : Fixture.food,
            samityId: Fixture.externalSamity,
          ),
        );
        expect(plan.errors, isEmpty, reason: '$type');
        expect(LedgerInvariants.describe(plan.lines), isNull, reason: '$type');
        expect(LedgerInvariants.totalDebit(plan.lines), greaterThan(0));
      }
    });
  });

  group('invariants', () {
    test('detects unbalanced and cross-fund leaks', () {
      expect(
        LedgerInvariants.describe(const [
          LineSpec(accountId: 'a', fundId: 'f', amount: 100),
          LineSpec(accountId: 'b', fundId: 'f', amount: -99),
        ]),
        contains('differ'),
      );
      expect(
        LedgerInvariants.describe(const [
          LineSpec(accountId: 'a', fundId: 'f1', amount: 100),
          LineSpec(accountId: 'b', fundId: 'f2', amount: -100),
        ]),
        contains('unbalanced'),
      );
      expect(
        LedgerInvariants.describe(const [
          LineSpec(accountId: 'a', fundId: 'f', amount: 0),
          LineSpec(accountId: 'b', fundId: 'f', amount: 0),
        ]),
        contains('zero'),
      );
    });
  });
}
