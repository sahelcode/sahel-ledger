// Firestore security rules tests. Run with `npm test` (starts the emulator).
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, test } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  query,
  serverTimestamp,
  setDoc,
  Timestamp,
  updateDoc,
  where,
  writeBatch,
} from 'firebase/firestore';

const HID = 'h1';
const OWNER = 'owner';
const ADMIN = 'admin';
const MEMBER = 'ruma';
const STRANGER = 'stranger';
const SISTER_FUND = 'f-sister';
const PERSONAL_FUND = 'f-personal';

let env;

const ctx = (uid, email, verified = true) =>
  env.authenticatedContext(uid, email ? { email, email_verified: verified } : {}).firestore();

function txDoc(id, overrides = {}) {
  return {
    id,
    type: 'income',
    status: 'posted',
    dateKey: 20261001,
    amount: 10000,
    currency: 'BDT',
    lines: [
      { accountId: 'acct-cash', fundId: PERSONAL_FUND, amount: 10000 },
      { accountId: 'cat.inc.salary', fundId: PERSONAL_FUND, amount: -10000 },
    ],
    fundIds: [PERSONAL_FUND],
    totalDebit: 10000,
    totalCredit: 10000,
    contentHash: 'a'.repeat(64),
    version: 1,
    createdBy: OWNER,
    modifiedBy: OWNER,
    readerUids: [OWNER],
    updatedAtServer: serverTimestamp(),
    ...overrides,
  };
}

async function seed() {
  await env.withSecurityRulesDisabled(async (c) => {
    const db = c.firestore();
    await setDoc(doc(db, `households/${HID}`), { name: 'Sahel family', ownerUid: OWNER, createdAt: 1 });
    const m = (role, extra = {}) => ({
      role,
      perms: [],
      fundIds: [],
      personIds: [],
      status: 'active',
      ...extra,
    });
    await setDoc(doc(db, `households/${HID}/members/${OWNER}`), m('owner'));
    await setDoc(
      doc(db, `households/${HID}/members/${ADMIN}`),
      m('admin', { perms: ['writeTransactions', 'readAll'] }),
    );
    await setDoc(
      doc(db, `households/${HID}/members/${MEMBER}`),
      m('member', { fundIds: [SISTER_FUND], personIds: ['p-ruma'] }),
    );
    await setDoc(doc(db, `households/${HID}/transactions/t-personal`), {
      ...txDoc('t-personal'),
      updatedAtServer: Timestamp.now(),
    });
    await setDoc(doc(db, `households/${HID}/transactions/t-sister`), {
      ...txDoc('t-sister', {
        type: 'fundDeposit',
        fundIds: [SISTER_FUND],
        readerUids: [OWNER, ADMIN, MEMBER],
      }),
      updatedAtServer: Timestamp.now(),
    });
    await setDoc(doc(db, `households/${HID}/transactions/t-pending`), {
      ...txDoc('t-pending', { status: 'pending' }),
      updatedAtServer: Timestamp.now(),
    });
  });
}

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-sahel-ledger',
    firestore: {
      rules: readFileSync(new URL('../../../firestore.rules', import.meta.url), 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});

beforeEach(async () => {
  await env.clearFirestore();
  await seed();
});

after(async () => {
  await env.cleanup();
});

describe('households', () => {
  test('a new user can create a household and become its owner', async () => {
    const db = ctx('newbie');
    const b = writeBatch(db);
    b.set(doc(db, 'households/h2'), { name: 'Mine', ownerUid: 'newbie', createdAt: 1 });
    b.set(doc(db, 'households/h2/members/newbie'), {
      role: 'owner', perms: [], fundIds: [], personIds: [], status: 'active',
    });
    await assertSucceeds(b.commit());
  });

  test('nobody can claim ownership of an existing household', async () => {
    const db = ctx(STRANGER);
    await assertFails(setDoc(doc(db, `households/${HID}/members/${STRANGER}`), {
      role: 'owner', perms: [], fundIds: [], personIds: [], status: 'active',
    }));
  });

  test('strangers cannot read anything by guessing ids', async () => {
    const db = ctx(STRANGER);
    await assertFails(getDoc(doc(db, `households/${HID}`)));
    await assertFails(getDoc(doc(db, `households/${HID}/transactions/t-sister`)));
    await assertFails(getDocs(collection(db, `households/${HID}/transactions`)));
  });

  test('unauthenticated access is denied', async () => {
    const db = env.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, `households/${HID}/transactions/t-personal`)));
  });
});

describe('transactions', () => {
  test('owner can write a balanced entry stamped with server time', async () => {
    await assertSucceeds(setDoc(doc(ctx(OWNER), `households/${HID}/transactions/t1`), txDoc('t1')));
  });

  test('unbalanced entries are rejected', async () => {
    await assertFails(setDoc(
      doc(ctx(OWNER), `households/${HID}/transactions/t1`),
      txDoc('t1', { totalCredit: 9999 }),
    ));
    await assertFails(setDoc(
      doc(ctx(OWNER), `households/${HID}/transactions/t1`),
      txDoc('t1', { totalDebit: 0, totalCredit: 0 }),
    ));
    await assertFails(setDoc(
      doc(ctx(OWNER), `households/${HID}/transactions/t1`),
      txDoc('t1', { lines: [{ accountId: 'x', fundId: 'f', amount: 1 }] }),
    ));
  });

  test('client-chosen timestamps and mismatched ids are rejected', async () => {
    await assertFails(setDoc(
      doc(ctx(OWNER), `households/${HID}/transactions/t1`),
      txDoc('t1', { updatedAtServer: Timestamp.fromMillis(0) }),
    ));
    await assertFails(setDoc(doc(ctx(OWNER), `households/${HID}/transactions/t1`), txDoc('t2')));
  });

  test('cannot create entries on behalf of someone else', async () => {
    await assertFails(setDoc(
      doc(ctx(ADMIN), `households/${HID}/transactions/t1`),
      txDoc('t1', { createdBy: OWNER }),
    ));
    await assertSucceeds(setDoc(
      doc(ctx(ADMIN), `households/${HID}/transactions/t1`),
      txDoc('t1', { createdBy: ADMIN }),
    ));
  });

  test('posted financial content is immutable', async () => {
    const ref = doc(ctx(OWNER), `households/${HID}/transactions/t-personal`);
    await assertFails(updateDoc(ref, { amount: 1, updatedAtServer: serverTimestamp() }));
    await assertFails(updateDoc(ref, {
      lines: [
        { accountId: 'acct-cash', fundId: PERSONAL_FUND, amount: 1 },
        { accountId: 'cat.inc.salary', fundId: PERSONAL_FUND, amount: -1 },
      ],
      totalDebit: 1,
      totalCredit: 1,
      updatedAtServer: serverTimestamp(),
    }));
    await assertFails(updateDoc(ref, { status: 'pending', updatedAtServer: serverTimestamp() }));
  });

  test('posted entries can never be deleted', async () => {
    await assertFails(deleteDoc(doc(ctx(OWNER), `households/${HID}/transactions/t-personal`)));
  });

  test('a reversal link is added once by someone allowed to reverse', async () => {
    const ref = doc(ctx(OWNER), `households/${HID}/transactions/t-personal`);
    await assertSucceeds(updateDoc(ref, {
      reversedByTxId: 'r1', version: 2, updatedAtServer: serverTimestamp(),
    }));
    await assertFails(updateDoc(ref, {
      reversedByTxId: 'r2', version: 3, updatedAtServer: serverTimestamp(),
    }));
    const adminRef = doc(ctx(ADMIN), `households/${HID}/transactions/t-sister`);
    await assertFails(updateDoc(adminRef, {
      reversedByTxId: 'r3', version: 2, updatedAtServer: serverTimestamp(),
    }));
  });

  test('pending can be posted or cancelled, posted cannot be cancelled', async () => {
    const pending = doc(ctx(OWNER), `households/${HID}/transactions/t-pending`);
    await assertSucceeds(updateDoc(pending, {
      status: 'posted', version: 2, updatedAtServer: serverTimestamp(),
    }));
    const posted = doc(ctx(OWNER), `households/${HID}/transactions/t-personal`);
    await assertFails(updateDoc(posted, {
      status: 'cancelled', version: 2, updatedAtServer: serverTimestamp(),
    }));
  });

  test('members are read-only', async () => {
    await assertFails(setDoc(
      doc(ctx(MEMBER), `households/${HID}/transactions/t1`),
      txDoc('t1', { createdBy: MEMBER }),
    ));
  });

  test('admins need the delegated permission to write', async () => {
    await env.withSecurityRulesDisabled(async (c) => {
      await updateDoc(doc(c.firestore(), `households/${HID}/members/${ADMIN}`), { perms: ['readAll'] });
    });
    await assertFails(setDoc(
      doc(ctx(ADMIN), `households/${HID}/transactions/t1`),
      txDoc('t1', { createdBy: ADMIN }),
    ));
  });
});

describe('member privacy', () => {
  test('a member reads only entries listing them as reader', async () => {
    const db = ctx(MEMBER);
    await assertSucceeds(getDoc(doc(db, `households/${HID}/transactions/t-sister`)));
    await assertFails(getDoc(doc(db, `households/${HID}/transactions/t-personal`)));
  });

  test('a member query must be filtered to their own documents', async () => {
    const db = ctx(MEMBER);
    const col = collection(db, `households/${HID}/transactions`);
    await assertFails(getDocs(col));
    await assertFails(getDocs(query(col, where('fundIds', 'array-contains', PERSONAL_FUND))));
    const mine = await assertSucceeds(getDocs(query(col, where('readerUids', 'array-contains', MEMBER))));
    if (mine.size !== 1) throw new Error(`expected 1 doc, got ${mine.size}`);
  });

  test('a member cannot read other members or grant themselves funds', async () => {
    const db = ctx(MEMBER);
    await assertFails(getDoc(doc(db, `households/${HID}/members/${ADMIN}`)));
    await assertSucceeds(getDoc(doc(db, `households/${HID}/members/${MEMBER}`)));
    await assertFails(updateDoc(doc(db, `households/${HID}/members/${MEMBER}`), {
      fundIds: [SISTER_FUND, PERSONAL_FUND],
    }));
    await assertFails(updateDoc(doc(db, `households/${HID}/members/${MEMBER}`), { role: 'owner' }));
  });

  test('a revoked member immediately loses access', async () => {
    await assertSucceeds(deleteDoc(doc(ctx(OWNER), `households/${HID}/members/${MEMBER}`)));
    await assertFails(getDoc(doc(ctx(MEMBER), `households/${HID}/transactions/t-sister`)));
  });

  test('a suspended (revoked status) member loses access', async () => {
    await assertSucceeds(updateDoc(doc(ctx(OWNER), `households/${HID}/members/${MEMBER}`), {
      status: 'revoked',
    }));
    await assertFails(getDoc(doc(ctx(MEMBER), `households/${HID}/transactions/t-sister`)));
  });

  test('the owner cannot be removed or demoted', async () => {
    await assertFails(deleteDoc(doc(ctx(ADMIN), `households/${HID}/members/${OWNER}`)));
    await assertFails(updateDoc(doc(ctx(OWNER), `households/${HID}/members/${OWNER}`), { role: 'member' }));
  });

  test('admins cannot promote anyone to admin', async () => {
    await env.withSecurityRulesDisabled(async (c) => {
      await updateDoc(doc(c.firestore(), `households/${HID}/members/${ADMIN}`), {
        perms: ['manageMembers', 'readAll'],
      });
    });
    await assertFails(updateDoc(doc(ctx(ADMIN), `households/${HID}/members/${MEMBER}`), {
      role: 'admin', perms: ['readAll'],
    }));
    await assertSucceeds(updateDoc(doc(ctx(ADMIN), `households/${HID}/members/${MEMBER}`), {
      fundIds: [],
    }));
  });
});

describe('invitations', () => {
  const CODE = 'abcdefghijklmnop1234';
  const invite = (overrides = {}) => ({
    householdId: HID,
    email: 'jui@example.com',
    role: 'member',
    perms: [],
    fundIds: [SISTER_FUND],
    personIds: [],
    createdBy: OWNER,
    createdAt: serverTimestamp(),
    expiresAt: Timestamp.fromMillis(Date.now() + 3 * 24 * 3600 * 1000),
    usedBy: null,
    ...overrides,
  });

  const joinBatch = (db, uid, memberOverrides = {}) => {
    const b = writeBatch(db);
    b.set(doc(db, `households/${HID}/members/${uid}`), {
      role: 'member',
      perms: [],
      fundIds: [SISTER_FUND],
      personIds: [],
      status: 'active',
      inviteCode: CODE,
      ...memberOverrides,
    });
    b.update(doc(db, `invites/${CODE}`), { usedBy: uid, usedAt: serverTimestamp() });
    return b.commit();
  };

  beforeEach(async () => {
    await assertSucceeds(setDoc(doc(ctx(OWNER), `invites/${CODE}`), invite()));
  });

  test('only managers can invite; only the owner can invite admins', async () => {
    await assertFails(setDoc(doc(ctx(MEMBER), 'invites/zzzzzzzzzzzzzzzzzzzz'), invite({ createdBy: MEMBER })));
    await assertFails(setDoc(doc(ctx(OWNER), 'invites/short'), invite()));
    await assertFails(setDoc(
      doc(ctx(OWNER), 'invites/yyyyyyyyyyyyyyyyyyyy'),
      invite({ expiresAt: Timestamp.fromMillis(Date.now() + 60 * 24 * 3600 * 1000) }),
    ));
  });

  test('the invited, verified email joins with exactly the granted access', async () => {
    await assertSucceeds(joinBatch(ctx('jui', 'jui@example.com'), 'jui'));
    await assertSucceeds(getDoc(doc(ctx('jui', 'jui@example.com'), `households/${HID}/members/jui`)));
  });

  test('joining with escalated access is denied', async () => {
    await assertFails(joinBatch(ctx('jui', 'jui@example.com'), 'jui', { role: 'admin' }));
    await assertFails(joinBatch(ctx('jui', 'jui@example.com'), 'jui', { fundIds: [SISTER_FUND, PERSONAL_FUND] }));
    await assertFails(joinBatch(ctx('jui', 'jui@example.com'), 'jui', { perms: ['readAll'] }));
  });

  test('wrong or unverified email cannot use the invite', async () => {
    await assertFails(joinBatch(ctx('mallory', 'mallory@example.com'), 'mallory'));
    await assertFails(joinBatch(ctx('jui', 'jui@example.com', false), 'jui'));
  });

  test('an invite works only once', async () => {
    await assertSucceeds(joinBatch(ctx('jui', 'jui@example.com'), 'jui'));
    await assertFails(joinBatch(ctx('jui2', 'jui@example.com'), 'jui2'));
  });

  test('expired invites are refused', async () => {
    await env.withSecurityRulesDisabled(async (c) => {
      await updateDoc(doc(c.firestore(), `invites/${CODE}`), { expiresAt: Timestamp.fromMillis(Date.now() - 1000) });
    });
    await assertFails(joinBatch(ctx('jui', 'jui@example.com'), 'jui'));
  });
});

describe('master data and audit', () => {
  const entity = (id, extra = {}) => ({
    id, version: 1, readerUids: [OWNER], updatedAtServer: serverTimestamp(), ...extra,
  });

  test('full account numbers cannot be stored', async () => {
    const db = ctx(OWNER);
    await assertSucceeds(setDoc(doc(db, `households/${HID}/accounts/a1`), entity('a1', { numberHint: '7890' })));
    await assertFails(setDoc(
      doc(db, `households/${HID}/accounts/a2`),
      entity('a2', { numberHint: '1234567890' }),
    ));
  });

  test('versions cannot go backwards', async () => {
    const db = ctx(OWNER);
    await assertSucceeds(setDoc(doc(db, `households/${HID}/persons/p1`), entity('p1', { version: 3 })));
    await assertFails(setDoc(doc(db, `households/${HID}/persons/p1`), entity('p1', { version: 2 })));
  });

  test('only approvers can approve reconciliation adjustments', async () => {
    await env.withSecurityRulesDisabled(async (c) => {
      await updateDoc(doc(c.firestore(), `households/${HID}/members/${ADMIN}`), {
        perms: ['writeTransactions', 'readAll'],
      });
    });
    const adminDb = ctx(ADMIN);
    await assertSucceeds(setDoc(doc(adminDb, `households/${HID}/recon/r1`), entity('r1', { approvedBy: null })));
    await assertFails(setDoc(doc(adminDb, `households/${HID}/recon/r1`), entity('r1', { approvedBy: ADMIN })));
    await assertSucceeds(setDoc(doc(ctx(OWNER), `households/${HID}/recon/r1`), entity('r1', { approvedBy: OWNER })));
  });

  test('audit events are append-only', async () => {
    const db = ctx(OWNER);
    await assertSucceeds(setDoc(doc(db, `households/${HID}/audit/e1`), { actorId: OWNER, action: 'posted' }));
    await assertFails(updateDoc(doc(db, `households/${HID}/audit/e1`), { action: 'nothing' }));
    await assertFails(deleteDoc(doc(db, `households/${HID}/audit/e1`)));
    await assertFails(setDoc(doc(db, `households/${HID}/audit/e2`), { actorId: 'someone-else' }));
    await assertFails(getDoc(doc(ctx(MEMBER), `households/${HID}/audit/e1`)));
  });

  test('member sees only funds listing them', async () => {
    await env.withSecurityRulesDisabled(async (c) => {
      const db = c.firestore();
      await setDoc(doc(db, `households/${HID}/funds/${SISTER_FUND}`), { id: SISTER_FUND, readerUids: [OWNER, MEMBER] });
      await setDoc(doc(db, `households/${HID}/funds/${PERSONAL_FUND}`), { id: PERSONAL_FUND, readerUids: [OWNER] });
    });
    await assertSucceeds(getDoc(doc(ctx(MEMBER), `households/${HID}/funds/${SISTER_FUND}`)));
    await assertFails(getDoc(doc(ctx(MEMBER), `households/${HID}/funds/${PERSONAL_FUND}`)));
  });
});
