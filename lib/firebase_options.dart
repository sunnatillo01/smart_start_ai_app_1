import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return ios;
      default:
        throw UnsupportedError(
          'Ushbu platforma Firebase tomonidan qo‘llab-quvvatlanmaydi',
        );
    }
  }

  /// 🔹 ANDROID
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "ANDROID_API_KEY",
    appId: "ANDROID_APP_ID",
    messagingSenderId: "SENDER_ID",
    projectId: "smart-start-chat-app",
    storageBucket: "smart-start-chat-app.appspot.com",
  );

  /// 🔹 IOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "IOS_API_KEY",
    appId: "IOS_APP_ID",
    messagingSenderId: "SENDER_ID",
    projectId: "smart-start-chat-app",
    storageBucket: "smart-start-chat-app.appspot.com",
    iosBundleId: "com.example.smartStartChat",
  );

  /// 🔹 WEB
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "WEB_API_KEY",
    appId: "WEB_APP_ID",
    messagingSenderId: "SENDER_ID",
    projectId: "smart-start-chat-app",
    storageBucket: "smart-start-chat-app.appspot.com",
    authDomain: "smart-start-chat-app.firebaseapp.com",
  );
}
