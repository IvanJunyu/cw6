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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC6QoToYoB4s09ubiDyvA4vRK56Hn5ZQj8',
    appId: '1:719045925997:web:b89ff1bf3658b6403b7364',
    messagingSenderId: '719045925997',
    projectId: 'cw-6-6188c',
    authDomain: 'cw-6-6188c.firebaseapp.com',
    storageBucket: 'cw-6-6188c.firebasestorage.app',
    measurementId: 'G-BKMPLPR720',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdevg0gdfLnF0GZDrLsi3-Qgfqvsb5Wkk',
    appId: '1:719045925997:android:7bee7841556b4f7f3b7364',
    messagingSenderId: '719045925997',
    projectId: 'cw-6-6188c',
    storageBucket: 'cw-6-6188c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2p65E8iuVhzc24LrP1MD0aXxOOFOXWTk',
    appId: '1:719045925997:ios:d3bcb00ba0c9e3eb3b7364',
    messagingSenderId: '719045925997',
    projectId: 'cw-6-6188c',
    storageBucket: 'cw-6-6188c.firebasestorage.app',
    iosBundleId: 'com.example.firebasew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2p65E8iuVhzc24LrP1MD0aXxOOFOXWTk',
    appId: '1:719045925997:ios:d3bcb00ba0c9e3eb3b7364',
    messagingSenderId: '719045925997',
    projectId: 'cw-6-6188c',
    storageBucket: 'cw-6-6188c.firebasestorage.app',
    iosBundleId: 'com.example.firebasew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC6QoToYoB4s09ubiDyvA4vRK56Hn5ZQj8',
    appId: '1:719045925997:web:a73541a806041de63b7364',
    messagingSenderId: '719045925997',
    projectId: 'cw-6-6188c',
    authDomain: 'cw-6-6188c.firebaseapp.com',
    storageBucket: 'cw-6-6188c.firebasestorage.app',
    measurementId: 'G-ZCTY0C9YJK',
  );
}
