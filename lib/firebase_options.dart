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
    apiKey: 'AIzaSyDs1_6qpIAcU742BvK71tp_A_aGkWPfZ1k',
    appId: '1:403025843120:web:66201d7515a75d1635fc75',
    messagingSenderId: '403025843120',
    projectId: 'estore-ept5',
    authDomain: 'estore-ept5.firebaseapp.com',
    databaseURL: 'https://estore-ept5-default-rtdb.firebaseio.com',
    storageBucket: 'estore-ept5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtNvhBN6rsAPz5HNgJRwC7203CuFpGmPU',
    appId: '1:403025843120:android:07b1489154de239735fc75',
    messagingSenderId: '403025843120',
    projectId: 'estore-ept5',
    databaseURL: 'https://estore-ept5-default-rtdb.firebaseio.com',
    storageBucket: 'estore-ept5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmUEmG4LtyB9RdCvcurwRXVvVCgjyEytI',
    appId: '1:403025843120:ios:9c2cdaec6870c41b35fc75',
    messagingSenderId: '403025843120',
    projectId: 'estore-ept5',
    databaseURL: 'https://estore-ept5-default-rtdb.firebaseio.com',
    storageBucket: 'estore-ept5.appspot.com',
    iosClientId: '403025843120-l780m8u63a3c0tb5gcvmgb2en9vfdkfn.apps.googleusercontent.com',
    iosBundleId: 'com.quantec.estore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBmUEmG4LtyB9RdCvcurwRXVvVCgjyEytI',
    appId: '1:403025843120:ios:7f955aaa27bd985a35fc75',
    messagingSenderId: '403025843120',
    projectId: 'estore-ept5',
    databaseURL: 'https://estore-ept5-default-rtdb.firebaseio.com',
    storageBucket: 'estore-ept5.appspot.com',
    iosClientId: '403025843120-b68a2075bproc3n25aaqrq57jkhqaqje.apps.googleusercontent.com',
    iosBundleId: 'com.quantec.estore.RunnerTests',
  );
}
