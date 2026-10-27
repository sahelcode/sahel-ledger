import 'ledger_types.dart';
import 'posting_engine.dart';

/// Household position computed from posted lines. All values in poisha.
class LedgerPosition {
  const LedgerPosition({
    required this.storageByAccount,
    required this.storageByAccountFund,
    required this.netAssetsByFund,
    required this.loansReceivableByPerson,
    required this.advancesReceivableByPerson,
    required this.loansPayableByPerson,
    required this.capitalByFundPerson,
    required this.externalSavingsByFund,
    required this.incomeTotal,
    required this.expenseTotal,
  });

  final Map<String, int> storageByAccount;
  final Map<(String, String), int> storageByAccountFund;
  final Map<String, int> netAssetsByFund;

  /// Positive = the person owes the household.
  final Map<String, int> loansReceivableByPerson;
  final Map<String, int> advancesReceivableByPerson;

  /// Positive = the household owes the person.
  final Map<String, int> loansPayableByPerson;

  /// Positive = contributions held for the person in that fund.
  final Map<(String, String), int> capitalByFundPerson;

  final Map<String, int> externalSavingsByFund;
  final int incomeTotal;
  final int expenseTotal;

  int get totalStorage => storageByAccount.values.fold(0, (a, b) => a + b);
  int get totalReceivable =>
      loansReceivableByPerson.values.fold(0, (a, b) => a + b) +
      advancesReceivableByPerson.values.fold(0, (a, b) => a + b);
  int get totalPayable => loansPayableByPerson.values.fold(0, (a, b) => a + b);

  int fundNet(String fundId) => netAssetsByFund[fundId] ?? 0;
  int storage(String accountId) => storageByAccount[accountId] ?? 0;
  int storageInFund(String accountId, String fundId) =>
      storageByAccountFund[(accountId, fundId)] ?? 0;
}

/// Computes a [LedgerPosition] from lines in memory.
///
/// The production app computes the same figures in SQL; this implementation
/// is the reference used by tests to cross-check those queries.
LedgerPosition computePosition(
  Iterable<LineSpec> lines,
  AccountRef? Function(String accountId) accountOf,
) {
  final storage = <String, int>{};
  final storageFund = <(String, String), int>{};
  final net = <String, int>{};
  final loansRec = <String, int>{};
  final advRec = <String, int>{};
  final loansPay = <String, int>{};
  final capital = <(String, String), int>{};
  final ext = <String, int>{};
  var income = 0;
  var expense = 0;

  void add<K>(Map<K, int> m, K k, int v) => m[k] = (m[k] ?? 0) + v;

  for (final l in lines) {
    final acct = accountOf(l.accountId);
    if (acct == null) {
      throw StateError('unknown account ${l.accountId}');
    }
    if (acct.accountClass.isBalanceSheetAsset) add(net, l.fundId, l.amount);
    if (acct.kind == LedgerAccountKind.storage) {
      add(storage, l.accountId, l.amount);
      add(storageFund, (l.accountId, l.fundId), l.amount);
    }
    switch (l.accountId) {
      case SystemAccounts.loansReceivable:
        add(loansRec, l.personId ?? '', l.amount);
      case SystemAccounts.advancesReceivable:
        add(advRec, l.personId ?? '', l.amount);
      case SystemAccounts.loansPayable:
        add(loansPay, l.personId ?? '', -l.amount);
      case SystemAccounts.fundCapital:
        add(capital, (l.fundId, l.personId ?? ''), -l.amount);
      case SystemAccounts.externalSavings:
        add(ext, l.fundId, l.amount);
    }
    if (acct.accountClass == AccountClass.income) income -= l.amount;
    if (acct.accountClass == AccountClass.expense) expense += l.amount;
  }
  return LedgerPosition(
    storageByAccount: storage,
    storageByAccountFund: storageFund,
    netAssetsByFund: net,
    loansReceivableByPerson: loansRec,
    advancesReceivableByPerson: advRec,
    loansPayableByPerson: loansPay,
    capitalByFundPerson: capital,
    externalSavingsByFund: ext,
    incomeTotal: income,
    expenseTotal: expense,
  );
}
