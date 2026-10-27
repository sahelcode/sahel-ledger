# Operations: backup, recovery, release

## Backups

*Settings → Backup & restore → Create backup file* writes a JSON file with
every table and a SHA-256 checksum, re-reads it from disk to verify, and
opens the share sheet (save to Drive, email to yourself, copy to a PC).

* Backups contain private financial data. Store them somewhere only you
  control.
* Android OS backups are deliberately disabled for this app
  (`allowBackup=false`), so these files are the device-level backup.
* With cloud sync enabled, Firestore is a second copy of everything you own.

## Restore

*Settings → Backup & restore → Restore from backup* (owner only):

1. The file is checked: format, schema version, checksum.
2. A safety backup of the current data is written to the app's
   `backups/` folder (`before-restore-*.json`).
3. The import runs in one SQLite transaction and is verified (foreign keys,
   every committed entry balanced overall and per fund, audit hash chain).
   Any failure rolls back completely; current data stays untouched.

Older-schema backups are refused until a migration path for that version is
added (`BackupService.inspect`).

## Recovery scenarios

| Situation | What to do |
| --- | --- |
| New phone, cloud sync on | Install, sign in, *Join*/open household; data syncs down |
| New phone, local only | Install, finish onboarding, restore the latest backup file |
| Forgot account password | *Forgot password?* sends a reset email |
| Forgot app-lock PIN | Clear app data (loses local data) and restore from cloud or backup |
| Sync conflict shown | Open *Reconciliation → Health checks*; the local copy is kept and the conflict is in the audit log; reverse/re-enter as appropriate |
| Audit chain reported broken | Stop using the device; restore from a backup that verifies |

## Release checklist (Android)

1. Run everything that CI runs: `dart format`, `flutter analyze`,
   `flutter test`, `cd firebase/rules-tests && npm test`.
2. Configure production Firebase (docs/FIREBASE_SETUP.md), deploy rules,
   enforce App Check.
3. Create an upload keystore and `android/key.properties` (git-ignored):

   ```
   storeFile=/absolute/path/upload-keystore.jks
   storePassword=…
   keyAlias=upload
   keyPassword=…
   ```
4. Replace the default launcher icon (e.g. with `flutter_launcher_icons`).
5. Bump `version:` in `pubspec.yaml`.
6. `flutter build appbundle --release` and test the bundle on a real device:
   onboarding, offline entry, sync, PDF export in Bengali, backup/restore.
7. Play Console: data-safety form (financial info, stored on device and in
   Firebase, encrypted in transit, user can request deletion), privacy
   policy URL.

## Schema changes

1. Edit `lib/data/db/tables.dart`, bump `schemaVersion`.
2. `dart run build_runner build --delete-conflicting-outputs`
3. `dart run drift_dev make-migrations` (snapshots the new schema and
   generates migration test scaffolding).
4. Implement the step in `AppDatabase.migration.onUpgrade`; triggers are
   recreated automatically.
5. Add a `migrateAndValidate` test from the previous version in
   `test/drift/app_db/`.
