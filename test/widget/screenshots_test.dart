// Opt-in visual check: renders key screens with real fonts and seeded data.
//
//   SCREENSHOT_DIR=/tmp/shots flutter test test/widget/screenshots_test.dart
//
// Skipped unless SCREENSHOT_DIR is set.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/app/app.dart';
import 'package:sahel_ledger/app/providers.dart';
import 'package:sahel_ledger/app/router.dart';
import 'package:sahel_ledger/data/db/database.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';
import 'package:sahel_ledger/domain/ledger/posting_engine.dart';

import '../support/fonts.dart';
import '../support/test_ledger.dart';

final _dir = Platform.environment['SCREENSHOT_DIR'];

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 15; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 15)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _shot(WidgetTester tester, String name) async {
  await _settle(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('shot')),
  );
  final image = await tester.runAsync(() => boundary.toImage(pixelRatio: 1.0));
  final bytes = await tester.runAsync(
    () => image!.toByteData(format: ui.ImageByteFormat.png),
  );
  File('$_dir/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
}

Future<TestLedger> _seed(AppDatabase db) async {
  final t = await TestLedger.create(db: db);
  final sister = (await t.master.person(t.sister))!;
  await t.master.updatePerson(
    t.sister,
    expectedVersion: sister.version,
    name: 'রুমা (বোন)',
  );
  final uncle = await t.master.createPerson(name: 'মামা', relation: 'uncle');
  final edu = await t.master.createFund(
    name: 'মামার শিক্ষা সহায়তা',
    kind: FundKind.purpose,
    ownerPersonId: uncle,
  );
  final today = DateKey.today();
  await t.income(
    tk(65000),
    to: t.bank,
    date: today,
    category: 'cat.inc.salary',
  );
  await t.post(
    TxInput(
      type: TxType.fundDeposit,
      amount: tk(50000),
      toAccountId: t.bank,
      fundId: t.sisterFund,
      personId: t.sister,
    ),
    date: today,
  );
  await t.post(
    TxInput(
      type: TxType.fundDeposit,
      amount: tk(20000),
      toAccountId: t.bank,
      fundId: edu,
      personId: uncle,
    ),
    date: today,
  );
  await t.post(
    TxInput(
      type: TxType.transfer,
      amount: tk(8000),
      fromAccountId: t.bank,
      toAccountId: t.bkash,
      fundId: t.personal,
    ),
    date: today,
  );
  await t.post(
    TxInput(
      type: TxType.loanGiven,
      amount: tk(5000),
      fromAccountId: t.bkash,
      fundId: t.personal,
      personId: t.friend,
      description: 'দোকানের জন্য ধার',
    ),
    date: today,
  );
  await t.expense(tk(2450.50), from: t.bkash, date: today);
  await t.post(
    TxInput(
      type: TxType.advancePaid,
      amount: tk(1200),
      fromAccountId: t.cash,
      fundId: t.personal,
      personId: t.sister,
    ),
    date: today,
    status: TxStatus.draft,
  );
  return t;
}

void main() {
  setUpAll(() async {
    await loadTestFonts();
    final icons = FontLoader('MaterialIcons')
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File(
              '${Platform.environment['FLUTTER_ROOT'] ?? '/opt/sdk/flutter'}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
            ).readAsBytesSync(),
          ),
        ),
      );
    await icons.load();
  });

  for (final lang in ['bn', 'en']) {
    for (final dark in [false, true]) {
      testWidgets('screens $lang ${dark ? 'dark' : 'light'}', (tester) async {
        if (_dir == null) return markTestSkipped('set SCREENSHOT_DIR');
        tester.view.physicalSize = const Size(412, 915);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        final db = openTestDb();
        await tester.runAsync(() => _seed(db));
        final settings = (await tester.runAsync(() async {
          await db.setKv(Kv.locale, lang);
          await db.setKv(Kv.themeMode, dark ? 'dark' : 'light');
          return AppSettings.load(db);
        }))!;
        final container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(db),
            initialSettingsProvider.overrideWithValue(settings),
          ],
        );
        await tester.pumpWidget(
          RepaintBoundary(
            key: const ValueKey('shot'),
            child: UncontrolledProviderScope(
              container: container,
              child: const SahelLedgerApp(),
            ),
          ),
        );
        final suffix = '${lang}_${dark ? 'dark' : 'light'}';
        await _shot(tester, '01_dashboard_$suffix');
        if (dark) return;
        final router = container.read(routerProvider);
        for (final (name, path) in [
          ('02_entry', '/tx/new'),
          ('03_people', '/people'),
          ('04_accounts', '/accounts'),
          ('05_loans', '/loans'),
          ('06_reports', '/reports'),
          ('07_recon', '/reconciliation'),
          ('08_more', '/more'),
        ]) {
          router.go(path);
          await _shot(tester, '${name}_$suffix');
        }
      });
    }
  }
}
