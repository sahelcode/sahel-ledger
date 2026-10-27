import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import '../db/database.dart';
import '../repositories/audit_log.dart';

class BackupException implements Exception {
  BackupException(this.code, [this.detail]);
  final String code;
  final String? detail;
  @override
  String toString() =>
      'BackupException($code${detail != null ? ': $detail' : ''})';
}

class BackupInfo {
  const BackupInfo({
    required this.createdAt,
    required this.schemaVersion,
    required this.transactionCount,
    required this.checksum,
  });
  final DateTime createdAt;
  final int schemaVersion;
  final int transactionCount;
  final String checksum;
}

/// Full local backup as a self-verifying JSON document.
///
/// Format:
/// ```json
/// {"format": "sahel-ledger-backup", "formatVersion": 1, "schemaVersion": 1,
///  "createdAt": "...", "checksum": "<sha256 of canonical tables>",
///  "tables": {"persons": [{...}], ...}}
/// ```
/// Values are the raw SQLite column values, so a restore reproduces the
/// database exactly, including posted history and the audit hash chain.
class BackupService {
  BackupService(this.db);

  final AppDatabase db;

  static const format = 'sahel-ledger-backup';
  static const formatVersion = 1;

  /// Insertion order respects foreign keys.
  static const tableOrder = [
    'persons',
    'funds',
    'ledger_accounts',
    'obligations',
    'samities',
    'samity_members',
    'budgets',
    'ledger_transactions',
    'transaction_lines',
    'attachments',
    'recon_sessions',
    'audit_events',
    'outbox',
    'key_values',
  ];

  /// Keys that describe this installation rather than the ledger.
  static const _deviceLocalKeys = {Kv.deviceId};

  Future<Map<String, Object?>> exportMap() async {
    final tables = <String, Object?>{};
    for (final t in tableOrder) {
      final rows = await db.customSelect('SELECT * FROM $t').get();
      tables[t] = [for (final r in rows) r.data];
    }
    return {
      'format': format,
      'formatVersion': formatVersion,
      'schemaVersion': db.schemaVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'checksum': sha256Hex(canonicalJson(tables)),
      'tables': tables,
    };
  }

  Future<String> exportJson() async => jsonEncode(await exportMap());

  Future<File> exportToFile(File file) async {
    final json = await exportJson();
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(json, flush: true);
    // Verify what is on disk before replacing the destination.
    inspect(await tmp.readAsString());
    await tmp.rename(file.path);
    await db.setKv(Kv.lastBackupAt, DateTime.now().toUtc().toIso8601String());
    return file;
  }

  /// Validates a backup document without touching the database.
  BackupInfo inspect(String json) {
    final Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException catch (e) {
      throw BackupException('not_json', e.message);
    }
    if (decoded is! Map<String, Object?> || decoded['format'] != format) {
      throw BackupException('wrong_format');
    }
    if ((decoded['formatVersion'] as num?)?.toInt() != formatVersion) {
      throw BackupException('unsupported_format_version');
    }
    final schema = (decoded['schemaVersion'] as num?)?.toInt() ?? 0;
    if (schema > db.schemaVersion) throw BackupException('newer_schema');
    if (schema < db.schemaVersion) {
      // Older backups would need data migration before import.
      throw BackupException('older_schema_unsupported');
    }
    final tables = decoded['tables'];
    if (tables is! Map<String, Object?>)
      throw BackupException('missing_tables');
    if (sha256Hex(canonicalJson(tables)) != decoded['checksum']) {
      throw BackupException('checksum_mismatch');
    }
    for (final t in tableOrder) {
      if (tables[t] is! List) throw BackupException('missing_table', t);
    }
    return BackupInfo(
      createdAt: DateTime.parse(decoded['createdAt']! as String),
      schemaVersion: schema,
      transactionCount: (tables['ledger_transactions']! as List).length,
      checksum: decoded['checksum']! as String,
    );
  }

  /// Replaces the whole database with the backup, atomically.
  ///
  /// The import runs in one SQLite transaction and is verified (foreign
  /// keys, balanced entries, audit chain) before commit; any failure rolls
  /// back and leaves the current data untouched. Callers should export a
  /// safety backup first (the UI does).
  Future<BackupInfo> restore(String json) async {
    final info = inspect(json);
    final tables =
        (jsonDecode(json) as Map<String, Object?>)['tables']!
            as Map<String, Object?>;
    final keepDeviceId = await db.getKv(Kv.deviceId);
    await db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      await db.transaction(() async {
        await db.dropTriggers();
        for (final t in tableOrder.reversed) {
          await db.customStatement('DELETE FROM $t');
        }
        for (final t in tableOrder) {
          for (final raw in tables[t]! as List) {
            final row = Map<String, Object?>.from(raw as Map);
            if (t == 'key_values' && _deviceLocalKeys.contains(row['key']))
              continue;
            final cols = row.keys.toList();
            await db.customInsert(
              'INSERT INTO $t (${cols.join(', ')}) VALUES (${List.filled(cols.length, '?').join(', ')})',
              variables: [for (final c in cols) _variable(row[c])],
            );
          }
        }
        if (keepDeviceId != null) await db.setKv(Kv.deviceId, keepDeviceId);
        await db.installTriggers();
        await _verify();
      });
    } finally {
      await db.customStatement('PRAGMA foreign_keys = ON');
    }
    return info;
  }

  Variable _variable(Object? v) => switch (v) {
    null => const Variable(null),
    final int i => Variable<int>(i),
    final double d => Variable<double>(d),
    final String s => Variable<String>(s),
    final bool b => Variable<bool>(b),
    _ => throw BackupException('bad_value', '$v'),
  };

  Future<void> _verify() async {
    final fk = await db.customSelect('PRAGMA foreign_key_check').get();
    if (fk.isNotEmpty)
      throw BackupException('foreign_keys', '${fk.first.data}');
    final unbalanced = await db.customSelect('''
        SELECT t.id FROM ledger_transactions t
        LEFT JOIN transaction_lines l ON l.tx_id = t.id
        WHERE t.status IN ('posted','pending')
        GROUP BY t.id HAVING COALESCE(SUM(l.amount),0) <> 0 OR COUNT(l.line_no) < 2
        UNION
        SELECT l.tx_id FROM transaction_lines l
        JOIN ledger_transactions t ON t.id = l.tx_id AND t.status IN ('posted','pending')
        GROUP BY l.tx_id, l.fund_id HAVING SUM(l.amount) <> 0''').get();
    if (unbalanced.isNotEmpty) {
      throw BackupException(
        'unbalanced',
        unbalanced.first.data.values.first.toString(),
      );
    }
    final broken = await AuditLog(db).verifyChain();
    if (broken != null) throw BackupException('audit_chain', 'seq $broken');
  }
}
