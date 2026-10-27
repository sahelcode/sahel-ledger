# Sahel Ledger — সাহেল লেজার

**Every Taka, Accounted For. · প্রতিটি টাকার নির্ভুল হিসাব।**

A Bengali-first personal and family fund manager for Bangladesh. It keeps
three questions separate that ordinary expense apps mix up:

| Question | Answered by |
| --- | --- |
| **Where** is the money? | Storage accounts: cash, banks, bKash, Nagad… |
| **Whose** money is it? | Funds: *my money*, a sister's savings, an uncle's education money, a samity pool |
| **Why** did it move? | Transaction type + income/expense category |

So ৳50,000 a sister keeps in your bank account shows up in the bank's
balance but never in *your* net worth; moving money from a bank to bKash is
never income; lending is a receivable, not an expense.

## Status

Built and verified in a cloud environment without an Android SDK or access
to a real Firebase project. See [What was verified](#what-was-verified)
for exactly what has and has not been exercised.

## Features

- **Ledger:** fund-accounting double entry in integer poisha; every entry
  balances overall *and per fund*; posted entries are immutable (enforced by
  SQLite triggers) and corrected only by reversal + replacement.
- **Entry:** quick conditional form (17 transaction types), searchable
  pickers, duplicate warnings, review step for complex entries, drafts for
  incomplete facts, pending entries (e.g. uncleared cheques).
- **People & funds:** entrusted and purpose funds per person, per-person
  statements (held for them / they owe / you owe).
- **Accounts:** cash, bank, mobile wallets, with "who owns the money in this
  account" breakdowns.
- **Loans & advances:** automatic tracking with partial repayments,
  settlement status and over-payment warnings.
- **Samity:** managed pools (you are treasurer) and external memberships,
  with per-member dues.
- **Budgets**, **reconciliation** (counted vs ledger, explained adjustments,
  approval workflow), **health checks** (unbalanced, overdrawn funds,
  duplicates, unusual amounts, stale drafts, sync conflicts).
- **Reports:** ten A4 PDF report types in Bengali or English with correct
  Bengali shaping, running balances, repeated headers and page numbers.
- **Offline-first sync** to Cloud Firestore with a durable outbox,
  idempotent writes, explicit conflicts and server-enforced privacy rules.
- **Household roles:** owner, administrator (delegated permissions), member
  (read-only, chosen funds), single-use email-bound invitations, revocation.
- **Safety:** hash-chained audit log, verified JSON backup/restore, app lock
  (PBKDF2-hashed PIN in the platform keystore), no full account numbers,
  data excluded from Android cloud backups.
- Light and dark themes; Bengali digits and lakh/crore grouping.

## Quick start

Requirements: Flutter 3.47 (Dart 3.13), Android SDK for device builds.

```bash
flutter pub get
flutter test                 # unit, repository, sync, PDF and widget tests
flutter run                  # runs in local-only mode until Firebase is configured
```

Firebase (optional, for sync and households): see
[docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md).

Security-rules tests (needs Node 22 and Java 21):

```bash
cd firebase/rules-tests && npm ci && npm test
```

Regenerate database code after schema changes:

```bash
dart run build_runner build --delete-conflicting-outputs
dart run drift_dev make-migrations   # after bumping schemaVersion
```

## Project layout

```
lib/
  core/money/            integer-poisha parsing & formatting (Bengali digits, lakh grouping)
  domain/ledger/         accounting vocabulary, posting engine, invariants, reference balances
  domain/access/         roles & permissions
  data/db/               Drift schema, integrity triggers, seed data
  data/repositories/     ledger, master data, reports, reconciliation, audit, outbox, attachments
  data/backup/           verified backup & atomic restore
  data/sync/             sync engine, Firestore store, household service, reader lists
  app/                   theme tokens, strings (bn/en), providers, router, shell
  features/              screens (dashboard, entry, history, people, accounts, loans,
                         samity, reports + PDF, reconciliation, household, settings, lock)
  shared/                reusable widgets, statement view
test/                    domain, data, sync, PDF, widget and schema-migration tests
firestore.rules          server-enforced access control
firebase/rules-tests/    emulator tests for the rules
drift_schemas/           frozen schema snapshots for migration tests
docs/                    architecture, Firebase setup, operations
```

## Documentation

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — accounting model, invariants, sync and security design
- [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) — connecting a Firebase project
- [docs/OPERATIONS.md](docs/OPERATIONS.md) — backup, recovery, release checklist

## What was verified

| Check | Result |
| --- | --- |
| `dart format`, `flutter analyze` | clean |
| `flutter test` | 97 passed, 4 skipped (opt-in screenshot harness) |
| Firestore rules tests on the emulator | 32 passed; a mutation check (weakened rules) made 4 fail as expected |
| PDF Bengali rendering | visually inspected via `pdftoppm`; naive vector text is mis-shaped, shipped path is correct |
| UI | rendered with real fonts in widget tests and inspected (Bengali/English, light/dark) |
| Android build | **not run** — no Android SDK available in the build environment; CI workflow builds an APK on GitHub runners |
| Real Firebase project | **not connected** — sync logic is tested against an in-memory fake that shares the production write-decision code; rules are tested on the emulator |

Fonts: Hind Siliguri (SIL Open Font License, `assets/fonts/OFL.txt`).
