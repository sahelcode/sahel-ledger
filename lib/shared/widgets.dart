import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/strings.dart';
import '../app/theme.dart';
import '../core/money/money.dart';
import '../data/db/database.dart';
import '../domain/ledger/ledger_types.dart';

/// Amount in Taka with the right digits, sign and semantic colour.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.poisha, {
    super.key,
    this.style,
    this.colorize = false,
    this.signed = false,
    this.compact = false,
    this.color,
  });

  final int poisha;
  final TextStyle? style;
  final bool colorize;
  final bool signed;
  final bool compact;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c =
        color ??
        (colorize
            ? (poisha > 0
                  ? context.ledger.positive
                  : poisha < 0
                  ? context.ledger.negative
                  : null)
            : null);
    final base = style ?? context.text.bodyLarge;
    return Text(
      s.money(poisha, signed: signed, compact: compact),
      style: base?.copyWith(
        color: c ?? base.color,
        fontFeatures: moneyFeatures,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Space.lg),
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.xs, Space.xl, Space.xs, Space.sm),
    child: Row(
      children: [
        Expanded(child: Text(title, style: context.text.titleMedium)),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Space.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 34,
              color: context.colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: Space.lg),
          Text(
            title,
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (body != null) ...[
            const SizedBox(height: Space.sm),
            Text(
              body!,
              style: context.text.bodyMedium?.copyWith(
                color: context.ledger.muted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: Space.lg),
            FilledButton.tonal(onPressed: onAction, child: Text(action!)),
          ],
        ],
      ),
    ),
  );
}

class ErrorState extends StatelessWidget {
  const ErrorState(this.error, {super.key, this.onRetry});
  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return EmptyState(
      icon: Icons.error_outline,
      title: s.somethingWrong,
      body: '$error',
      action: onRetry == null ? null : s.retry,
      onAction: onRetry,
    );
  }
}

/// Renders loading / error / data states of an [AsyncValue] consistently.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody(this.value, {super.key, required this.builder, this.onRetry});
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => builder(value),
    AsyncError(:final error) => ErrorState(error, onRetry: onRetry),
    _ => const Center(
      child: Padding(
        padding: EdgeInsets.all(Space.xl),
        child: CircularProgressIndicator(),
      ),
    ),
  };
}

class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.color, this.background, this.icon});
  final String label;
  final Color? color;
  final Color? background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? context.colors.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background ?? context.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.tx, {super.key});
  final TxRow tx;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final l = context.ledger;
    if (tx.reversedByTxId != null) {
      return Pill(s.reversed, color: l.muted, icon: Icons.undo);
    }
    return switch (tx.status) {
      TxStatus.draft => Pill(
        s.status(tx.status),
        color: l.warning,
        background: l.warningContainer,
        icon: Icons.edit_note,
      ),
      TxStatus.pending => Pill(
        s.status(tx.status),
        color: l.warning,
        background: l.warningContainer,
        icon: Icons.schedule,
      ),
      TxStatus.cancelled => Pill(
        s.status(tx.status),
        color: l.muted,
        icon: Icons.block,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

IconData txIcon(TxType t) => switch (t) {
  TxType.income => Icons.south_west_rounded,
  TxType.expense => Icons.north_east_rounded,
  TxType.transfer => Icons.swap_horiz_rounded,
  TxType.fundDeposit => Icons.savings_outlined,
  TxType.fundWithdrawal => Icons.outbox_outlined,
  TxType.loanGiven => Icons.handshake_outlined,
  TxType.loanRepaymentReceived => Icons.assignment_turned_in_outlined,
  TxType.loanTaken => Icons.account_balance_outlined,
  TxType.loanRepaymentPaid => Icons.task_alt_rounded,
  TxType.advancePaid => Icons.receipt_long_outlined,
  TxType.reimbursementReceived => Icons.replay_rounded,
  TxType.samityContribution => Icons.groups_2_outlined,
  TxType.samityPayout => Icons.group_remove_outlined,
  TxType.interFundLoan => Icons.compare_arrows_rounded,
  TxType.interFundRepayment => Icons.sync_alt_rounded,
  TxType.openingBalance => Icons.flag_outlined,
  TxType.adjustment => Icons.balance_rounded,
  TxType.reversal => Icons.undo_rounded,
};

IconData storageIcon(StorageType? t) => switch (t) {
  StorageType.cash => Icons.payments_outlined,
  StorageType.bank => Icons.account_balance_outlined,
  StorageType.mobileWallet => Icons.phone_android_rounded,
  _ => Icons.wallet_outlined,
};

/// How a transaction changes the user's position, for list colouring:
/// +1 money in, -1 money out, 0 neutral movement.
int txDirection(TxType t) => switch (t) {
  TxType.income ||
  TxType.loanRepaymentReceived ||
  TxType.reimbursementReceived ||
  TxType.fundDeposit ||
  TxType.loanTaken ||
  TxType.samityPayout => 1,
  TxType.expense ||
  TxType.loanGiven ||
  TxType.advancePaid ||
  TxType.fundWithdrawal ||
  TxType.loanRepaymentPaid ||
  TxType.samityContribution => -1,
  _ => 0,
};

class TxTile extends ConsumerWidget {
  const TxTile(this.tx, {super.key, this.onTap});
  final TxRow tx;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final names = ref.watch(namesProvider);
    final dir = txDirection(tx.type);
    final muted =
        tx.reversedByTxId != null ||
        tx.status == TxStatus.cancelled ||
        tx.status == TxStatus.draft;
    final subtitle = <String>[
      s.day(tx.dateKey),
      if (tx.categoryId != null) names.account(tx.categoryId),
      if (tx.personId != null) names.person(tx.personId),
      if (tx.type == TxType.transfer)
        '${names.account(tx.fromAccountId)} → ${names.account(tx.toAccountId)}',
    ].join(' · ');
    final color = dir > 0
        ? context.ledger.positive
        : dir < 0
        ? context.colors.onSurface
        : context.colors.primary;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: dir > 0
            ? context.ledger.positiveContainer
            : context.colors.surfaceContainer,
        foregroundColor: dir > 0
            ? context.ledger.positive
            : context.colors.primary,
        child: Icon(txIcon(tx.type), size: 20),
      ),
      title: Text(
        (tx.description?.isNotEmpty ?? false)
            ? tx.description!
            : s.txType(tx.type),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: muted && tx.reversedByTxId != null
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (tx.amount != null)
            MoneyText(
              dir < 0 ? -tx.amount! : tx.amount!,
              signed: dir != 0,
              color: muted ? context.ledger.muted : color,
              style: context.text.titleSmall,
            ),
          StatusPill(tx),
        ],
      ),
    );
  }
}

/// Amount input that parses straight to poisha (no floating point).
class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    this.label,
    this.autofocus = false,
    this.allowZero = false,
    this.big = false,
    this.optional = false,
    this.onChanged,
  });

  final bool optional;
  final TextEditingController controller;
  final String? label;
  final bool autofocus;
  final bool allowZero;
  final bool big;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.,]')),
      ],
      style: big
          ? context.text.headlineMedium?.copyWith(
              fontFeatures: moneyFeatures,
              fontWeight: FontWeight.w600,
            )
          : context.text.titleMedium?.copyWith(fontFeatures: moneyFeatures),
      decoration: InputDecoration(
        labelText: label ?? s.amount,
        prefixText: '৳ ',
        prefixStyle: big
            ? context.text.headlineMedium
            : context.text.titleMedium,
      ),
      validator: (v) {
        if (optional && (v ?? '').trim().isEmpty) return null;
        final r = parsePoisha(v ?? '', allowZero: allowZero);
        return r.isOk ? null : s.moneyError(r.error!);
      },
    );
  }
}

class PickerItem<T> {
  const PickerItem(
    this.value,
    this.label, {
    this.subtitle,
    this.icon,
    this.trailing,
  });
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
}

/// Searchable bottom-sheet picker.
Future<T?> showPicker<T>(
  BuildContext context, {
  required String title,
  required List<PickerItem<T>> items,
  T? selected,
  String? createLabel,
  Future<T?> Function()? onCreate,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _PickerSheet<T>(
      title: title,
      items: items,
      selected: selected,
      createLabel: createLabel,
      onCreate: onCreate,
    ),
  );
}

class _PickerSheet<T> extends StatefulWidget {
  const _PickerSheet({
    required this.title,
    required this.items,
    this.selected,
    this.createLabel,
    this.onCreate,
  });
  final String title;
  final List<PickerItem<T>> items;
  final T? selected;
  final String? createLabel;
  final Future<T?> Function()? onCreate;

  @override
  State<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T> extends State<_PickerSheet<T>> {
  var _q = '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final q = normalizeDigits(_q.toLowerCase());
    final items = widget.items
        .where(
          (i) =>
              q.isEmpty ||
              i.label.toLowerCase().contains(q) ||
              (i.subtitle?.toLowerCase().contains(q) ?? false),
        )
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (ctx, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: context.text.titleLarge),
                ),
                if (widget.onCreate != null)
                  TextButton.icon(
                    onPressed: () async {
                      final created = await widget.onCreate!();
                      if (created != null && context.mounted) {
                        Navigator.pop(context, created);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: Text(widget.createLabel ?? s.add),
                  ),
              ],
            ),
          ),
          if (widget.items.length > 6)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: s.search,
                ),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: scroll,
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final it = items[i];
                final sel = it.value == widget.selected;
                return ListTile(
                  leading: it.icon == null ? null : Icon(it.icon),
                  title: Text(it.label),
                  subtitle: it.subtitle == null ? null : Text(it.subtitle!),
                  trailing: sel
                      ? Icon(Icons.check_circle, color: context.colors.primary)
                      : it.trailing,
                  selected: sel,
                  onTap: () => Navigator.pop(context, it.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A form row that opens a picker.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
    this.errorText,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;
  final IconData? icon;
  final String? errorText;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(Radii.md),
    child: InputDecorator(
      isEmpty: value == null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        suffixIcon: const Icon(Icons.expand_more),
        errorText: errorText,
      ),
      child: value == null ? null : Text(value!, style: context.text.bodyLarge),
    ),
  );
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  String? confirm,
  bool destructive = false,
}) async {
  final s = S.of(context);
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(s.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: context.colors.error)
              : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirm ?? s.confirm),
        ),
      ],
    ),
  );
  return r ?? false;
}

Future<String?> promptText(
  BuildContext context, {
  required String title,
  String? hint,
  String? body,
  int minLength = 1,
  String? initial,
}) {
  final c = TextEditingController(text: initial);
  final s = S.of(context);
  return showDialog<String>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (body != null) ...[Text(body), const SizedBox(height: Space.md)],
            TextField(
              controller: c,
              autofocus: true,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(hintText: hint),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: c.text.trim().length >= minLength
                ? () => Navigator.pop(ctx, c.text.trim())
                : null,
            child: Text(s.confirm),
          ),
        ],
      ),
    ),
  );
}

void showSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? context.colors.error : null,
      ),
    );
}

String accountLabel(LedgerAccountRow a, bool bn) =>
    bn && a.nameBn != null ? a.nameBn! : a.name;

/// Two-value stat for cards.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.colorize = false,
    this.icon,
    this.onTap,
  });
  final String label;
  final int value;
  final bool colorize;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onTap,
    padding: const EdgeInsets.all(Space.md + 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: context.ledger.muted),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                label,
                style: context.text.labelMedium?.copyWith(
                  color: context.ledger.muted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.sm),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: MoneyText(
            value,
            colorize: colorize,
            style: context.text.titleMedium,
          ),
        ),
      ],
    ),
  );
}
