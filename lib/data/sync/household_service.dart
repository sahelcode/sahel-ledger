import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/access/access.dart';
import '../db/database.dart';
import '../repositories/outbox_repository.dart';
import 'household_directory.dart';

class InviteInfo {
  const InviteInfo(
    this.code,
    this.householdId,
    this.role,
    this.email,
    this.expiresAt,
  );
  final String code;
  final String householdId;
  final HouseholdRole role;
  final String email;
  final DateTime expiresAt;
}

/// Household membership in Firestore. Every operation here is also
/// enforced by `firestore.rules`; this class only shapes valid requests.
class HouseholdService {
  HouseholdService(this.firestore, this.db);

  final FirebaseFirestore firestore;
  final AppDatabase db;

  DocumentReference<Map<String, dynamic>> _household(String hid) =>
      firestore.collection('households').doc(hid);

  /// Creates a household owned by [uid] and remembers it locally.
  Future<String> createHousehold({
    required String uid,
    required String name,
    String? displayName,
    String? email,
  }) async {
    final ref = firestore.collection('households').doc();
    final batch = firestore.batch()
      ..set(ref, {
        'name': name,
        'ownerUid': uid,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      })
      ..set(ref.collection('members').doc(uid), {
        ...MemberInfo(
          uid: uid,
          role: HouseholdRole.owner,
          displayName: displayName,
          email: email,
        ).toJson(),
        'joinedAt': FieldValue.serverTimestamp(),
      });
    await batch.commit();
    await db.setKv(Kv.householdId, ref.id);
    await db.setKv(Kv.actorId, uid);
    // Upload everything recorded before the household existed.
    await requeueAll();
    return ref.id;
  }

  /// Households where [uid] is a member (by looking up the local id).
  Future<MemberInfo?> membership(String hid, String uid) async {
    final snap = await _household(hid).collection('members').doc(uid).get();
    if (!snap.exists) return null;
    return MemberInfo.fromJson(uid, snap.data()!);
  }

  Future<HouseholdDirectory> directory(String hid, MemberInfo viewer) async {
    if (!viewer.readsAll &&
        !viewer.delegated.contains(Permission.manageMembers)) {
      // Members may only read their own membership document.
      return HouseholdDirectory([viewer]);
    }
    final snap = await _household(hid).collection('members').get();
    return HouseholdDirectory([
      for (final d in snap.docs) MemberInfo.fromJson(d.id, d.data()),
    ]);
  }

  static String _code() {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(
      20,
      (_) => alphabet[r.nextInt(alphabet.length)],
    ).join();
  }

  /// Creates a single-use invitation valid for 7 days, bound to [email].
  Future<InviteInfo> createInvite({
    required String hid,
    required String createdBy,
    required String email,
    required HouseholdRole role,
    Set<Permission> perms = const {},
    Set<String> fundIds = const {},
    Set<String> personIds = const {},
  }) async {
    assert(role != HouseholdRole.owner);
    final code = _code();
    final expires = DateTime.now().add(const Duration(days: 7));
    await firestore.collection('invites').doc(code).set({
      'householdId': hid,
      'email': email.trim().toLowerCase(),
      'role': role.name,
      'perms': [for (final p in perms) p.name]..sort(),
      'fundIds': fundIds.toList()..sort(),
      'personIds': personIds.toList()..sort(),
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expires),
      'usedBy': null,
    });
    return InviteInfo(code, hid, role, email, expires);
  }

  /// Joins a household with an invitation code. The signed-in account's
  /// verified email must match the invitation.
  Future<String> acceptInvite({
    required String code,
    required String uid,
    String? displayName,
  }) async {
    final inviteRef = firestore
        .collection('invites')
        .doc(code.trim().toUpperCase());
    final inv = await inviteRef.get();
    if (!inv.exists) throw StateError('invite_not_found');
    final d = inv.data()!;
    final hid = d['householdId'] as String;
    final batch = firestore.batch()
      ..set(_household(hid).collection('members').doc(uid), {
        'role': d['role'],
        'perms': d['perms'],
        'fundIds': d['fundIds'],
        'personIds': d['personIds'],
        'displayName': displayName,
        'email': d['email'],
        'status': 'active',
        'inviteCode': inviteRef.id,
        'joinedAt': FieldValue.serverTimestamp(),
      })
      ..update(inviteRef, {
        'usedBy': uid,
        'usedAt': FieldValue.serverTimestamp(),
      });
    await batch.commit();
    await db.setKv(Kv.householdId, hid);
    await db.setKv(Kv.actorId, uid);
    return hid;
  }

  Future<void> updateMember(String hid, MemberInfo m) async {
    await _household(hid).collection('members').doc(m.uid).update(m.toJson());
    // Readers are denormalised onto documents: recompute them.
    await requeueAll();
  }

  /// Removes a member. Access ends immediately (rules check membership on
  /// every read); documents are then re-stamped without their uid.
  Future<void> revokeMember(String hid, String uid) async {
    await _household(hid).collection('members').doc(uid).delete();
    await requeueAll();
  }

  Future<void> requeueAll() async {
    final outbox = OutboxRepository(db);
    await db.transaction(() async {
      for (final p in await db.select(db.persons).get()) {
        await outbox.enqueue('person', p.id);
      }
      for (final f in await db.select(db.funds).get()) {
        await outbox.enqueue('fund', f.id);
      }
      for (final a in await db.select(db.ledgerAccounts).get()) {
        if (!a.isSystem) await outbox.enqueue('account', a.id);
      }
      for (final o in await db.select(db.obligations).get()) {
        await outbox.enqueue('obligation', o.id);
      }
      for (final s in await db.select(db.samities).get()) {
        await outbox.enqueue('samity', s.id);
      }
      for (final b in await db.select(db.budgets).get()) {
        await outbox.enqueue('budget', b.id);
      }
      for (final t in await db.select(db.ledgerTransactions).get()) {
        await outbox.enqueue('tx', t.id);
      }
      for (final r in await db.select(db.reconSessions).get()) {
        await outbox.enqueue('recon', r.id);
      }
    });
  }
}
