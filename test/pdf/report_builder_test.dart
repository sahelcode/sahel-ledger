import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/app/providers.dart';
import 'package:sahel_ledger/app/strings.dart';
import 'package:sahel_ledger/domain/access/access.dart';
import 'package:sahel_ledger/domain/ledger/ledger_types.dart';
import 'package:sahel_ledger/domain/ledger/posting_engine.dart';
import 'package:sahel_ledger/features/reports/pdf/pdf_text.dart';
import 'package:sahel_ledger/features/reports/pdf/report_builder.dart';

import '../support/fonts.dart';
import '../support/test_ledger.dart';

/// Extracts the vector text layer of a PDF (Bengali runs are images, so
/// only Latin text and numbers appear). Returns null without poppler.
Future<String?> pdfText(List<int> bytes, String name) async {
  final dir = Directory(
    Platform.environment['PDF_OUT'] ??
        Directory.systemTemp.createTempSync('pdf').path,
  );
  final f = File('${dir.path}/$name.pdf')..writeAsBytesSync(bytes);
  try {
    final r = await Process.run('pdftotext', ['-layout', f.path, '-']);
    return r.exitCode == 0 ? r.stdout as String : null;
  } on ProcessException {
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TestLedger t;
  late PdfTextKit kit;

  setUpAll(() async {
    final (regular, bold) = await loadTestFonts();
    kit = PdfTextKit(regular: regular, bold: bold, fontFamily: 'HindSiliguri');
  });

  setUp(() async {
    t = await TestLedger.create();
    await t.master.updatePerson(
      t.sister,
      expectedVersion: (await t.master.person(t.sister))!.version,
      name: 'রুমা আক্তার',
    );
    await t.income(tk(45000), to: t.bank, date: 20261001);
    await t.post(
      TxInput(
        type: TxType.fundDeposit,
        amount: tk(50000),
        toAccountId: t.bank,
        fundId: t.sisterFund,
        personId: t.sister,
        description: 'বোনের সঞ্চয় জমা',
      ),
      date: 20261002,
    );
    await t.post(
      TxInput(
        type: TxType.fundWithdrawal,
        amount: tk(7500.50),
        fromAccountId: t.bank,
        fundId: t.sisterFund,
        personId: t.sister,
        description: 'Medical expenses withdrawal',
      ),
      date: 20261010,
    );
    await t.post(
      TxInput(
        type: TxType.loanGiven,
        amount: tk(5000),
        fromAccountId: t.bank,
        fundId: t.personal,
        personId: t.sister,
        description: 'ধার — সেলাই মেশিন',
      ),
      date: 20261012,
    );
    await t.expense(tk(1250), from: t.bank, date: 20261015);
  });
  tearDown(() => t.db.close());

  ReportBuilder builder(TestLedger l, {bool bn = true}) => ReportBuilder(
    reports: l.reports,
    ledger: l.ledger,
    names: LedgerNames({}, {}, {}, bn),
    kit: kit,
    s: S(bn),
    now: DateTime(2026, 10, 27, 10, 30),
  );

  Future<ReportBuilder> namedBuilder(TestLedger l, {bool bn = true}) async {
    final accounts = {for (final a in await l.master.allAccounts()) a.id: a};
    final funds = {
      for (final f in await l.db.select(l.db.funds).get()) f.id: f,
    };
    final persons = {
      for (final p in await l.db.select(l.db.persons).get()) p.id: p,
    };
    return ReportBuilder(
      reports: l.reports,
      ledger: l.ledger,
      names: LedgerNames(accounts, funds, persons, bn),
      kit: kit,
      s: S(bn),
      now: DateTime(2026, 10, 27, 10, 30),
    );
  }

  test('every report kind builds in both languages', () async {
    final samity = await t.master.createSamity(
      name: 'পাড়ার সমিতি',
      mode: SamityMode.managed,
      contributionAmount: tk(500),
      startOn: 20261001,
      memberIds: [t.sister],
    );
    for (final bn in [true, false]) {
      final b = await namedBuilder(t, bn: bn);
      for (final k in ReportKind.values) {
        final subject = switch (k) {
          ReportKind.person => t.sister,
          ReportKind.fund => t.sisterFund,
          ReportKind.account => t.bank,
          ReportKind.samity => samity,
          _ => null,
        };
        final bytes = await b.build(
          ReportRequest(k, subjectId: subject, from: 20261001, to: 20261031),
        );
        expect(bytes.length, greaterThan(1000), reason: '$k');
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      }
    }
    expect(builder(t).kit, same(kit));
  });

  test('account statement totals and closing balance', () async {
    final b = await namedBuilder(t, bn: false);
    final bytes = await b.build(
      ReportRequest(
        ReportKind.account,
        subjectId: t.bank,
        from: 20261001,
        to: 20261031,
      ),
    );
    final text = await pdfText(bytes, 'account_statement_en');
    if (text == null) return markTestSkipped('pdftotext not available');
    // 45000 + 50000 - 7500.50 - 5000 - 1250 = 81249.50
    expect(text, contains('৳ 81,249.50'));
    expect(text, contains('৳ 95,000.00'), reason: 'total in');
    expect(text, contains('৳ 13,750.50'), reason: 'total out');
    expect(text, contains('Page 1 of 1'));
  });

  test('person statement in Bengali renders for visual inspection', () async {
    final b = await namedBuilder(t);
    final bytes = await b.build(
      ReportRequest(
        ReportKind.person,
        subjectId: t.sister,
        from: 20261001,
        to: 20261031,
        preparedFor: 'রুমা আক্তার',
      ),
    );
    final text = await pdfText(bytes, 'person_statement_bn');
    if (text == null) return markTestSkipped('pdftotext not available');
    // Bengali digits are vector text: held for her = 50000 - 7500.50.
    expect(text, contains('৳ ৪২,৪৯৯.৫০'));
    expect(text, contains('৳ ৫,০০০.০০'), reason: 'she owes the loan');
  });

  test('a member\'s PDF contains only permitted funds', () async {
    final member = t.as(
      ActorContext(
        actorId: 'uid-ruma',
        role: HouseholdRole.member,
        allowedFundIds: {t.sisterFund},
      ),
    );
    final b = await namedBuilder(member, bn: false);
    final bytes = await b.build(
      const ReportRequest(ReportKind.householdSummary),
    );
    final text = await pdfText(bytes, 'member_summary_en');
    if (text == null) return markTestSkipped('pdftotext not available');
    expect(text, contains('৳ 42,499.50'), reason: 'her fund');
    expect(text, isNot(contains('45,000')), reason: 'owner salary hidden');
    expect(
      text,
      isNot(contains('81,249.50')),
      reason: 'full bank balance hidden',
    );
    expect(
      text,
      isNot(contains('5,000.00')),
      reason: 'loan on personal fund hidden',
    );
  });

  test('a long statement paginates with repeated headers', () async {
    for (var i = 0; i < 120; i++) {
      await t.expense(tk(10 + i), from: t.bank, date: 20261016);
    }
    final b = await namedBuilder(t, bn: false);
    final bytes = await b.build(
      ReportRequest(ReportKind.account, subjectId: t.bank),
    );
    final text = await pdfText(bytes, 'long_statement_en');
    if (text == null) return markTestSkipped('pdftotext not available');
    final pages = RegExp(r'Page \d+ of (\d+)').firstMatch(text)!.group(1)!;
    expect(int.parse(pages), greaterThan(2));
    expect(
      'Balance'.allMatches(text).length,
      greaterThanOrEqualTo(int.parse(pages)),
      reason: 'header on each page',
    );
  });
}
