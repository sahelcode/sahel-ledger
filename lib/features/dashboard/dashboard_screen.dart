import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../data/repositories/reports_repository.dart';
import '../../shared/widgets.dart';
import '../sync/sync_badge.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final summary = ref.watch(dashboardProvider);
    final persons = ref.watch(personsProvider).value ?? const [];
    final self = persons.where((p) => p.isSelf).firstOrNull;
    return Scaffold(
      body: SafeArea(
        child: AsyncBody(
          summary,
          builder: (d) => ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.md,
              Space.lg,
              120,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.greeting,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.ledger.muted,
                          ),
                        ),
                        Text(
                          self?.name ?? s.appName,
                          style: context.text.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SyncBadge(),
                ],
              ),
              const SizedBox(height: Space.lg),
              _HeroCard(d),
              const SizedBox(height: Space.md),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: Space.md,
                crossAxisSpacing: Space.md,
                childAspectRatio: 1.9,
                children: [
                  StatTile(
                    label: s.personalNetWorth,
                    value: d.personalNet,
                    colorize: true,
                    icon: Icons.person_outline,
                    onTap: () => _explain(
                      context,
                      s.personalNetWorth,
                      s.personalNetHint,
                    ),
                  ),
                  StatTile(
                    label: s.owedToYou,
                    value: d.receivables,
                    icon: Icons.call_received,
                    onTap: () => context.push('/loans'),
                  ),
                  StatTile(
                    label: s.youOwe,
                    value: d.payables,
                    icon: Icons.call_made,
                    onTap: () => context.push('/loans'),
                  ),
                  StatTile(
                    label: s.samitySavings,
                    value: d.externalSavings,
                    icon: Icons.groups_2_outlined,
                    onTap: () => context.push('/samity'),
                  ),
                ],
              ),
              if (d.pendingCount + d.draftCount > 0) ...[
                const SizedBox(height: Space.md),
                AppCard(
                  color: context.ledger.warningContainer,
                  onTap: () => context.go('/history'),
                  child: Row(
                    children: [
                      Icon(
                        Icons.pending_actions,
                        color: context.ledger.warning,
                      ),
                      const SizedBox(width: Space.md),
                      Expanded(
                        child: Text(
                          s.pendingDrafts(d.pendingCount, d.draftCount),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
              SectionHeader(s.thisMonth),
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      label: s.income,
                      value: d.monthIncome,
                      icon: Icons.south_west,
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: StatTile(
                      label: s.expense,
                      value: d.monthExpense,
                      icon: Icons.north_east,
                    ),
                  ),
                ],
              ),
              SectionHeader(
                s.accountsTitle,
                action: s.seeAll,
                onAction: () => context.go('/accounts'),
              ),
              const _AccountStrip(),
              SectionHeader(
                s.recent,
                action: s.seeAll,
                onAction: () => context.go('/history'),
              ),
              const _RecentList(),
              const SizedBox(height: Space.lg),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: context.ledger.muted,
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      s.notHeldNote,
                      style: context.text.bodySmall?.copyWith(
                        color: context.ledger.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _explain(BuildContext context, String title, String body) =>
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(S.of(ctx).close),
            ),
          ],
        ),
      );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard(this.d);
  final DashboardSummary d;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final total = d.totalStorage;
    final ownShare = total <= 0
        ? 0.0
        : (d.personalStorage / total).clamp(0.0, 1.0);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.xl),
        gradient: LinearGradient(
          colors: [context.ledger.heroStart, context.ledger.heroEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.totalHeld,
            style: context.text.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: Space.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: MoneyText(
              total,
              color: Colors.white,
              style: context.text.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: Space.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              color: Colors.white24,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: ownShare,
                heightFactor: 1,
                child: Container(color: AppColors.emerald300),
              ),
            ),
          ),
          const SizedBox(height: Space.md),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  color: AppColors.emerald300,
                  label: s.yourMoney,
                  value: d.personalStorage,
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: _HeroStat(
                  color: Colors.white38,
                  label: s.heldForOthers,
                  value: d.entrustedStorage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.color,
    required this.label,
    required this.value,
  });
  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: context.text.labelMedium?.copyWith(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      const SizedBox(height: 2),
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: MoneyText(
          value,
          color: Colors.white,
          style: context.text.titleMedium,
        ),
      ),
    ],
  );
}

class _AccountStrip extends ConsumerWidget {
  const _AccountStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final balances = ref.watch(accountBalancesProvider);
    return AsyncBody(
      balances,
      builder: (list) => SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: list.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: Space.md),
          itemBuilder: (ctx, i) {
            if (i == list.length) {
              return SizedBox(
                width: 120,
                child: AppCard(
                  onTap: () => context.go('/accounts'),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: context.colors.primary,
                        ),
                        const SizedBox(height: Space.xs),
                        Text(
                          s.addAccount,
                          textAlign: TextAlign.center,
                          style: context.text.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            final b = list[i];
            return SizedBox(
              width: 168,
              child: AppCard(
                onTap: () => context.push('/accounts/${b.account.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          storageIcon(b.account.storageType),
                          size: 18,
                          color: context.colors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            accountLabel(b.account, s.bn),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.labelLarge,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: MoneyText(
                        b.balance,
                        style: context.text.titleMedium,
                        color: b.balance < 0 ? context.ledger.negative : null,
                      ),
                    ),
                    if (b.byFund.length > 1)
                      Text(
                        '${s.num(b.byFund.length)} ${s.fundsTitle}',
                        style: context.text.labelSmall?.copyWith(
                          color: context.ledger.muted,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RecentList extends ConsumerWidget {
  const _RecentList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    return AsyncBody(
      ref.watch(recentTxProvider),
      builder: (list) => list.isEmpty
          ? AppCard(
              child: EmptyState(
                icon: Icons.receipt_long_outlined,
                title: s.noTransactions,
                body: s.noTransactionsBody,
              ),
            )
          : Card(
              child: Column(
                children: [
                  for (var i = 0; i < list.length; i++) ...[
                    if (i > 0) const Divider(indent: 72),
                    TxTile(
                      list[i],
                      onTap: () => context.push('/tx/${list[i].id}'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
