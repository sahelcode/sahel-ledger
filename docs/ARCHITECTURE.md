# Architecture

## Layers

```
features/ (Flutter screens, Riverpod)
   │ reads providers in app/providers.dart
   ▼
data/repositories/  ──►  data/db (Drift + SQLite, triggers)
   │                        ▲
   ▼                        │ outbox
domain/ (pure Dart: money, posting engine, access)     data/sync ──► Firestore
```

* `domain/` has no Flutter or database imports and holds the accounting
  rules. It is the most heavily tested code.
* Repositories own every write and run each mutation, its audit event and
  its outbox entry in **one SQLite transaction**.
* Screens never write to the database directly.
* State management: Riverpod 3 (`Provider`, `StreamProvider`, `Notifier`),
  with Drift streams so screens update when the ledger changes.

## Accounting model

### Funds, accounts, lines

Every transaction is a list of **lines**: `(account, fund, signed amount,
person?, counterFund?)`. Debits are positive, credits negative, amounts in
integer poisha.

* **Storage accounts** (asset): cash, banks, mobile wallets — *where*.
* **Funds**: personal (one per household), entrusted (someone's savings),
  purpose (money given for a reason), samity (a pool you manage) — *whose*.
* **Categories** (income/expense accounts) — *why*.
* **System accounts**: loans receivable, advances receivable, loans payable,
  fund deposits (capital), opening balance, inter-fund dues, external samity
  savings, reconciliation difference.

### Invariants

1. Lines of a committed entry sum to zero. *(engine, SQLite trigger, sync import, restore)*
2. Lines sum to zero **per fund** — money can change owner only through an
   explicit entry. *(same places)*
3. Posted entries and their lines are never updated or deleted; only the
   reversal link may be added once. *(SQLite triggers, Firestore rules)*
4. Amounts are integers; user input is parsed straight to poisha and more
   than two decimals is rejected, never rounded.
5. Incomplete input is never "completed" by guessing: the engine returns
   field errors and the UI offers a draft. Drafts and pending entries do not
   affect balances.

### Templates (TxType → lines)

| Type | Lines (fund F, amount A) |
| --- | --- |
| income | Dr to-account / Cr income category |
| expense | Dr expense category / Cr from-account |
| transfer | Dr to / Cr from (+ optional fee: Dr bank charges / Cr from) |
| fundDeposit | Dr to / Cr fund deposits (person) — F must not be personal |
| fundWithdrawal | Dr fund deposits (person) / Cr from |
| loanGiven / loanRepaymentReceived | Dr/Cr loans receivable (person) against storage |
| loanTaken / loanRepaymentPaid | Cr/Dr loans payable (person) against storage |
| advancePaid / reimbursementReceived | Dr/Cr advances receivable (person) against storage |
| samityContribution (managed) | Dr account / Cr fund deposits (member) in the samity fund |
| samityContribution (external) | Dr external savings / Cr from |
| interFundLoan / interFundRepayment | storage moves between funds F→G, balanced by inter-fund due lines in both funds |
| openingBalance | Dr account / Cr opening balance |
| adjustment | Dr/Cr account against reconciliation difference (reason required) |
| reversal | exact negation of the original lines |

### Derived figures

* Account balance = sum of its lines; per-fund breakdown groups by fund.
* Fund net = sum over asset + liability lines of that fund.
* *Personal net* = personal fund net (cash + receivables + external savings −
  payables − dues to other funds). *Held for others* = non-personal funds.
* Income/expense reports read only category accounts, so transfers, loans,
  deposits and inter-fund moves can never be double counted.
* `domain/ledger/balances.dart` is a reference implementation used by tests
  to cross-check the SQL in `ReportsRepository`.

## Local database

Drift over SQLite, schema v1, frozen in `drift_schemas/`. Dates are integer
`yyyymmdd` keys; `sort_key` (µs) orders entries within a day. Indexes cover
status/date, account+fund, fund, person, obligation, samity and sync state.
History uses keyset pagination, so large ledgers never load fully.

Triggers (`IntegrityTriggers`): insert as `staging` first; balanced
(overall + per fund) when moving to pending/posted; posted immutable;
cancelled final; committed rows undeletable; lines of committed entries
locked; audit log append-only.

Audit log: every event stores `hash = sha256(prevHash + event)`; tampering
is detected by `AuditLog.verifyChain()` and shown in Settings.

## Sync

* **Outbox**: one row per changed entity (not a payload); the latest local
  state is uploaded. Rows are deleted only after a Firestore *transaction*
  commits (server confirmation). Failures back off exponentially
  (2^n s, max 1 h, jitter); conflicts are parked, never dropped.
* **Idempotency**: client-generated UUIDs + content hash. A lost
  acknowledgement or duplicate delivery results in `alreadyPresent`.
* **Ledger entries are never last-write-wins** (`decideTxWrite`): content
  must match; status only moves forward (pending → posted/cancelled); a
  reversal link is set once; posted-vs-cancelled or two different reversals
  are conflicts for a human. Only a still-pending entry may be replaced by a
  newer version of itself.
* **Master data** (names, accounts, funds…) uses versions: newer wins, equal
  version with different content is a conflict; local unsynced edits are
  never overwritten by a pull.
* **Pull** re-validates every incoming entry (balance + hash) before writing
  it; invalid documents are rejected and audited.
* Both the Firestore store and the test fake call the same decision
  functions, so tested semantics equal shipped semantics.

## Security model

* Firestore rules are the boundary; UI checks are convenience.
* Each document carries `readerUids` (owner, admins with `readAll`, members
  allowed for **all** funds the document touches). Members must query with
  `readerUids array-contains uid`; any other read is denied. Membership is
  re-checked on every read, so revocation is immediate.
* Admins only have explicitly delegated permissions; members are read-only.
* Invitations are single-use, expire within 15 days, bound to a verified
  email, and the joining member must copy the invite's grants exactly.
* Reports are generated from the local database, which for a member device
  only contains what the server let it read; repositories additionally
  apply the actor's fund scope.
* No service-account keys or secrets in the app. Firebase client config is
  not secret; App Check (Play Integrity) is activated when Firebase is
  configured and should be enforced in the console.

### Known limitations

* The local SQLite file is not encrypted (no SQLCipher). Device security
  relies on Android app sandboxing plus the optional app lock, which is a
  screen lock, not encryption.
* Master-data edits on two devices are versioned, not field-merged.
* Receipt attachments are stored only on the device; Storage rules deny all.
* Changing a member's funds re-stamps `readerUids` by re-uploading the
  owner's documents (fine for household scale, not for large ledgers).

## PDF and Bengali text

The `pdf` package does not apply OpenType shaping, so Bengali drawn as
vector text is wrong (pre-base vowel signs, conjuncts, split vowels). Runs
containing Bengali letters are laid out by Flutter's text engine (HarfBuzz)
and embedded as 288-dpi images (`PdfTextKit`); Latin text, digits (ASCII and
Bengali) and ৳ remain selectable vector text in the embedded Hind Siliguri
font. Verified by rendering pages to PNG and comparing both approaches.
