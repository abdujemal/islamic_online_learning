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
    apiKey: 'AIzaSyBiA2vITeod4WsEGK_pO1bWQPl_Vwa5vAA',
    appId: '1:289944837560:android:b64fc8b263d01445be834d',
    messagingSenderId: '289944837560',
    projectId: 'completed-full-lectures',
    databaseURL: 'https://completed-full-lectures-default-rtdb.firebaseio.com',
    storageBucket: 'completed-full-lectures.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDror_NjHs9wHrBMvmLnh-gh6Rd6E8P2Ys',
    appId: '1:289944837560:ios:1b1a411859d5125dbe834d',
    messagingSenderId: '289944837560',
    projectId: 'completed-full-lectures',
    databaseURL: 'https://completed-full-lectures-default-rtdb.firebaseio.com',
    storageBucket: 'completed-full-lectures.appspot.com',
    androidClientId: '289944837560-8jcd9g6vo9g97p9vdufcle0o8d1pvrvl.apps.googleusercontent.com',
    iosClientId: '289944837560-kpqp9rkknp0htkogmfieqj1sn8iljh01.apps.googleusercontent.com',
    iosBundleId: 'com.aj.islamicOnlineLearning',
  );
}