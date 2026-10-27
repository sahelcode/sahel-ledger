// Drift check constraints reference their own column getter by design.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../../domain/ledger/ledger_types.dart';

/// Columns shared by synchronised master-data rows.
mixin SyncedRow on Table {
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
}

@DataClassName('PersonRow')
class Persons extends Table with SyncedRow {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get relation => text().withDefault(const Constant('other'))();
  TextColumn get phone => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSelf => boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FundRow')
class Funds extends Table with SyncedRow {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get kind => textEnum<FundKind>()();
  TextColumn get ownerPersonId => text().nullable().references(Persons, #id)();
  TextColumn get description => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Storage accounts, income/expense categories and system accounts.
@DataClassName('LedgerAccountRow')
class LedgerAccounts extends Table with SyncedRow {
  TextColumn get id => text()();
  TextColumn get kind => textEnum<LedgerAccountKind>()();
  TextColumn get accountClass => textEnum<AccountClass>()();
  TextColumn get storageType => textEnum<StorageType>().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get nameBn => text().nullable()();
  TextColumn get institution => text().nullable()();

  /// Only the last digits are ever stored, never a full account number.
  TextColumn get numberHint => text().nullable()();
  TextColumn get icon => text().nullable()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ObligationRow')
class Obligations extends Table with SyncedRow {
  TextColumn get id => text()();
  TextColumn get kind => textEnum<ObligationKind>()();
  TextColumn get personId => text().references(Persons, #id)();
  TextColumn get fundId => text().references(Funds, #id)();
  TextColumn get title => text().nullable()();
  IntColumn get openedOn => integer()();
  IntColumn get dueOn => integer().nullable()();
  TextColumn get status =>
      textEnum<ObligationStatus>().withDefault(const Constant('open'))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SamityRow')
class Samities extends Table with SyncedRow {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get mode => textEnum<SamityMode>()();
  TextColumn get fundId => text().nullable().references(Funds, #id)();
  IntColumn get contributionAmount =>
      integer().withDefault(const Constant(0))();

  /// `monthly` or `weekly`.
  TextColumn get frequency => text().withDefault(const Constant('monthly'))();
  IntColumn get startOn => integer()();
  TextColumn get notes => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SamityMemberRow')
class SamityMembers extends Table with SyncedRow {
  TextColumn get samityId => text().references(Samities, #id)();
  TextColumn get personId => text().references(Persons, #id)();
  IntColumn get shares => integer().withDefault(const Constant(1))();
  IntColumn get joinedOn => integer()();

  @override
  Set<Column> get primaryKey => {samityId, personId};
}

@DataClassName('BudgetRow')
class Budgets extends Table with SyncedRow {
  TextColumn get id => text()();
  IntColumn get monthKey => integer()();
  TextColumn get categoryId => text().references(LedgerAccounts, #id)();
  IntColumn get limitAmount => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {monthKey, categoryId},
  ];
}

@DataClassName('TxRow')
@TableIndex(name: 'tx_status_date', columns: {#status, #dateKey, #sortKey})
@TableIndex(name: 'tx_person', columns: {#personId})
@TableIndex(name: 'tx_obligation', columns: {#obligationId})
@TableIndex(name: 'tx_samity', columns: {#samityId})
@TableIndex(name: 'tx_sync', columns: {#syncStatus})
class LedgerTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => textEnum<TxType>()();
  TextColumn get status => textEnum<TxStatus>()();
  IntColumn get dateKey => integer()();
  IntColumn get amount => integer().nullable().check(
    amount.isNull() | amount.isBiggerThanValue(0),
  )();
  TextColumn get currency => text().withDefault(const Constant('BDT'))();
  IntColumn get fee => integer().withDefault(const Constant(0))();
  BoolColumn get increase => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get referenceNo => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get personId => text().nullable()();
  TextColumn get fundId => text().nullable()();
  TextColumn get toFundId => text().nullable()();
  TextColumn get fromAccountId => text().nullable()();
  TextColumn get toAccountId => text().nullable()();
  TextColumn get obligationId => text().nullable()();
  TextColumn get samityId => text().nullable()();
  TextColumn get reconSessionId => text().nullable()();
  TextColumn get reversesTxId => text().nullable()();
  TextColumn get reversedByTxId => text().nullable()();
  TextColumn get replacesTxId => text().nullable()();
  TextColumn get createdBy => text()();
  TextColumn get modifiedBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get postedAt => dateTime().nullable()();

  /// Creation time in microseconds; orders entries within the same day
  /// deterministically (DateTime columns only keep whole seconds).
  IntColumn get sortKey => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get contentHash => text().nullable()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LineRow')
@TableIndex(name: 'line_account', columns: {#accountId, #fundId})
@TableIndex(name: 'line_fund', columns: {#fundId})
@TableIndex(name: 'line_person', columns: {#personId, #accountId})
class TransactionLines extends Table {
  TextColumn get txId => text().references(LedgerTransactions, #id)();
  IntColumn get lineNo => integer()();
  TextColumn get accountId => text().references(LedgerAccounts, #id)();
  TextColumn get fundId => text().references(Funds, #id)();
  TextColumn get personId => text().nullable()();
  TextColumn get counterFundId => text().nullable()();
  IntColumn get amount => integer().check(amount.isNotValue(0))();

  @override
  Set<Column> get primaryKey => {txId, lineNo};
}

@DataClassName('AttachmentRow')
class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get txId => text().references(LedgerTransactions, #id)();
  TextColumn get fileName => text()();
  TextColumn get localPath => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get sizeBytes => integer()();
  TextColumn get sha256 => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReconSessionRow')
class ReconSessions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(LedgerAccounts, #id)();
  TextColumn get fundId => text().nullable()();
  IntColumn get asOfDateKey => integer()();
  IntColumn get expectedBalance => integer()();
  IntColumn get actualBalance => integer()();

  /// open | matched | adjusted | pendingApproval | unresolved
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get adjustmentTxId => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get approvedBy => text().nullable()();
  DateTimeColumn get approvedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only, hash-chained audit log.
@DataClassName('AuditRow')
@TableIndex(name: 'audit_entity', columns: {#entityType, #entityId})
class AuditEvents extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get eventId => text().unique()();
  DateTimeColumn get at => dateTime()();
  TextColumn get actorId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  TextColumn get details => text().nullable()();
  TextColumn get prevHash => text()();
  TextColumn get hash => text()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
}

/// Durable queue of cloud operations. Rows are only removed after the server
/// confirms the write.
@DataClassName('OutboxRow')
@TableIndex(name: 'outbox_state', columns: {#state, #nextAttemptAt})
class Outbox extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime()();
  TextColumn get lastError => text().nullable()();

  /// pending | failed | conflict
  TextColumn get state => text().withDefault(const Constant('pending'))();
}

@DataClassName('KvRow')
class KeyValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
