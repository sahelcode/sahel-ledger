// Placeholder. Generate the real file for your Firebase project with:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=<your-project-id> --platforms=android,ios
//
// That command overwrites this file. Until then the app runs fully offline
// (local-only mode) and cloud features are hidden.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform =>
      throw UnsupportedError('Firebase is not configured for this build.');
}
