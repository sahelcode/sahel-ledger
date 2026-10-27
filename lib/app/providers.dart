import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';
import '../data/repositories/ledger_repository.dart';
import '../data/repositories/master_repository.dart';
import '../data/repositories/outbox_repository.dart';
import '../data/repositories/reconciliation_repository.dart';
import '../data/repositories/reports_repository.dart';
import '../data/sync/household_directory.dart';
import '../domain/access/access.dart';
import '../domain/ledger/ledger_types.dart';

/// Overridden in `main()` with the opened database.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('database'),
);

/// Whether Firebase was initialised (a `firebase_options.dart` exists).
final firebaseReadyProvider = Provider<bool>((ref) => false);

class AppSettings {
  const AppSettings({
    required this.locale,
    required this.themeMode,
    required this.onboarded,
  });
  final Locale locale;
  final ThemeMode themeMode;
  final bool onboarded;

  AppSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? onboarded,
  }) => AppSettings(
    locale: locale ?? this.locale,
    themeMode: themeMode ?? this.themeMode,
    onboarded: onboarded ?? this.onboarded,
  );

  static Future<AppSettings> load(AppDatabase db) async {
    final mode = await db.getKv(Kv.themeMode);
    return AppSettings(
      locale: Locale((await db.getKv(Kv.locale)) ?? 'bn'),
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == mode,
        orElse: () => ThemeMode.system,
      ),
      onboarded: (await db.getKv(Kv.onboarded)) == 'true',
    );
  }
}

final initialSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings(
    locale: Locale('bn'),
    themeMode: ThemeMode.system,
    onboarded: false,
  ),
);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> setLocale(Locale l) async {
    state = state.copyWith(locale: l);
    await _db.setKv(Kv.locale, l.languageCode);
  }

  Future<void> setThemeMode(ThemeMode m) async {
    state = state.copyWith(themeMode: m);
    await _db.setKv(Kv.themeMode, m.name);
  }

  void markOnboarded() => state = state.copyWith(onboarded: true);
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

/// The cached household membership of the signed-in user, if any.
const kvMembership = 'membership_json';

class SessionNotifier extends Notifier<MemberInfo?> {
  @override
  MemberInfo? build() => null;

  Future<void> load() async {
    final db = ref.read(databaseProvider);
    final raw = await db.getKv(kvMembership);
    final uid = await db.getKv(Kv.actorId);
    if (raw == null || uid == null) {
      state = null;
      return;
    }
    state = MemberInfo.fromJson(uid, jsonDecode(raw) as Map<String, Object?>);
  }

  Future<void> set(MemberInfo m) async {
    final db = ref.read(databaseProvider);
    await db.setKv(kvMembership, jsonEncode(m.toJson()));
    await db.setKv(Kv.actorId, m.uid);
    state = m;
  }

  Future<void> clear() async {
    final db = ref.read(databaseProvider);
    await (db.delete(
          db.keyValues,
        )..where((k) => k.key.isIn([kvMembership, Kv.actorId, Kv.householdId])))
        .go();
    state = null;
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, MemberInfo?>(
  SessionNotifier.new,
);

/// Who is acting. Without a household the device user is the local owner.
final actorProvider = Provider<ActorContext>((ref) {
  final m = ref.watch(sessionProvider);
  return m?.toActor() ?? ActorContext.localOwner;
});

final ledgerRepoProvider = Provider<LedgerRepository>(
  (ref) => LedgerRepository(
    ref.watch(databaseProvider),
    actor: ref.watch(actorProvider),
  ),
);
final masterRepoProvider = Provider<MasterRepository>(
  (ref) => MasterRepository(
    ref.watch(databaseProvider),
    actor: ref.watch(actorProvider),
  ),
);
final reportsRepoProvider = Provider<ReportsRepository>(
  (ref) => ReportsRepository(
    ref.watch(databaseProvider),
    actor: ref.watch(actorProvider),
  ),
);
final reconRepoProvider = Provider<ReconciliationRepository>(
  (ref) => ReconciliationRepository(
    ref.watch(databaseProvider),
    actor: ref.watch(actorProvider),
  ),
);

// ------------------------------------------------------------ live data

final personsProvider = StreamProvider<List<PersonRow>>(
  (ref) => ref.watch(masterRepoProvider).watchPersons(),
);

final fundsProvider = StreamProvider<List<FundRow>>(
  (ref) => ref.watch(masterRepoProvider).watchFunds(),
);

final storageAccountsProvider = StreamProvider<List<LedgerAccountRow>>(
  (ref) =>
      ref.watch(masterRepoProvider).watchAccounts({LedgerAccountKind.storage}),
);

final categoriesProvider = StreamProvider.family<List<LedgerAccountRow>, bool>(
  (ref, income) => ref.watch(masterRepoProvider).watchAccounts({
    income
        ? LedgerAccountKind.incomeCategory
        : LedgerAccountKind.expenseCategory,
  }),
);

final samitiesProvider = StreamProvider<List<SamityRow>>(
  (ref) => ref.watch(masterRepoProvider).watchSamities(),
);

final dashboardProvider = StreamProvider<DashboardSummary>(
  (ref) => ref.watch(reportsRepoProvider).watchDashboard(),
);

final accountBalancesProvider = StreamProvider<List<AccountBalance>>((ref) {
  final r = ref.watch(reportsRepoProvider);
  return r.watchLedger(r.accountBalances);
});

final fundBalancesProvider = StreamProvider<List<FundBalance>>((ref) {
  final r = ref.watch(reportsRepoProvider);
  return r.watchLedger(r.fundBalances);
});

final obligationsProvider = StreamProvider<List<ObligationSummary>>((ref) {
  final r = ref.watch(reportsRepoProvider);
  return r.watchLedger(r.obligations);
});

final recentTxProvider = StreamProvider<List<TxRow>>(
  (ref) => ref.watch(ledgerRepoProvider).watchPage(const TxFilter(), limit: 8),
);

final outboxCountProvider = StreamProvider<int>(
  (ref) => OutboxRepository(ref.watch(databaseProvider)).watchPendingCount(),
);

final personSummaryProvider = StreamProvider.family<PersonSummary?, String>((
  ref,
  id,
) {
  final r = ref.watch(reportsRepoProvider);
  return r.watchLedger(() => r.personSummary(id));
});

final diagnosticsProvider = FutureProvider.autoDispose<List<Diagnostic>>(
  (ref) => ref.watch(reportsRepoProvider).diagnostics(),
);

/// Display names for ids (accounts, funds, people) in the current language.
class LedgerNames {
  LedgerNames(this.accounts, this.funds, this.persons, this.bn);
  final Map<String, LedgerAccountRow> accounts;
  final Map<String, FundRow> funds;
  final Map<String, PersonRow> persons;
  final bool bn;

  String account(String? id) {
    if (id == null) return '—';
    final a = accounts[id];
    if (a == null) return '—';
    return bn && a.nameBn != null ? a.nameBn! : a.name;
  }

  String fund(String? id) {
    final f = id == null ? null : funds[id];
    if (f == null) return '—';
    if (f.kind == FundKind.personal) return bn ? 'আমার নিজের টাকা' : 'My money';
    return f.name;
  }

  String person(String? id) => id == null ? '—' : (persons[id]?.name ?? '—');
}

final allAccountsProvider = StreamProvider<List<LedgerAccountRow>>(
  (ref) => ref
      .watch(masterRepoProvider)
      .watchAccounts(LedgerAccountKind.values.toSet(), includeArchived: true),
);

final allFundsProvider = StreamProvider<List<FundRow>>(
  (ref) => ref.watch(masterRepoProvider).watchFunds(includeArchived: true),
);

final allPersonsProvider = StreamProvider<List<PersonRow>>(
  (ref) => ref.watch(masterRepoProvider).watchPersons(includeArchived: true),
);

final namesProvider = Provider<LedgerNames>((ref) {
  final bn = ref.watch(settingsProvider).locale.languageCode == 'bn';
  return LedgerNames(
    {
      for (final a
          in ref.watch(allAccountsProvider).value ?? const <LedgerAccountRow>[])
        a.id: a,
    },
    {
      for (final f in ref.watch(allFundsProvider).value ?? const <FundRow>[])
        f.id: f,
    },
    {
      for (final p
          in ref.watch(allPersonsProvider).value ?? const <PersonRow>[])
        p.id: p,
    },
    bn,
  );
});

final personalFundIdProvider = FutureProvider<String?>(
  (ref) => ref.watch(databaseProvider).getKv(Kv.personalFundId),
);
