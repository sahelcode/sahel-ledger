import 'ledger_types.dart';

/// One signed ledger line. Debit = positive, credit = negative (poisha).
class LineSpec {
  const LineSpec({
    required this.accountId,
    required this.fundId,
    required this.amount,
    this.personId,
    this.counterFundId,
  });

  final String accountId;
  final String fundId;
  final int amount;

  /// Counterparty person for receivable / payable / fund-capital lines.
  final String? personId;

  /// The other fund on inter-fund due lines.
  final String? counterFundId;

  LineSpec negate() => LineSpec(
    accountId: accountId,
    fundId: fundId,
    amount: -amount,
    personId: personId,
    counterFundId: counterFundId,
  );

  Map<String, Object?> toJson() => {
    'accountId': accountId,
    'fundId': fundId,
    'amount': amount,
    'personId': personId,
    'counterFundId': counterFundId,
  };

  static LineSpec fromJson(Map<String, Object?> j) => LineSpec(
    accountId: j['accountId']! as String,
    fundId: j['fundId']! as String,
    amount: (j['amount']! as num).toInt(),
    personId: j['personId'] as String?,
    counterFundId: j['counterFundId'] as String?,
  );

  @override
  bool operator ==(Object other) =>
      other is LineSpec &&
      other.accountId == accountId &&
      other.fundId == fundId &&
      other.amount == amount &&
      other.personId == personId &&
      other.counterFundId == counterFundId;

  @override
  int get hashCode =>
      Object.hash(accountId, fundId, amount, personId, counterFundId);

  @override
  String toString() =>
      'Line($accountId, fund=$fundId, ${amount >= 0 ? 'Dr' : 'Cr'} ${amount.abs()}'
      '${personId != null ? ', person=$personId' : ''})';
}

class AccountRef {
  const AccountRef(this.id, this.kind, this.accountClass);
  final String id;
  final LedgerAccountKind kind;
  final AccountClass accountClass;
}

class FundRef {
  const FundRef(this.id, this.kind, {this.ownerPersonId});
  final String id;
  final FundKind kind;
  final String? ownerPersonId;
}

class SamityRef {
  const SamityRef(this.id, this.mode, {this.fundId});
  final String id;
  final SamityMode mode;

  /// For managed samities: the fund holding the pool.
  final String? fundId;
}

class ObligationRef {
  const ObligationRef(
    this.id,
    this.kind,
    this.personId,
    this.fundId, {
    this.status = ObligationStatus.open,
  });
  final String id;
  final ObligationKind kind;
  final String personId;
  final String fundId;
  final ObligationStatus status;
}

/// Read-only view of master data the engine needs to validate input.
abstract interface class LedgerLookup {
  AccountRef? account(String id);
  FundRef? fund(String id);
  SamityRef? samity(String id);
  ObligationRef? obligation(String id);
}

class MapLedgerLookup implements LedgerLookup {
  MapLedgerLookup({
    Iterable<AccountRef> accounts = const [],
    Iterable<FundRef> funds = const [],
    Iterable<SamityRef> samities = const [],
    Iterable<ObligationRef> obligations = const [],
  }) : _accounts = {for (final a in accounts) a.id: a},
       _funds = {for (final f in funds) f.id: f},
       _samities = {for (final s in samities) s.id: s},
       _obligations = {for (final o in obligations) o.id: o};

  final Map<String, AccountRef> _accounts;
  final Map<String, FundRef> _funds;
  final Map<String, SamityRef> _samities;
  final Map<String, ObligationRef> _obligations;

  @override
  AccountRef? account(String id) => _accounts[id];
  @override
  FundRef? fund(String id) => _funds[id];
  @override
  SamityRef? samity(String id) => _samities[id];
  @override
  ObligationRef? obligation(String id) => _obligations[id];
}

/// What the user entered. Only fields relevant to [type] are read.
class TxInput {
  const TxInput({
    required this.type,
    this.amount,
    this.fromAccountId,
    this.toAccountId,
    this.fundId,
    this.toFundId,
    this.personId,
    this.categoryId,
    this.obligationId,
    this.samityId,
    this.fee = 0,
    this.increase = true,
    this.description,
  });

  final TxType type;
  final int? amount;
  final String? fromAccountId;
  final String? toAccountId;
  final String? fundId;
  final String? toFundId;
  final String? personId;
  final String? categoryId;
  final String? obligationId;
  final String? samityId;

  /// Optional transfer fee (poisha), charged to the source account as an
  /// expense of the same fund.
  final int fee;

  /// For [TxType.adjustment]: true when the counted balance is higher than
  /// the ledger balance.
  final bool increase;

  /// Free text; required as the *reason* for adjustments.
  final String? description;

  TxInput copyWith({
    TxType? type,
    int? amount,
    String? fromAccountId,
    String? toAccountId,
    String? fundId,
    String? toFundId,
    String? personId,
    String? categoryId,
    String? obligationId,
    String? samityId,
    int? fee,
    bool? increase,
    String? description,
  }) => TxInput(
    type: type ?? this.type,
    amount: amount ?? this.amount,
    fromAccountId: fromAccountId ?? this.fromAccountId,
    toAccountId: toAccountId ?? this.toAccountId,
    fundId: fundId ?? this.fundId,
    toFundId: toFundId ?? this.toFundId,
    personId: personId ?? this.personId,
    categoryId: categoryId ?? this.categoryId,
    obligationId: obligationId ?? this.obligationId,
    samityId: samityId ?? this.samityId,
    fee: fee ?? this.fee,
    increase: increase ?? this.increase,
    description: description ?? this.description,
  );
}

/// Validation error codes, keyed by field name in [PostingPlan.errors].
abstract final class PostingError {
  static const required = 'required';
  static const invalid = 'invalid';
  static const notStorage = 'not_storage';
  static const sameAccount = 'same_account';
  static const sameFund = 'same_fund';
  static const wrongCategory = 'wrong_category';
  static const personalFundNotAllowed = 'personal_fund_not_allowed';
  static const mismatch = 'mismatch';
  static const settled = 'settled';
}

class PostingPlan {
  const PostingPlan(this.lines, this.errors, {this.personId, this.fundId});

  final List<LineSpec> lines;

  /// field -> error code. Non-empty means the input can only be a draft.
  final Map<String, String> errors;

  /// Resolved main person / fund (may be derived from samity or obligation).
  final String? personId;
  final String? fundId;

  bool get isComplete => errors.isEmpty;
}

class LedgerInvariantViolation implements Exception {
  LedgerInvariantViolation(this.message);
  final String message;
  @override
  String toString() => 'LedgerInvariantViolation: $message';
}

abstract final class LedgerInvariants {
  /// Throws if [lines] are not a valid balanced entry.
  static void check(List<LineSpec> lines) {
    final problem = describe(lines);
    if (problem != null) throw LedgerInvariantViolation(problem);
  }

  /// Returns a description of the first violated invariant, or null.
  static String? describe(List<LineSpec> lines) {
    if (lines.length < 2) return 'needs at least two lines';
    var total = 0;
    final perFund = <String, int>{};
    for (final l in lines) {
      if (l.amount == 0) return 'zero-amount line';
      if (l.amount.abs() > 9007199254740991) return 'amount out of range';
      if (l.accountId.isEmpty || l.fundId.isEmpty)
        return 'missing account/fund';
      total += l.amount;
      perFund[l.fundId] = (perFund[l.fundId] ?? 0) + l.amount;
    }
    if (total != 0) return 'debits and credits differ by $total';
    for (final e in perFund.entries) {
      if (e.value != 0) return 'fund ${e.key} is unbalanced by ${e.value}';
    }
    return null;
  }

  static int totalDebit(List<LineSpec> lines) =>
      lines.where((l) => l.amount > 0).fold(0, (s, l) => s + l.amount);

  static int totalCredit(List<LineSpec> lines) =>
      lines.where((l) => l.amount < 0).fold(0, (s, l) => s - l.amount);
}

/// Turns a [TxInput] into balanced ledger lines, or explains what is missing.
///
/// The engine never guesses: if a fact needed for the accounting treatment
/// is missing, it reports an error and the caller must save a draft.
class PostingEngine {
  const PostingEngine(this.lookup);

  final LedgerLookup lookup;

  PostingPlan plan(TxInput input) {
    final errors = <String, String>{};
    final amount = input.amount;
    if (amount == null || amount <= 0) {
      errors['amount'] = amount == null
          ? PostingError.required
          : PostingError.invalid;
    }
    if (input.fee < 0) errors['fee'] = PostingError.invalid;

    var fundId = input.fundId;
    var personId = input.personId;

    // Derive fund/person from linked samity or obligation.
    if (input.type.usesSamity) {
      final s = input.samityId == null ? null : lookup.samity(input.samityId!);
      if (s == null) {
        errors['samity'] = input.samityId == null
            ? PostingError.required
            : PostingError.invalid;
      } else if (s.mode == SamityMode.managed) {
        if (s.fundId == null) {
          errors['samity'] = PostingError.invalid;
        } else {
          fundId = s.fundId;
        }
      }
    }
    if (input.type.usesObligation && input.obligationId != null) {
      final o = lookup.obligation(input.obligationId!);
      if (o == null) {
        errors['obligation'] = PostingError.invalid;
      } else {
        if (o.kind != _obligationKindFor(input.type)) {
          errors['obligation'] = PostingError.mismatch;
        } else if (personId != null && personId != o.personId) {
          errors['person'] = PostingError.mismatch;
        } else if (fundId != null && fundId != o.fundId) {
          errors['fund'] = PostingError.mismatch;
        }
        personId ??= o.personId;
        fundId ??= o.fundId;
      }
    }

    FundRef? fund;
    if (fundId == null) {
      errors['fund'] ??= PostingError.required;
    } else {
      fund = lookup.fund(fundId);
      if (fund == null) errors['fund'] ??= PostingError.invalid;
    }

    void requireStorage(String field, String? id) {
      if (id == null) {
        errors[field] = PostingError.required;
        return;
      }
      final a = lookup.account(id);
      if (a == null) {
        errors[field] = PostingError.invalid;
      } else if (a.kind != LedgerAccountKind.storage) {
        errors[field] = PostingError.notStorage;
      }
    }

    final type = input.type;
    if (type.usesFromAccount ||
        type == TxType.interFundLoan ||
        type == TxType.interFundRepayment ||
        type == TxType.adjustment) {
      requireStorage('fromAccount', input.fromAccountId);
    }
    if (type.usesToAccount) requireStorage('toAccount', input.toAccountId);
    if (type == TxType.transfer &&
        input.fromAccountId != null &&
        input.fromAccountId == input.toAccountId) {
      errors['toAccount'] = PostingError.sameAccount;
    }
    if (type.needsPerson && personId == null) {
      errors['person'] ??= PostingError.required;
    }
    if (type == TxType.samityContribution || type == TxType.samityPayout) {
      final s = input.samityId == null ? null : lookup.samity(input.samityId!);
      if (s?.mode == SamityMode.managed && personId == null) {
        errors['person'] ??= PostingError.required;
      }
    }
    if (type.usesCategory) {
      final wanted = type == TxType.income
          ? LedgerAccountKind.incomeCategory
          : LedgerAccountKind.expenseCategory;
      final c = input.categoryId == null
          ? null
          : lookup.account(input.categoryId!);
      if (input.categoryId == null) {
        errors['category'] = PostingError.required;
      } else if (c == null) {
        errors['category'] = PostingError.invalid;
      } else if (c.kind != wanted) {
        errors['category'] = PostingError.wrongCategory;
      }
    }
    if ((type == TxType.fundDeposit || type == TxType.fundWithdrawal) &&
        fund != null &&
        fund.kind.isPersonal) {
      // Money arriving in the user's own fund is income, not a deposit.
      errors['fund'] = PostingError.personalFundNotAllowed;
    }
    if (type.usesToFund) {
      if (input.toFundId == null) {
        errors['toFund'] = PostingError.required;
      } else if (lookup.fund(input.toFundId!) == null) {
        errors['toFund'] = PostingError.invalid;
      } else if (input.toFundId == fundId) {
        errors['toFund'] = PostingError.sameFund;
      }
      if (input.toAccountId != null) {
        requireStorage('toAccount', input.toAccountId);
      }
    }
    if (type == TxType.adjustment &&
        (input.description == null || input.description!.trim().isEmpty)) {
      errors['reason'] = PostingError.required;
    }
    if (type == TxType.reversal) {
      errors['type'] = PostingError.invalid; // use buildReversal instead
    }

    if (errors.isNotEmpty) {
      return PostingPlan(const [], errors, personId: personId, fundId: fundId);
    }

    final lines = _build(input, amount!, fundId!, personId);
    LedgerInvariants.check(lines);
    return PostingPlan(lines, const {}, personId: personId, fundId: fundId);
  }

  static ObligationKind? _obligationKindFor(TxType t) => switch (t) {
    TxType.loanGiven ||
    TxType.loanRepaymentReceived => ObligationKind.loanGiven,
    TxType.loanTaken || TxType.loanRepaymentPaid => ObligationKind.loanTaken,
    TxType.advancePaid ||
    TxType.reimbursementReceived => ObligationKind.advance,
    _ => null,
  };

  static ObligationKind? obligationKindFor(TxType t) => _obligationKindFor(t);

  List<LineSpec> _build(TxInput i, int a, String f, String? p) {
    LineSpec dr(String acct, {String? person, String? fund, String? cf}) =>
        LineSpec(
          accountId: acct,
          fundId: fund ?? f,
          amount: a,
          personId: person,
          counterFundId: cf,
        );
    LineSpec cr(String acct, {String? person, String? fund, String? cf}) =>
        LineSpec(
          accountId: acct,
          fundId: fund ?? f,
          amount: -a,
          personId: person,
          counterFundId: cf,
        );

    final from = i.fromAccountId;
    final to = i.toAccountId;
    switch (i.type) {
      case TxType.income:
        return [dr(to!, person: p), cr(i.categoryId!, person: p)];
      case TxType.expense:
        return [dr(i.categoryId!, person: p), cr(from!, person: p)];
      case TxType.transfer:
        return [
          dr(to!),
          cr(from!),
          if (i.fee > 0) ...[
            LineSpec(
              accountId: SystemAccounts.transferFees,
              fundId: f,
              amount: i.fee,
            ),
            LineSpec(accountId: from, fundId: f, amount: -i.fee),
          ],
        ];
      case TxType.fundDeposit:
        return [dr(to!), cr(SystemAccounts.fundCapital, person: p)];
      case TxType.fundWithdrawal:
        return [dr(SystemAccounts.fundCapital, person: p), cr(from!)];
      case TxType.loanGiven:
        return [dr(SystemAccounts.loansReceivable, person: p), cr(from!)];
      case TxType.loanRepaymentReceived:
        return [dr(to!), cr(SystemAccounts.loansReceivable, person: p)];
      case TxType.loanTaken:
        return [dr(to!), cr(SystemAccounts.loansPayable, person: p)];
      case TxType.loanRepaymentPaid:
        return [dr(SystemAccounts.loansPayable, person: p), cr(from!)];
      case TxType.advancePaid:
        return [dr(SystemAccounts.advancesReceivable, person: p), cr(from!)];
      case TxType.reimbursementReceived:
        return [dr(to!), cr(SystemAccounts.advancesReceivable, person: p)];
      case TxType.samityContribution:
        final s = lookup.samity(i.samityId!)!;
        if (s.mode == SamityMode.managed) {
          // A member pays into the pool I hold. `from` is where it landed.
          return [dr(from!), cr(SystemAccounts.fundCapital, person: p)];
        }
        // I pay my contribution to an external samity: still my asset.
        return [dr(SystemAccounts.externalSavings), cr(from!)];
      case TxType.samityPayout:
        final s = lookup.samity(i.samityId!)!;
        if (s.mode == SamityMode.managed) {
          return [dr(SystemAccounts.fundCapital, person: p), cr(to!)];
        }
        return [dr(to!), cr(SystemAccounts.externalSavings)];
      case TxType.interFundLoan:
      case TxType.interFundRepayment:
        // Ownership of money sitting in `from` passes from fund f to toFund,
        // recorded as a due between the two funds. Physically the money may
        // also move to `to`.
        final g = i.toFundId!;
        return [
          cr(from!),
          dr(SystemAccounts.interFundDue, cf: g),
          dr(to ?? from, fund: g),
          cr(SystemAccounts.interFundDue, fund: g, cf: f),
        ];
      case TxType.openingBalance:
        return [dr(to!), cr(SystemAccounts.openingBalance)];
      case TxType.adjustment:
        return i.increase
            ? [dr(from!), cr(SystemAccounts.reconciliationDifference)]
            : [dr(SystemAccounts.reconciliationDifference), cr(from!)];
      case TxType.reversal:
        throw StateError('unreachable');
    }
  }

  /// Lines that exactly cancel [original].
  static List<LineSpec> buildReversal(List<LineSpec> original) {
    final lines = [for (final l in original) l.negate()];
    LedgerInvariants.check(lines);
    return lines;
  }
}
