import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../core/money/money.dart';
import '../../data/db/database.dart';
import '../../data/repositories/reports_repository.dart';
import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/widgets.dart';

final _samityStatusProvider = StreamProvider.autoDispose
    .family<List<SamityMemberStatus>, String>((ref, id) {
      final r = ref.watch(reportsRepoProvider);
      return r.watchLedger(() => r.samityStatus(id));
    });

class SamityScreen extends ConsumerWidget {
  const SamityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final canEdit = ref.watch(actorProvider).can(Permission.manageMasterData);
    return Scaffold(
      appBar: AppBar(title: Text(s.samityTitle)),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              heroTag: 'add-samity',
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const _AddSamitySheet(),
              ),
              icon: const Icon(Icons.add),
              label: Text(s.addSamity),
            )
          : null,
      body: AsyncBody(
        ref.watch(samitiesProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(icon: Icons.groups_2_outlined, title: s.noSamity)
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  Space.lg,
                  Space.md,
                  Space.lg,
                  120,
                ),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
                itemBuilder: (ctx, i) => _SamityCard(list[i]),
              ),
      ),
    );
  }
}

class _SamityCard extends ConsumerWidget {
  const _SamityCard(this.samity);
  final SamityRow samity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final status =
        ref.watch(_samityStatusProvider(samity.id)).value ?? const [];
    final paid = status.fold(0, (a, b) => a + b.paid);
    final due = status.fold(0, (a, b) => a + (b.due > 0 ? b.due : 0));
    return AppCard(
      onTap: () => context.push('/samity/${samity.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.groups_2_outlined),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(samity.name, style: context.text.titleSmall),
              ),
              Pill(
                samity.mode == SamityMode.managed
                    ? s.samityManaged.split('(').first.trim()
                    : s.samityExternal,
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            '${s.contribution}: ${s.money(samity.contributionAmount)} · ${samity.frequency == 'weekly' ? s.weekly : s.monthly}',
            style: context.text.bodySmall?.copyWith(
              color: context.ledger.muted,
            ),
          ),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              Expanded(child: Text('${s.paid}: ${s.money(paid)}')),
              Text(
                '${s.due}: ${s.money(due)}',
                style: TextStyle(
                  color: due > 0
                      ? context.ledger.warning
                      : context.ledger.positive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SamityDetailScreen extends ConsumerWidget {
  const SamityDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final samity = (ref.watch(samitiesProvider).value ?? const [])
        .where((x) => x.id == id)
        .firstOrNull;
    final canWrite = ref.watch(actorProvider).can(Permission.writeTransactions);
    final canEdit = ref.watch(actorProvider).can(Permission.manageMasterData);
    if (samity == null) return Scaffold(appBar: AppBar());
    return Scaffold(
      appBar: AppBar(title: Text(samity.name)),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              heroTag: 'samity-pay',
              onPressed: () => context.push(
                '/tx/new?type=${TxType.samityContribution.name}&samity=$id',
              ),
              icon: const Icon(Icons.add),
              label: Text(s.txType(TxType.samityContribution)),
            )
          : null,
      body: AsyncBody(
        ref.watch(_samityStatusProvider(id)),
        builder: (status) => ListView(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, 120),
          children: [
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: s.paid,
                    value: status.fold(0, (a, b) => a + b.paid),
                  ),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: StatTile(
                    label: s.expected,
                    value: status.fold(0, (a, b) => a + b.expected),
                  ),
                ),
              ],
            ),
            SectionHeader(
              samity.mode == SamityMode.managed ? s.members : s.samity,
              action: samity.mode == SamityMode.managed && canEdit
                  ? s.add
                  : null,
              onAction: () async {
                final persons = ref.read(personsProvider).value ?? const [];
                final v = await showPicker<String>(
                  context,
                  title: s.member,
                  items: [for (final p in persons) PickerItem(p.id, p.name)],
                );
                if (v != null) {
                  await ref
                      .read(masterRepoProvider)
                      .addSamityMember(id, v, joinedOn: DateKey.today());
                  ref.invalidate(_samityStatusProvider(id));
                }
              },
            ),
            Card(
              child: Column(
                children: [
                  for (final m in status)
                    ListTile(
                      title: Text(
                        m.personId.isEmpty ? s.me : names.person(m.personId),
                      ),
                      subtitle: Text(
                        '${s.paid}: ${s.money(m.paid)} / ${s.expected}: ${s.money(m.expected)}',
                      ),
                      trailing: Text(
                        m.due > 0 ? '${s.due} ${s.money(m.due)}' : '✓',
                        style: TextStyle(
                          color: m.due > 0
                              ? context.ledger.warning
                              : context.ledger.positive,
                        ),
                      ),
                      onTap: canWrite && m.personId.isNotEmpty
                          ? () => context.push(
                              '/tx/new?type=${TxType.samityContribution.name}&samity=$id&person=${m.personId}',
                            )
                          : null,
                    ),
                ],
              ),
            ),
            if (canWrite)
              Padding(
                padding: const EdgeInsets.only(top: Space.md),
                child: OutlinedButton.icon(
                  onPressed: () => context.push(
                    '/tx/new?type=${TxType.samityPayout.name}&samity=$id',
                  ),
                  icon: Icon(txIcon(TxType.samityPayout)),
                  label: Text(s.txType(TxType.samityPayout)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddSamitySheet extends ConsumerStatefulWidget {
  const _AddSamitySheet();
  @override
  ConsumerState<_AddSamitySheet> createState() => _AddSamitySheetState();
}

class _AddSamitySheetState extends ConsumerState<_AddSamitySheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  SamityMode _mode = SamityMode.external;
  String _freq = 'monthly';
  int _start = DateKey.firstOfMonth(DateKey.monthKey(DateKey.today()));
  final _members = <String>{};

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final persons = ref.watch(personsProvider).value ?? const [];
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
              Text(s.addSamity, style: context.text.titleLarge),
              const SizedBox(height: Space.md),
              RadioGroup<SamityMode>(
                groupValue: _mode,
                onChanged: (v) => setState(() => _mode = v!),
                child: Column(
                  children: [
                    RadioListTile(
                      value: SamityMode.external,
                      title: Text(s.samityExternal),
                    ),
                    RadioListTile(
                      value: SamityMode.managed,
                      title: Text(s.samityManaged),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: s.name),
                validator: (v) => (v ?? '').trim().isEmpty ? s.required : null,
              ),
              const SizedBox(height: Space.md),
              AmountField(controller: _amount, label: s.contribution),
              const SizedBox(height: Space.md),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'monthly', label: Text(s.monthly)),
                  ButtonSegment(value: 'weekly', label: Text(s.weekly)),
                ],
                selected: {_freq},
                onSelectionChanged: (v) => setState(() => _freq = v.first),
              ),
              const SizedBox(height: Space.md),
              PickerField(
                label: s.startDate,
                value: s.day(_start),
                icon: Icons.event,
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateKey.toDate(_start),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) setState(() => _start = DateKey.fromDate(d));
                },
              ),
              if (_mode == SamityMode.managed) ...[
                const SizedBox(height: Space.md),
                Text(s.members, style: context.text.labelLarge),
                Wrap(
                  spacing: Space.sm,
                  children: [
                    for (final p in persons)
                      FilterChip(
                        label: Text(p.isSelf ? s.me : p.name),
                        selected: _members.contains(p.id),
                        onSelected: (v) => setState(
                          () => v ? _members.add(p.id) : _members.remove(p.id),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: Space.lg),
              FilledButton(
                onPressed: () async {
                  if (!_form.currentState!.validate()) return;
                  try {
                    await ref
                        .read(masterRepoProvider)
                        .createSamity(
                          name: _name.text,
                          mode: _mode,
                          contributionAmount: parsePoisha(_amount.text).poisha!,
                          frequency: _freq,
                          startOn: _start,
                          memberIds: _members.toList(),
                        );
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) showSnack(context, '$e', error: true);
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
