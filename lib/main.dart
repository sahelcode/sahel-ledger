import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'data/db/database.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.open();
  final firebaseReady = await _initFirebase();
  final settings = await AppSettings.load(db);
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      firebaseReadyProvider.overrideWithValue(firebaseReady),
      initialSettingsProvider.overrideWithValue(settings),
    ],
  );
  await container.read(sessionProvider.notifier).load();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SahelLedgerApp(),
    ),
  );
}

/// Firebase is optional: without a generated `firebase_options.dart` the app
/// runs in local-only mode.
Future<bool> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase not configured, running local-only: $e');
    return false;
  }
  try {
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kReleaseMode
          ? const AndroidPlayIntegrityProvider()
          : const AndroidDebugProvider(),
      providerApple: const AppleDeviceCheckProvider(),
    );
  } catch (e) {
    // App Check must also be enforced in the Firebase console to matter.
    debugPrint('App Check activation failed: $e');
  }
  return true;
}
