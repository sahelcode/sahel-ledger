import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/ledger/ledger_types.dart';
import '../features/accounts/accounts_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/household/household_screen.dart';
import '../features/loans/loans_screen.dart';
import '../features/more/more_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/people/people_screen.dart';
import '../features/reconciliation/reconciliation_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/samity/samity_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/transactions/entry_screen.dart';
import '../features/transactions/history_screen.dart';
import '../features/transactions/transaction_detail_screen.dart';
import 'providers.dart';
import 'shell.dart';

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(
      settingsProvider.select((s) => s.onboarded),
      (_, _) => notifyListeners(),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final onboarded = ref.read(settingsProvider).onboarded;
      final atOnboarding = state.matchedLocation == '/onboarding';
      if (!onboarded && !atOnboarding) return '/onboarding';
      if (onboarded && atOnboarding) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, _) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (_, _) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/people', builder: (_, _) => const PeopleScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/accounts',
                builder: (_, _) => const AccountsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/more', builder: (_, _) => const MoreScreen()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/tx/new',
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return EntryScreen(
            initialType: q['type'] == null
                ? null
                : TxType.values.byName(q['type']!),
            personId: q['person'],
            accountId: q['account'],
            fundId: q['fund'],
            obligationId: q['obligation'],
            samityId: q['samity'],
          );
        },
      ),
      GoRoute(
        path: '/tx/:id',
        builder: (_, state) =>
            TransactionDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tx/:id/edit',
        builder: (_, state) => EntryScreen(editId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/people/:id',
        builder: (_, state) =>
            PersonDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/accounts/:id',
        builder: (_, state) =>
            AccountDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/funds/:id',
        builder: (_, state) =>
            FundDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/loans', builder: (_, _) => const LoansScreen()),
      GoRoute(path: '/samity', builder: (_, _) => const SamityScreen()),
      GoRoute(
        path: '/samity/:id',
        builder: (_, state) =>
            SamityDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/reports', builder: (_, _) => const ReportsScreen()),
      GoRoute(
        path: '/reconciliation',
        builder: (_, _) => const ReconciliationScreen(),
      ),
      GoRoute(path: '/household', builder: (_, _) => const HouseholdScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/budgets', builder: (_, _) => const BudgetsScreen()),
      GoRoute(path: '/audit', builder: (_, _) => const AuditScreen()),
    ],
  );
});
