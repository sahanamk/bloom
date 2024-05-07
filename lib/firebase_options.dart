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
    apiKey: 'AIzaSyBgo74nKF1DdHAGsdRasQTox2ejCoXxKAU',
    appId: '1:848668496604:web:5bc96167827d3262c75a19',
    messagingSenderId: '848668496604',
    projectId: 'bloom-97ea1',
    authDomain: 'bloom-97ea1.firebaseapp.com',
    storageBucket: 'bloom-97ea1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7BYWgbrWM06SEw3FMzatt8JphckkhxhY',
    appId: '1:848668496604:android:202b5198b83941d3c75a19',
    messagingSenderId: '848668496604',
    projectId: 'bloom-97ea1',
    storageBucket: 'bloom-97ea1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSHA8BKn2Btz3D9x22nSnG2PVnZ0Sczqc',
    appId: '1:848668496604:ios:7a0ae873c5955724c75a19',
    messagingSenderId: '848668496604',
    projectId: 'bloom-97ea1',
    storageBucket: 'bloom-97ea1.appspot.com',
    iosBundleId: 'com.example.bloom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSHA8BKn2Btz3D9x22nSnG2PVnZ0Sczqc',
    appId: '1:848668496604:ios:7a0ae873c5955724c75a19',
    messagingSenderId: '848668496604',
    projectId: 'bloom-97ea1',
    storageBucket: 'bloom-97ea1.appspot.com',
    iosBundleId: 'com.example.bloom',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBgo74nKF1DdHAGsdRasQTox2ejCoXxKAU',
    appId: '1:848668496604:web:247ea178abad9ac7c75a19',
    messagingSenderId: '848668496604',
    projectId: 'bloom-97ea1',
    authDomain: 'bloom-97ea1.firebaseapp.com',
    storageBucket: 'bloom-97ea1.appspot.com',
  );
}
