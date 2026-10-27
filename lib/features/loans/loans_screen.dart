import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../data/repositories/ledger_repository.dart';
import '../../data/repositories/reports_repository.dart';
import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/widgets.dart';
import '../transactions/history_screen.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final canWrite = ref.watch(actorProvider).can(Permission.writeTransactions);
    final tabs = [
      (s.lent, ObligationKind.loanGiven, TxType.loanGiven),
      (s.borrowed, ObligationKind.loanTaken, TxType.loanTaken),
      (s.advances, ObligationKind.advance, TxType.advancePaid),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.loansTitle),
          bottom: TabBar(tabs: [for (final t in tabs) Tab(text: t.$1)]),
        ),
        body: AsyncBody(
          ref.watch(obligationsProvider),
          builder: (all) => TabBarView(
            children: [
              for (final t in tabs)
                _ObligationList(
                  items: all.where((o) => o.obligation.kind == t.$2).toList(),
                  newType: t.$3,
                  canWrite: canWrite,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ObligationList extends ConsumerWidget {
  const _ObligationList({
    required this.items,
    required this.newType,
    required this.canWrite,
  });
  final List<ObligationSummary> items;
  final TxType newType;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final total = items.fold(0, (a, b) => a + b.outstanding);
    final repayType = switch (newType) {
      TxType.loanGiven => TxType.loanRepaymentReceived,
      TxType.loanTaken => TxType.loanRepaymentPaid,
      _ => TxType.reimbursementReceived,
    };
    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 100),
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: '${s.outstanding} · ${s.total}',
                value: total,
              ),
            ),
            if (canWrite) ...[
              const SizedBox(width: Space.md),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/tx/new?type=${newType.name}'),
                icon: Icon(txIcon(newType)),
                label: Text(s.newOne),
              ),
            ],
          ],
        ),
        const SizedBox(height: Space.md),
        if (items.isEmpty)
          EmptyState(icon: Icons.handshake_outlined, title: s.noLoans),
        for (final o in items)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: AppCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => HistoryScreen(
                    title: names.person(o.obligation.personId),
                    initial: TxFilter(obligationId: o.obligation.id),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          names.person(o.obligation.personId),
                          style: context.text.titleSmall,
                        ),
                      ),
                      Pill(
                        o.obligation.status == ObligationStatus.settled
                            ? s.settled
                            : s.open,
                        color: o.obligation.status == ObligationStatus.settled
                            ? context.ledger.positive
                            : context.ledger.warning,
                        background:
                            o.obligation.status == ObligationStatus.settled
                            ? context.ledger.positiveContainer
                            : context.ledger.warningContainer,
                      ),
                    ],
                  ),
                  if (o.obligation.title != null)
                    Text(
                      o.obligation.title!,
                      style: context.text.bodySmall?.copyWith(
                        color: context.ledger.muted,
                      ),
                    ),
                  const SizedBox(height: Space.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${s.principal}: ${s.money(o.principal)}\n${s.day(o.obligation.openedOn)}'
                          '${o.obligation.dueOn != null ? ' → ${s.day(o.obligation.dueOn!)}' : ''}',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(s.outstanding, style: context.text.labelSmall),
                          MoneyText(
                            o.outstanding,
                            style: context.text.titleMedium,
                            color: o.outstanding < 0
                                ? context.ledger.negative
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (o.outstanding < 0)
                    Text(
                      s.overpaid,
                      style: TextStyle(color: context.ledger.negative),
                    ),
                  if (o.principal > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.sm),
                      child: LinearProgressIndicator(
                        value: ((o.principal - o.outstanding) / o.principal)
                            .clamp(0.0, 1.0),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                        color: context.ledger.positive,
                      ),
                    ),
                  if (canWrite && o.outstanding > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => context.push(
                          '/tx/new?type=${repayType.name}&obligation=${o.obligation.id}&person=${o.obligation.personId}&fund=${o.obligation.fundId}',
                        ),
                        icon: const Icon(Icons.payments_outlined),
                        label: Text(s.recordRepayment),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
