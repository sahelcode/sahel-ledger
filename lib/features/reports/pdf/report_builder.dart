import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../app/providers.dart' show LedgerNames;
import '../../../app/strings.dart';
import '../../../data/db/database.dart';
import '../../../data/repositories/ledger_repository.dart';
import '../../../data/repositories/reconciliation_repository.dart';
import '../../../data/repositories/reports_repository.dart';
import '../../../domain/ledger/ledger_types.dart';
import 'pdf_text.dart';

enum ReportKind {
  person,
  fund,
  account,
  dateRange,
  monthly,
  loans,
  advances,
  samity,
  householdSummary,
  reconciliation;

  bool get needsSubject =>
      this == person || this == fund || this == account || this == samity;
}

class ReportRequest {
  const ReportRequest(
    this.kind, {
    this.subjectId,
    this.from,
    this.to,
    this.preparedFor,
  });
  final ReportKind kind;
  final String? subjectId;
  final int? from;
  final int? to;
  final String? preparedFor;
}

/// Builds A4 PDF reports from ledger queries.
///
/// All figures come from [ReportsRepository], which applies the viewer's
/// fund scope, so a report can never include data the viewer may not see.
class ReportBuilder {
  ReportBuilder({
    required this.reports,
    required this.ledger,
    required this.names,
    required this.kit,
    required this.s,
    this.reconSessions = const [],
    DateTime? now,
  }) : now = now ?? DateTime.now();

  final ReportsRepository reports;
  final LedgerRepository ledger;
  final LedgerNames names;
  final PdfTextKit kit;
  final S s;
  final List<ReconSessionRow> reconSessions;
  final DateTime now;

  static const _navy = PdfColor.fromInt(0xFF0B2545);
  static const _slate = PdfColor.fromInt(0xFF64748B);
  static const _line = PdfColor.fromInt(0xFFE2E8F0);
  static const _zebra = PdfColor.fromInt(0xFFF8FAFC);
  static const _green = PdfColor.fromInt(0xFF047857);
  static const _red = PdfColor.fromInt(0xFFB91C1C);
  static const _pageWidth = 595.28 - 2 * 36;
  static const maxRows = 5000;

  String _m(int v) => s.money(v);

  Future<Uint8List> build(ReportRequest r) async {
    final (title, subtitle, body) = await _content(r);
    final period = r.from == null && r.to == null
        ? s.bn
              ? 'সব সময়'
              : 'All time'
        : '${r.from == null ? '…' : s.day(r.from!)} – ${r.to == null ? s.day(DateKey.today(now)) : s.day(r.to!)}';
    final header = await kit.text(title, size: 9, color: _slate);
    final titleW = await kit.text(
      title,
      size: 18,
      isBold: true,
      color: _navy,
      maxWidth: _pageWidth,
    );
    final subW = subtitle == null
        ? null
        : await kit.text(
            subtitle,
            size: 11,
            color: _slate,
            maxWidth: _pageWidth,
          );
    final periodW = await kit.text('${s.period}: $period', size: 9);
    final generated = s.bn ? 'তৈরির সময়' : 'Generated';
    final genW = await kit.text(
      '$generated: ${s.day(DateKey.fromDate(now))} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      size: 9,
    );
    final prepared = r.preparedFor == null
        ? null
        : await kit.text(
            '${s.bn ? 'যাঁর জন্য প্রস্তুত' : 'Prepared for'}: ${r.preparedFor}',
            size: 9,
          );
    final confidential = await kit.text(
      s.bn
          ? 'গোপনীয় — এটি একটি কপি; শেয়ার করার পর ফেরত নেওয়া যায় না।'
          : 'Confidential — this is a copy and cannot be recalled once shared.',
      size: 7,
      color: _slate,
    );
    final brand = await kit.text(
      '${s.appName} · ${s.tagline}',
      size: 7,
      color: _slate,
    );

    final doc = pw.Document(
      title: title,
      author: s.appName,
      creator: s.appName,
    );
    doc.addPage(
      pw.MultiPage(
        maxPages: 400,
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 40),
          theme: pw.ThemeData.withFont(base: kit.regular, bold: kit.bold),
        ),
        header: (ctx) => ctx.pageNumber == 1
            ? pw.SizedBox()
            : pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.only(bottom: 6),
                margin: const pw.EdgeInsets.only(bottom: 8),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: _line)),
                ),
                child: header,
              ),
        footer: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(top: 6),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: _line)),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [brand, confidential],
                ),
              ),
              pw.Text(
                s.bn
                    ? 'পৃষ্ঠা ${s.num(ctx.pageNumber)} / ${s.num(ctx.pagesCount)}'
                    : 'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                style: kit.style(size: 8, color: _slate),
              ),
            ],
          ),
        ),
        build: (ctx) => [
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 10),
            margin: const pw.EdgeInsets.only(bottom: 12),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: _navy, width: 2)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                titleW,
                ?subW,
                pw.SizedBox(height: 6),
                periodW,
                genW,
                ?prepared,
              ],
            ),
          ),
          ...body,
        ],
      ),
    );
    return doc.save();
  }

  // ------------------------------------------------------------ helpers

  Future<pw.Widget> _h2(String t) async => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
    child: await kit.text(
      t,
      size: 12,
      isBold: true,
      color: _navy,
      maxWidth: _pageWidth,
    ),
  );

  Future<pw.Widget> _kvGrid(List<(String, int)> items) async {
    final cells = <pw.Widget>[];
    for (final (k, v) in items) {
      cells.add(
        pw.Container(
          width: (_pageWidth - 16) / 3,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _line),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              await kit.text(
                k,
                size: 8,
                color: _slate,
                maxWidth: (_pageWidth - 16) / 3 - 16,
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                _m(v),
                style: kit.style(
                  size: 11,
                  isBold: true,
                  color: v < 0 ? _red : PdfColors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return pw.Wrap(spacing: 8, runSpacing: 8, children: cells);
  }

  /// Table with repeated header, zebra rows, right-aligned money columns.
  Future<pw.Widget> _table({
    required List<String> headers,
    required List<double> widths,
    required Set<int> numeric,
    required List<List<String>> rows,
    List<String>? totals,
  }) async {
    final total = widths.fold(0.0, (a, b) => a + b);
    final colW = [for (final w in widths) w / total * _pageWidth];
    Future<pw.Widget> cell(
      String t,
      int i, {
      bool bold = false,
      PdfColor color = PdfColors.black,
    }) async {
      final align = numeric.contains(i)
          ? pw.TextAlign.right
          : pw.TextAlign.left;
      final w = await kit.text(
        t,
        size: 8,
        isBold: bold,
        color: color,
        maxWidth: colW[i] - 8,
        align: align,
      );
      return pw.Container(
        alignment: numeric.contains(i)
            ? pw.Alignment.topRight
            : pw.Alignment.topLeft,
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: w,
      );
    }

    final tableRows = <pw.TableRow>[
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(color: _navy),
        children: [
          for (var i = 0; i < headers.length; i++)
            await cell(headers[i], i, bold: true, color: PdfColors.white),
        ],
      ),
    ];
    for (var r = 0; r < rows.length; r++) {
      tableRows.add(
        pw.TableRow(
          decoration: r.isOdd ? const pw.BoxDecoration(color: _zebra) : null,
          children: [
            for (var i = 0; i < rows[r].length; i++) await cell(rows[r][i], i),
          ],
        ),
      );
    }
    if (totals != null) {
      tableRows.add(
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: _navy, width: 1)),
          ),
          children: [
            for (var i = 0; i < totals.length; i++)
              await cell(totals[i], i, bold: true),
          ],
        ),
      );
    }
    return pw.Table(
      columnWidths: {
        for (var i = 0; i < colW.length; i++) i: pw.FixedColumnWidth(colW[i]),
      },
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: _line, width: 0.5),
      ),
      children: tableRows,
    );
  }

  Future<List<pw.Widget>> _statement(
    Statement st, {
    String? inLabel,
    String? outLabel,
  }) async {
    final rows = <List<String>>[
      ['', s.opening, '', '', '', _m(st.opening)],
      for (final r in st.rows.take(maxRows))
        [
          s.day(r.dateKey),
          '${r.description ?? s.txType(r.type)}${r.reversed ? ' (${s.reversed})' : ''}',
          r.counterAccountId == null ? '' : names.account(r.counterAccountId),
          r.debit == 0 ? '' : _m(r.debit),
          r.credit == 0 ? '' : _m(r.credit),
          _m(r.running),
        ],
    ];
    return [
      await _table(
        headers: [
          s.date,
          s.description,
          s.account,
          inLabel ?? s.debit,
          outLabel ?? s.credit,
          s.balance,
        ],
        widths: [62, 130, 90, 70, 70, 78],
        numeric: {3, 4, 5},
        rows: rows,
        totals: [
          '',
          s.closing,
          '',
          _m(st.totalDebit),
          _m(st.totalCredit),
          _m(st.closing),
        ],
      ),
      if (st.rows.length > maxRows)
        await kit.text('… ${st.rows.length - maxRows}', size: 8),
    ];
  }

  // ------------------------------------------------------------ content

  Future<(String, String?, List<pw.Widget>)> _content(ReportRequest r) async {
    final from = r.from, to = r.to;
    switch (r.kind) {
      case ReportKind.account:
        final id = r.subjectId!;
        final st = await reports.statement(
          StatementSpec(StatementKind.account, id, from: from, to: to),
        );
        final bal = (await reports.accountBalances(
          asOf: to,
          includeArchived: true,
        )).where((b) => b.account.id == id).firstOrNull;
        return (
          s.reportAccount,
          names.account(id),
          [
            if (bal != null && bal.byFund.isNotEmpty) ...[
              await _h2(s.whoOwnsThis),
              await _table(
                headers: [s.fundsTitle, s.balance],
                widths: [3, 1],
                numeric: {1},
                rows: [
                  for (final e in bal.byFund.entries)
                    [names.fund(e.key), _m(e.value)],
                ],
                totals: [s.total, _m(bal.balance)],
              ),
            ],
            await _h2(s.statement),
            ...await _statement(st),
          ],
        );
      case ReportKind.fund:
        final id = r.subjectId!;
        final st = await reports.statement(
          StatementSpec(StatementKind.fund, id, from: from, to: to),
        );
        final f = names.funds[id];
        return (
          s.reportFund,
          '${names.fund(id)}${f?.ownerPersonId != null && f?.kind != FundKind.personal ? ' — ${names.person(f!.ownerPersonId)}' : ''}',
          [await _h2(s.statement), ...await _statement(st)],
        );
      case ReportKind.person:
        final id = r.subjectId!;
        final p = (await reports.personSummary(id, asOf: to))!;
        final dues = await reports.statement(
          StatementSpec(StatementKind.personDues, id, from: from, to: to),
        );
        final body = <pw.Widget>[
          await _kvGrid([
            (s.heldForPerson, p.heldForPerson),
            (s.theyOweYou, p.loanReceivable + p.advanceReceivable),
            (s.youOweThem, p.loanPayable),
            (s.netPosition, p.netOwedToPerson),
          ]),
        ];
        for (final f in p.ownedFunds) {
          final st = await reports.statement(
            StatementSpec(StatementKind.fund, f.fund.id, from: from, to: to),
          );
          body
            ..add(await _h2('${s.fundsTitle}: ${f.fund.name}'))
            ..addAll(await _statement(st));
        }
        if (p.capitalByFund.isNotEmpty) {
          body
            ..add(await _h2(s.bn ? 'তহবিলে জমা' : 'Contributions'))
            ..add(
              await _table(
                headers: [s.fundsTitle, s.amount],
                widths: [3, 1],
                numeric: {1},
                rows: [
                  for (final e in p.capitalByFund.entries)
                    [names.fund(e.key), _m(e.value)],
                ],
              ),
            );
        }
        if (dues.rows.isNotEmpty || dues.opening != 0) {
          body
            ..add(await _h2(s.dues))
            ..addAll(
              await _statement(
                dues,
                inLabel: s.bn ? 'পাওনা বাড়ে' : 'Owes more',
                outLabel: s.bn ? 'পাওনা কমে' : 'Owes less',
              ),
            );
        }
        return (s.reportPerson, p.person.name, body);
      case ReportKind.dateRange:
        final rows = <List<String>>[];
        TxCursor? cursor;
        while (rows.length < maxRows) {
          final page = await ledger.page(
            TxFilter(fromDate: from, toDate: to, statuses: {TxStatus.posted}),
            limit: 500,
            after: cursor,
          );
          if (page.isEmpty) break;
          for (final t in page) {
            rows.add([
              s.day(t.dateKey),
              s.txType(t.type),
              [
                t.description,
                names.person(t.personId) == '—'
                    ? null
                    : names.person(t.personId),
              ].whereType<String>().join(' · '),
              [
                if (t.fromAccountId != null) names.account(t.fromAccountId),
                if (t.toAccountId != null) names.account(t.toAccountId),
              ].join(' → '),
              t.amount == null ? '' : _m(t.amount!),
            ]);
          }
          cursor = TxCursor.of(page.last);
        }
        return (
          s.reportRange,
          null,
          [
            await _table(
              headers: [
                s.date,
                s.whatHappened,
                s.description,
                s.account,
                s.amount,
              ],
              widths: [62, 90, 140, 120, 80],
              numeric: {4},
              rows: rows.reversed.toList(),
            ),
          ],
        );
      case ReportKind.monthly:
        final mk = DateKey.monthKey(from ?? DateKey.today(now));
        final a = DateKey.firstOfMonth(mk), b = DateKey.lastOfMonth(mk);
        final inc = await reports.categoryTotals(income: true, from: a, to: b);
        final exp = await reports.categoryTotals(income: false, from: a, to: b);
        final ti = inc.fold(0, (x, y) => x + y.total),
            te = exp.fold(0, (x, y) => x + y.total);
        final budgets = await reports.budgetStatus(mk);
        return (
          s.reportMonthly,
          s.month(mk),
          [
            await _kvGrid([
              (s.income, ti),
              (s.expense, te),
              (s.bn ? 'নিট' : 'Net', ti - te),
            ]),
            await _h2(s.income),
            await _table(
              headers: [s.category, s.amount],
              widths: [3, 1],
              numeric: {1},
              rows: [
                for (final c in inc)
                  [names.account(c.category.id), _m(c.total)],
              ],
              totals: [s.total, _m(ti)],
            ),
            await _h2(s.expense),
            await _table(
              headers: [s.category, s.amount],
              widths: [3, 1],
              numeric: {1},
              rows: [
                for (final c in exp)
                  [names.account(c.category.id), _m(c.total)],
              ],
              totals: [s.total, _m(te)],
            ),
            if (budgets.isNotEmpty) ...[
              await _h2(s.budgets),
              await _table(
                headers: [s.category, s.limit, s.spent],
                widths: [2, 1, 1],
                numeric: {1, 2},
                rows: [
                  for (final x in budgets)
                    [names.account(x.category.id), _m(x.limit), _m(x.spent)],
                ],
              ),
            ],
            await kit.text(
              s.bn
                  ? 'নিজের অ্যাকাউন্টের মধ্যে স্থানান্তর, ঋণ ও আমানত আয়-ব্যয়ে গোনা হয়নি।'
                  : 'Transfers between own accounts, loans and entrusted deposits are not counted as income or expense.',
              size: 8,
              color: _slate,
              maxWidth: _pageWidth,
            ),
          ],
        );
      case ReportKind.loans:
      case ReportKind.advances:
        final kinds = r.kind == ReportKind.loans
            ? {ObligationKind.loanGiven, ObligationKind.loanTaken}
            : {ObligationKind.advance};
        final list = await reports.obligations(kinds: kinds);
        final body = <pw.Widget>[];
        for (final k in kinds) {
          final items = list.where((o) => o.obligation.kind == k).toList();
          if (items.isEmpty) continue;
          body
            ..add(
              await _h2(switch (k) {
                ObligationKind.loanGiven => s.lent,
                ObligationKind.loanTaken => s.borrowed,
                ObligationKind.advance => s.advances,
              }),
            )
            ..add(
              await _table(
                headers: [
                  s.person,
                  s.date,
                  s.description,
                  s.principal,
                  s.outstanding,
                ],
                widths: [100, 62, 140, 80, 80],
                numeric: {3, 4},
                rows: [
                  for (final o in items)
                    [
                      names.person(o.obligation.personId),
                      s.day(o.obligation.openedOn),
                      o.obligation.title ?? '',
                      _m(o.principal),
                      _m(o.outstanding),
                    ],
                ],
                totals: [
                  s.total,
                  '',
                  '',
                  _m(items.fold(0, (a, b) => a + b.principal)),
                  _m(items.fold(0, (a, b) => a + b.outstanding)),
                ],
              ),
            );
          for (final o in items.where((o) => o.outstanding != 0)) {
            final txs = await ledger.page(
              TxFilter(obligationId: o.obligation.id),
              limit: 200,
            );
            body
              ..add(
                await _h2(
                  '${names.person(o.obligation.personId)} — ${s.money(o.outstanding)}',
                ),
              )
              ..add(
                await _table(
                  headers: [s.date, s.whatHappened, s.amount],
                  widths: [1, 3, 1],
                  numeric: {2},
                  rows: [
                    for (final t in txs.reversed.where(
                      (t) => t.status == TxStatus.posted,
                    ))
                      [s.day(t.dateKey), s.txType(t.type), _m(t.amount ?? 0)],
                  ],
                ),
              );
          }
        }
        if (body.isEmpty) body.add(await kit.text(s.noLoans, size: 10));
        return (
          r.kind == ReportKind.loans ? s.reportLoans : s.reportAdvances,
          null,
          body,
        );
      case ReportKind.samity:
        final id = r.subjectId!;
        final status = await reports.samityStatus(id, asOf: to);
        return (
          s.reportSamity,
          null,
          [
            await _table(
              headers: [s.member, s.paid, s.expected, s.due],
              widths: [3, 1, 1, 1],
              numeric: {1, 2, 3},
              rows: [
                for (final m in status)
                  [
                    m.personId.isEmpty ? s.me : names.person(m.personId),
                    _m(m.paid),
                    _m(m.expected),
                    _m(m.due),
                  ],
              ],
              totals: [
                s.total,
                _m(status.fold(0, (a, b) => a + b.paid)),
                _m(status.fold(0, (a, b) => a + b.expected)),
                _m(status.fold(0, (a, b) => a + b.due)),
              ],
            ),
          ],
        );
      case ReportKind.householdSummary:
        final d = await reports.dashboard(asOf: to);
        final accounts = await reports.accountBalances(asOf: to);
        final funds = await reports.fundBalances(asOf: to);
        final obligations = await reports.obligations();
        return (
          s.reportSummary,
          null,
          [
            await _kvGrid([
              (s.totalHeld, d.totalStorage),
              (s.yourMoney, d.personalStorage),
              (s.heldForOthers, d.entrustedStorage),
              (s.personalNetWorth, d.personalNet),
              (s.owedToYou, d.receivables),
              (s.youOwe, d.payables),
            ]),
            await _h2(s.accountsTitle),
            await _table(
              headers: [s.account, s.fundsTitle, s.balance],
              widths: [2, 3, 1],
              numeric: {2},
              rows: [
                for (final b in accounts)
                  [
                    names.account(b.account.id),
                    b.byFund.entries
                        .map((e) => '${names.fund(e.key)}: ${_m(e.value)}')
                        .join('\n'),
                    _m(b.balance),
                  ],
              ],
              totals: [s.total, '', _m(d.totalStorage)],
            ),
            await _h2(s.fundsTitle),
            await _table(
              headers: [
                s.fundsTitle,
                s.fundOwner,
                s.accountsTitle,
                s.netPosition,
              ],
              widths: [3, 2, 1.3, 1.3],
              numeric: {2, 3},
              rows: [
                for (final f in funds)
                  [
                    names.fund(f.fund.id),
                    f.fund.kind == FundKind.personal
                        ? s.me
                        : names.person(f.fund.ownerPersonId),
                    _m(f.storage),
                    _m(f.net),
                  ],
              ],
            ),
            await _h2(s.loansTitle),
            await _table(
              headers: [s.person, s.whatHappened, s.outstanding],
              widths: [2, 2, 1],
              numeric: {2},
              rows: [
                for (final o in obligations.where((o) => o.outstanding != 0))
                  [
                    names.person(o.obligation.personId),
                    switch (o.obligation.kind) {
                      ObligationKind.loanGiven => s.lent,
                      ObligationKind.loanTaken => s.borrowed,
                      ObligationKind.advance => s.advances,
                    },
                    _m(o.outstanding),
                  ],
              ],
            ),
            await kit.text(
              s.notHeldNote,
              size: 8,
              color: _slate,
              maxWidth: _pageWidth,
            ),
          ],
        );
      case ReportKind.reconciliation:
        final diags = await reports.diagnostics();
        return (
          s.reportRecon,
          null,
          [
            await _table(
              headers: [
                s.date,
                s.account,
                s.ledgerBalance,
                s.countedBalance,
                s.difference,
                s.balance,
              ],
              widths: [62, 110, 80, 80, 70, 90],
              numeric: {2, 3, 4},
              rows: [
                for (final x in reconSessions)
                  [
                    s.day(x.asOfDateKey),
                    names.account(x.accountId),
                    _m(x.expectedBalance),
                    _m(x.actualBalance),
                    _m(x.actualBalance - x.expectedBalance),
                    switch (x.status) {
                      ReconStatus.matched => s.matched,
                      ReconStatus.adjusted => s.adjusted,
                      ReconStatus.pendingApproval => s.pendingApproval,
                      _ => s.unresolved,
                    },
                  ],
              ],
            ),
            await _h2(s.healthChecks),
            if (diags.isEmpty)
              await kit.text(s.allClear, size: 10, color: _green)
            else
              await _table(
                headers: [s.healthChecks, s.amount],
                widths: [3, 1],
                numeric: {1},
                rows: [
                  for (final d in diags)
                    [
                      s.diagnostic(d.kind),
                      d.amount == null ? '' : _m(d.amount!),
                    ],
                ],
              ),
          ],
        );
    }
  }
}
