import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../core/money/money.dart';
import '../../data/repositories/reports_repository.dart';
import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/statement_view.dart';
import '../../shared/widgets.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final canEdit = ref.watch(actorProvider).can(Permission.manageMasterData);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.navAccounts),
          bottom: TabBar(
            tabs: [
              Tab(text: s.accountsTitle),
              Tab(text: s.fundsTitle),
            ],
          ),
        ),
        floatingActionButton: canEdit
            ? Builder(
                builder: (ctx) => FloatingActionButton(
                  heroTag: 'add-acct',
                  onPressed: () => DefaultTabController.of(ctx).index == 0
                      ? showAddAccountSheet(context)
                      : showAddFundSheet(context),
                  child: const Icon(Icons.add),
                ),
              )
            : null,
        body: TabBarView(
          children: [
            AsyncBody(
              ref.watch(accountBalancesProvider),
              builder: (list) {
                final total = list.fold(0, (a, b) => a + b.balance);
                final groups = <StorageType, List<AccountBalance>>{};
                for (final b in list) {
                  (groups[b.account.storageType ?? StorageType.other] ??= [])
                      .add(b);
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    Space.lg,
                    Space.md,
                    Space.lg,
                    120,
                  ),
                  children: [
                    AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.totalHeld,
                              style: context.text.bodyMedium,
                            ),
                          ),
                          MoneyText(total, style: context.text.titleMedium),
                        ],
                      ),
                    ),
                    for (final e in groups.entries) ...[
                      SectionHeader(s.storageType(e.key)),
                      for (final b in e.value)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Space.sm),
                          child: _AccountCard(b),
                        ),
                    ],
                  ],
                );
              },
            ),
            AsyncBody(
              ref.watch(fundBalancesProvider),
              builder: (list) => ListView(
                padding: const EdgeInsets.fromLTRB(
                  Space.lg,
                  Space.md,
                  Space.lg,
                  120,
                ),
                children: [
                  for (final f in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: AppCard(
                        onTap: () => context.push('/funds/${f.fund.id}'),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: f.fund.kind == FundKind.personal
                                  ? context.ledger.positiveContainer
                                  : context.colors.primaryContainer,
                              child: Icon(
                                f.fund.kind == FundKind.personal
                                    ? Icons.person
                                    : Icons.savings_outlined,
                                color: f.fund.kind == FundKind.personal
                                    ? context.ledger.positive
                                    : context.colors.primary,
                              ),
                            ),
                            const SizedBox(width: Space.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.fundName(f.fund.name, f.fund.kind),
                                    style: context.text.titleSmall,
                                  ),
                                  Text(
                                    s.fundKind(f.fund.kind),
                                    style: context.text.bodySmall?.copyWith(
                                      color: context.ledger.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MoneyText(
                              f.net,
                              style: context.text.titleSmall,
                              colorize: f.net < 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard(this.b);
  final AccountBalance b;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final a = b.account;
    return AppCard(
      onTap: () => context.push('/accounts/${a.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: context.colors.primaryContainer,
                child: Icon(
                  storageIcon(a.storageType),
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(accountLabel(a, s.bn), style: context.text.titleSmall),
                    if (a.institution != null || a.numberHint != null)
                      Text(
                        [
                          a.institution,
                          if (a.numberHint != null) '•••• ${a.numberHint}',
                        ].whereType<String>().join(' · '),
                        style: context.text.bodySmall?.copyWith(
                          color: context.ledger.muted,
                        ),
                      ),
                  ],
                ),
              ),
              MoneyText(
                b.balance,
                style: context.text.titleMedium,
                color: b.balance < 0 ? context.ledger.negative : null,
              ),
            ],
          ),
          if (b.byFund.length > 1 ||
              b.byFund.keys.any(
                (f) => names.funds[f]?.kind != FundKind.personal,
              )) ...[
            const SizedBox(height: Space.md),
            for (final e in b.byFund.entries)
              Padding(
                padding: const EdgeInsets.only(left: 56, top: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        names.fund(e.key),
                        style: context.text.bodySmall?.copyWith(
                          color: context.ledger.muted,
                        ),
                      ),
                    ),
                    MoneyText(
                      e.value,
                      style: context.text.bodySmall,
                      color: e.value < 0 ? context.ledger.negative : null,
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

Future<void> showAddAccountSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddAccountSheet(),
    );

class _AddAccountSheet extends ConsumerStatefulWidget {
  const _AddAccountSheet();
  @override
  ConsumerState<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends ConsumerState<_AddAccountSheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _inst = TextEditingController();
  final _digits = TextEditingController();
  final _opening = TextEditingController();
  StorageType _type = StorageType.bank;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Space.lg,
        0,
        Space.lg,
        MediaQuery.viewInsetsOf(context).bottom + Space.lg,
      ),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.addAccount, style: context.text.titleLarge),
              const SizedBox(height: Space.lg),
              SegmentedButton<StorageType>(
                segments: [
                  for (final t in StorageType.values)
                    ButtonSegment(
                      value: t,
                      label: Text(s.storageType(t)),
                      icon: Icon(storageIcon(t)),
                    ),
                ],
                selected: {_type},
                showSelectedIcon: false,
                onSelectionChanged: (v) => setState(() => _type = v.first),
              ),
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.sm,
                children: [
                  for (final quick
                      in _type == StorageType.mobileWallet
                          ? ['bKash', 'Nagad', 'Rocket', 'Upay']
                          : _type == StorageType.bank
                          ? [
                              'Dutch-Bangla Bank',
                              'BRAC Bank',
                              'Islami Bank',
                              'Sonali Bank',
                              'City Bank',
                            ]
                          : const <String>[])
                    ActionChip(
                      label: Text(quick),
                      onPressed: () => setState(() => _name.text = quick),
                    ),
                ],
              ),
              const SizedBox(height: Space.sm),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: s.name),
                validator: (v) => (v ?? '').trim().isEmpty ? s.required : null,
              ),
              if (_type == StorageType.bank) ...[
                const SizedBox(height: Space.md),
                TextFormField(
                  controller: _inst,
                  decoration: InputDecoration(labelText: s.institution),
                ),
              ],
              if (_type != StorageType.cash) ...[
                const SizedBox(height: Space.md),
                TextFormField(
                  controller: _digits,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: s.lastDigits,
                    helperText: s.lastDigitsHint,
                  ),
                ),
              ],
              const SizedBox(height: Space.md),
              AmountField(
                controller: _opening,
                label: s.openingCash,
                allowZero: true,
                optional: true,
              ),
              const SizedBox(height: Space.lg),
              FilledButton(
                onPressed: _saving
                    ? null
                    : () async {
                        if (!_form.currentState!.validate()) return;
                        setState(() => _saving = true);
                        try {
                          await ref
                              .read(masterRepoProvider)
                              .createStorageAccount(
                                name: _name.text,
                                type: _type,
                                institution: _inst.text.trim().isEmpty
                                    ? null
                                    : _inst.text.trim(),
                                numberHint: _digits.text.trim().isEmpty
                                    ? null
                                    : _digits.text.trim(),
                                openingBalance:
                                    parsePoisha(
                                      _opening.text,
                                      allowZero: true,
                                    ).poisha ??
                                    0,
                              );
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          if (context.mounted) {
                            showSnack(context, '$e', error: true);
                          }
                          setState(() => _saving = false);
                        }
                      },
                child: Text(s.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showAddFundSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddFundSheet(),
    );

class _AddFundSheet extends ConsumerStatefulWidget {
  const _AddFundSheet();
  @override
  ConsumerState<_AddFundSheet> createState() => _AddFundSheetState();
}

class _AddFundSheetState extends ConsumerState<_AddFundSheet> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  FundKind _kind = FundKind.entrusted;
  String? _owner;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final persons = (ref.watch(personsProvider).value ?? const [])
        .where((p) => !p.isSelf)
        .toList();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Space.lg,
        0,
        Space.lg,
        MediaQuery.viewInsetsOf(context).bottom + Space.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.addFund, style: context.text.titleLarge),
          const SizedBox(height: Space.lg),
          SegmentedButton<FundKind>(
            segments: [
              for (final k in [FundKind.entrusted, FundKind.purpose])
                ButtonSegment(value: k, label: Text(s.fundKind(k))),
            ],
            selected: {_kind},
            onSelectionChanged: (v) => setState(() => _kind = v.first),
          ),
          const SizedBox(height: Space.md),
          PickerField(
            label: s.fundOwner,
            value: persons.where((p) => p.id == _owner).firstOrNull?.name,
            icon: Icons.person_outline,
            onTap: () async {
              final v = await showPicker<String>(
                context,
                title: s.fundOwner,
                items: [for (final p in persons) PickerItem(p.id, p.name)],
              );
              if (v != null) setState(() => _owner = v);
            },
          ),
          const SizedBox(height: Space.md),
          TextField(
            controller: _name,
            decoration: InputDecoration(
              labelText: s.name,
              hintText: s.purposeExample,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: Space.md),
          TextField(
            controller: _desc,
            decoration: InputDecoration(
              labelText: '${s.description} (${s.optional})',
            ),
          ),
          const SizedBox(height: Space.lg),
          FilledButton(
            onPressed: _name.text.trim().isEmpty || _owner == null
                ? null
                : () async {
                    try {
                      await ref
                          .read(masterRepoProvider)
                          .createFund(
                            name: _name.text,
                            kind: _kind,
                            ownerPersonId: _owner,
                            description: _desc.text.trim().isEmpty
                                ? null
                                : _desc.text.trim(),
                          );
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        showSnack(context, '$e', error: true);
                      }
                    }
                  },
            child: Text(s.save),
          ),
        ],
      ),
    );
  }
}

class AccountDetailScreen extends ConsumerWidget {
  const AccountDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final balance = (ref.watch(accountBalancesProvider).value ?? const [])
        .where((b) => b.account.id == id)
        .firstOrNull;
    final canWrite = ref.watch(actorProvider).can(Permission.writeTransactions);
    return Scaffold(
      appBar: AppBar(
        title: Text(names.account(id)),
        actions: [
          if (canWrite)
            IconButton(
              tooltip: s.reconTitle,
              icon: const Icon(Icons.fact_check_outlined),
              onPressed: () => context.push('/reconciliation'),
            ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              heroTag: 'acct-add',
              onPressed: () => context.push('/tx/new?account=$id'),
              icon: const Icon(Icons.add),
              label: Text(s.addTransaction),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 120),
        children: [
          if (balance != null)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.currentBalance,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.ledger.muted,
                    ),
                  ),
                  MoneyText(
                    balance.balance,
                    style: context.text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (balance.byFund.isNotEmpty) ...[
                    const Divider(height: Space.xl),
                    Text(s.whoOwnsThis, style: context.text.labelLarge),
                    const SizedBox(height: Space.sm),
                    for (final e in balance.byFund.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(child: Text(names.fund(e.key))),
                            MoneyText(
                              e.value,
                              color: e.value < 0
                                  ? context.ledger.negative
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    if (balance.byFund.values.any((v) => v < 0))
                      Padding(
                        padding: const EdgeInsets.only(top: Space.sm),
                        child: Text(
                          s.overdrawnFund,
                          style: TextStyle(color: context.ledger.negative),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          SectionHeader(s.statement),
          StatementView(spec: StatementSpec(StatementKind.account, id)),
        ],
      ),
    );
  }
}

class FundDetailScreen extends ConsumerWidget {
  const FundDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final f = (ref.watch(fundBalancesProvider).value ?? const [])
        .where((x) => x.fund.id == id)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(names.fund(id))),
      body: ListView(
        padding: const EdgeInsets.all(Space.lg),
        children: [
          if (f != null)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.fundKind(f.fund.kind),
                    style: context.text.labelLarge?.copyWith(
                      color: context.ledger.muted,
                    ),
                  ),
                  if (f.fund.ownerPersonId != null &&
                      f.fund.kind != FundKind.personal)
                    Text(
                      '${s.fundOwner}: ${names.person(f.fund.ownerPersonId)}',
                    ),
                  const SizedBox(height: Space.sm),
                  MoneyText(
                    f.net,
                    style: context.text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    colorize: f.net < 0,
                  ),
                  if (f.fund.description != null) Text(f.fund.description!),
                ],
              ),
            ),
          SectionHeader(s.statement),
          StatementView(spec: StatementSpec(StatementKind.fund, id)),
        ],
      ),
    );
  }
}
