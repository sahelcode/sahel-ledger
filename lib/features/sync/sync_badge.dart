import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'sync_controller.dart';

/// Compact, honest sync status: never shows "synced" while changes wait.
class SyncBadge extends ConsumerWidget {
  const SyncBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final sync = ref.watch(syncControllerProvider);
    final pending = ref.watch(outboxCountProvider).value ?? 0;
    final l = context.ledger;
    final (icon, label, color, bg) = switch (sync.phase) {
      SyncPhase.localOnly => (
        Icons.phone_android,
        s.syncLocalOnly,
        l.muted,
        null,
      ),
      SyncPhase.syncing => (
        Icons.sync,
        s.syncPending(pending),
        context.colors.primary,
        null,
      ),
      SyncPhase.offline => (
        Icons.cloud_off,
        s.offline,
        l.warning,
        l.warningContainer,
      ),
      SyncPhase.error => (
        Icons.sync_problem,
        s.syncFailed,
        l.negative,
        l.negativeContainer,
      ),
      SyncPhase.idle when (sync.lastReport?.conflicts ?? 0) > 0 => (
        Icons.report_gmailerrorred,
        s.syncConflict,
        l.warning,
        l.warningContainer,
      ),
      SyncPhase.idle when pending > 0 => (
        Icons.cloud_upload_outlined,
        s.syncPending(pending),
        l.warning,
        l.warningContainer,
      ),
      SyncPhase.idle => (
        Icons.cloud_done_outlined,
        s.syncUpToDate,
        l.positive,
        l.positiveContainer,
      ),
    };
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.xl),
      onTap: () => context.push('/settings'),
      child: Pill(label, icon: icon, color: color, background: bg),
    );
  }
}
