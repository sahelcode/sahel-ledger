import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../data/repositories/ledger_repository.dart';
import '../../domain/ledger/ledger_types.dart';
import '../../shared/widgets.dart';

/// Paginated, filterable history. Pages are fetched with a keyset cursor,
/// so even years of entries never load into memory at once.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key, this.initial = const TxFilter(), this.title});
  final TxFilter initial;
  final String? title;

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  static const _pageSize = 40;
  late TxFilter _filter = widget.initial;
  final _rows = <TxRow>[];
  bool _loading = false;
  bool _done = false;
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 600) {
        _more();
      }
    });
    _reload();
  }

  Future<void> _reload() async {
    _rows.clear();
    _done = false;
    await _more();
  }

  Future<void> _more() async {
    if (_loading || _done) return;
    setState(() => _loading = true);
    final page = await ref
        .read(ledgerRepoProvider)
        .page(
          _filter,
          limit: _pageSize,
          after: _rows.isEmpty ? null : TxCursor.of(_rows.last),
        );
    if (!mounted) return;
    setState(() {
      _rows.addAll(page);
      _done = page.length < _pageSize;
      _loading = false;
    });
  }

  void _apply(TxFilter f) {
    setState(() => _filter = f);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    // Reload when the ledger changes (new entry, sync).
    ref.listen(recentTxProvider, (_, _) => _reload());
    final names = ref.watch(namesProvider);
    final active = <Widget>[
      if (_filter.statuses != null)
        InputChip(
          label: Text(_filter.statuses!.map(s.status).join(', ')),
          onDeleted: () => _apply(_copy(statuses: null, clearStatuses: true)),
        ),
      if (_filter.accountId != null)
        InputChip(
          label: Text(names.account(_filter.accountId)),
          onDeleted: () => _apply(_copy(clearAccount: true)),
        ),
      if (_filter.personId != null)
        InputChip(
          label: Text(names.person(_filter.personId)),
          onDeleted: () => _apply(_copy(clearPerson: true)),
        ),
      if (_filter.fromDate != null || _filter.toDate != null)
        InputChip(
          label: Text(
            '${_filter.fromDate == null ? '…' : s.day(_filter.fromDate!)} – ${_filter.toDate == null ? '…' : s.day(_filter.toDate!)}',
          ),
          onDeleted: () => _apply(_copy(clearDates: true)),
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? s.historyTitle),
        actions: [
          IconButton(
            onPressed: _openFilters,
            icon: const Icon(Icons.tune),
            tooltip: s.filters,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: s.search,
                isDense: true,
              ),
              onSubmitted: (v) => _apply(_filter.copyWith(search: v)),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              children: [
                for (final st in [TxStatus.draft, TxStatus.pending])
                  Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: FilterChip(
                      label: Text(s.status(st)),
                      selected: _filter.statuses?.contains(st) ?? false,
                      onSelected: (v) => _apply(
                        v ? _copy(statuses: {st}) : _copy(clearStatuses: true),
                      ),
                    ),
                  ),
                ...active.map(
                  (w) => Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _rows.isEmpty && !_loading
                ? EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: s.noTransactions,
                    body: s.noTransactionsBody,
                  )
                : RefreshIndicator(
                    onRefresh: _reload,
                    child: ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: _rows.length + (_done ? 0 : 1),
                      itemBuilder: (ctx, i) {
                        if (i >= _rows.length) {
                          return const Padding(
                            padding: EdgeInsets.all(Space.lg),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final r = _rows[i];
                        final header =
                            i == 0 || _rows[i - 1].dateKey != r.dateKey;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (header)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  Space.lg,
                                  Space.lg,
                                  Space.lg,
                                  Space.xs,
                                ),
                                child: Text(
                                  s.day(r.dateKey),
                                  style: context.text.labelLarge?.copyWith(
                                    color: context.ledger.muted,
                                  ),
                                ),
                              ),
                            TxTile(r, onTap: () => context.push('/tx/${r.id}')),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  TxFilter _copy({
    Set<TxStatus>? statuses,
    bool clearStatuses = false,
    bool clearAccount = false,
    bool clearPerson = false,
    bool clearDates = false,
    String? accountId,
    String? personId,
    int? from,
    int? to,
  }) => TxFilter(
    fromDate: clearDates ? null : (from ?? _filter.fromDate),
    toDate: clearDates ? null : (to ?? _filter.toDate),
    types: _filter.types,
    statuses: clearStatuses ? null : (statuses ?? _filter.statuses),
    accountId: clearAccount ? null : (accountId ?? _filter.accountId),
    fundId: _filter.fundId,
    personId: clearPerson ? null : (personId ?? _filter.personId),
    categoryId: _filter.categoryId,
    obligationId: _filter.obligationId,
    samityId: _filter.samityId,
    search: _filter.search,
  );

  Future<void> _openFilters() async {
    final s = S.of(context);
    final accounts = ref.read(storageAccountsProvider).value ?? const [];
    final persons = ref.read(personsProvider).value ?? const [];
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(s.filters, style: ctx.text.titleLarge)),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(s.period),
              onTap: () async {
                Navigator.pop(ctx);
                final r = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (r != null) {
                  _apply(
                    _copy(
                      from: DateKey.fromDate(r.start),
                      to: DateKey.fromDate(r.end),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text(s.account),
              onTap: () async {
                Navigator.pop(ctx);
                final v = await showPicker<String>(
                  context,
                  title: s.account,
                  items: [
                    for (final a in accounts)
                      PickerItem(
                        a.id,
                        accountLabel(a, s.bn),
                        icon: storageIcon(a.storageType),
                      ),
                  ],
                );
                if (v != null) _apply(_copy(accountId: v));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(s.person),
              onTap: () async {
                Navigator.pop(ctx);
                final v = await showPicker<String>(
                  context,
                  title: s.person,
                  items: [for (final p in persons) PickerItem(p.id, p.name)],
                );
                if (v != null) _apply(_copy(personId: v));
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: Text(s.clearFilters),
              onTap: () {
                Navigator.pop(ctx);
                _search.clear();
                _apply(const TxFilter());
              },
            ),
          ],
        ),
      ),
    );
  }
}
