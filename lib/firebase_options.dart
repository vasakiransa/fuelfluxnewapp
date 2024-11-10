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
    apiKey: 'AIzaSyB7lVShujZA5WBfsFqVld2i5rxI03Xq-B0',
    appId: '1:438767336200:web:68f1df59e31c753ff1cabd',
    messagingSenderId: '438767336200',
    projectId: 'fuelflux-9d713',
    authDomain: 'fuelflux-9d713.firebaseapp.com',
    storageBucket: 'fuelflux-9d713.firebasestorage.app',
    measurementId: 'G-MH5QHR65DN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCXnZAAdzk8CneC8VQ-SI01bNA1Dsx0ZME',
    appId: '1:438767336200:android:43a2dcff9aaca03ef1cabd',
    messagingSenderId: '438767336200',
    projectId: 'fuelflux-9d713',
    storageBucket: 'fuelflux-9d713.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvoNQVKsTEg-R7mdkghI5dTnA8kvCYvxw',
    appId: '1:438767336200:ios:f36b6629badbf62cf1cabd',
    messagingSenderId: '438767336200',
    projectId: 'fuelflux-9d713',
    storageBucket: 'fuelflux-9d713.firebasestorage.app',
    iosBundleId: 'com.example.cng',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAvoNQVKsTEg-R7mdkghI5dTnA8kvCYvxw',
    appId: '1:438767336200:ios:f36b6629badbf62cf1cabd',
    messagingSenderId: '438767336200',
    projectId: 'fuelflux-9d713',
    storageBucket: 'fuelflux-9d713.firebasestorage.app',
    iosBundleId: 'com.example.cng',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7lVShujZA5WBfsFqVld2i5rxI03Xq-B0',
    appId: '1:438767336200:web:8804c9c2d0badb68f1cabd',
    messagingSenderId: '438767336200',
    projectId: 'fuelflux-9d713',
    authDomain: 'fuelflux-9d713.firebaseapp.com',
    storageBucket: 'fuelflux-9d713.firebasestorage.app',
    measurementId: 'G-M5Q7PKF1SB',
  );
}
