# Firebase setup

The app works fully offline without Firebase. These steps enable cloud
sync, households and invitations. Nothing here was run against a real
project from the build environment (no credentials were available); the
rules were tested on the Firestore emulator.

## 1. Projects

Create two projects so testing never touches real family data, e.g.
`sahel-ledger-dev` and `sahel-ledger-prod`. Firestore location: an Asian
region close to Bangladesh (e.g. `asia-south1`, Mumbai). The location
cannot be changed later.

## 2. Services

1. **Authentication → Sign-in method:** enable *Email/Password*. Under
   *Templates*, set the sender name; verification and password-reset emails
   are used by the app.
2. **Firestore Database:** create in production mode.
3. **App Check:** register the Android app with *Play Integrity*. After
   release builds report valid tokens, click **Enforce** for Firestore.
   For debug builds, add the debug token printed in logcat.
4. Storage is not used yet (attachments stay on device); its rules deny all.

## 3. Connect the app

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=sahel-ledger-dev --platforms=android,ios \
  --android-package-name=com.sahelcode.sahel_ledger
```

This overwrites the placeholder `lib/firebase_options.dart`. The generated
values are client identifiers, not secrets, but keep separate files per
environment if you build dev and prod from the same tree.

## 4. Deploy rules and indexes

```bash
npm i -g firebase-tools
firebase login
firebase use sahel-ledger-dev
cd firebase/rules-tests && npm ci && npm test && cd ../..   # must pass first
firebase deploy --only firestore:rules,firestore:indexes,storage
```

Deploying rules replaces existing rules. If the project already holds data
from another app, review it before deploying.

## 5. First use

1. In the app: *More → Household & members → Create account*, verify the
   email, then *Create household*. Data recorded before signing in is
   uploaded automatically.
2. Invite a family member: enter their email, choose *Member* and the funds
   they may see. Share the 20-character code privately. They create an
   account with that email, verify it, and *Join with invite code*.
3. Revoke access from the same screen; it takes effect immediately.

## Data model

```
households/{hid}                    name, ownerUid
households/{hid}/members/{uid}      role, perms[], fundIds[], personIds[], status
households/{hid}/transactions/{id}  entry + lines[], fundIds[], readerUids[], contentHash
households/{hid}/{persons|funds|accounts|obligations|samities|budgets|recon}/{id}
households/{hid}/audit/{id}         append-only
invites/{code}                      householdId, email, role, grants, expiresAt, usedBy
```

All monetary values are integers (poisha).
