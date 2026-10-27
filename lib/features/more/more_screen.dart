import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';
import '../sync/sync_badge.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final items = [
      (Icons.handshake_outlined, s.loansTitle, '/loans'),
      (Icons.groups_2_outlined, s.samityTitle, '/samity'),
      (Icons.pie_chart_outline, s.budgets, '/budgets'),
      (Icons.picture_as_pdf_outlined, s.reportsTitle, '/reports'),
      (Icons.fact_check_outlined, s.reconTitle, '/reconciliation'),
      (Icons.family_restroom, s.householdTitle, '/household'),
      (Icons.history_edu_outlined, s.auditTrail, '/audit'),
      (Icons.settings_outlined, s.settingsTitle, '/settings'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(s.navMore),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: Space.lg),
            child: SyncBadge(),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(Space.lg),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: Space.md,
          crossAxisSpacing: Space.md,
          childAspectRatio: 1.35,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final (icon, label, path) = items[i];
          return AppCard(
            onTap: () => context.push(path),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  child: Icon(icon, color: context.colors.onPrimaryContainer),
                ),
                Text(label, style: context.text.titleSmall, maxLines: 2),
              ],
            ),
          );
        },
      ),
    );
  }
}
