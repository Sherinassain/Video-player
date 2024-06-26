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
    apiKey: 'AIzaSyAZgDE-Yrns1wc_7UFvwRfOG_pyXmnyPkA',
    appId: '1:875747812733:android:5b7c97aa6db97cadb8d814',
    messagingSenderId: '875747812733',
    projectId: 'lilacmtest',
    databaseURL: 'https://lilacmtest-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'lilacmtest.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvz4-taYXZlKkgiaJZustGV_sUoi8eSQA',
    appId: '1:875747812733:ios:b5eda4a5c8b8f85bb8d814',
    messagingSenderId: '875747812733',
    projectId: 'lilacmtest',
    databaseURL: 'https://lilacmtest-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'lilacmtest.appspot.com',
    iosBundleId: 'com.example.myApp',
  );

}