import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../data/sync/household_directory.dart';
import '../../domain/access/access.dart';
import '../../shared/widgets.dart';
import '../sync/sync_controller.dart';

final authUserProvider = StreamProvider<User?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return Stream.value(null);
  return FirebaseAuth.instance.userChanges();
});

final _householdIdProvider = FutureProvider.autoDispose<String?>((ref) {
  ref.watch(sessionProvider);
  return ref.watch(databaseProvider).getKv(Kv.householdId);
});

final _membersProvider = FutureProvider.autoDispose<List<MemberInfo>>((
  ref,
) async {
  final service = ref.watch(householdServiceProvider);
  final me = ref.watch(sessionProvider);
  final hid = await ref.watch(_householdIdProvider.future);
  if (service == null || me == null || hid == null) return const [];
  return (await service.directory(hid, me)).members;
});

class HouseholdScreen extends ConsumerWidget {
  const HouseholdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    if (!ref.watch(firebaseReadyProvider)) {
      return Scaffold(
        appBar: AppBar(title: Text(s.householdTitle)),
        body: EmptyState(
          icon: Icons.cloud_off_outlined,
          title: s.syncLocalOnly,
          body: s.cloudNotConfigured,
        ),
      );
    }
    final user = ref.watch(authUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.householdTitle),
        actions: [
          if (user.value != null)
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await ref.read(sessionProvider.notifier).clear();
              },
              child: Text(s.signOut),
            ),
        ],
      ),
      body: AsyncBody(
        user,
        builder: (u) =>
            u == null ? const _SignInForm() : _HouseholdBody(user: u),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  const _SignInForm();
  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function() f) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await f();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? e.code);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return ListView(
      padding: const EdgeInsets.all(Space.xl),
      children: [
        Icon(Icons.family_restroom, size: 56, color: context.colors.primary),
        const SizedBox(height: Space.lg),
        Text(
          s.roleOwnerHint,
          textAlign: TextAlign.center,
          style: context.text.bodyMedium,
        ),
        const SizedBox(height: Space.xl),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(labelText: s.email),
        ),
        const SizedBox(height: Space.md),
        TextField(
          controller: _password,
          obscureText: true,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(labelText: s.password),
        ),
        if (_error != null) ...[
          const SizedBox(height: Space.sm),
          Text(_error!, style: TextStyle(color: context.colors.error)),
        ],
        const SizedBox(height: Space.lg),
        FilledButton(
          onPressed: _busy
              ? null
              : () => _run(
                  () => FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _email.text.trim(),
                    password: _password.text,
                  ),
                ),
          child: Text(s.signIn),
        ),
        const SizedBox(height: Space.sm),
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _run(() async {
                  final c = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: _email.text.trim(),
                        password: _password.text,
                      );
                  await c.user?.sendEmailVerification();
                }),
          child: Text(s.createAccount),
        ),
        TextButton(
          onPressed: _busy || _email.text.trim().isEmpty
              ? null
              : () => _run(() async {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: _email.text.trim(),
                  );
                  if (context.mounted) showSnack(context, s.resetSent);
                }),
          child: Text(s.forgotPassword),
        ),
        const SizedBox(height: Space.lg),
        Text(
          s.accountRecovery,
          style: context.text.bodySmall?.copyWith(color: context.ledger.muted),
        ),
      ],
    );
  }
}

class _HouseholdBody extends ConsumerWidget {
  const _HouseholdBody({required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final hid = ref.watch(_householdIdProvider);
    final session = ref.watch(sessionProvider);
    final service = ref.watch(householdServiceProvider)!;
    return AsyncBody(
      hid,
      builder: (h) {
        if (h == null || session == null) {
          return ListView(
            padding: const EdgeInsets.all(Space.xl),
            children: [
              Text(user.email ?? '', style: context.text.titleMedium),
              if (!user.emailVerified) ...[
                const SizedBox(height: Space.sm),
                Text(
                  s.verifyEmail,
                  style: TextStyle(color: context.ledger.warning),
                ),
                TextButton(
                  onPressed: () => user.sendEmailVerification(),
                  child: Text(s.sendVerification),
                ),
                TextButton(
                  onPressed: () => user.reload(),
                  child: Text(s.retry),
                ),
              ],
              const SizedBox(height: Space.xl),
              FilledButton.icon(
                icon: const Icon(Icons.add_home_outlined),
                label: Text(s.createHousehold),
                onPressed: () async {
                  try {
                    final id = await service.createHousehold(
                      uid: user.uid,
                      name: user.displayName ?? user.email ?? 'Household',
                      email: user.email,
                    );
                    final me = await service.membership(id, user.uid);
                    if (me != null) {
                      await ref.read(sessionProvider.notifier).set(me);
                    }
                    ref.invalidate(_householdIdProvider);
                  } catch (e) {
                    if (context.mounted) showSnack(context, '$e', error: true);
                  }
                },
              ),
              const SizedBox(height: Space.md),
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: Text(s.joinHousehold),
                onPressed: !user.emailVerified
                    ? null
                    : () async {
                        final code = await promptText(
                          context,
                          title: s.inviteCode,
                          minLength: 16,
                        );
                        if (code == null) return;
                        try {
                          final id = await service.acceptInvite(
                            code: code,
                            uid: user.uid,
                            displayName: user.displayName,
                          );
                          final me = await service.membership(id, user.uid);
                          if (me != null) {
                            await ref.read(sessionProvider.notifier).set(me);
                          }
                          ref.invalidate(_householdIdProvider);
                        } catch (e) {
                          if (context.mounted) {
                            showSnack(context, '$e', error: true);
                          }
                        }
                      },
              ),
            ],
          );
        }
        final canManage = session.toActor().can(Permission.manageMembers);
        return ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.email ?? user.uid,
                          style: context.text.titleSmall,
                        ),
                        Text(_roleLabel(s, session.role)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SectionHeader(
              s.members,
              action: canManage && user.emailVerified ? s.inviteMember : null,
              onAction: () => _invite(context, ref, h),
            ),
            AsyncBody(
              ref.watch(_membersProvider),
              builder: (members) => Card(
                child: Column(
                  children: [
                    for (final m in members)
                      ListTile(
                        leading: Icon(
                          m.role == HouseholdRole.owner
                              ? Icons.star
                              : Icons.person_outline,
                        ),
                        title: Text(m.displayName ?? m.email ?? m.uid),
                        subtitle: Text(
                          '${_roleLabel(s, m.role)}'
                          '${m.role == HouseholdRole.member ? ' · ${s.num(m.fundIds.length)} ${s.fundsTitle}' : ''}',
                        ),
                        trailing:
                            canManage &&
                                m.role != HouseholdRole.owner &&
                                m.uid != session.uid
                            ? IconButton(
                                tooltip: s.revoke,
                                icon: Icon(
                                  Icons.person_remove_outlined,
                                  color: context.ledger.negative,
                                ),
                                onPressed: () async {
                                  final ok = await confirmDialog(
                                    context,
                                    title: s.revoke,
                                    body: m.email ?? m.uid,
                                    destructive: true,
                                  );
                                  if (!ok) return;
                                  await ref
                                      .read(householdServiceProvider)!
                                      .revokeMember(h, m.uid);
                                  ref.invalidate(_membersProvider);
                                },
                              )
                            : null,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Space.lg),
            Text(
              s.pdfWarning,
              style: context.text.bodySmall?.copyWith(
                color: context.ledger.muted,
              ),
            ),
          ],
        );
      },
    );
  }

  String _roleLabel(S s, HouseholdRole r) => switch (r) {
    HouseholdRole.owner => '${s.owner} — ${s.roleOwnerHint}',
    HouseholdRole.admin => '${s.admin} — ${s.roleAdminHint}',
    HouseholdRole.member => '${s.memberRole} — ${s.roleMemberHint}',
  };

  Future<void> _invite(BuildContext context, WidgetRef ref, String hid) async {
    final s = S.of(context);
    final email = TextEditingController();
    var role = HouseholdRole.member;
    final funds = <String>{};
    final perms = <Permission>{};
    final allFunds = ref.read(fundsProvider).value ?? const [];
    final isOwner = ref.read(actorProvider).role == HouseholdRole.owner;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(s.inviteMember),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: email,
                  decoration: InputDecoration(labelText: s.email),
                ),
                const SizedBox(height: Space.md),
                if (isOwner)
                  SegmentedButton<HouseholdRole>(
                    segments: [
                      ButtonSegment(
                        value: HouseholdRole.member,
                        label: Text(s.memberRole),
                      ),
                      ButtonSegment(
                        value: HouseholdRole.admin,
                        label: Text(s.admin),
                      ),
                    ],
                    selected: {role},
                    onSelectionChanged: (v) => setState(() => role = v.first),
                  ),
                const SizedBox(height: Space.md),
                if (role == HouseholdRole.member) ...[
                  Text(s.canSeeFunds, style: ctx.text.labelLarge),
                  for (final f in allFunds)
                    CheckboxListTile(
                      dense: true,
                      value: funds.contains(f.id),
                      title: Text(s.fundName(f.name, f.kind)),
                      onChanged: (v) => setState(
                        () => v! ? funds.add(f.id) : funds.remove(f.id),
                      ),
                    ),
                ] else
                  for (final p in Permission.values)
                    CheckboxListTile(
                      dense: true,
                      value: perms.contains(p),
                      title: Text(p.name),
                      onChanged: (v) =>
                          setState(() => v! ? perms.add(p) : perms.remove(p)),
                    ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(s.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(s.inviteMember),
            ),
          ],
        ),
      ),
    );
    if (ok != true || email.text.trim().isEmpty) return;
    try {
      final uid = ref.read(sessionProvider)!.uid;
      final inv = await ref
          .read(householdServiceProvider)!
          .createInvite(
            hid: hid,
            createdBy: uid,
            email: email.text,
            role: role,
            perms: perms,
            fundIds: funds,
          );
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(s.inviteCode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                inv.code,
                style: ctx.text.headlineSmall?.copyWith(letterSpacing: 2),
              ),
              const SizedBox(height: Space.md),
              Text(s.inviteCreated),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Clipboard.setData(ClipboardData(text: inv.code)),
              child: const Icon(Icons.copy),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(s.done),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) showSnack(context, '$e', error: true);
    }
  }
}
