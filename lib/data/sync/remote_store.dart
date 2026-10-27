/// Cloud storage abstraction used by the sync engine.
///
/// Implemented by `FirestoreRemoteStore` in production and by an in-memory
/// fake in tests. Both use [decideTxWrite] / [decideEntityWrite], so the
/// conflict semantics under test are exactly the ones shipped.
library;

/// The server could not be reached or timed out: retry later.
class RemoteUnavailable implements Exception {
  RemoteUnavailable(this.message);
  final String message;
  @override
  String toString() => 'RemoteUnavailable($message)';
}

/// The server refused the write (security rules). Retrying will not help
/// until permissions change.
class RemoteDenied implements Exception {
  RemoteDenied(this.message);
  final String message;
  @override
  String toString() => 'RemoteDenied($message)';
}

enum WriteOutcome {
  /// The server now holds the local state (newly written or updated).
  written,

  /// The server already held identical content; nothing to do.
  alreadyPresent,

  /// Server and local content diverged; a human must decide.
  conflict,
}

class RemoteWriteResult {
  const RemoteWriteResult(this.outcome, {this.remote});
  final WriteOutcome outcome;

  /// Server copy, provided for conflicts.
  final Map<String, Object?>? remote;
}

class RemoteDoc {
  const RemoteDoc(this.id, this.data, this.updatedAtMs);
  final String id;
  final Map<String, Object?> data;
  final int updatedAtMs;
}

/// Position in a collection's change feed: (server updatedAt, doc id).
class RemoteCursor {
  const RemoteCursor(this.updatedAtMs, this.id);
  final int updatedAtMs;
  final String id;

  String encode() => '$updatedAtMs|$id';
  static RemoteCursor? decode(String? s) {
    if (s == null || !s.contains('|')) return null;
    final i = s.indexOf('|');
    return RemoteCursor(int.parse(s.substring(0, i)), s.substring(i + 1));
  }
}

abstract interface class RemoteStore {
  Future<RemoteWriteResult> putTransaction(
    String householdId,
    Map<String, Object?> doc,
  );

  Future<RemoteWriteResult> putEntity(
    String householdId,
    String collection,
    String id,
    Map<String, Object?> doc,
  );

  /// Documents changed after [after], oldest first.
  Future<List<RemoteDoc>> changes(
    String householdId,
    String collection, {
    RemoteCursor? after,
    required String viewerUid,
    required bool viewerReadsAll,
    int limit = 200,
  });
}

/// Fields of a transaction that may change after it was first committed.
const txMutableFields = {
  'status',
  'reversedByTxId',
  'version',
  'modifiedBy',
  'readerUids',
  'postedAt',
  'updatedAt',
};

enum TxWriteDecision { create, updateMutable, overwrite, noop, conflict }

const _statusRank = {'pending': 0, 'posted': 1, 'cancelled': 1};

/// Decides how to apply a local transaction [local] given the server copy.
///
/// * Immutable financial content (hashed) must match, except that a still
///   pending entry may be replaced by a newer version of itself.
/// * Status only moves forward (pending -> posted/cancelled), and a
///   reversal link can be added once, never changed.
TxWriteDecision decideTxWrite(
  Map<String, Object?>? remote,
  Map<String, Object?> local,
) {
  if (remote == null) return TxWriteDecision.create;
  final rv = (remote['version'] as num?)?.toInt() ?? 0;
  final lv = (local['version'] as num?)?.toInt() ?? 0;
  if (remote['contentHash'] != local['contentHash']) {
    if (remote['status'] == 'pending' &&
        local['status'] != 'cancelled' &&
        lv > rv) {
      return TxWriteDecision.overwrite;
    }
    return TxWriteDecision.conflict;
  }
  final rs = remote['status'] as String?;
  final ls = local['status'] as String?;
  if (rs != ls) {
    final rr = _statusRank[rs] ?? 0, lr = _statusRank[ls] ?? 0;
    // posted vs cancelled: two devices finalised a pending entry differently.
    if (rr == lr) return TxWriteDecision.conflict;
    // Server is ahead: nothing to push, the pull will catch the local copy up.
    if (rr > lr) return TxWriteDecision.noop;
    return TxWriteDecision.updateMutable;
  }
  final rRev = remote['reversedByTxId'], lRev = local['reversedByTxId'];
  if (rRev != null && lRev != null && rRev != lRev) {
    return TxWriteDecision.conflict;
  }
  if (lRev != null && rRev == null) return TxWriteDecision.updateMutable;
  if (!_sameList(remote['readerUids'], local['readerUids'])) {
    return TxWriteDecision.updateMutable;
  }
  return TxWriteDecision.noop;
}

enum EntityWriteDecision { create, update, noop, conflict }

/// Master data uses optimistic versions: a newer local version replaces the
/// server copy; equal versions with different content are a conflict.
EntityWriteDecision decideEntityWrite(
  Map<String, Object?>? remote,
  Map<String, Object?> local, {
  Set<String> ignoreKeys = const {
    'updatedAt',
    'readerUids',
    'syncStatus',
    'updatedAtServer',
  },
}) {
  if (remote == null) return EntityWriteDecision.create;
  final rv = (remote['version'] as num?)?.toInt() ?? 0;
  final lv = (local['version'] as num?)?.toInt() ?? 0;
  if (lv > rv) return EntityWriteDecision.update;
  bool same() {
    for (final k in {...remote.keys, ...local.keys}) {
      if (ignoreKeys.contains(k)) continue;
      if (!_deepEq(remote[k], local[k])) return false;
    }
    return true;
  }

  if (same()) {
    return _sameList(remote['readerUids'], local['readerUids'])
        ? EntityWriteDecision.noop
        : EntityWriteDecision.update;
  }
  return EntityWriteDecision.conflict;
}

bool _sameList(Object? a, Object? b) {
  final la = (a as List?)?.map((e) => '$e').toSet() ?? {};
  final lb = (b as List?)?.map((e) => '$e').toSet() ?? {};
  return la.length == lb.length && la.containsAll(lb);
}

bool _deepEq(Object? a, Object? b) {
  if (a is num && b is num) return a == b;
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_deepEq(a[i], b[i])) return false;
    }
    return true;
  }
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final k in a.keys) {
      if (!_deepEq(a[k], b[k])) return false;
    }
    return true;
  }
  return a == b;
}
