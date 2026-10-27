import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/theme.dart';
import '../../core/money/money.dart';
import '../../shared/widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _cash = TextEditingController();
  bool _saving = false;

  Future<void> _finish() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final cash = _cash.text.trim().isEmpty
          ? 0
          : parsePoisha(_cash.text, allowZero: true).poisha ?? 0;
      await ref
          .read(masterRepoProvider)
          .completeOnboarding(selfName: _name.text.trim(), openingCash: cash);
      ref.read(settingsProvider.notifier).markOnboarded();
    } catch (e) {
      if (mounted) showSnack(context, '$e', error: true);
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _step == 0 ? _welcome(s) : _setup(s),
        ),
      ),
    );
  }

  Widget _welcome(S s) {
    final settings = ref.watch(settingsProvider);
    return ListView(
      key: const ValueKey('welcome'),
      padding: const EdgeInsets.all(Space.xl),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'bn', label: Text('বাংলা')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {settings.locale.languageCode},
            onSelectionChanged: (v) =>
                ref.read(settingsProvider.notifier).setLocale(Locale(v.first)),
          ),
        ),
        const SizedBox(height: Space.xxl),
        Container(
          constraints: const BoxConstraints(minHeight: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.xl),
            gradient: LinearGradient(
              colors: [context.ledger.heroStart, context.ledger.heroEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(Space.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: Space.xl),
              Text(
                s.appName,
                style: context.text.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                s.tagline,
                style: context.text.bodyLarge?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.xl),
        Text(
          s.welcomeTitle,
          style: context.text.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Space.md),
        Text(
          s.welcomeBody,
          style: context.text.bodyLarge?.copyWith(color: context.ledger.muted),
        ),
        const SizedBox(height: Space.xl),
        for (final (icon, text) in [
          (Icons.shield_outlined, s.onboardPoint1),
          (Icons.cloud_off_outlined, s.onboardPoint2),
          (Icons.lock_outline, s.onboardPoint3),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: context.ledger.positiveContainer,
                  child: Icon(icon, size: 18, color: context.ledger.positive),
                ),
                const SizedBox(width: Space.md),
                Expanded(child: Text(text, style: context.text.bodyLarge)),
              ],
            ),
          ),
        const SizedBox(height: Space.xl),
        FilledButton(
          onPressed: () => setState(() => _step = 1),
          child: Text(s.getStarted),
        ),
      ],
    );
  }

  Widget _setup(S s) => Form(
    key: _form,
    child: ListView(
      key: const ValueKey('setup'),
      padding: const EdgeInsets.all(Space.xl),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => setState(() => _step = 0),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(
          s.setupTitle,
          style: context.text.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Space.xl),
        TextFormField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: s.yourName,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? s.required : null,
        ),
        const SizedBox(height: Space.lg),
        AmountField(
          controller: _cash,
          label: s.openingCash,
          allowZero: true,
          optional: true,
        ),
        Padding(
          padding: const EdgeInsets.only(top: Space.sm, left: Space.xs),
          child: Text(
            s.openingCashHint,
            style: context.text.bodySmall?.copyWith(
              color: context.ledger.muted,
            ),
          ),
        ),
        const SizedBox(height: Space.xxl),
        FilledButton(
          onPressed: _saving ? null : _finish,
          child: _saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(s.continueLabel),
        ),
      ],
    ),
  );
}
