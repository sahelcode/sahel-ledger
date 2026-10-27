import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/features/lock/app_lock.dart';

import '../support/memory_secret_store.dart';

void main() {
  test('PBKDF2-HMAC-SHA256 matches reference vectors', () {
    // Reference values from Python's hashlib.pbkdf2_hmac('sha256', ...).
    expect(
      PinHasher.hash('password', 'salt'.codeUnits, rounds: 1),
      'Eg+2z/z4syxD5yJSVsT4N6hlSMkszDVICAWYfLcL4Xs=',
    );
    expect(
      PinHasher.hash('password', 'salt'.codeUnits, rounds: 2),
      'rk0Mla9rRtMtCt/5KPBt0CowP47zwlHf1uLYWpVHTEM=',
    );
    expect(
      PinHasher.hash('password', 'salt'.codeUnits, rounds: 4096),
      'xeR41ZKIyEGqUw22hFxMjZYok6ABzk4RpJY4c6qYE0o=',
    );
  });

  test('PIN is stored only as a salted hash; wrong PINs back off', () async {
    final store = MemorySecretStore();
    final c = ProviderContainer(
      overrides: [secretStoreProvider.overrideWithValue(store)],
    );
    addTearDown(c.dispose);
    c.read(appLockProvider);
    await Future<void>.delayed(Duration.zero);
    expect(c.read(appLockProvider).loaded, isTrue);
    expect(c.read(appLockProvider).locked, isFalse);
    await c.read(appLockProvider.notifier).setPin('2468');
    expect(store.data.values.any((v) => v.contains('2468')), isFalse);
    // Simulate restart.
    final c2 = ProviderContainer(
      overrides: [secretStoreProvider.overrideWithValue(store)],
    );
    addTearDown(c2.dispose);
    c2.read(appLockProvider);
    await Future<void>.delayed(Duration.zero);
    expect(c2.read(appLockProvider).locked, isTrue);
    for (var i = 0; i < 5; i++) {
      expect(await c2.read(appLockProvider.notifier).unlock('0000'), isFalse);
    }
    expect(c2.read(appLockProvider).lockedUntil, isNotNull);
    expect(
      await c2.read(appLockProvider.notifier).unlock('2468'),
      isFalse,
      reason: 'cool-down',
    );
  });
}
