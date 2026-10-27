import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../data/repositories/reports_repository.dart';
import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/statement_view.dart';
import '../../shared/widgets.dart';

/// Bottom sheet to add a person. Returns the new id.
Future<String?> showAddPersonSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => const _AddPersonSheet(),
  );
}

class _AddPersonSheet extends ConsumerStatefulWidget {
  const _AddPersonSheet();
  @override
  ConsumerState<_AddPersonSheet> createState() => _AddPersonSheetState();
}

class _AddPersonSheetState extends ConsumerState<_AddPersonSheet> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  String _relation = 'relative';
  bool _fund = false;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.addPerson, style: context.text.titleLarge),
          const SizedBox(height: Space.lg),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: s.name),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: Space.md),
          DropdownButtonFormField<String>(
            initialValue: _relation,
            decoration: InputDecoration(labelText: s.relation),
            items: [
              for (final r in S.relations)
                DropdownMenuItem(value: r, child: Text(s.relationLabel(r))),
            ],
            onChanged: (v) => setState(() => _relation = v ?? 'other'),
          ),
          const SizedBox(height: Space.md),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: '${s.phone} (${s.optional})',
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _fund,
            onChanged: (v) => setState(() => _fund = v),
            title: Text(s.holdsMoneyWithMe),
            subtitle: Text(s.holdsMoneyHint),
          ),
          const SizedBox(height: Space.md),
          FilledButton(
            onPressed: _name.text.trim().isEmpty || _saving
                ? null
                : () async {
                    setState(() => _saving = true);
                    try {
                      final id = await ref
                          .read(masterRepoProvider)
                          .createPerson(
                            name: _name.text,
                            relation: _relation,
                            phone: _phone.text.trim().isEmpty
                                ? null
                                : _phone.text.trim(),
                            createEntrustedFund: _fund,
                          );
                      if (context.mounted) Navigator.pop(context, id);
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
    );
  }
}

final _peopleSummariesProvider = StreamProvider<List<PersonSummary>>((ref) {
  final r = ref.watch(reportsRepoProvider);
  final persons = ref.watch(personsProvider).value ?? const [];
  return r.watchLedger(() async {
    final out = <PersonSummary>[];
    for (final p in persons.where((p) => !p.isSelf)) {
      final x = await r.personSummary(p.id);
      if (x != null) out.add(x);
    }
    return out;
  });
});

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final canEdit = ref.watch(actorProvider).can(Permission.manageMasterData);
    return Scaffold(
      appBar: AppBar(title: Text(s.peopleTitle)),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              heroTag: 'add-person',
              onPressed: () => showAddPersonSheet(context, ref),
              tooltip: s.addPerson,
              child: const Icon(Icons.person_add_alt_1),
            )
          : null,
      body: AsyncBody(
        ref.watch(_peopleSummariesProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(
                icon: Icons.people_outline,
                title: s.noPeople,
                body: s.noPeopleBody,
                action: canEdit ? s.addPerson : null,
                onAction: () => showAddPersonSheet(context, ref),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  Space.lg,
                  Space.sm,
                  Space.lg,
                  120,
                ),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
                itemBuilder: (ctx, i) => _PersonCard(list[i]),
              ),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard(this.p);
  final PersonSummary p;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final owes = p.loanReceivable + p.advanceReceivable;
    return AppCard(
      onTap: () => context.push('/people/${p.person.id}'),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: context.colors.primaryContainer,
            child: Text(
              p.person.name.characters.first.toUpperCase(),
              style: TextStyle(
                color: context.colors.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.person.name, style: context.text.titleSmall),
                Wrap(
                  spacing: Space.sm,
                  children: [
                    Text(
                      s.relationLabel(p.person.relation),
                      style: context.text.bodySmall?.copyWith(
                        color: context.ledger.muted,
                      ),
                    ),
                    if (p.heldForPerson != 0)
                      Text(
                        '${s.heldForPerson}: ${s.money(p.heldForPerson)}',
                        style: context.text.bodySmall,
                      ),
                    if (owes != 0)
                      Text(
                        '${s.theyOweYou}: ${s.money(owes)}',
                        style: context.text.bodySmall?.copyWith(
                          color: context.ledger.positive,
                        ),
                      ),
                    if (p.loanPayable != 0)
                      Text(
                        '${s.youOweThem}: ${s.money(p.loanPayable)}',
                        style: context.text.bodySmall?.copyWith(
                          color: context.ledger.negative,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class PersonDetailScreen extends ConsumerWidget {
  const PersonDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final canWrite = ref.watch(actorProvider).can(Permission.writeTransactions);
    return AsyncBody(
      ref.watch(personSummaryProvider(id)),
      builder: (p) {
        if (p == null) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyState(icon: Icons.person_off, title: s.somethingWrong),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(p.person.name),
              actions: [
                IconButton(
                  tooltip: s.generatePdf,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: () => context.push('/reports'),
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: s.details),
                  Tab(text: s.statement),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.all(Space.lg),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            label: s.heldForPerson,
                            value: p.heldForPerson,
                          ),
                        ),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: StatTile(
                            label: s.theyOweYou,
                            value: p.loanReceivable + p.advanceReceivable,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.md),
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            label: s.youOweThem,
                            value: p.loanPayable,
                          ),
                        ),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: StatTile(
                            label: s.netPosition,
                            value: p.netOwedToPerson,
                            colorize: true,
                          ),
                        ),
                      ],
                    ),
                    if (p.ownedFunds.isNotEmpty) ...[
                      SectionHeader(s.fundsTitle),
                      for (final f in p.ownedFunds)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Space.sm),
                          child: AppCard(
                            onTap: () => context.push('/funds/${f.fund.id}'),
                            child: Row(
                              children: [
                                const Icon(Icons.savings_outlined),
                                const SizedBox(width: Space.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(f.fund.name),
                                      Text(
                                        s.fundKind(f.fund.kind),
                                        style: context.text.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                MoneyText(
                                  f.net,
                                  style: context.text.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                    if (canWrite) ...[
                      SectionHeader(s.addTransaction),
                      Wrap(
                        spacing: Space.sm,
                        runSpacing: Space.sm,
                        children: [
                          for (final t in [
                            TxType.fundDeposit,
                            TxType.fundWithdrawal,
                            TxType.loanGiven,
                            TxType.loanRepaymentReceived,
                            TxType.loanTaken,
                            TxType.loanRepaymentPaid,
                            TxType.advancePaid,
                            TxType.reimbursementReceived,
                          ])
                            ActionChip(
                              avatar: Icon(txIcon(t), size: 18),
                              label: Text(s.txType(t)),
                              onPressed: () => context.push(
                                '/tx/new?type=${t.name}&person=$id',
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(Space.lg),
                  children: [
                    Text(s.dues, style: context.text.titleMedium),
                    const SizedBox(height: Space.sm),
                    StatementView(
                      spec: StatementSpec(StatementKind.personDues, id),
                    ),
                    for (final f in p.ownedFunds) ...[
                      const SizedBox(height: Space.lg),
                      Text(f.fund.name, style: context.text.titleMedium),
                      const SizedBox(height: Space.sm),
                      StatementView(
                        spec: StatementSpec(StatementKind.fund, f.fund.id),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
