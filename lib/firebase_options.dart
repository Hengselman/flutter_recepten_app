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
    apiKey: 'AIzaSyC_84N2q1j-mm4HmCto9QSmkq1FtnnRvao',
    appId: '1:793391574076:web:62c85a600d19527e46a739',
    messagingSenderId: '793391574076',
    projectId: 'iiatimd-devin',
    authDomain: 'iiatimd-devin.firebaseapp.com',
    databaseURL: 'https://iiatimd-devin-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iiatimd-devin.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVn63ruWFJGx8467FrNxC5gjMdJV3iXHo',
    appId: '1:793391574076:android:8b346b9eb29e443a46a739',
    messagingSenderId: '793391574076',
    projectId: 'iiatimd-devin',
    databaseURL: 'https://iiatimd-devin-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iiatimd-devin.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlWBMrPbtlDX_D_smrSvIJTJiHNPSnZ1Y',
    appId: '1:793391574076:ios:76cee9c30ce40fd546a739',
    messagingSenderId: '793391574076',
    projectId: 'iiatimd-devin',
    databaseURL: 'https://iiatimd-devin-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iiatimd-devin.appspot.com',
    iosClientId: '793391574076-7i0pc9ntk3bg1j07l771j8les25u06nv.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterReceptenApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlWBMrPbtlDX_D_smrSvIJTJiHNPSnZ1Y',
    appId: '1:793391574076:ios:76cee9c30ce40fd546a739',
    messagingSenderId: '793391574076',
    projectId: 'iiatimd-devin',
    databaseURL: 'https://iiatimd-devin-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iiatimd-devin.appspot.com',
    iosClientId: '793391574076-7i0pc9ntk3bg1j07l771j8les25u06nv.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterReceptenApp',
  );
}
