/// Core vocabulary of the Sahel Ledger fund-accounting model.
///
/// The model separates three questions that a household ledger must never
/// mix up:
///
/// * **Where** is the money? -> a ledger account of kind [LedgerAccountKind.storage]
///   (cash, bank, bKash, Nagad...).
/// * **Whose** money is it? -> a [FundKind] fund carried on every ledger line.
/// * **Why** did it move? -> the [TxType] plus income/expense categories.
///
/// Every posted transaction is a set of signed lines (debit positive, credit
/// negative) that sums to zero overall **and** per fund. That second rule is
/// what keeps ownership correct: money can only change owner through an
/// explicit entry (deposit, withdrawal, inter-fund loan...), never by accident.
library;

/// Accounting class of a ledger account; decides its normal balance side.
enum AccountClass {
  asset,
  liability,
  equity,
  income,
  expense;

  /// Asset and expense accounts increase with debits (positive amounts).
  bool get debitNormal => this == asset || this == expense;

  /// Whether lines on this class count toward a fund's net assets.
  bool get isBalanceSheetAsset => this == asset || this == liability;
}

enum LedgerAccountKind { storage, incomeCategory, expenseCategory, system }

/// Physical/financial location type for storage accounts.
enum StorageType { cash, bank, mobileWallet, other }

/// Who a fund belongs to and why it exists.
enum FundKind {
  /// The user's own money.
  personal,

  /// Money held in trust for another person (e.g. a sister's savings).
  entrusted,

  /// Money given for a specific purpose (e.g. an uncle's education support).
  purpose,

  /// A samity/committee pool managed by the user.
  samity;

  bool get isPersonal => this == personal;
}

enum TxStatus {
  /// Incomplete or unconfirmed; never affects balances; editable/deletable.
  draft,

  /// Internal transient state used while lines are being written.
  staging,

  /// Complete and balanced but not yet confirmed (e.g. an uncleared cheque).
  /// Shown as projected; excluded from posted balances.
  pending,

  /// Final. Immutable; can only be corrected via a reversal entry.
  posted,

  /// A pending transaction that was cancelled before posting.
  cancelled,
}

/// Transaction templates. Each one maps to a fixed, auditable line pattern
/// built by [PostingEngine].
enum TxType {
  income,
  expense,
  transfer,
  fundDeposit,
  fundWithdrawal,
  loanGiven,
  loanRepaymentReceived,
  loanTaken,
  loanRepaymentPaid,
  advancePaid,
  reimbursementReceived,
  samityContribution,
  samityPayout,
  interFundLoan,
  interFundRepayment,
  openingBalance,
  adjustment,
  reversal;

  /// Types that a user can pick in the quick-entry form.
  static const userSelectable = [
    expense,
    income,
    transfer,
    fundDeposit,
    fundWithdrawal,
    loanGiven,
    loanRepaymentReceived,
    loanTaken,
    loanRepaymentPaid,
    advancePaid,
    reimbursementReceived,
    samityContribution,
    samityPayout,
    interFundLoan,
    interFundRepayment,
    openingBalance,
  ];

  bool get usesFromAccount => const {
    expense,
    transfer,
    fundWithdrawal,
    loanGiven,
    loanRepaymentPaid,
    advancePaid,
    samityContribution,
  }.contains(this);

  bool get usesToAccount => const {
    income,
    transfer,
    fundDeposit,
    loanRepaymentReceived,
    loanTaken,
    reimbursementReceived,
    samityPayout,
    openingBalance,
  }.contains(this);

  bool get needsPerson => const {
    fundDeposit,
    fundWithdrawal,
    loanGiven,
    loanRepaymentReceived,
    loanTaken,
    loanRepaymentPaid,
    advancePaid,
    reimbursementReceived,
  }.contains(this);

  bool get usesCategory => this == income || this == expense;

  bool get usesSamity => this == samityContribution || this == samityPayout;

  bool get usesToFund => this == interFundLoan || this == interFundRepayment;

  bool get usesObligation => const {
    loanGiven,
    loanRepaymentReceived,
    loanTaken,
    loanRepaymentPaid,
    advancePaid,
    reimbursementReceived,
  }.contains(this);

  /// Pure movements between the user's own accounts or funds. These are
  /// excluded from income/expense reporting to avoid double counting.
  bool get isInternalMovement =>
      const {transfer, interFundLoan, interFundRepayment}.contains(this);
}

enum ObligationKind {
  /// Money I lent: a receivable.
  loanGiven,

  /// Money I borrowed: a payable.
  loanTaken,

  /// Money I paid on someone's behalf, to be reimbursed: a receivable.
  advance;

  bool get isReceivable => this != loanTaken;
}

enum ObligationStatus { open, settled }

enum SamityMode {
  /// The user is the treasurer and physically holds the pool money.
  managed,

  /// The user is a member paying into a samity run by someone else.
  external,
}

enum SyncStatus { localOnly, pending, synced, failed, conflict }

/// Stable identifiers for built-in system accounts.
abstract final class SystemAccounts {
  static const loansReceivable = 'sys.loans_receivable';
  static const advancesReceivable = 'sys.advances_receivable';
  static const loansPayable = 'sys.loans_payable';
  static const fundCapital = 'sys.fund_capital';
  static const openingBalance = 'sys.opening_balance';
  static const interFundDue = 'sys.interfund_due';
  static const externalSavings = 'sys.external_savings';
  static const reconciliationDifference = 'sys.recon_difference';
  static const transferFees = 'cat.exp.bank_fees';

  static const all = {
    loansReceivable: AccountClass.asset,
    advancesReceivable: AccountClass.asset,
    loansPayable: AccountClass.liability,
    fundCapital: AccountClass.equity,
    openingBalance: AccountClass.equity,
    interFundDue: AccountClass.asset,
    externalSavings: AccountClass.asset,
    reconciliationDifference: AccountClass.expense,
  };
}

/// Calendar dates are stored as integer keys `yyyymmdd` (e.g. 20261027) so
/// that sorting, range filters and indexes are exact and timezone-free.
abstract final class DateKey {
  static int fromDate(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  static DateTime toDate(int key) =>
      DateTime(key ~/ 10000, (key ~/ 100) % 100, key % 100);

  static int today([DateTime? now]) => fromDate(now ?? DateTime.now());

  static int monthKey(int dateKey) => dateKey ~/ 100;

  static int firstOfMonth(int monthKey) => monthKey * 100 + 1;

  static int lastOfMonth(int monthKey) {
    final y = monthKey ~/ 100;
    final m = monthKey % 100;
    return fromDate(DateTime(y, m + 1, 0));
  }

  static String iso(int key) {
    final y = key ~/ 10000;
    final m = (key ~/ 100) % 100;
    final d = key % 100;
    return '$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
  }
}
