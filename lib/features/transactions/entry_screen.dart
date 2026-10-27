import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../core/money/money.dart';
import '../../data/db/database.dart';
import '../../data/repositories/ledger_repository.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../domain/ledger/posting_engine.dart';
import '../../shared/widgets.dart';
import '../people/people_screen.dart' show showAddPersonSheet;

/// Quick, conditional transaction entry.
class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({
    super.key,
    this.initialType,
    this.personId,
    this.accountId,
    this.fundId,
    this.obligationId,
    this.samityId,
    this.editId,
  });

  final TxType? initialType;
  final String? personId;
  final String? accountId;
  final String? fundId;
  final String? obligationId;
  final String? samityId;

  /// Id of a draft or pending entry to complete.
  final String? editId;

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _fee = TextEditingController();
  final _desc = TextEditingController();
  final _notes = TextEditingController();
  final _ref = TextEditingController();

  /// Stable id for this form: re-submitting never duplicates.
  late String _draftId =
      widget.editId ??
      TxDraft(input: const TxInput(type: TxType.expense), dateKey: 0).id;

  TxType _type = TxType.expense;
  String? _from, _to, _fund, _toFund, _person, _category, _obligation, _samity;
  int _date = DateKey.today();
  bool _pending = false;
  bool _showAdvanced = false;
  bool _saving = false;
  Map<String, String> _errors = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? TxType.expense;
    _person = widget.personId;
    _fund = widget.fundId;
    _obligation = widget.obligationId;
    _samity = widget.samityId;
    if (widget.accountId != null) {
      if (_type.usesToAccount) {
        _to = widget.accountId;
      } else {
        _from = widget.accountId;
      }
    }
    _load();
  }

  Future<void> _load() async {
    final personal = await ref.read(databaseProvider).getKv(Kv.personalFundId);
    if (widget.editId != null) {
      final t =
          (await ref.read(ledgerRepoProvider).getWithLines(widget.editId!))?.tx;
      if (t != null) {
        _type = t.type;
        _amount.text = t.amount == null ? '' : poishaToInput(t.amount!);
        _fee.text = t.fee == 0 ? '' : poishaToInput(t.fee);
        _desc.text = t.description ?? '';
        _notes.text = t.notes ?? '';
        _ref.text = t.referenceNo ?? '';
        _from = t.fromAccountId;
        _to = t.toAccountId;
        _fund = t.fundId;
        _toFund = t.toFundId;
        _person = t.personId;
        _category = t.categoryId;
        _obligation = t.obligationId;
        _samity = t.samityId;
        _date = t.dateKey;
        _pending = t.status == TxStatus.pending;
        _draftId = t.id;
      }
    }
    _fund ??= personal;
    if (mounted) setState(() => _loaded = true);
  }

  TxInput _input() {
    final amount = parsePoisha(_amount.text).poisha;
    final fee = _fee.text.trim().isEmpty
        ? 0
        : (parsePoisha(_fee.text).poisha ?? 0);
    final t = _type;
    return TxInput(
      type: t,
      amount: amount,
      fromAccountId: t.usesFromAccount || t.usesToFund ? _from : null,
      toAccountId: t.usesToAccount || (t.usesToFund && _to != null)
          ? _to
          : null,
      fundId: t.usesSamity ? (_samityIsManaged ? null : _fund) : _fund,
      toFundId: t.usesToFund ? _toFund : null,
      personId: t.needsPerson || t.usesCategory || t.usesSamity
          ? _person
          : null,
      categoryId: t.usesCategory ? _category : null,
      obligationId: t.usesObligation ? _obligation : null,
      samityId: t.usesSamity ? _samity : null,
      fee: t == TxType.transfer ? fee : 0,
      description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
    );
  }

  bool get _samityIsManaged {
    final list = ref.read(samitiesProvider).value ?? const [];
    return list.where((s) => s.id == _samity).firstOrNull?.mode ==
        SamityMode.managed;
  }

  TxDraft _draft() => TxDraft(
    id: _draftId,
    input: _input(),
    dateKey: _date,
    notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    referenceNo: _ref.text.trim().isEmpty ? null : _ref.text.trim(),
  );

  Future<void> _saveDraft() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(ledgerRepoProvider).save(_draft(), target: TxStatus.draft);
      if (!mounted) return;
      showSnack(context, S.of(context).draftSaved);
      context.pop();
    } catch (e) {
      if (mounted) showSnack(context, '$e', error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    if (_saving) return;
    final s = S.of(context);
    final formOk = _form.currentState!.validate();
    final repo = ref.read(ledgerRepoProvider);
    final draft = _draft();
    final plan = await repo.preview(draft);
    setState(() => _errors = plan.errors);
    if (!formOk || !plan.isComplete) {
      if (!mounted) return;
      final asDraft = await confirmDialog(
        context,
        title: s.saveDraft,
        body: s.draftWhy,
        confirm: s.saveDraft,
      );
      if (asDraft) await _saveDraft();
      return;
    }
    final dupes = await repo.possibleDuplicates(draft);
    if (!mounted) return;
    if (dupes.isNotEmpty) {
      final go = await confirmDialog(
        context,
        title: s.duplicateWarning,
        body: s.duplicateBody(dupes.length),
        confirm: s.postAnyway,
      );
      if (!go || !mounted) return;
    }
    final needsReview = !const {
      TxType.expense,
      TxType.income,
      TxType.transfer,
    }.contains(_type);
    if (needsReview) {
      final ok = await _review(plan.lines);
      if (ok != true || !mounted) return;
    }
    setState(() => _saving = true);
    try {
      await repo.save(
        draft,
        target: _pending ? TxStatus.pending : TxStatus.posted,
      );
      if (!mounted) return;
      showSnack(context, s.posted);
      context.pop();
    } on TxValidationException catch (e) {
      setState(() => _errors = e.errors);
    } catch (e) {
      if (mounted) showSnack(context, '$e', error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool?> _review(List<LineSpec> lines) {
    final s = S.of(context);
    final names = ref.read(namesProvider);
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.reviewTitle, style: ctx.text.titleLarge),
              const SizedBox(height: Space.xs),
              Text(
                s.txType(_type),
                style: ctx.text.bodyMedium?.copyWith(color: ctx.ledger.muted),
              ),
              const SizedBox(height: Space.md),
              MoneyText(
                parsePoisha(_amount.text).poisha ?? 0,
                style: ctx.text.headlineMedium,
              ),
              const SizedBox(height: Space.md),
              Text(s.lines, style: ctx.text.labelLarge),
              const SizedBox(height: Space.sm),
              for (final l in lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        l.amount > 0
                            ? Icons.add_circle_outline
                            : Icons.remove_circle_outline,
                        size: 18,
                        color: l.amount > 0
                            ? ctx.ledger.positive
                            : ctx.ledger.negative,
                      ),
                      const SizedBox(width: Space.sm),
                      Expanded(
                        child: Text(
                          '${names.account(l.accountId)}'
                          '${l.personId != null ? ' · ${names.person(l.personId)}' : ''}\n${names.fund(l.fundId)}',
                          style: ctx.text.bodyMedium,
                        ),
                      ),
                      MoneyText(l.amount.abs(), style: ctx.text.bodyMedium),
                    ],
                  ),
                ),
              if (_pending) ...[
                const SizedBox(height: Space.sm),
                Text(
                  s.pendingHint,
                  style: ctx.text.bodySmall?.copyWith(
                    color: ctx.ledger.warning,
                  ),
                ),
              ],
              const SizedBox(height: Space.lg),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(_pending ? s.markPending : s.post),
              ),
              const SizedBox(height: Space.sm),
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(s.back),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------- pickers

  Future<void> _pickAccount(bool from) async {
    final s = S.of(context);
    final balances = ref.read(accountBalancesProvider).value ?? const [];
    final v = await showPicker<String>(
      context,
      title: from ? s.fromAccount : s.toAccount,
      selected: from ? _from : _to,
      items: [
        for (final b in balances)
          PickerItem(
            b.account.id,
            accountLabel(b.account, s.bn),
            subtitle: s.money(b.balance),
            icon: storageIcon(b.account.storageType),
          ),
      ],
    );
    if (v != null) setState(() => from ? _from = v : _to = v);
  }

  Future<void> _pickFund(bool target) async {
    final s = S.of(context);
    final funds = ref.read(fundBalancesProvider).value ?? const [];
    final names = ref.read(namesProvider);
    final v = await showPicker<String>(
      context,
      title: target ? s.toFund : s.whoseMoney,
      selected: target ? _toFund : _fund,
      items: [
        for (final f in funds)
          PickerItem(
            f.fund.id,
            s.fundName(f.fund.name, f.fund.kind),
            subtitle:
                '${s.fundKind(f.fund.kind)}'
                '${f.fund.ownerPersonId != null && f.fund.kind != FundKind.personal ? ' · ${names.person(f.fund.ownerPersonId)}' : ''}'
                ' · ${s.money(f.net)}',
            icon: f.fund.kind == FundKind.personal
                ? Icons.person
                : Icons.savings_outlined,
          ),
      ],
    );
    if (v != null) setState(() => target ? _toFund = v : _fund = v);
  }

  Future<void> _pickPerson() async {
    final s = S.of(context);
    final persons = (ref.read(personsProvider).value ?? const []).where(
      (p) => !p.isSelf,
    );
    final v = await showPicker<String>(
      context,
      title: s.person,
      selected: _person,
      createLabel: s.addPerson,
      onCreate: () => showAddPersonSheet(context, ref),
      items: [
        for (final p in persons)
          PickerItem(
            p.id,
            p.name,
            subtitle: s.relationLabel(p.relation),
            icon: Icons.person_outline,
          ),
      ],
    );
    if (v != null) {
      setState(() {
        _person = v;
        _obligation = null;
        // Deposits default to the person's own entrusted fund.
        if (_type == TxType.fundDeposit || _type == TxType.fundWithdrawal) {
          final f = (ref.read(fundsProvider).value ?? const []).where(
            (f) => f.ownerPersonId == v && f.kind != FundKind.personal,
          );
          if (f.length == 1) _fund = f.first.id;
        }
      });
    }
  }

  Future<void> _pickCategory() async {
    final s = S.of(context);
    final cats =
        ref.read(categoriesProvider(_type == TxType.income)).value ?? const [];
    final v = await showPicker<String>(
      context,
      title: s.category,
      selected: _category,
      items: [for (final c in cats) PickerItem(c.id, accountLabel(c, s.bn))],
    );
    if (v != null) setState(() => _category = v);
  }

  Future<void> _pickObligation() async {
    final s = S.of(context);
    final kind = PostingEngine.obligationKindFor(_type);
    final names = ref.read(namesProvider);
    final list = (ref.read(obligationsProvider).value ?? const [])
        .where(
          (o) =>
              o.obligation.kind == kind &&
              o.outstanding > 0 &&
              (_person == null || o.obligation.personId == _person),
        )
        .toList();
    final v = await showPicker<String>(
      context,
      title: s.linkToExisting,
      selected: _obligation,
      items: [
        for (final o in list)
          PickerItem(
            o.obligation.id,
            '${names.person(o.obligation.personId)} · ${s.money(o.outstanding)}',
            subtitle:
                '${s.day(o.obligation.openedOn)}${o.obligation.title != null ? ' · ${o.obligation.title}' : ''}',
          ),
      ],
    );
    if (v != null) {
      final o = list.firstWhere((x) => x.obligation.id == v);
      setState(() {
        _obligation = v;
        _person = o.obligation.personId;
        _fund = o.obligation.fundId;
      });
    }
  }

  Future<void> _pickSamity() async {
    final s = S.of(context);
    final list = ref.read(samitiesProvider).value ?? const [];
    final v = await showPicker<String>(
      context,
      title: s.samity,
      selected: _samity,
      items: [
        for (final x in list)
          PickerItem(x.id, x.name, icon: Icons.groups_2_outlined),
      ],
    );
    if (v != null) setState(() => _samity = v);
  }

  Future<void> _pickType() async {
    final s = S.of(context);
    final v = await showPicker<TxType>(
      context,
      title: s.whatHappened,
      selected: _type,
      items: [
        for (final t in TxType.userSelectable)
          PickerItem(
            t,
            s.txType(t),
            subtitle: s.txTypeHint(t),
            icon: txIcon(t),
          ),
      ],
    );
    if (v != null) _setType(v);
  }

  void _setType(TxType t) => setState(() {
    if (_type.usesCategory != t.usesCategory ||
        (_type == TxType.income) != (t == TxType.income)) {
      _category = null;
    }
    _type = t;
    _errors = {};
    if (t == TxType.fundDeposit || t == TxType.fundWithdrawal) {
      final f = ref
          .read(fundsProvider)
          .value
          ?.where((x) => x.id == _fund)
          .firstOrNull;
      if (f?.kind == FundKind.personal) _fund = null;
    }
  });

  // --------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    // Keep pickers' data warm.
    ref.watch(accountBalancesProvider);
    ref.watch(fundBalancesProvider);
    ref.watch(obligationsProvider);
    ref.watch(samitiesProvider);
    ref.watch(categoriesProvider(true));
    ref.watch(categoriesProvider(false));
    String? err(String f) =>
        _errors[f] == null ? null : s.fieldError(f, _errors[f]!);
    final t = _type;
    final managedSamity = t.usesSamity && _samityIsManaged;
    final quick = [
      TxType.expense,
      TxType.income,
      TxType.transfer,
      TxType.loanGiven,
      TxType.fundDeposit,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editId == null ? s.addTransaction : s.completeDraft),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Space.lg,
                  Space.sm,
                  Space.lg,
                  140,
                ),
                children: [
                  SizedBox(
                    height: 42,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final q in quick)
                          Padding(
                            padding: const EdgeInsets.only(right: Space.sm),
                            child: ChoiceChip(
                              avatar: Icon(txIcon(q), size: 18),
                              label: Text(
                                s.txType(q).split(' ').take(3).join(' '),
                              ),
                              selected: _type == q,
                              onSelected: (_) => _setType(q),
                            ),
                          ),
                        ActionChip(
                          avatar: const Icon(Icons.more_horiz, size: 18),
                          label: Text(s.more),
                          onPressed: _pickType,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.md),
                  AppCard(
                    onTap: _pickType,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Space.lg,
                      vertical: Space.md,
                    ),
                    child: Row(
                      children: [
                        Icon(txIcon(t), color: context.colors.primary),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.txType(t), style: context.text.titleSmall),
                              Text(
                                s.txTypeHint(t),
                                style: context.text.bodySmall?.copyWith(
                                  color: context.ledger.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.expand_more),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.lg),
                  AmountField(
                    controller: _amount,
                    autofocus: widget.editId == null,
                    big: true,
                  ),
                  const SizedBox(height: Space.lg),
                  if (t.usesSamity) ...[
                    PickerField(
                      label: s.samity,
                      value: _samity == null
                          ? null
                          : (ref.read(samitiesProvider).value ?? const [])
                                .where((x) => x.id == _samity)
                                .firstOrNull
                                ?.name,
                      icon: Icons.groups_2_outlined,
                      errorText: err('samity'),
                      onTap: _pickSamity,
                    ),
                    const SizedBox(height: Space.md),
                  ],
                  if (t.needsPerson || managedSamity) ...[
                    PickerField(
                      label: managedSamity ? s.member : s.person,
                      value: _person == null ? null : names.person(_person),
                      icon: Icons.person_outline,
                      errorText: err('person'),
                      onTap: _pickPerson,
                    ),
                    const SizedBox(height: Space.md),
                  ],
                  if (t.usesObligation &&
                      !const {
                        TxType.loanGiven,
                        TxType.loanTaken,
                        TxType.advancePaid,
                      }.contains(t)) ...[
                    PickerField(
                      label: s.linkToExisting,
                      value: _obligation == null ? null : s.loan,
                      icon: Icons.link,
                      errorText: err('obligation'),
                      onTap: _pickObligation,
                    ),
                    const SizedBox(height: Space.md),
                  ],
                  if (t.usesFromAccount || t.usesToFund) ...[
                    PickerField(
                      label: t == TxType.samityContribution && managedSamity
                          ? s.toAccount
                          : t.usesToFund
                          ? s.account
                          : s.fromAccount,
                      value: _from == null ? null : names.account(_from),
                      icon: Icons.north_east,
                      errorText: err('fromAccount'),
                      onTap: () => _pickAccount(true),
                    ),
                    const SizedBox(height: Space.md),
                  ],
                  if (t.usesToAccount) ...[
                    PickerField(
                      label: t == TxType.samityPayout && managedSamity
                          ? s.fromAccount
                          : s.toAccount,
                      value: _to == null ? null : names.account(_to),
                      icon: Icons.south_west,
                      errorText: err('toAccount'),
                      onTap: () => _pickAccount(false),
                    ),
                    const SizedBox(height: Space.md),
                  ],
                  if (t.usesCategory) ...[
                    _CategoryChips(
                      income: t == TxType.income,
                      selected: _category,
                      onSelected: (c) => setState(() => _category = c),
                      onMore: _pickCategory,
                    ),
                    if (err('category') != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Space.xs,
                          left: Space.md,
                        ),
                        child: Text(
                          err('category')!,
                          style: TextStyle(
                            color: context.colors.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: Space.md),
                  ],
                  if (!managedSamity && _obligation == null) ...[
                    PickerField(
                      label: s.whoseMoney,
                      value: _fund == null ? null : names.fund(_fund),
                      icon: Icons.savings_outlined,
                      errorText: err('fund'),
                      onTap: () => _pickFund(false),
                    ),
                    const SizedBox(height: Space.md),
                  ],
                  if (t.usesToFund) ...[
                    PickerField(
                      label: s.toFund,
                      value: _toFund == null ? null : names.fund(_toFund),
                      icon: Icons.savings,
                      errorText: err('toFund'),
                      onTap: () => _pickFund(true),
                    ),
                    const SizedBox(height: Space.md),
                  ],
                  PickerField(
                    label: s.date,
                    value: s.day(_date),
                    icon: Icons.event_outlined,
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: DateKey.toDate(_date),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (d != null) {
                        setState(() => _date = DateKey.fromDate(d));
                      }
                    },
                  ),
                  const SizedBox(height: Space.md),
                  TextFormField(
                    controller: _desc,
                    decoration: InputDecoration(
                      labelText: '${s.description} (${s.optional})',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: Space.sm),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showAdvanced = !_showAdvanced),
                    icon: Icon(
                      _showAdvanced ? Icons.expand_less : Icons.expand_more,
                    ),
                    label: Text(s.advanced),
                  ),
                  if (_showAdvanced) ...[
                    if (t == TxType.transfer) ...[
                      AmountField(
                        controller: _fee,
                        label: '${s.fee} (${s.optional})',
                        optional: true,
                      ),
                      const SizedBox(height: Space.md),
                    ],
                    TextFormField(
                      controller: _ref,
                      decoration: InputDecoration(labelText: s.reference),
                    ),
                    const SizedBox(height: Space.md),
                    TextFormField(
                      controller: _notes,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(labelText: s.notes),
                    ),
                    const SizedBox(height: Space.sm),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _pending,
                      onChanged: (v) => setState(() => _pending = v),
                      title: Text(s.markPending),
                      subtitle: Text(s.pendingHint),
                    ),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.lg,
            Space.sm,
            Space.lg,
            Space.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : _saveDraft,
                  child: Text(s.saveDraft),
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(_pending ? s.markPending : s.post),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChips extends ConsumerWidget {
  const _CategoryChips({
    required this.income,
    required this.selected,
    required this.onSelected,
    required this.onMore,
  });
  final bool income;
  final String? selected;
  final ValueChanged<String> onSelected;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final cats = ref.watch(categoriesProvider(income)).value ?? const [];
    final shown = cats.take(8).toList();
    if (selected != null && !shown.any((c) => c.id == selected)) {
      final sel = cats.where((c) => c.id == selected).firstOrNull;
      if (sel != null) shown.insert(0, sel);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.category,
          style: context.text.labelLarge?.copyWith(color: context.ledger.muted),
        ),
        const SizedBox(height: Space.sm),
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            for (final c in shown)
              ChoiceChip(
                label: Text(accountLabel(c, s.bn)),
                selected: c.id == selected,
                onSelected: (_) => onSelected(c.id),
              ),
            ActionChip(
              avatar: const Icon(Icons.more_horiz, size: 18),
              label: Text(s.more),
              onPressed: onMore,
            ),
          ],
        ),
      ],
    );
  }
}
