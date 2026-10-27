/// Household roles and permissions.
///
/// The same model is enforced server-side by `firestore.rules`; the client
/// copy exists for UX (hiding actions the user cannot perform) and for
/// filtering locally generated reports. Client checks are never the security
/// boundary.
library;

enum HouseholdRole { owner, admin, member }

enum Permission {
  /// Create and post transactions.
  writeTransactions,

  /// Reverse posted transactions.
  reverseTransactions,

  /// Create/edit people, funds, accounts, samities and budgets.
  manageMasterData,

  /// Invite, change and revoke members.
  manageMembers,

  /// Approve reconciliation adjustments.
  approveAdjustments,

  /// Read every fund in the household.
  readAll,
}

class ActorContext {
  const ActorContext({
    required this.actorId,
    required this.role,
    this.delegated = const {},
    this.allowedFundIds,
  });

  /// The single-device owner before any cloud account exists.
  static const localOwner = ActorContext(
    actorId: 'local-owner',
    role: HouseholdRole.owner,
  );

  final String actorId;
  final HouseholdRole role;

  /// Permissions explicitly delegated to an administrator.
  final Set<Permission> delegated;

  /// Funds a member may read. `null` means every fund (owner, or an admin
  /// with [Permission.readAll]).
  final Set<String>? allowedFundIds;

  bool can(Permission p) => switch (role) {
    HouseholdRole.owner => true,
    HouseholdRole.admin => delegated.contains(p),
    // Members are read-only, restricted to their funds.
    HouseholdRole.member => false,
  };

  /// Effective fund filter for reports and statements.
  Set<String>? get fundScope {
    if (role == HouseholdRole.owner) return null;
    if (role == HouseholdRole.admin && delegated.contains(Permission.readAll)) {
      return null;
    }
    return allowedFundIds ?? const {};
  }

  bool canReadFund(String fundId) {
    final scope = fundScope;
    return scope == null || scope.contains(fundId);
  }
}

class PermissionDenied implements Exception {
  PermissionDenied(this.permission);
  final Permission permission;
  @override
  String toString() => 'PermissionDenied(${permission.name})';
}

extension ActorGuard on ActorContext {
  void require(Permission p) {
    if (!can(p)) throw PermissionDenied(p);
  }
}
