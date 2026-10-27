import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/providers.dart';
import '../app/strings.dart';
import '../app/theme.dart';
import '../data/repositories/reports_repository.dart';
import 'widgets.dart';

final statementProvider = StreamProvider.autoDispose
    .family<Statement, StatementSpec>((ref, spec) {
      final r = ref.watch(reportsRepoProvider);
      return r.watchLedger(() => r.statement(spec));
    });

/// Opening balance, in/out columns, running balance, closing balance.
class StatementView extends ConsumerWidget {
  const StatementView({super.key, required this.spec});
  final StatementSpec spec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    return AsyncBody(
      ref.watch(statementProvider(spec)),
      builder: (st) => Card(
        child: Column(
          children: [
            _row(context, s.opening, null, null, st.opening, bold: true),
            const Divider(),
            if (st.rows.isEmpty)
              Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Text(s.noTransactions),
              ),
            for (final r in st.rows)
              InkWell(
                onTap: () => context.push('/tx/${r.txId}'),
                child: _row(
                  context,
                  '${s.day(r.dateKey)} · ${r.description ?? s.txType(r.type)}',
                  r.debit,
                  r.credit,
                  r.running,
                  sub: r.counterAccountId == null
                      ? null
                      : ref.watch(namesProvider).account(r.counterAccountId),
                  strike: r.reversed,
                ),
              ),
            const Divider(),
            _row(
              context,
              s.closing,
              st.totalDebit,
              st.totalCredit,
              st.closing,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    int? debit,
    int? credit,
    int running, {
    bool bold = false,
    String? sub,
    bool strike = false,
  }) {
    final s = S.of(context);
    final style = (bold ? context.text.titleSmall : context.text.bodyMedium)
        ?.copyWith(fontFeatures: moneyFeatures);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.sm,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: style?.copyWith(
                    decoration: strike ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (sub != null)
                  Text(
                    sub,
                    style: context.text.bodySmall?.copyWith(
                      color: context.ledger.muted,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if ((debit ?? 0) > 0)
                  Text(
                    '+${s.money(debit!, compact: true)}',
                    style: style?.copyWith(color: context.ledger.positive),
                  ),
                if ((credit ?? 0) > 0)
                  Text('-${s.money(credit!, compact: true)}', style: style),
                Text(
                  s.money(running, compact: true),
                  style: context.text.bodySmall?.copyWith(
                    color: context.ledger.muted,
                    fontFeatures: moneyFeatures,
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
