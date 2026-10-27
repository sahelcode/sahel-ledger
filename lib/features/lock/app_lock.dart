import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/strings.dart';
import '../../app/theme.dart';

/// Minimal key-value contract so the lock can be tested without platform
/// channels.
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class PlatformSecretStore implements SecretStore {
  const PlatformSecretStore();
  static const _s = FlutterSecureStorage();
  @override
  Future<String?> read(String key) => _s.read(key: key);
  @override
  Future<void> write(String key, String value) =>
      _s.write(key: key, value: value);
  @override
  Future<void> delete(String key) => _s.delete(key: key);
}

final secretStoreProvider = Provider<SecretStore>(
  (ref) => const PlatformSecretStore(),
);

/// PIN hashing: PBKDF2-HMAC-SHA256 with a random salt. The PIN itself is
/// never stored. Lives in the platform keystore/keychain.
abstract final class PinHasher {
  static const iterations = 120000;

  static String hash(String pin, List<int> salt, {int rounds = iterations}) {
    final hmac = Hmac(sha256, utf8.encode(pin));
    // PBKDF2, single block (32 bytes).
    var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
    final out = List<int>.from(u);
    for (var i = 1; i < rounds; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < out.length; j++) {
        out[j] ^= u[j];
      }
    }
    return base64Encode(out);
  }

  static bool constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}

class LockState {
  const LockState({
    required this.enabled,
    required this.locked,
    this.failures = 0,
    this.lockedUntil,
    this.loaded = true,
  });

  /// False until secure storage was read; content stays hidden meanwhile.
  final bool loaded;
  final bool enabled;
  final bool locked;
  final int failures;
  final DateTime? lockedUntil;
}

class AppLock extends Notifier<LockState> {
  static const _kHash = 'pin_hash';
  static const _kSalt = 'pin_salt';
  DateTime? _backgroundedAt;
  static const relockAfter = Duration(minutes: 2);

  SecretStore get _store => ref.read(secretStoreProvider);

  @override
  LockState build() {
    Future.microtask(_load);
    // Hidden until we know whether a PIN exists.
    return const LockState(enabled: false, locked: false, loaded: false);
  }

  Future<void> _load() async {
    bool has;
    try {
      has = (await _store.read(_kHash)) != null;
    } catch (e) {
      // Keystore unavailable: the PIN cannot be checked either. The lock is
      // a convenience screen, not encryption, so the app stays usable.
      debugPrint('app lock unavailable: $e');
      has = false;
    }
    state = LockState(enabled: has, locked: has);
  }

  Future<void> setPin(String pin) async {
    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    await _store.write(_kSalt, base64Encode(salt));
    await _store.write(_kHash, PinHasher.hash(pin, salt));
    state = const LockState(enabled: true, locked: false);
  }

  Future<void> disable() async {
    await _store.delete(_kHash);
    await _store.delete(_kSalt);
    state = const LockState(enabled: false, locked: false);
  }

  /// Returns true when unlocked. Repeated failures add a growing delay.
  Future<bool> unlock(String pin) async {
    final until = state.lockedUntil;
    if (until != null && DateTime.now().isBefore(until)) return false;
    final hash = await _store.read(_kHash);
    final salt = await _store.read(_kSalt);
    if (hash == null || salt == null) {
      state = const LockState(enabled: false, locked: false);
      return true;
    }
    if (PinHasher.constantTimeEquals(
      PinHasher.hash(pin, base64Decode(salt)),
      hash,
    )) {
      state = const LockState(enabled: true, locked: false);
      return true;
    }
    final f = state.failures + 1;
    state = LockState(
      enabled: true,
      locked: true,
      failures: f,
      lockedUntil: f >= 5
          ? DateTime.now().add(Duration(seconds: 30 * (f - 4)))
          : null,
    );
    return false;
  }

  void onLifecycle(AppLifecycleState s) {
    if (!state.enabled) return;
    if (s == AppLifecycleState.paused || s == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    } else if (s == AppLifecycleState.resumed) {
      final at = _backgroundedAt;
      _backgroundedAt = null;
      if (at != null && DateTime.now().difference(at) >= relockAfter) {
        state = LockState(
          enabled: true,
          locked: true,
          failures: state.failures,
        );
      }
    }
  }
}

final appLockProvider = NotifierProvider<AppLock, LockState>(AppLock.new);

/// Shows [child] only when the app is unlocked.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      ref.read(appLockProvider.notifier).onLifecycle(state);

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockProvider);
    return Stack(
      children: [
        widget.child,
        if (!lock.loaded)
          Positioned.fill(child: ColoredBox(color: context.ledger.heroStart))
        else if (lock.locked)
          const Positioned.fill(child: _LockScreen()),
      ],
    );
  }
}

class _LockScreen extends ConsumerStatefulWidget {
  const _LockScreen();
  @override
  ConsumerState<_LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<_LockScreen> {
  final _pin = TextEditingController();
  bool _wrong = false;

  Future<void> _submit() async {
    final ok = await ref.read(appLockProvider.notifier).unlock(_pin.text);
    _pin.clear();
    if (mounted) setState(() => _wrong = !ok);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final lock = ref.watch(appLockProvider);
    final waiting =
        lock.lockedUntil != null && DateTime.now().isBefore(lock.lockedUntil!);
    return Material(
      color: context.ledger.heroStart,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Space.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: Colors.white, size: 48),
                const SizedBox(height: Space.lg),
                Text(
                  s.appName,
                  style: context.text.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: Space.xl),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _pin,
                    autofocus: true,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 8,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 24, letterSpacing: 8),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: s.pin,
                      errorText: _wrong
                          ? s.wrongPin
                          : (waiting ? s.tryLater : null),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(height: Space.lg),
                FilledButton.tonal(
                  onPressed: waiting ? null : _submit,
                  child: Text(s.unlock),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
