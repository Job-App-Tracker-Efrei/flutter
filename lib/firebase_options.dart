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
    apiKey: 'AIzaSyBV7a2GVXcG11oPRtUGk5l8w0B9A11AqW0',
    appId: '1:922794878150:android:2835cf19cc7f2f734723c7',
    messagingSenderId: '922794878150',
    projectId: 'job-tracker-efrei',
    storageBucket: 'job-tracker-efrei.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjGZybrlr_I_SutJQ9ky6N05oQUIVNsUM',
    appId: '1:922794878150:ios:cfe4e5ecc8ca8ec54723c7',
    messagingSenderId: '922794878150',
    projectId: 'job-tracker-efrei',
    storageBucket: 'job-tracker-efrei.firebasestorage.app',
    iosClientId:
        '922794878150-g79u17ou49n5b5apiop2vs5gj8skli04.apps.googleusercontent.com',
    iosBundleId: 'com.jobapptracker.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjGZybrlr_I_SutJQ9ky6N05oQUIVNsUM',
    appId: '1:922794878150:ios:cfe4e5ecc8ca8ec54723c7',
    messagingSenderId: '922794878150',
    projectId: 'job-tracker-efrei',
    storageBucket: 'job-tracker-efrei.firebasestorage.app',
    iosClientId:
        '922794878150-g79u17ou49n5b5apiop2vs5gj8skli04.apps.googleusercontent.com',
    iosBundleId: 'com.jobapptracker.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2mQ2A1m9JQMl4z7NPBdQeG4BpHHiA4Ms',
    appId: '1:922794878150:web:e0ea050c24efea884723c7',
    messagingSenderId: '922794878150',
    projectId: 'job-tracker-efrei',
    authDomain: 'job-tracker-efrei.firebaseapp.com',
    storageBucket: 'job-tracker-efrei.firebasestorage.app',
    measurementId: 'G-W2MYXPHSJQ',
  );
}
