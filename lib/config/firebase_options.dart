import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration for this project ("learning-app-lms").
///
/// The Android values below were pulled from android/app/google-services.json.
/// iOS and web are not configured yet — [currentPlatform] throws a clear
/// error on those platforms until they're set up (via the Firebase console
/// + `flutterfire configure`, or by hand the same way Android was done here).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions has not been configured for web. '
        'Add a web app in the Firebase console and fill in FirebaseOptions.web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions has not been configured for iOS. '
          'Add an iOS app in the Firebase console, download '
          'GoogleService-Info.plist into ios/Runner/, and fill in '
          'FirebaseOptions.ios.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARabEYGzXCqMfEsqB1BzwjBlkX3K8-Usw',
    appId: '1:638622663810:android:51c3cde462d4b367fa209b',
    messagingSenderId: '638622663810',
    projectId: 'learning-app-lms',
    storageBucket: 'learning-app-lms.firebasestorage.app',
  );
}
