import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/app/app.dart';
import 'package:sahel_ledger/app/providers.dart';
import 'package:sahel_ledger/data/db/database.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';

import '../support/fonts.dart';
import '../support/test_ledger.dart';

/// Lets real async work (SQLite queries) finish between frames. Used
/// instead of pumpAndSettle, which never settles while a progress
/// indicator animates.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 15; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 15)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  late AppDatabase db;

  Future<void> pumpApp(WidgetTester tester, {String lang = 'en'}) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);
    final settings = (await tester.runAsync(() async {
      await db.setKv(Kv.locale, lang);
      return AppSettings.load(db);
    }))!;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          initialSettingsProvider.overrideWithValue(settings),
        ],
        child: const SahelLedgerApp(),
      ),
    );
    await settle(tester);
  }

  // Real Bengali font instead of the square Ahem test glyphs, so layout
  // checks reflect what users see.
  setUpAll(loadTestFonts);
  setUp(() => db = openTestDb());

  /// Unmounts the app. The in-memory database is simply dropped: closing
  /// it here would wait on stream queries created inside the fake-async
  /// test zone.
  Future<void> closeDb(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('onboarding, dashboard and posting an expense', (tester) async {
    await tester.runAsync(() => db.select(db.keyValues).get());
    await pumpApp(tester);

    expect(find.text('Get started'), findsOneWidget);
    await tester.ensureVisible(find.text('Get started'));
    await tester.tap(find.text('Get started'));
    await settle(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'Sahel');
    await tester.enterText(find.byType(TextFormField).at(1), '2,000');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await settle(tester);

    // Dashboard with the opening cash as personal money.
    expect(find.text('Sahel'), findsOneWidget);
    expect(find.text('Total held in all accounts'), findsOneWidget);
    expect(find.text('৳ 2,000.00'), findsWidgets);

    // Add an expense through the entry form.
    await tester.tap(find.text('Add transaction'));
    await settle(tester);
    await tester.enterText(find.byType(TextFormField).first, '150.75');
    await tester.tap(find.text('From account'));
    await settle(tester);
    await tester.tap(find.text('Cash').last);
    await settle(tester);
    await tester.tap(find.text('Food & groceries'));
    await settle(tester);
    await tester.tap(find.text('Post'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await settle(tester);

    final txs = await tester.runAsync(
      () => db.select(db.ledgerTransactions).get(),
    );
    final expense = txs!.firstWhere((t) => t.type == TxType.expense);
    expect(
      expense.amount,
      15075,
      reason: 'decimal input stored as integer poisha',
    );
    expect(expense.status, TxStatus.posted);
    expect(find.text('৳ 1,849.25'), findsWidgets);

    await closeDb(tester);
  });

  testWidgets('incomplete entry is offered as a draft instead of guessed', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await db.select(db.keyValues).get();
      await TestLedgerSeed.onboard(db);
    });
    await pumpApp(tester);
    await tester.tap(find.text('Add transaction'));
    await settle(tester);
    await tester.enterText(find.byType(TextFormField).first, '500');
    await tester.tap(find.text('Post'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await settle(tester);
    expect(find.text('Save draft'), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Save draft'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await settle(tester);
    final txs = await tester.runAsync(
      () => db.select(db.ledgerTransactions).get(),
    );
    expect(txs!.single.status, TxStatus.draft);
    await closeDb(tester);
  });

  testWidgets('Bengali UI renders with Bengali digits', (tester) async {
    await tester.runAsync(() async {
      await db.select(db.keyValues).get();
      await TestLedgerSeed.onboard(db, cash: 123456);
    });
    await pumpApp(tester, lang: 'bn');
    expect(find.text('সব অ্যাকাউন্টে মোট টাকা'), findsOneWidget);
    expect(find.text('৳ ১,২৩৪.৫৬'), findsWidgets);
    await closeDb(tester);
  });
}
