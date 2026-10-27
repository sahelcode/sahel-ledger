import '../../domain/access/access.dart';

/// A household member as stored in `households/{hid}/members/{uid}`.
class MemberInfo {
  const MemberInfo({
    required this.uid,
    required this.role,
    this.delegated = const {},
    this.fundIds = const {},
    this.personIds = const {},
    this.displayName,
    this.email,
    this.active = true,
  });

  final String uid;
  final HouseholdRole role;
  final Set<Permission> delegated;
  final Set<String> fundIds;
  final Set<String> personIds;
  final String? displayName;
  final String? email;
  final bool active;

  bool get readsAll =>
      role == HouseholdRole.owner ||
      (role == HouseholdRole.admin && delegated.contains(Permission.readAll));

  ActorContext toActor() => ActorContext(
    actorId: uid,
    role: role,
    delegated: delegated,
    allowedFundIds: readsAll ? null : fundIds,
  );

  Map<String, Object?> toJson() => {
    'role': role.name,
    'perms': [for (final p in delegated) p.name],
    'fundIds': fundIds.toList()..sort(),
    'personIds': personIds.toList()..sort(),
    'displayName': displayName,
    'email': email,
    'status': active ? 'active' : 'revoked',
  };

  static MemberInfo fromJson(String uid, Map<String, Object?> j) => MemberInfo(
    uid: uid,
    role: HouseholdRole.values.byName(j['role'] as String? ?? 'member'),
    delegated: {
      for (final p in (j['perms'] as List? ?? const []))
        if (Permission.values.any((x) => x.name == p))
          Permission.values.byName(p as String),
    },
    fundIds: {for (final f in (j['fundIds'] as List? ?? const [])) f as String},
    personIds: {
      for (final f in (j['personIds'] as List? ?? const [])) f as String,
    },
    displayName: j['displayName'] as String?,
    email: j['email'] as String?,
    active: (j['status'] as String? ?? 'active') == 'active',
  );
}

/// Computes which members may read a document. The result is stored as
/// `readerUids` on every synced document and checked by security rules, so
/// a member's queries can only ever return documents listing their uid.
class HouseholdDirectory {
  HouseholdDirectory(this.members);

  final List<MemberInfo> members;

  /// Readers of something touching all of [fundIds]: full readers plus
  /// members permitted for *every* one of those funds.
  List<String> readersForFunds(Set<String> fundIds) {
    final out = <String>{};
    for (final m in members.where((m) => m.active)) {
      if (m.readsAll ||
          (fundIds.isNotEmpty && m.fundIds.containsAll(fundIds))) {
        out.add(m.uid);
      }
    }
    return out.toList()..sort();
  }

  /// Readers of a person record: full readers, the member linked to that
  /// person, and members who can see a fund the person owns or contributes to.
  List<String> readersForPerson(String personId, Set<String> relatedFundIds) {
    final out = <String>{};
    for (final m in members.where((m) => m.active)) {
      if (m.readsAll ||
          m.personIds.contains(personId) ||
          m.fundIds.any(relatedFundIds.contains)) {
        out.add(m.uid);
      }
    }
    return out.toList()..sort();
  }

  /// Everyone active (account names and categories are shared labels).
  List<String> allReaders() =>
      [for (final m in members.where((m) => m.active)) m.uid]..sort();
}
