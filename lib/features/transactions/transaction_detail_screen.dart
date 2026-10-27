import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../data/repositories/attachment_repository.dart';
import '../../data/repositories/audit_log.dart';
import '../../data/repositories/ledger_repository.dart';
import '../../domain/access/access.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/widgets.dart';

final _txDetailProvider = StreamProvider.autoDispose
    .family<(TxWithLines?, List<AuditRow>), String>((ref, id) {
      final repo = ref.watch(ledgerRepoProvider);
      final db = ref.watch(databaseProvider);
      return repo
          .watchTx(id)
          .asyncMap(
            (_) async => (
              await repo.getWithLines(id),
              await AuditLog(db).forEntity('tx', id),
            ),
          );
    });

final _attachmentsProvider = StreamProvider.autoDispose
    .family<List<AttachmentRow>, String>((ref, id) {
      final db = ref.watch(databaseProvider);
      return (db.select(
        db.attachments,
      )..where((a) => a.txId.equals(id))).watch();
    });

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final actor = ref.watch(actorProvider);
    return Scaffold(
      appBar: AppBar(title: Text(s.details)),
      body: AsyncBody(
        ref.watch(_txDetailProvider(id)),
        builder: (data) {
          final (txl, audit) = data;
          if (txl == null) {
            return EmptyState(
              icon: Icons.lock_outline,
              title: s.somethingWrong,
            );
          }
          final t = txl.tx;
          final dir = txDirection(t.type);
          return ListView(
            padding: const EdgeInsets.all(Space.lg),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(txIcon(t.type), color: context.colors.primary),
                        const SizedBox(width: Space.sm),
                        Expanded(
                          child: Text(
                            s.txType(t.type),
                            style: context.text.titleSmall,
                          ),
                        ),
                        StatusPill(t),
                      ],
                    ),
                    const SizedBox(height: Space.md),
                    if (t.amount != null)
                      MoneyText(
                        dir < 0 ? -t.amount! : t.amount!,
                        signed: dir != 0,
                        colorize: dir > 0,
                        style: context.text.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (t.description != null) ...[
                      const SizedBox(height: Space.xs),
                      Text(t.description!, style: context.text.bodyLarge),
                    ],
                    const Divider(height: Space.xl),
                    _kv(context, s.date, s.day(t.dateKey)),
                    if (t.fromAccountId != null)
                      _kv(
                        context,
                        s.fromAccount,
                        names.account(t.fromAccountId),
                      ),
                    if (t.toAccountId != null)
                      _kv(context, s.toAccount, names.account(t.toAccountId)),
                    if (t.fundId != null)
                      _kv(context, s.whoseMoney, names.fund(t.fundId)),
                    if (t.toFundId != null)
                      _kv(context, s.toFund, names.fund(t.toFundId)),
                    if (t.personId != null)
                      _kv(context, s.person, names.person(t.personId)),
                    if (t.categoryId != null)
                      _kv(context, s.category, names.account(t.categoryId)),
                    if (t.fee > 0) _kv(context, s.fee, s.money(t.fee)),
                    if (t.referenceNo != null)
                      _kv(context, s.reference, t.referenceNo!),
                    if (t.notes != null) _kv(context, s.notes, t.notes!),
                    _kv(context, s.syncTitle, s.syncStatus(t.syncStatus)),
                    if (t.reversesTxId != null)
                      _link(
                        context,
                        s.reversalOf,
                        () => context.push('/tx/${t.reversesTxId}'),
                      ),
                    if (t.reversedByTxId != null)
                      _link(
                        context,
                        s.reversed,
                        () => context.push('/tx/${t.reversedByTxId}'),
                      ),
                    if (t.replacesTxId != null)
                      _link(
                        context,
                        s.reverseAndCorrect,
                        () => context.push('/tx/${t.replacesTxId}'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: Space.md),
              _Actions(txl: txl, actor: actor),
              if (txl.lines.isNotEmpty) ...[
                SectionHeader(s.lines),
                Card(
                  child: Column(
                    children: [
                      for (final l in txl.lines)
                        ListTile(
                          dense: true,
                          title: Text(names.account(l.accountId)),
                          subtitle: Text(
                            [
                              names.fund(l.fundId),
                              if (l.personId != null) names.person(l.personId),
                            ].join(' · '),
                          ),
                          trailing: Text(
                            '${l.amount > 0 ? s.debit : s.credit}  ${s.money(l.amount.abs())}',
                            style: TextStyle(
                              fontFeatures: moneyFeatures,
                              color: l.amount > 0
                                  ? context.ledger.positive
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              _Attachments(
                txId: t.id,
                canAdd: actor.can(Permission.writeTransactions),
              ),
              SectionHeader(s.auditTrail),
              Card(
                child: Column(
                  children: [
                    for (final a in audit)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.history, size: 18),
                        title: Text(a.action),
                        subtitle: Text('${a.at.toLocal()} · ${a.actorId}'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            k,
            style: context.text.bodyMedium?.copyWith(
              color: context.ledger.muted,
            ),
          ),
        ),
        Expanded(child: Text(v, style: context.text.bodyMedium)),
      ],
    ),
  );

  Widget _link(BuildContext context, String label, VoidCallback onTap) => Align(
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.link, size: 18),
      label: Text(label),
    ),
  );
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.txl, required this.actor});
  final TxWithLines txl;
  final ActorContext actor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final t = txl.tx;
    final repo = ref.read(ledgerRepoProvider);
    Future<void> run(Future<void> Function() f) async {
      try {
        await f();
      } catch (e) {
        if (context.mounted) showSnack(context, '$e', error: true);
      }
    }

    final buttons = <Widget>[
      if (t.status == TxStatus.draft &&
          actor.can(Permission.writeTransactions)) ...[
        FilledButton.icon(
          onPressed: () => context.push('/tx/${t.id}/edit'),
          icon: const Icon(Icons.edit_note),
          label: Text(s.completeDraft),
        ),
        OutlinedButton.icon(
          onPressed: () => run(() async {
            if (await confirmDialog(
              context,
              title: s.deleteDraft,
              body: s.deleteDraft,
              destructive: true,
            )) {
              await repo.deleteDraft(t.id);
              if (context.mounted) context.pop();
            }
          }),
          icon: const Icon(Icons.delete_outline),
          label: Text(s.deleteDraft),
        ),
      ],
      if (t.status == TxStatus.pending &&
          actor.can(Permission.writeTransactions)) ...[
        FilledButton.icon(
          onPressed: () => run(() => repo.postPending(t.id)),
          icon: const Icon(Icons.check),
          label: Text(s.confirmPending),
        ),
        OutlinedButton(
          onPressed: () => context.push('/tx/${t.id}/edit'),
          child: Text(s.edit),
        ),
        OutlinedButton(
          onPressed: () => run(() async {
            final reason = await promptText(
              context,
              title: s.cancelPending,
              hint: s.reverseReason,
            );
            if (reason != null) await repo.cancelPending(t.id, reason);
          }),
          child: Text(s.cancelPending),
        ),
      ],
      if (t.status == TxStatus.posted &&
          t.reversedByTxId == null &&
          t.type != TxType.reversal &&
          actor.can(Permission.reverseTransactions)) ...[
        OutlinedButton.icon(
          onPressed: () => run(() async {
            final reason = await promptText(
              context,
              title: s.reverse,
              body: s.reverseExplain,
              hint: s.reverseReason,
              minLength: 3,
            );
            if (reason == null) return;
            await repo.reverse(t.id, reason: reason);
            if (context.mounted) showSnack(context, s.reversed);
          }),
          icon: const Icon(Icons.undo),
          label: Text(s.reverse),
        ),
        OutlinedButton.icon(
          onPressed: () => run(() async {
            final reason = await promptText(
              context,
              title: s.reverseAndCorrect,
              body: s.reverseExplain,
              hint: s.reverseReason,
              minLength: 3,
            );
            if (reason == null) return;
            await repo.reverse(t.id, reason: reason);
            if (!context.mounted) return;
            // Re-enter a corrected entry, prefilled from the original.
            final q = <String, String>{
              'type': t.type.name,
              'person': ?t.personId,
              'account': ?(t.fromAccountId ?? t.toAccountId),
              'fund': ?t.fundId,
            };
            await context.push(
              Uri(path: '/tx/new', queryParameters: q).toString(),
            );
          }),
          icon: const Icon(Icons.edit_outlined),
          label: Text(s.reverseAndCorrect),
        ),
      ],
    ];
    if (buttons.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: Space.sm, runSpacing: Space.sm, children: buttons);
  }
}

class _Attachments extends ConsumerWidget {
  const _Attachments({required this.txId, required this.canAdd});
  final String txId;
  final bool canAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final list = ref.watch(_attachmentsProvider(txId)).value ?? const [];
    if (list.isEmpty && !canAdd) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          s.attachments,
          action: canAdd ? s.addReceipt : null,
          onAction: () async {
            final f = await FilePicker.pickFile(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
            );
            final path = f?.path;
            if (path == null) return;
            final dir = Directory(
              p.join(
                (await getApplicationSupportDirectory()).path,
                'attachments',
              ),
            );
            try {
              await AttachmentRepository(
                ref.read(databaseProvider),
                actor: ref.read(actorProvider),
                storageDir: dir,
              ).add(txId, File(path));
            } catch (e) {
              if (context.mounted) showSnack(context, '$e', error: true);
            }
          },
        ),
        for (final a in list)
          ListTile(
            leading: Icon(
              a.fileName.toLowerCase().endsWith('.pdf')
                  ? Icons.picture_as_pdf
                  : Icons.image_outlined,
            ),
            title: Text(a.fileName),
            subtitle: Text('${(a.sizeBytes / 1024).toStringAsFixed(0)} KB'),
          ),
      ],
    );
  }
}
