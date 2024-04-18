// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyB5UPPiNoPt6LFL0y-6yY03M_LpWxSGu_g',
    appId: '1:30248763369:android:c0c74e53935450576ad578',
    messagingSenderId: '30248763369',
    projectId: 'lilacmtestnew',
    storageBucket: 'lilacmtestnew.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMcSX8XpwFMMUiRQw67FwnJ1GDBCzbGMY',
    appId: '1:30248763369:ios:e060c112b1fc5dd76ad578',
    messagingSenderId: '30248763369',
    projectId: 'lilacmtestnew',
    storageBucket: 'lilacmtestnew.appspot.com',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBPZKQvBaDvlC6WzGEnhE2L6eKIRRlQ-9k',
    appId: '1:30248763369:web:cd6a082a8af7dda56ad578',
    messagingSenderId: '30248763369',
    projectId: 'lilacmtestnew',
    authDomain: 'lilacmtestnew.firebaseapp.com',
    storageBucket: 'lilacmtestnew.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMcSX8XpwFMMUiRQw67FwnJ1GDBCzbGMY',
    appId: '1:30248763369:ios:e060c112b1fc5dd76ad578',
    messagingSenderId: '30248763369',
    projectId: 'lilacmtestnew',
    storageBucket: 'lilacmtestnew.appspot.com',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBPZKQvBaDvlC6WzGEnhE2L6eKIRRlQ-9k',
    appId: '1:30248763369:web:744da56e837620766ad578',
    messagingSenderId: '30248763369',
    projectId: 'lilacmtestnew',
    authDomain: 'lilacmtestnew.firebaseapp.com',
    storageBucket: 'lilacmtestnew.appspot.com',
  );

}