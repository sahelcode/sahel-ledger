import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../core/money/money.dart';
import '../../data/db/database.dart';
import '../../data/repositories/reconciliation_repository.dart';
import '../../data/repositories/reports_repository.dart';
import '../../domain/access/access.dart';
import '../../shared/widgets.dart';

final _sessionsProvider = StreamProvider.autoDispose<List<ReconSessionRow>>(
  (ref) => ref.watch(reconRepoProvider).watchAll(),
);

class ReconciliationScreen extends ConsumerStatefulWidget {
  const ReconciliationScreen({super.key});
  @override
  ConsumerState<ReconciliationScreen> createState() =>
      _ReconciliationScreenState();
}

class _ReconciliationScreenState extends ConsumerState<ReconciliationScreen> {
  String? _account;
  final _actual = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final actor = ref.watch(actorProvider);
    final balances = ref.watch(accountBalancesProvider).value ?? const [];
    final expected = balances
        .where((b) => b.account.id == _account)
        .firstOrNull
        ?.balance;
    final diags = ref.watch(diagnosticsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(s.reconTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 80),
        children: [
          Text(
            s.reconIntro,
            style: context.text.bodyMedium?.copyWith(
              color: context.ledger.muted,
            ),
          ),
          const SizedBox(height: Space.lg),
          if (actor.can(Permission.writeTransactions))
            AppCard(
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PickerField(
                      label: s.account,
                      value: _account == null ? null : names.account(_account),
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () async {
                        final v = await showPicker<String>(
                          context,
                          title: s.account,
                          items: [
                            for (final b in balances)
                              PickerItem(
                                b.account.id,
                                accountLabel(b.account, s.bn),
                                icon: storageIcon(b.account.storageType),
                              ),
                          ],
                        );
                        if (v != null) setState(() => _account = v);
                      },
                    ),
                    if (expected != null) ...[
                      const SizedBox(height: Space.sm),
                      Text(
                        '${s.ledgerBalance}: ${s.money(expected)}',
                        style: context.text.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: Space.md),
                    AmountField(
                      controller: _actual,
                      label: s.countedBalance,
                      allowZero: true,
                    ),
                    const SizedBox(height: Space.md),
                    FilledButton(
                      onPressed: _account == null
                          ? null
                          : () async {
                              if (!_form.currentState!.validate()) return;
                              try {
                                await ref
                                    .read(reconRepoProvider)
                                    .start(
                                      accountId: _account!,
                                      actualBalance: parsePoisha(
                                        _actual.text,
                                        allowZero: true,
                                      ).poisha!,
                                    );
                                _actual.clear();
                                ref.invalidate(diagnosticsProvider);
                              } catch (e) {
                                if (context.mounted) {
                                  showSnack(context, '$e', error: true);
                                }
                              }
                            },
                      child: Text(s.startRecon),
                    ),
                  ],
                ),
              ),
            ),
          SectionHeader(s.reconTitle),
          AsyncBody(
            ref.watch(_sessionsProvider),
            builder: (list) => Column(
              children: [
                for (final r in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: _SessionCard(r),
                  ),
              ],
            ),
          ),
          SectionHeader(s.healthChecks),
          AsyncBody(
            diags,
            onRetry: () => ref.invalidate(diagnosticsProvider),
            builder: (list) => list.isEmpty
                ? AppCard(
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          color: context.ledger.positive,
                        ),
                        const SizedBox(width: Space.md),
                        Text(s.allClear),
                      ],
                    ),
                  )
                : Card(
                    child: Column(
                      children: [for (final d in list) _DiagnosticTile(d)],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticTile extends ConsumerWidget {
  const _DiagnosticTile(this.d);
  final Diagnostic d;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final color = switch (d.severity) {
      Severity.critical => context.ledger.negative,
      Severity.warning => context.ledger.warning,
      Severity.info => context.colors.primary,
    };
    final subject = switch (d.kind) {
      DiagnosticKind.negativeStorage => names.account(d.subjectId),
      DiagnosticKind.fundOverdrawnInAccount =>
        '${names.fund(d.related)} @ ${names.account(d.subjectId)}',
      _ => null,
    };
    final isTx = const {
      DiagnosticKind.unbalancedTransaction,
      DiagnosticKind.staleDraft,
      DiagnosticKind.possibleDuplicate,
      DiagnosticKind.unusualAmount,
    }.contains(d.kind);
    return ListTile(
      leading: Icon(Icons.warning_amber_rounded, color: color),
      title: Text(s.diagnostic(d.kind)),
      subtitle: Text(
        [?subject, if (d.amount != null) s.money(d.amount!)].join(' · '),
      ),
      trailing: isTx ? const Icon(Icons.chevron_right) : null,
      onTap: isTx ? () => context.push('/tx/${d.subjectId}') : null,
    );
  }
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard(this.r);
  final ReconSessionRow r;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final actor = ref.watch(actorProvider);
    final diff = r.actualBalance - r.expectedBalance;
    final (label, color) = switch (r.status) {
      ReconStatus.matched => (s.matched, context.ledger.positive),
      ReconStatus.adjusted => (s.adjusted, context.ledger.positive),
      ReconStatus.pendingApproval => (
        s.pendingApproval,
        context.ledger.warning,
      ),
      _ => (s.unresolved, context.ledger.negative),
    };
    final repo = ref.read(reconRepoProvider);
    Future<void> run(Future<void> Function() f) async {
      try {
        await f();
        ref.invalidate(diagnosticsProvider);
      } catch (e) {
        if (context.mounted) showSnack(context, '$e', error: true);
      }
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  names.account(r.accountId),
                  style: context.text.titleSmall,
                ),
              ),
              Pill(label, color: color),
            ],
          ),
          Text(
            s.day(r.asOfDateKey),
            style: context.text.bodySmall?.copyWith(
              color: context.ledger.muted,
            ),
          ),
          const SizedBox(height: Space.sm),
          Text('${s.ledgerBalance}: ${s.money(r.expectedBalance)}'),
          Text('${s.countedBalance}: ${s.money(r.actualBalance)}'),
          if (diff != 0)
            Text(
              '${s.difference}: ${s.money(diff, signed: true)}',
              style: TextStyle(
                color: context.ledger.negative,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (r.notes != null) Text(r.notes!, style: context.text.bodySmall),
          if (r.status == ReconStatus.unresolved) ...[
            const SizedBox(height: Space.sm),
            Text(s.possibleCauses, style: context.text.labelLarge),
            for (final c in s.causes)
              Text('• $c', style: context.text.bodySmall),
            if (actor.can(Permission.writeTransactions))
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => run(() async {
                    final funds = ref.read(fundsProvider).value ?? const [];
                    final fund = await showPicker<String>(
                      context,
                      title: s.whoseMoney,
                      items: [
                        for (final f in funds)
                          PickerItem(f.id, s.fundName(f.name, f.kind)),
                      ],
                    );
                    if (fund == null || !context.mounted) return;
                    final reason = await promptText(
                      context,
                      title: s.recordAdjustment,
                      hint: s.adjustmentReason,
                      minLength: 5,
                    );
                    if (reason != null) {
                      await repo.proposeAdjustment(
                        r.id,
                        reason: reason,
                        fundId: fund,
                      );
                    }
                  }),
                  child: Text(s.recordAdjustment),
                ),
              ),
          ],
          if (r.status == ReconStatus.pendingApproval &&
              actor.can(Permission.approveAdjustments))
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => run(() async {
                    final reason = await promptText(context, title: s.reject);
                    if (reason != null) await repo.reject(r.id, reason);
                  }),
                  child: Text(s.reject),
                ),
                FilledButton(
                  onPressed: () => run(() => repo.approve(r.id)),
                  child: Text(s.approve),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
