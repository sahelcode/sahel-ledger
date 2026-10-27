import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/widgets.dart';
import 'pdf/pdf_text.dart';
import 'pdf/report_builder.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

enum _Preset { thisMonth, lastMonth, thisYear, all, custom }

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportKind _kind = ReportKind.householdSummary;
  String? _subject;
  _Preset _preset = _Preset.thisMonth;
  int? _from, _to;
  String _lang = 'bn';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _applyPreset(_Preset.thisMonth);
    _lang = ref.read(settingsProvider).locale.languageCode;
  }

  void _applyPreset(_Preset p) {
    final today = DateKey.today();
    final mk = DateKey.monthKey(today);
    final prev = (mk % 100 == 1) ? (mk ~/ 100 - 1) * 100 + 12 : mk - 1;
    setState(() {
      _preset = p;
      switch (p) {
        case _Preset.thisMonth:
          _from = DateKey.firstOfMonth(mk);
          _to = DateKey.lastOfMonth(mk);
        case _Preset.lastMonth:
          _from = DateKey.firstOfMonth(prev);
          _to = DateKey.lastOfMonth(prev);
        case _Preset.thisYear:
          _from = (today ~/ 10000) * 10000 + 101;
          _to = today;
        case _Preset.all:
          _from = null;
          _to = null;
        case _Preset.custom:
          break;
      }
    });
  }

  String _kindLabel(S s, ReportKind k) => switch (k) {
    ReportKind.person => s.reportPerson,
    ReportKind.fund => s.reportFund,
    ReportKind.account => s.reportAccount,
    ReportKind.dateRange => s.reportRange,
    ReportKind.monthly => s.reportMonthly,
    ReportKind.loans => s.reportLoans,
    ReportKind.advances => s.reportAdvances,
    ReportKind.samity => s.reportSamity,
    ReportKind.householdSummary => s.reportSummary,
    ReportKind.reconciliation => s.reportRecon,
  };

  IconData _kindIcon(ReportKind k) => switch (k) {
    ReportKind.person => Icons.person_outline,
    ReportKind.fund => Icons.savings_outlined,
    ReportKind.account => Icons.account_balance_outlined,
    ReportKind.dateRange => Icons.date_range,
    ReportKind.monthly => Icons.bar_chart,
    ReportKind.loans => Icons.handshake_outlined,
    ReportKind.advances => Icons.receipt_long_outlined,
    ReportKind.samity => Icons.groups_2_outlined,
    ReportKind.householdSummary => Icons.family_restroom,
    ReportKind.reconciliation => Icons.fact_check_outlined,
  };

  Future<void> _pickSubject() async {
    final s = S.of(context);
    final List<PickerItem<String>> items = switch (_kind) {
      ReportKind.person => [
        for (final p in (ref.read(personsProvider).value ?? const []).where(
          (p) => !p.isSelf,
        ))
          PickerItem(p.id, p.name),
      ],
      ReportKind.fund => [
        for (final f in ref.read(fundsProvider).value ?? const [])
          PickerItem(f.id, s.fundName(f.name, f.kind)),
      ],
      ReportKind.account => [
        for (final a in ref.read(storageAccountsProvider).value ?? const [])
          PickerItem(a.id, accountLabel(a, s.bn)),
      ],
      ReportKind.samity => [
        for (final x in ref.read(samitiesProvider).value ?? const [])
          PickerItem(x.id, x.name),
      ],
      _ => <PickerItem<String>>[],
    };
    final v = await showPicker<String>(
      context,
      title: s.choose,
      items: items,
      selected: _subject,
    );
    if (v != null) setState(() => _subject = v);
  }

  Future<void> _generate() async {
    final s = S.of(context);
    setState(() => _busy = true);
    try {
      final reportS = S(_lang == 'bn');
      final regular = pw.Font.ttf(
        await rootBundle.load('assets/fonts/HindSiliguri-Regular.ttf'),
      );
      final bold = pw.Font.ttf(
        await rootBundle.load('assets/fonts/HindSiliguri-SemiBold.ttf'),
      );
      final names = ref.read(namesProvider);
      final builder = ReportBuilder(
        reports: ref.read(reportsRepoProvider),
        ledger: ref.read(ledgerRepoProvider),
        names: LedgerNames(
          names.accounts,
          names.funds,
          names.persons,
          _lang == 'bn',
        ),
        kit: PdfTextKit(regular: regular, bold: bold, fontFamily: kFontFamily),
        s: reportS,
        reconSessions: await ref.read(reconRepoProvider).watchAll().first,
      );
      final bytes = await builder.build(
        ReportRequest(
          _kind,
          subjectId: _subject,
          from: _kind == ReportKind.monthly
              ? (_from ?? DateKey.today())
              : _from,
          to: _to,
          preparedFor: _kind == ReportKind.person
              ? names.person(_subject)
              : null,
        ),
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(_kindLabel(s, _kind))),
            body: PdfPreview(
              build: (_) async => bytes,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              pdfFileName: 'sahel-ledger-${_kind.name}-${DateKey.today()}.pdf',
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) showSnack(context, '$e', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    ref.watch(personsProvider);
    ref.watch(fundsProvider);
    ref.watch(storageAccountsProvider);
    ref.watch(samitiesProvider);
    final presets = {
      _Preset.thisMonth: s.thisMonth,
      _Preset.lastMonth: s.bn ? 'গত মাস' : 'Last month',
      _Preset.thisYear: s.bn ? 'এই বছর' : 'This year',
      _Preset.all: s.all,
      _Preset.custom: s.bn ? 'নির্দিষ্ট' : 'Custom',
    };
    final subjectLabel = switch (_kind) {
      ReportKind.person => names.person(_subject),
      ReportKind.fund => names.fund(_subject),
      ReportKind.account => names.account(_subject),
      ReportKind.samity =>
        (ref.read(samitiesProvider).value ?? const [])
            .where((x) => x.id == _subject)
            .firstOrNull
            ?.name,
      _ => null,
    };
    return Scaffold(
      appBar: AppBar(title: Text(s.reportsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, 120),
        children: [
          SectionHeader(s.choose),
          Card(
            child: RadioGroup<ReportKind>(
              groupValue: _kind,
              onChanged: (v) => setState(() {
                _kind = v!;
                _subject = null;
              }),
              child: Column(
                children: [
                  for (final k in ReportKind.values)
                    RadioListTile<ReportKind>(
                      value: k,
                      title: Text(_kindLabel(s, k)),
                      secondary: Icon(_kindIcon(k)),
                    ),
                ],
              ),
            ),
          ),
          if (_kind.needsSubject) ...[
            const SizedBox(height: Space.md),
            PickerField(
              label: _kindLabel(s, _kind),
              value: _subject == null ? null : subjectLabel,
              icon: _kindIcon(_kind),
              onTap: _pickSubject,
            ),
          ],
          SectionHeader(s.period),
          Wrap(
            spacing: Space.sm,
            children: [
              for (final e in presets.entries)
                ChoiceChip(
                  label: Text(e.value),
                  selected: _preset == e.key,
                  onSelected: (_) async {
                    if (e.key != _Preset.custom) return _applyPreset(e.key);
                    final r = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (r != null) {
                      setState(() {
                        _preset = _Preset.custom;
                        _from = DateKey.fromDate(r.start);
                        _to = DateKey.fromDate(r.end);
                      });
                    }
                  },
                ),
            ],
          ),
          if (_from != null || _to != null)
            Padding(
              padding: const EdgeInsets.only(top: Space.sm),
              child: Text(
                '${_from == null ? '…' : s.day(_from!)} – ${_to == null ? '…' : s.day(_to!)}',
                style: context.text.bodySmall?.copyWith(
                  color: context.ledger.muted,
                ),
              ),
            ),
          SectionHeader(s.reportLanguage),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'bn', label: Text('বাংলা')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {_lang},
            onSelectionChanged: (v) => setState(() => _lang = v.first),
          ),
          const SizedBox(height: Space.xl),
          AppCard(
            color: context.ledger.warningContainer,
            child: Row(
              children: [
                Icon(Icons.privacy_tip_outlined, color: context.ledger.warning),
                const SizedBox(width: Space.md),
                Expanded(child: Text(s.pdfWarning)),
              ],
            ),
          ),
          const SizedBox(height: Space.lg),
          FilledButton.icon(
            onPressed: _busy || (_kind.needsSubject && _subject == null)
                ? null
                : _generate,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf),
            label: Text(s.generatePdf),
          ),
        ],
      ),
    );
  }
}
