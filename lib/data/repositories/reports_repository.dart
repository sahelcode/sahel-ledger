import 'package:drift/drift.dart';

import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../db/database.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalStorage,
    required this.personalStorage,
    required this.entrustedStorage,
    required this.personalNet,
    required this.entrustedNet,
    required this.receivables,
    required this.payables,
    required this.externalSavings,
    required this.pendingCount,
    required this.draftCount,
    required this.unsyncedCount,
    required this.monthIncome,
    required this.monthExpense,
  });

  /// All money physically held across cash/bank/wallet accounts.
  final int totalStorage;

  /// Portion of [totalStorage] belonging to the personal fund.
  final int personalStorage;

  /// Portion of [totalStorage] held for others (entrusted/purpose/samity).
  final int entrustedStorage;

  /// What the user actually owns: personal fund net assets (storage +
  /// receivables + savings - payables - dues to other funds).
  final int personalNet;

  /// Net amount held on behalf of others.
  final int entrustedNet;
  final int receivables;
  final int payables;
  final int externalSavings;
  final int pendingCount;
  final int draftCount;
  final int unsyncedCount;
  final int monthIncome;
  final int monthExpense;
}

class AccountBalance {
  const AccountBalance(this.account, this.balance, this.byFund);
  final LedgerAccountRow account;
  final int balance;
  final Map<String, int> byFund;
}

class FundBalance {
  const FundBalance(this.fund, this.net, this.storage);
  final FundRow fund;
  final int net;
  final int storage;
}

class PersonSummary {
  const PersonSummary({
    required this.person,
    required this.ownedFunds,
    required this.loanReceivable,
    required this.advanceReceivable,
    required this.loanPayable,
    required this.capitalByFund,
  });

  final PersonRow person;
  final List<FundBalance> ownedFunds;

  /// Positive: the person owes the household.
  final int loanReceivable;
  final int advanceReceivable;

  /// Positive: the household owes the person.
  final int loanPayable;

  /// Contributions recorded for this person, per fund (e.g. samity shares).
  final Map<String, int> capitalByFund;

  int get heldForPerson => ownedFunds.fold(0, (s, f) => s + f.net);
  int get netOwedToPerson =>
      heldForPerson + loanPayable - loanReceivable - advanceReceivable;
}

enum StatementKind { account, fund, personDues, category }

class StatementSpec {
  const StatementSpec(this.kind, this.id, {this.from, this.to});
  final StatementKind kind;
  final String id;
  final int? from;
  final int? to;
}

class StatementRow {
  const StatementRow({
    required this.txId,
    required this.dateKey,
    required this.type,
    required this.description,
    required this.debit,
    required this.credit,
    required this.running,
    required this.reversed,
    this.personId,
    this.counterAccountName,
  });

  final String txId;
  final int dateKey;
  final TxType type;
  final String? description;

  /// Increase of the statement subject (money in / owed more).
  final int debit;

  /// Decrease of the statement subject.
  final int credit;
  final int running;
  final bool reversed;
  final String? personId;
  final String? counterAccountName;
}

class Statement {
  const Statement(this.spec, this.opening, this.rows);
  final StatementSpec spec;
  final int opening;
  final List<StatementRow> rows;

  int get totalDebit => rows.fold(0, (s, r) => s + r.debit);
  int get totalCredit => rows.fold(0, (s, r) => s + r.credit);
  int get closing => opening + totalDebit - totalCredit;
}

class CategoryTotal {
  const CategoryTotal(this.category, this.total);
  final LedgerAccountRow category;
  final int total;
}

class ObligationSummary {
  const ObligationSummary(this.obligation, this.principal, this.outstanding);
  final ObligationRow obligation;
  final int principal;
  final int outstanding;
}

class SamityMemberStatus {
  const SamityMemberStatus(
    this.personId,
    this.shares,
    this.paid,
    this.expected,
  );
  final String personId;
  final int shares;
  final int paid;
  final int expected;
  int get due => expected - paid;
}

class BudgetStatus {
  const BudgetStatus(this.category, this.limit, this.spent);
  final LedgerAccountRow category;
  final int limit;
  final int spent;
  double get ratio => limit == 0 ? 0 : spent / limit;
}

enum DiagnosticKind {
  unbalancedTransaction,
  negativeStorage,
  fundOverdrawnInAccount,
  overpaidObligation,
  staleDraft,
  possibleDuplicate,
  unusualAmount,
  unresolvedReconciliation,
  syncConflict,
  auditChainBroken,
}

enum Severity { info, warning, critical }

class Diagnostic {
  const Diagnostic(
    this.kind,
    this.severity,
    this.subjectId, {
    this.amount,
    this.related,
  });
  final DiagnosticKind kind;
  final Severity severity;
  final String subjectId;
  final int? amount;
  final String? related;
}

/// Read-side queries. All figures come from posted lines only, computed in
/// SQL so large histories are never loaded into memory.
class ReportsRepository {
  ReportsRepository(this.db, {required this.actor});

  final AppDatabase db;
  final ActorContext actor;

  static const _posted = "t.status = 'posted'";

  /// SQL fragment + variables restricting lines to the viewer's funds.
  (String, List<Variable>) _scope([String alias = 'l']) {
    final scope = actor.fundScope;
    if (scope == null) return ('', const []);
    if (scope.isEmpty) return (' AND 0', const []);
    return (
      ' AND $alias.fund_id IN (${List.filled(scope.length, '?').join(',')})',
      [for (final f in scope) Variable(f)],
    );
  }

  Future<int> _sum(String where, List<Variable> vars, {int? asOf}) async {
    final (scopeSql, scopeVars) = _scope();
    final row = await db
        .customSelect(
          '''SELECT COALESCE(SUM(l.amount), 0) AS s
             FROM transaction_lines l
             JOIN ledger_transactions t ON t.id = l.tx_id
             JOIN ledger_accounts a ON a.id = l.account_id
             LEFT JOIN funds f ON f.id = l.fund_id
             WHERE $_posted AND ($where)
             ${asOf != null ? 'AND t.date_key <= ?' : ''}$scopeSql''',
          variables: [...vars, if (asOf != null) Variable(asOf), ...scopeVars],
        )
        .getSingle();
    return row.read<int>('s');
  }

  Future<DashboardSummary> dashboard({int? asOf, int? monthKey}) async {
    final mk = monthKey ?? DateKey.monthKey(DateKey.today());
    final from = DateKey.firstOfMonth(mk);
    final to = DateKey.lastOfMonth(mk);
    final storage = await _sum("a.kind = 'storage'", [], asOf: asOf);
    final personalStorage = await _sum(
      "a.kind = 'storage' AND f.kind = 'personal'",
      [],
      asOf: asOf,
    );
    final personalNet = await _sum(
      "a.account_class IN ('asset','liability') AND f.kind = 'personal'",
      [],
      asOf: asOf,
    );
    final entrustedNet = await _sum(
      "a.account_class IN ('asset','liability') AND f.kind <> 'personal'",
      [],
      asOf: asOf,
    );
    final receivables = await _sum('l.account_id IN (?, ?)', [
      Variable(SystemAccounts.loansReceivable),
      Variable(SystemAccounts.advancesReceivable),
    ], asOf: asOf);
    final payables = -await _sum('l.account_id = ?', [
      Variable(SystemAccounts.loansPayable),
    ], asOf: asOf);
    final ext = await _sum('l.account_id = ?', [
      Variable(SystemAccounts.externalSavings),
    ], asOf: asOf);
    final income = -await _sum(
      "a.kind = 'incomeCategory' AND t.date_key BETWEEN ? AND ?",
      [Variable(from), Variable(to)],
    );
    final expense = await _sum(
      "a.kind = 'expenseCategory' AND t.date_key BETWEEN ? AND ?",
      [Variable(from), Variable(to)],
    );
    Future<int> count(String sql) async =>
        (await db.customSelect(sql).getSingle()).read<int>('c');
    return DashboardSummary(
      totalStorage: storage,
      personalStorage: personalStorage,
      entrustedStorage: storage - personalStorage,
      personalNet: personalNet,
      entrustedNet: entrustedNet,
      receivables: receivables,
      payables: payables,
      externalSavings: ext,
      pendingCount: await count(
        "SELECT COUNT(*) AS c FROM ledger_transactions WHERE status = 'pending'",
      ),
      draftCount: await count(
        "SELECT COUNT(*) AS c FROM ledger_transactions WHERE status = 'draft'",
      ),
      unsyncedCount: await count('SELECT COUNT(*) AS c FROM outbox'),
      monthIncome: income,
      monthExpense: expense,
    );
  }

  /// Re-runs [dashboard] whenever ledger tables change.
  Stream<DashboardSummary> watchDashboard() => db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          db.ledgerTransactions,
          db.transactionLines,
          db.outbox,
          db.funds,
        },
      )
      .watch()
      .asyncMap((_) => dashboard());

  Stream<T> watchLedger<T>(Future<T> Function() query) => db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          db.ledgerTransactions,
          db.transactionLines,
          db.ledgerAccounts,
          db.funds,
          db.obligations,
          db.persons,
        },
      )
      .watch()
      .asyncMap((_) => query());

  Future<List<AccountBalance>> accountBalances({
    int? asOf,
    bool includeArchived = false,
  }) async {
    final accounts =
        await (db.select(db.ledgerAccounts)
              ..where(
                (a) =>
                    a.kind.equalsValue(LedgerAccountKind.storage) &
                    (includeArchived
                        ? const Constant(true)
                        : a.archived.equals(false)),
              )
              ..orderBy([(a) => OrderingTerm.asc(a.sortOrder)]))
            .get();
    final (scopeSql, scopeVars) = _scope();
    final rows = await db
        .customSelect(
          '''SELECT l.account_id AS acct, l.fund_id AS fund, SUM(l.amount) AS s
             FROM transaction_lines l
             JOIN ledger_transactions t ON t.id = l.tx_id
             JOIN ledger_accounts a ON a.id = l.account_id
             WHERE $_posted AND a.kind = 'storage'
             ${asOf != null ? 'AND t.date_key <= ?' : ''}$scopeSql
             GROUP BY l.account_id, l.fund_id''',
          variables: [if (asOf != null) Variable(asOf), ...scopeVars],
        )
        .get();
    final byAcct = <String, Map<String, int>>{};
    for (final r in rows) {
      final s = r.read<int>('s');
      if (s == 0) continue;
      (byAcct[r.read<String>('acct')] ??= {})[r.read<String>('fund')] = s;
    }
    return [
      for (final a in accounts)
        AccountBalance(
          a,
          (byAcct[a.id] ?? const {}).values.fold(0, (x, y) => x + y),
          byAcct[a.id] ?? const {},
        ),
    ];
  }

  Future<List<FundBalance>> fundBalances({
    int? asOf,
    bool includeArchived = false,
  }) async {
    final q = db.select(db.funds)
      ..orderBy([
        (f) => OrderingTerm.asc(f.kind),
        (f) => OrderingTerm.asc(f.name),
      ]);
    if (!includeArchived) q.where((f) => f.archived.equals(false));
    final scope = actor.fundScope;
    if (scope != null) q.where((f) => f.id.isIn(scope));
    final funds = await q.get();
    final rows = await db
        .customSelect(
          '''SELECT l.fund_id AS fund,
               SUM(CASE WHEN a.account_class IN ('asset','liability') THEN l.amount ELSE 0 END) AS net,
               SUM(CASE WHEN a.kind = 'storage' THEN l.amount ELSE 0 END) AS storage
             FROM transaction_lines l
             JOIN ledger_transactions t ON t.id = l.tx_id
             JOIN ledger_accounts a ON a.id = l.account_id
             WHERE $_posted ${asOf != null ? 'AND t.date_key <= ?' : ''}
             GROUP BY l.fund_id''',
          variables: [if (asOf != null) Variable(asOf)],
        )
        .get();
    final m = {
      for (final r in rows)
        r.read<String>('fund'): (r.read<int>('net'), r.read<int>('storage')),
    };
    return [
      for (final f in funds) FundBalance(f, m[f.id]?.$1 ?? 0, m[f.id]?.$2 ?? 0),
    ];
  }

  Future<PersonSummary?> personSummary(String personId, {int? asOf}) async {
    final person = await (db.select(
      db.persons,
    )..where((p) => p.id.equals(personId))).getSingleOrNull();
    if (person == null) return null;
    final funds = (await fundBalances(asOf: asOf, includeArchived: true))
        .where(
          (f) =>
              f.fund.ownerPersonId == personId &&
              f.fund.kind != FundKind.personal,
        )
        .toList();
    Future<int> personSum(String account) => _sum(
      'l.account_id = ? AND l.person_id = ?',
      [Variable(account), Variable(personId)],
      asOf: asOf,
    );
    final (scopeSql, scopeVars) = _scope();
    final capRows = await db
        .customSelect(
          '''SELECT l.fund_id AS fund, -SUM(l.amount) AS s
             FROM transaction_lines l JOIN ledger_transactions t ON t.id = l.tx_id
             WHERE $_posted AND l.account_id = ? AND l.person_id = ?$scopeSql
             ${asOf != null ? 'AND t.date_key <= ?' : ''}
             GROUP BY l.fund_id''',
          variables: [
            Variable(SystemAccounts.fundCapital),
            Variable(personId),
            ...scopeVars,
            if (asOf != null) Variable(asOf),
          ],
        )
        .get();
    return PersonSummary(
      person: person,
      ownedFunds: funds,
      loanReceivable: await personSum(SystemAccounts.loansReceivable),
      advanceReceivable: await personSum(SystemAccounts.advancesReceivable),
      loanPayable: -await personSum(SystemAccounts.loansPayable),
      capitalByFund: {
        for (final r in capRows) r.read<String>('fund'): r.read<int>('s'),
      },
    );
  }

  /// Line filter for each statement kind and the sign that turns raw
  /// debit-positive amounts into "increase of the subject".
  (String, List<Variable>, int) _statementFilter(StatementSpec s) =>
      switch (s.kind) {
        StatementKind.account => ('l.account_id = ?', [Variable(s.id)], 1),
        StatementKind.fund => (
          "l.fund_id = ? AND a.account_class IN ('asset','liability')",
          [Variable(s.id)],
          1,
        ),
        StatementKind.personDues => (
          // Positive running balance: the person owes the household.
          'l.person_id = ? AND l.account_id IN (?, ?, ?)',
          [
            Variable(s.id),
            Variable(SystemAccounts.loansReceivable),
            Variable(SystemAccounts.advancesReceivable),
            Variable(SystemAccounts.loansPayable),
          ],
          1,
        ),
        StatementKind.category => ('l.account_id = ?', [Variable(s.id)], 1),
      };

  Future<Statement> statement(StatementSpec spec) async {
    final (where, vars, sign) = _statementFilter(spec);
    final (scopeSql, scopeVars) = _scope();
    var opening = 0;
    if (spec.from != null) {
      final r = await db
          .customSelect(
            '''SELECT COALESCE(SUM(l.amount), 0) AS s FROM transaction_lines l
               JOIN ledger_transactions t ON t.id = l.tx_id
               JOIN ledger_accounts a ON a.id = l.account_id
               WHERE $_posted AND $where AND t.date_key < ?$scopeSql''',
            variables: [...vars, Variable(spec.from!), ...scopeVars],
          )
          .getSingle();
      opening = r.read<int>('s') * sign;
    }
    final rows = await db
        .customSelect(
          '''SELECT t.id AS id, t.date_key AS d, t.type AS type, t.description AS descr,
                    t.person_id AS person, t.reversed_by_tx_id AS rev,
                    SUM(l.amount) AS amt,
                    (SELECT a2.name FROM transaction_lines l2
                       JOIN ledger_accounts a2 ON a2.id = l2.account_id
                     WHERE l2.tx_id = t.id AND NOT (${where.replaceAll('l.', 'l2.').replaceAll('a.', 'a2.')})
                     ORDER BY ABS(l2.amount) DESC LIMIT 1) AS counter
             FROM transaction_lines l
             JOIN ledger_transactions t ON t.id = l.tx_id
             JOIN ledger_accounts a ON a.id = l.account_id
             WHERE $_posted AND $where
             ${spec.from != null ? 'AND t.date_key >= ?' : ''}
             ${spec.to != null ? 'AND t.date_key <= ?' : ''}$scopeSql
             GROUP BY t.id
             HAVING SUM(l.amount) <> 0
             ORDER BY t.date_key ASC, t.sort_key ASC, t.id ASC''',
          variables: [
            ...vars.map((v) => v), // used by the correlated sub-select
            ...vars,
            if (spec.from != null) Variable(spec.from!),
            if (spec.to != null) Variable(spec.to!),
            ...scopeVars,
          ],
        )
        .get();
    var running = opening;
    final out = <StatementRow>[];
    for (final r in rows) {
      final amt = r.read<int>('amt') * sign;
      running += amt;
      out.add(
        StatementRow(
          txId: r.read<String>('id'),
          dateKey: r.read<int>('d'),
          type: TxType.values.byName(r.read<String>('type')),
          description: r.readNullable<String>('descr'),
          debit: amt > 0 ? amt : 0,
          credit: amt < 0 ? -amt : 0,
          running: running,
          reversed: r.readNullable<String>('rev') != null,
          personId: r.readNullable<String>('person'),
          counterAccountName: r.readNullable<String>('counter'),
        ),
      );
    }
    return Statement(spec, opening, out);
  }

  /// Income or expense totals per category in a date range. Transfers and
  /// other internal movements never touch category accounts, so they are
  /// excluded by construction.
  Future<List<CategoryTotal>> categoryTotals({
    required bool income,
    required int from,
    required int to,
    String? fundId,
  }) async {
    final (scopeSql, scopeVars) = _scope();
    final rows = await db
        .customSelect(
          '''SELECT l.account_id AS cat, SUM(l.amount) AS s FROM transaction_lines l
             JOIN ledger_transactions t ON t.id = l.tx_id
             JOIN ledger_accounts a ON a.id = l.account_id
             WHERE $_posted AND a.kind = ? AND t.date_key BETWEEN ? AND ?
             ${fundId != null ? 'AND l.fund_id = ?' : ''}$scopeSql
             GROUP BY l.account_id''',
          variables: [
            Variable(income ? 'incomeCategory' : 'expenseCategory'),
            Variable(from),
            Variable(to),
            if (fundId != null) Variable(fundId),
            ...scopeVars,
          ],
        )
        .get();
    final cats = {
      for (final a in await db.select(db.ledgerAccounts).get()) a.id: a,
    };
    final out = [
      for (final r in rows)
        if (r.read<int>('s') != 0)
          CategoryTotal(
            cats[r.read<String>('cat')]!,
            r.read<int>('s') * (income ? -1 : 1),
          ),
    ]..sort((a, b) => b.total.compareTo(a.total));
    return out;
  }

  /// (monthKey, income, expense) for the last [months] months.
  Future<List<(int, int, int)>> monthlyTrend({
    int months = 6,
    int? endMonth,
  }) async {
    final end = endMonth ?? DateKey.monthKey(DateKey.today());
    final keys = <int>[];
    var y = end ~/ 100, m = end % 100;
    for (var i = 0; i < months; i++) {
      keys.insert(0, y * 100 + m);
      m--;
      if (m == 0) {
        m = 12;
        y--;
      }
    }
    final (scopeSql, scopeVars) = _scope();
    final rows = await db
        .customSelect(
          '''SELECT t.date_key / 100 AS mk,
               -SUM(CASE WHEN a.kind = 'incomeCategory' THEN l.amount ELSE 0 END) AS inc,
               SUM(CASE WHEN a.kind = 'expenseCategory' THEN l.amount ELSE 0 END) AS exp
             FROM transaction_lines l
             JOIN ledger_transactions t ON t.id = l.tx_id
             JOIN ledger_accounts a ON a.id = l.account_id
             WHERE $_posted AND t.date_key BETWEEN ? AND ?$scopeSql
             GROUP BY mk''',
          variables: [
            Variable(DateKey.firstOfMonth(keys.first)),
            Variable(DateKey.lastOfMonth(keys.last)),
            ...scopeVars,
          ],
        )
        .get();
    final m2 = {
      for (final r in rows)
        r.read<int>('mk'): (r.read<int>('inc'), r.read<int>('exp')),
    };
    return [for (final k in keys) (k, m2[k]?.$1 ?? 0, m2[k]?.$2 ?? 0)];
  }

  Future<List<ObligationSummary>> obligations({
    Set<ObligationKind>? kinds,
    String? personId,
  }) async {
    final (scopeSql, scopeVars) = _scope('o');
    final rows = await db
        .customSelect(
          '''SELECT o.id AS id,
               COALESCE(SUM(CASE WHEN t.type IN ('loanGiven','loanTaken','advancePaid')
                 AND t.reversed_by_tx_id IS NULL THEN ABS(l.amount) ELSE 0 END), 0) AS principal,
               COALESCE(SUM(l.amount), 0) AS bal
             FROM obligations o
             LEFT JOIN ledger_transactions t ON t.obligation_id = o.id AND t.status = 'posted'
             LEFT JOIN transaction_lines l ON l.tx_id = t.id AND l.account_id IN (?, ?, ?)
             WHERE 1 $scopeSql
             GROUP BY o.id''',
          variables: [
            Variable(SystemAccounts.loansReceivable),
            Variable(SystemAccounts.advancesReceivable),
            Variable(SystemAccounts.loansPayable),
            ...scopeVars,
          ],
        )
        .get();
    final data = {
      for (final r in rows)
        r.read<String>('id'): (r.read<int>('principal'), r.read<int>('bal')),
    };
    final q = db.select(db.obligations)
      ..orderBy([
        (o) => OrderingTerm.asc(o.status),
        (o) => OrderingTerm.desc(o.openedOn),
      ]);
    if (kinds != null) q.where((o) => o.kind.isIn(kinds.map((k) => k.name)));
    if (personId != null) q.where((o) => o.personId.equals(personId));
    final scope = actor.fundScope;
    if (scope != null) q.where((o) => o.fundId.isIn(scope));
    return [
      for (final o in await q.get())
        ObligationSummary(
          o,
          data[o.id]?.$1 ?? 0,
          (o.kind == ObligationKind.loanTaken ? -1 : 1) * (data[o.id]?.$2 ?? 0),
        ),
    ];
  }

  /// Contribution status per member for a samity up to [asOf].
  Future<List<SamityMemberStatus>> samityStatus(
    String samityId, {
    int? asOf,
  }) async {
    final s = await (db.select(
      db.samities,
    )..where((x) => x.id.equals(samityId))).getSingle();
    final members = await (db.select(
      db.samityMembers,
    )..where((m) => m.samityId.equals(samityId))).get();
    final until = asOf ?? DateKey.today();
    final rows = await db
        .customSelect(
          '''SELECT t.person_id AS p, SUM(CASE WHEN t.type = 'samityContribution' THEN t.amount
                 WHEN t.type = 'reversal' THEN 0 ELSE 0 END) AS paid,
                 SUM(CASE WHEN t.type = 'reversal' THEN t.amount ELSE 0 END) AS rev
             FROM ledger_transactions t
             WHERE t.status = 'posted' AND t.samity_id = ? AND t.date_key <= ?
               AND (t.type = 'samityContribution' OR (t.type = 'reversal'
                 AND (SELECT o.type FROM ledger_transactions o WHERE o.id = t.reverses_tx_id) = 'samityContribution'))
             GROUP BY t.person_id''',
          variables: [Variable(samityId), Variable(until)],
        )
        .get();
    final paid = {
      for (final r in rows)
        r.readNullable<String>('p') ?? '':
            r.read<int>('paid') - r.read<int>('rev'),
    };
    int periodsBetween(int start, int end) {
      if (end < start) return 0;
      final a = DateKey.toDate(start), b = DateKey.toDate(end);
      if (s.frequency == 'weekly') return b.difference(a).inDays ~/ 7 + 1;
      return (b.year - a.year) * 12 + b.month - a.month + 1;
    }

    if (s.mode == SamityMode.external) {
      final total = paid.values.fold(0, (x, y) => x + y);
      return [
        SamityMemberStatus(
          '',
          1,
          total,
          periodsBetween(s.startOn, until) * s.contributionAmount,
        ),
      ];
    }
    return [
      for (final m in members)
        SamityMemberStatus(
          m.personId,
          m.shares,
          paid[m.personId] ?? 0,
          periodsBetween(
                m.joinedOn > s.startOn ? m.joinedOn : s.startOn,
                until,
              ) *
              s.contributionAmount *
              m.shares,
        ),
    ];
  }

  Future<List<BudgetStatus>> budgetStatus(int monthKey) async {
    final budgets = await (db.select(
      db.budgets,
    )..where((b) => b.monthKey.equals(monthKey))).get();
    final spent = {
      for (final c in await categoryTotals(
        income: false,
        from: DateKey.firstOfMonth(monthKey),
        to: DateKey.lastOfMonth(monthKey),
      ))
        c.category.id: c.total,
    };
    final cats = {
      for (final a in await db.select(db.ledgerAccounts).get()) a.id: a,
    };
    return [
      for (final b in budgets)
        if (cats[b.categoryId] != null)
          BudgetStatus(
            cats[b.categoryId]!,
            b.limitAmount,
            spent[b.categoryId] ?? 0,
          ),
    ];
  }

  /// Health checks that help find missing or misclassified money. Nothing
  /// here changes data; every finding needs a human decision.
  Future<List<Diagnostic>> diagnostics({int staleDraftDays = 7}) async {
    final out = <Diagnostic>[];
    // 1. Committed entries that do not balance (should be impossible thanks
    //    to triggers; checked anyway, e.g. after an external import).
    for (final r in await db.customSelect('''
        SELECT t.id AS id, COALESCE(SUM(l.amount), 0) AS s, COUNT(l.line_no) AS n
        FROM ledger_transactions t LEFT JOIN transaction_lines l ON l.tx_id = t.id
        WHERE t.status IN ('posted', 'pending')
        GROUP BY t.id HAVING s <> 0 OR n < 2
        UNION
        SELECT l.tx_id AS id, SUM(l.amount) AS s, 2 AS n FROM transaction_lines l
        JOIN ledger_transactions t ON t.id = l.tx_id AND t.status IN ('posted','pending')
        GROUP BY l.tx_id, l.fund_id HAVING SUM(l.amount) <> 0''').get()) {
      out.add(
        Diagnostic(
          DiagnosticKind.unbalancedTransaction,
          Severity.critical,
          r.read<String>('id'),
          amount: r.read<int>('s'),
        ),
      );
    }
    // 2. Storage balances that are negative overall, or per fund (a fund
    //    spending money that belongs to another fund).
    for (final b in await accountBalances()) {
      if (b.balance < 0) {
        out.add(
          Diagnostic(
            DiagnosticKind.negativeStorage,
            Severity.warning,
            b.account.id,
            amount: b.balance,
          ),
        );
      }
      for (final e in b.byFund.entries) {
        if (e.value < 0) {
          out.add(
            Diagnostic(
              DiagnosticKind.fundOverdrawnInAccount,
              Severity.warning,
              b.account.id,
              amount: e.value,
              related: e.key,
            ),
          );
        }
      }
    }
    // 3. Obligations repaid more than lent.
    for (final o in await obligations()) {
      if (o.outstanding < 0) {
        out.add(
          Diagnostic(
            DiagnosticKind.overpaidObligation,
            Severity.warning,
            o.obligation.id,
            amount: o.outstanding,
          ),
        );
      }
    }
    // 4. Old drafts that never got completed.
    final cutoff = DateKey.fromDate(
      DateTime.now().subtract(Duration(days: staleDraftDays)),
    );
    for (final r
        in await db
            .customSelect(
              "SELECT id FROM ledger_transactions WHERE status = 'draft' AND date_key < ?",
              variables: [Variable(cutoff)],
            )
            .get()) {
      out.add(
        Diagnostic(
          DiagnosticKind.staleDraft,
          Severity.info,
          r.read<String>('id'),
        ),
      );
    }
    // 5. Possible duplicates: same type, amount, day and accounts.
    for (final r in await db.customSelect('''
        SELECT MIN(id) AS a, MAX(id) AS b, amount FROM ledger_transactions
        WHERE status IN ('posted','pending') AND reversed_by_tx_id IS NULL AND type <> 'reversal'
        GROUP BY type, amount, date_key, IFNULL(from_account_id,''), IFNULL(to_account_id,''),
                 IFNULL(person_id,''), IFNULL(category_id,'')
        HAVING COUNT(*) > 1''').get()) {
      out.add(
        Diagnostic(
          DiagnosticKind.possibleDuplicate,
          Severity.info,
          r.read<String>('a'),
          related: r.read<String>('b'),
          amount: r.readNullable<int>('amount'),
        ),
      );
    }
    // 6. Unusually large entries: > 5x the 180-day average for that type
    //    and at least ৳10,000.
    final since = DateKey.fromDate(
      DateTime.now().subtract(const Duration(days: 180)),
    );
    for (final r
        in await db
            .customSelect(
              '''SELECT t.id AS id, t.amount AS amount FROM ledger_transactions t
         JOIN (SELECT type, AVG(amount) AS avg_amt, COUNT(*) AS n FROM ledger_transactions
               WHERE status = 'posted' AND date_key >= ? AND type NOT IN ('reversal','openingBalance')
               GROUP BY type) s ON s.type = t.type
         WHERE t.status = 'posted' AND t.date_key >= ? AND s.n >= 5
           AND t.amount >= 1000000 AND t.amount > 5 * s.avg_amt''',
              variables: [Variable(since), Variable(since)],
            )
            .get()) {
      out.add(
        Diagnostic(
          DiagnosticKind.unusualAmount,
          Severity.info,
          r.read<String>('id'),
          amount: r.read<int>('amount'),
        ),
      );
    }
    // 7. Reconciliations left open with a difference.
    for (final r in await (db.select(
      db.reconSessions,
    )..where((s) => s.status.isIn(['unresolved', 'pendingApproval']))).get()) {
      out.add(
        Diagnostic(
          DiagnosticKind.unresolvedReconciliation,
          Severity.warning,
          r.id,
          amount: r.actualBalance - r.expectedBalance,
        ),
      );
    }
    // 8. Sync conflicts waiting for a decision.
    for (final r in await (db.select(
      db.outbox,
    )..where((o) => o.state.equals('conflict'))).get()) {
      out.add(
        Diagnostic(
          DiagnosticKind.syncConflict,
          Severity.warning,
          r.entityId,
          related: r.entityType,
        ),
      );
    }
    return out;
  }
}
