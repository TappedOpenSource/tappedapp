// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBh3y9V9FhKJDbJOhqJTj14JoUQiewmkgI',
    appId: '1:269420857313:android:48c1ec29913d8073f7f4a0',
    messagingSenderId: '269420857313',
    projectId: 'in-the-loop-306520',
    storageBucket: 'in-the-loop-306520.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEwIUyEtxgU-pp6sX-VrHOzYLC7Sibd2M',
    appId: '1:269420857313:ios:f702ccb384ec91f2f7f4a0',
    messagingSenderId: '269420857313',
    projectId: 'in-the-loop-306520',
    storageBucket: 'in-the-loop-306520.appspot.com',
    androidClientId: '269420857313-6ajuiqa48fc06b7adnafdoavuntkd3li.apps.googleusercontent.com',
    iosClientId: '269420857313-1bqljp8o95hfqt9un7u43qht55bden0s.apps.googleusercontent.com',
    iosBundleId: 'com.intheloopstudio',
  );
}