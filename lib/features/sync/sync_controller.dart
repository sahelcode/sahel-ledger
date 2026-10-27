import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/db/database.dart';
import '../../data/sync/firestore_remote_store.dart';
import '../../data/sync/household_service.dart';
import '../../data/sync/sync_engine.dart';
import '../../domain/ledger/ledger_types.dart';

enum SyncPhase { localOnly, idle, syncing, offline, error }

class SyncState {
  const SyncState(this.phase, {this.lastReport, this.lastSyncAt, this.message});
  final SyncPhase phase;
  final SyncReport? lastReport;
  final DateTime? lastSyncAt;
  final String? message;
}

final householdServiceProvider = Provider<HouseholdService?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return null;
  return HouseholdService(
    FirebaseFirestore.instance,
    ref.watch(databaseProvider),
  );
});

/// Runs sync when a household is linked: on start, when connectivity
/// returns, shortly after local changes, and every few minutes.
class SyncController extends Notifier<SyncState> {
  Timer? _periodic;
  Timer? _debounce;
  StreamSubscription<List<ConnectivityResult>>? _conn;
  bool _online = true;

  @override
  SyncState build() {
    ref.onDispose(() {
      _periodic?.cancel();
      _debounce?.cancel();
      _conn?.cancel();
    });
    final session = ref.watch(sessionProvider);
    if (!ref.watch(firebaseReadyProvider) || session == null) {
      return const SyncState(SyncPhase.localOnly);
    }
    _periodic = Timer.periodic(const Duration(minutes: 5), (_) => syncNow());
    _conn = Connectivity().onConnectivityChanged.listen((r) {
      final online = r.any((c) => c != ConnectivityResult.none);
      if (online && !_online) syncNow();
      _online = online;
      if (!online) {
        state = SyncState(SyncPhase.offline, lastSyncAt: state.lastSyncAt);
      }
    });
    ref.listen(outboxCountProvider, (prev, next) {
      final n = next.value ?? 0;
      if (n > (prev?.value ?? 0)) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(seconds: 3), syncNow);
      }
    });
    Future.microtask(syncNow);
    return const SyncState(SyncPhase.idle);
  }

  Future<void> syncNow() async {
    final service = ref.read(householdServiceProvider);
    final session = ref.read(sessionProvider);
    final db = ref.read(databaseProvider);
    if (service == null || session == null) return;
    final hid = await db.getKv(Kv.householdId);
    if (hid == null) return;
    if (state.phase == SyncPhase.syncing) return;
    state = SyncState(
      SyncPhase.syncing,
      lastSyncAt: state.lastSyncAt,
      lastReport: state.lastReport,
    );
    try {
      // Refresh our own membership first: revocation or new grants apply now.
      final me = await service.membership(hid, session.uid);
      if (me == null || !me.active) {
        state = const SyncState(SyncPhase.error, message: 'membership_revoked');
        return;
      }
      await ref.read(sessionProvider.notifier).set(me);
      final engine = SyncEngine(
        db: db,
        remote: FirestoreRemoteStore(FirebaseFirestore.instance),
        householdId: hid,
        viewer: me,
        directory: await service.directory(hid, me),
      );
      final report = await engine.syncNow();
      await _ensureLocalKeys(db);
      state = SyncState(
        report.failed > 0 ? SyncPhase.error : SyncPhase.idle,
        lastReport: report,
        lastSyncAt: DateTime.now(),
        message: report.errors.isEmpty ? null : report.errors.first,
      );
    } catch (e) {
      debugPrint('sync failed: $e');
      state = SyncState(
        _online ? SyncPhase.error : SyncPhase.offline,
        lastSyncAt: state.lastSyncAt,
        message: '$e',
      );
    }
  }

  /// A device that joined a household learns its personal fund from data.
  Future<void> _ensureLocalKeys(AppDatabase db) async {
    if (await db.getKv(Kv.selfPersonId) == null) {
      final self = await (db.select(
        db.persons,
      )..where((p) => p.isSelf.equals(true))).getSingleOrNull();
      if (self != null) await db.setKv(Kv.selfPersonId, self.id);
    }
    if (await db.getKv(Kv.personalFundId) != null) return;
    final personal = await (db.select(
      db.funds,
    )..where((f) => f.kind.equalsValue(FundKind.personal))).getSingleOrNull();
    if (personal != null) await db.setKv(Kv.personalFundId, personal.id);
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(
  SyncController.new,
);
