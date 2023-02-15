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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyARIPRh1f3G31PaXd4F5vqQuQH1yjyLwG0',
    appId: '1:667327318779:web:ae60fac0508475ee907e5e',
    messagingSenderId: '667327318779',
    projectId: 'official-console',
    authDomain: 'official-console.firebaseapp.com',
    databaseURL: 'https://official-console-default-rtdb.firebaseio.com',
    storageBucket: 'official-console.appspot.com',
    measurementId: 'G-NZWJ7DSYZ3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmrm-dy2Q67VGToBzDb9_CRu6jeDGtcoM',
    appId: '1:667327318779:android:ccdbe5ddd68565b2907e5e',
    messagingSenderId: '667327318779',
    projectId: 'official-console',
    databaseURL: 'https://official-console-default-rtdb.firebaseio.com',
    storageBucket: 'official-console.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgGmP9X5dWA_YfyIzM089h8rrMt_0yS30',
    appId: '1:667327318779:ios:8bffc5e3e80d9b00907e5e',
    messagingSenderId: '667327318779',
    projectId: 'official-console',
    databaseURL: 'https://official-console-default-rtdb.firebaseio.com',
    storageBucket: 'official-console.appspot.com',
    androidClientId: '667327318779-1df0tca6a31k7h367uvhn2sfmka84vas.apps.googleusercontent.com',
    iosClientId: '667327318779-lufv8ntk3d9rfgb3thv3boofmeup22ik.apps.googleusercontent.com',
    iosBundleId: 'com.evs.dev.cameroon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgGmP9X5dWA_YfyIzM089h8rrMt_0yS30',
    appId: '1:667327318779:ios:4136347176772bde907e5e',
    messagingSenderId: '667327318779',
    projectId: 'official-console',
    databaseURL: 'https://official-console-default-rtdb.firebaseio.com',
    storageBucket: 'official-console.appspot.com',
    androidClientId: '667327318779-1df0tca6a31k7h367uvhn2sfmka84vas.apps.googleusercontent.com',
    iosClientId: '667327318779-o2smqpqn1oje760a3mapoba0ot5fqg6p.apps.googleusercontent.com',
    iosBundleId: 'com.example.cameroon2',
  );
}
