// Schema-migration safety net.
//
// `drift_schemas/` holds a frozen JSON snapshot of every released schema
// version. When the schema changes: bump `schemaVersion`, run
// `dart run drift_dev make-migrations`, add a step to `onUpgrade`, and
// extend this file with a `migrateAndValidate` test from the previous
// version (see https://drift.simonbinder.eu/migrations/tests/).
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/data/db/database.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('a fresh database matches the frozen v1 schema', () async {
    final schema = await verifier.schemaAt(1);
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 1);
    await db.close();
  });

  test('code schema matches the current schema snapshot', () async {
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory()));
    await db.validateDatabaseSchema();
    await db.close();
  });
}
