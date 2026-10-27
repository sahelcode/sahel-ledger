import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../core/money/money.dart';
import '../../data/backup/backup_service.dart';
import '../../data/db/database.dart';
import '../../data/repositories/audit_log.dart';
import '../../data/repositories/reports_repository.dart';
import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/widgets.dart';
import '../lock/app_lock.dart';
import '../sync/sync_controller.dart';

final _lastBackupProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(databaseProvider).getKv(Kv.lastBackupAt),
);

final _auditCheckProvider = FutureProvider.autoDispose<int?>(
  (ref) => AuditLog(ref.watch(databaseProvider)).verifyChain(),
);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<File> _backupFile(String prefix) async {
    final dir = Directory(
      p.join((await getApplicationDocumentsDirectory()).path, 'backups'),
    );
    await dir.create(recursive: true);
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    return File(p.join(dir.path, '$prefix-$stamp.json'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final settings = ref.watch(settingsProvider);
    final db = ref.watch(databaseProvider);
    final sync = ref.watch(syncControllerProvider);
    final firebase = ref.watch(firebaseReadyProvider);
    final pending = ref.watch(outboxCountProvider).value ?? 0;
    final last = ref.watch(_lastBackupProvider).value;
    final audit = ref.watch(_auditCheckProvider);
    final isOwner = ref.watch(actorProvider).role == HouseholdRole.owner;

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xxl),
        children: [
          SectionHeader(s.language),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'bn', label: Text('বাংলা')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {settings.locale.languageCode},
            onSelectionChanged: (v) =>
                ref.read(settingsProvider.notifier).setLocale(Locale(v.first)),
          ),
          SectionHeader(s.theme),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(s.system),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(s.light),
                icon: const Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(s.dark),
                icon: const Icon(Icons.dark_mode),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (v) =>
                ref.read(settingsProvider.notifier).setThemeMode(v.first),
          ),
          SectionHeader(s.appLock),
          const _AppLockTile(),
          SectionHeader(s.syncTitle),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!firebase)
                  Text(s.cloudNotConfigured)
                else ...[
                  Text(switch (sync.phase) {
                    SyncPhase.localOnly => s.syncLocalOnly,
                    SyncPhase.offline => s.offline,
                    SyncPhase.error => s.syncFailed,
                    SyncPhase.syncing => s.syncPending(pending),
                    SyncPhase.idle =>
                      pending > 0 ? s.syncPending(pending) : s.syncUpToDate,
                  }),
                  if (sync.lastSyncAt != null)
                    Text(
                      '${sync.lastSyncAt!.toLocal()}',
                      style: context.text.bodySmall?.copyWith(
                        color: context.ledger.muted,
                      ),
                    ),
                  if (sync.message != null)
                    Text(
                      sync.message!,
                      style: context.text.bodySmall?.copyWith(
                        color: context.ledger.negative,
                      ),
                    ),
                  const SizedBox(height: Space.sm),
                  FilledButton.tonalIcon(
                    onPressed: sync.phase == SyncPhase.localOnly
                        ? null
                        : () => ref
                              .read(syncControllerProvider.notifier)
                              .syncNow(),
                    icon: const Icon(Icons.sync),
                    label: Text(s.syncNow),
                  ),
                ],
              ],
            ),
          ),
          SectionHeader(s.backupTitle),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  s.lastBackup(
                    last == null
                        ? s.never
                        : DateTime.parse(last)
                              .toLocal()
                              .toString()
                              .split('.')
                              .first,
                  ),
                ),
                const SizedBox(height: Space.md),
                FilledButton.icon(
                  icon: const Icon(Icons.backup_outlined),
                  label: Text(s.createBackup),
                  onPressed: () async {
                    try {
                      final f = await BackupService(db)
                          .exportToFile(await _backupFile('sahel-ledger'));
                      ref.invalidate(_lastBackupProvider);
                      if (!context.mounted) return;
                      showSnack(context, s.backupDone);
                      await SharePlus.instance.share(
                        ShareParams(files: [XFile(f.path)], text: s.appName),
                      );
                    } catch (e) {
                      if (context.mounted) {
                        showSnack(context, '$e', error: true);
                      }
                    }
                  },
                ),
                const SizedBox(height: Space.sm),
                OutlinedButton.icon(
                  icon: const Icon(Icons.restore),
                  label: Text(s.restoreBackup),
                  onPressed: !isOwner
                      ? null
                      : () async {
                          final picked = await FilePicker.pickFile(
                            type: FileType.custom,
                            allowedExtensions: ['json'],
                          );
                          if (picked?.path == null || !context.mounted) return;
                          try {
                            final json = await File(picked!.path!)
                                .readAsString();
                            final svc = BackupService(db);
                            final info = svc.inspect(json);
                            if (!context.mounted) return;
                            final ok = await confirmDialog(
                              context,
                              title: s.restoreBackup,
                              body:
                                  '${s.restoreWarning}\n\n${info.createdAt.toLocal()} · ${s.num(info.transactionCount)}',
                              destructive: true,
                            );
                            if (!ok) return;
                            await svc.exportToFile(
                              await _backupFile('before-restore'),
                            );
                            await svc.restore(json);
                            ref.invalidate(_auditCheckProvider);
                            if (context.mounted) {
                              showSnack(context, s.restoreDone);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              showSnack(context, '$e', error: true);
                            }
                          }
                        },
                ),
              ],
            ),
          ),
          SectionHeader(s.integrity),
          AppCard(
            child: AsyncBody(
              audit,
              builder: (broken) => Row(
                children: [
                  Icon(
                    broken == null
                        ? Icons.verified_user_outlined
                        : Icons.gpp_bad_outlined,
                    color: broken == null
                        ? context.ledger.positive
                        : context.ledger.negative,
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Text(
                      broken == null ? s.auditOk : s.auditBroken(broken),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SectionHeader(
            s.categories,
            action: s.add,
            onAction: () => _addCategory(context, ref),
          ),
          SectionHeader(s.about),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.appName, style: context.text.titleSmall),
                Text(s.tagline),
                const SizedBox(height: Space.sm),
                Text(
                  'v0.1.0',
                  style: context.text.bodySmall?.copyWith(
                    color: context.ledger.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final s = S.of(context);
    final income = await showPicker<bool>(
      context,
      title: s.category,
      items: [PickerItem(false, s.expense), PickerItem(true, s.income)],
    );
    if (income == null || !context.mounted) return;
    final name = await promptText(context, title: s.category, hint: s.name);
    if (name == null) return;
    await ref
        .read(masterRepoProvider)
        .createCategory(income: income, name: name, nameBn: name);
  }
}

final _budgetsProvider = FutureProvider.autoDispose
    .family<List<BudgetStatus>, int>((ref, month) {
      ref.watch(recentTxProvider);
      return ref.watch(reportsRepoProvider).budgetStatus(month);
    });

class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});
  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  int _month = DateKey.monthKey(DateKey.today());

  void _shift(int d) {
    var y = _month ~/ 100, m = _month % 100 + d;
    if (m == 0) {
      m = 12;
      y--;
    } else if (m == 13) {
      m = 1;
      y++;
    }
    setState(() => _month = y * 100 + m);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final canEdit = ref.watch(actorProvider).can(Permission.manageMasterData);
    return Scaffold(
      appBar: AppBar(title: Text(s.budgets)),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              heroTag: 'budget',
              onPressed: () async {
                final cats =
                    ref.read(categoriesProvider(false)).value ?? const [];
                final cat = await showPicker<String>(
                  context,
                  title: s.category,
                  items: [
                    for (final c in cats)
                      PickerItem(c.id, accountLabel(c, s.bn)),
                  ],
                );
                if (cat == null || !context.mounted) return;
                final v = await promptText(
                  context,
                  title: s.setBudget,
                  hint: '৳',
                );
                final amount = v == null ? null : parsePoisha(v).poisha;
                if (amount == null) return;
                await ref
                    .read(masterRepoProvider)
                    .setBudget(_month, cat, amount);
                ref.invalidate(_budgetsProvider(_month));
              },
              icon: const Icon(Icons.add),
              label: Text(s.setBudget),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(Space.lg),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  s.month(_month),
                  textAlign: TextAlign.center,
                  style: context.text.titleMedium,
                ),
              ),
              IconButton(
                onPressed: () => _shift(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          AsyncBody(
            ref.watch(_budgetsProvider(_month)),
            builder: (list) => Column(
              children: [
                for (final b in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  accountLabel(b.category, s.bn),
                                  style: context.text.titleSmall,
                                ),
                              ),
                              Text(
                                '${s.money(b.spent, compact: true)} / ${s.money(b.limit, compact: true)}',
                              ),
                            ],
                          ),
                          const SizedBox(height: Space.sm),
                          LinearProgressIndicator(
                            value: b.ratio.clamp(0.0, 1.0),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                            color: b.ratio > 1
                                ? context.ledger.negative
                                : b.ratio > 0.85
                                ? context.ledger.warning
                                : context.ledger.positive,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final _auditProvider = FutureProvider.autoDispose<List<AuditRow>>(
  (ref) => AuditLog(ref.watch(databaseProvider)).recent(limit: 300),
);

class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.auditTrail)),
      body: AsyncBody(
        ref.watch(_auditProvider),
        builder: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final a = list[i];
            return ListTile(
              dense: true,
              title: Text('${a.entityType} · ${a.action}'),
              subtitle: Text(
                '${a.at.toLocal()} · ${a.actorId}\n#${a.seq} ${a.hash.substring(0, 12)}…',
              ),
              isThreeLine: true,
            );
          },
        ),
      ),
    );
  }
}

class _AppLockTile extends ConsumerWidget {
  const _AppLockTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final lock = ref.watch(appLockProvider);
    return AppCard(
      padding: EdgeInsets.zero,
      child: SwitchListTile(
        value: lock.enabled,
        title: Text(s.appLock),
        subtitle: Text(s.appLockHint),
        onChanged: (on) async {
          if (!on) return ref.read(appLockProvider.notifier).disable();
          final pin = await promptText(context, title: s.setPin, minLength: 4);
          if (pin == null) return;
          if (!RegExp(r'^\d{4,8}$').hasMatch(pin)) {
            if (context.mounted) showSnack(context, s.setPin, error: true);
            return;
          }
          await ref.read(appLockProvider.notifier).setPin(pin);
        },
      ),
    );
  }
}
