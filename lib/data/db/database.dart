import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/ledger/ledger_types.dart';
import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

/// SQL triggers that enforce ledger integrity inside SQLite itself, so that
/// no code path (including bugs or restore/sync imports) can corrupt posted
/// history.
abstract final class IntegrityTriggers {
  static const _financialColumns = [
    'type',
    'amount',
    'currency',
    'fee',
    'increase',
    'date_key',
    'description',
    'category_id',
    'person_id',
    'fund_id',
    'to_fund_id',
    'from_account_id',
    'to_account_id',
    'obligation_id',
    'samity_id',
    'reverses_tx_id',
    'created_by',
    'created_at',
    'content_hash',
  ];

  static const _balanced = '''
    (SELECT COUNT(*) FROM transaction_lines WHERE tx_id = NEW.id) >= 2
    AND (SELECT COALESCE(SUM(amount), 0) FROM transaction_lines WHERE tx_id = NEW.id) = 0
    AND NOT EXISTS (
      SELECT 1 FROM transaction_lines WHERE tx_id = NEW.id
      GROUP BY fund_id HAVING SUM(amount) <> 0)''';

  static List<String> get statements => [
    // Committed transactions must first be written as `staging` so that
    // their lines exist before the balance check runs.
    '''CREATE TRIGGER IF NOT EXISTS tx_insert_staging
       BEFORE INSERT ON ledger_transactions
       WHEN NEW.status IN ('pending', 'posted', 'cancelled')
       BEGIN SELECT RAISE(ABORT, 'ledger: insert as staging first'); END''',
    '''CREATE TRIGGER IF NOT EXISTS tx_balanced_on_commit
       BEFORE UPDATE OF status ON ledger_transactions
       WHEN NEW.status IN ('pending', 'posted') AND NOT ($_balanced)
       BEGIN SELECT RAISE(ABORT, 'ledger: unbalanced transaction'); END''',
    '''CREATE TRIGGER IF NOT EXISTS tx_posted_immutable
       BEFORE UPDATE ON ledger_transactions
       WHEN OLD.status = 'posted' AND (
         NEW.status <> 'posted'
         OR (OLD.reversed_by_tx_id IS NOT NULL
             AND NEW.reversed_by_tx_id IS NOT OLD.reversed_by_tx_id)
         ${_financialColumns.map((c) => 'OR NEW.$c IS NOT OLD.$c').join('\n         ')})
       BEGIN SELECT RAISE(ABORT, 'ledger: posted transactions are immutable'); END''',
    '''CREATE TRIGGER IF NOT EXISTS tx_cancelled_final
       BEFORE UPDATE ON ledger_transactions
       WHEN OLD.status = 'cancelled' AND NEW.status <> 'cancelled'
       BEGIN SELECT RAISE(ABORT, 'ledger: cancelled transactions are final'); END''',
    '''CREATE TRIGGER IF NOT EXISTS tx_no_delete_committed
       BEFORE DELETE ON ledger_transactions
       WHEN OLD.status NOT IN ('draft', 'staging')
       BEGIN SELECT RAISE(ABORT, 'ledger: committed transactions cannot be deleted'); END''',
    for (final op in ['INSERT', 'UPDATE', 'DELETE'])
      '''CREATE TRIGGER IF NOT EXISTS lines_locked_${op.toLowerCase()}
         BEFORE $op ON transaction_lines
         WHEN (SELECT status FROM ledger_transactions
               WHERE id = ${op == 'DELETE' ? 'OLD' : 'NEW'}.tx_id)
              NOT IN ('draft', 'staging')
         BEGIN SELECT RAISE(ABORT, 'ledger: lines of committed transactions are locked'); END''',
    '''CREATE TRIGGER IF NOT EXISTS audit_no_update
       BEFORE UPDATE ON audit_events
       WHEN NEW.hash IS NOT OLD.hash OR NEW.prev_hash IS NOT OLD.prev_hash
         OR NEW.details IS NOT OLD.details OR NEW.action IS NOT OLD.action
         OR NEW.entity_id IS NOT OLD.entity_id OR NEW.at IS NOT OLD.at
         OR NEW.actor_id IS NOT OLD.actor_id
       BEGIN SELECT RAISE(ABORT, 'audit: append only'); END''',
    '''CREATE TRIGGER IF NOT EXISTS audit_no_delete
       BEFORE DELETE ON audit_events
       BEGIN SELECT RAISE(ABORT, 'audit: append only'); END''',
  ];

  static const names = [
    'tx_insert_staging',
    'tx_balanced_on_commit',
    'tx_posted_immutable',
    'tx_cancelled_final',
    'tx_no_delete_committed',
    'lines_locked_insert',
    'lines_locked_update',
    'lines_locked_delete',
    'audit_no_update',
    'audit_no_delete',
  ];
}

@DriftDatabase(
  tables: [
    Persons,
    Funds,
    LedgerAccounts,
    Obligations,
    Samities,
    SamityMembers,
    Budgets,
    LedgerTransactions,
    TransactionLines,
    Attachments,
    ReconSessions,
    AuditEvents,
    Outbox,
    KeyValues,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Opens the on-device database.
  factory AppDatabase.open({String name = 'sahel_ledger'}) =>
      AppDatabase(driftDatabase(name: name));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await installTriggers();
      await seedSystemData(this);
    },
    onUpgrade: (m, from, to) async {
      // Future schema versions add stepwise migrations here. Triggers are
      // recreated afterwards because they may reference changed columns.
      await installTriggers();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> installTriggers() async {
    for (final s in IntegrityTriggers.statements) {
      await customStatement(s);
    }
  }

  Future<void> dropTriggers() async {
    for (final n in IntegrityTriggers.names) {
      await customStatement('DROP TRIGGER IF EXISTS $n');
    }
  }

  Future<String?> getKv(String key) async {
    final row = await (select(
      keyValues,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setKv(String key, String value) => into(
    keyValues,
  ).insertOnConflictUpdate(KeyValuesCompanion.insert(key: key, value: value));
}

/// Keys for [KeyValues].
abstract final class Kv {
  static const selfPersonId = 'self_person_id';
  static const personalFundId = 'personal_fund_id';
  static const onboarded = 'onboarded';
  static const deviceId = 'device_id';
  static const householdId = 'household_id';
  static const actorId = 'actor_id';
  static const pullCursorPrefix = 'pull_cursor.';
  static const locale = 'locale';
  static const themeMode = 'theme_mode';
  static const lastBackupAt = 'last_backup_at';
}

extension SyncStatusX on SyncStatus {
  bool get needsUpload =>
      this == SyncStatus.pending || this == SyncStatus.failed;
}
