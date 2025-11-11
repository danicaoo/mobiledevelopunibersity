import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
        return macos;
      default:
        return web; // Fallback to web
    }
  }

  // КОНФИГУРАЦИЯ ДЛЯ WEB - используй значения из Web конфигурации
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA5-xh91FQqHmkQgRtpeeBQ7gD6FVPU-dg',
    appId: '1:860700558221:web:b7b9758f4759e6392773c4',
    messagingSenderId: '860700558221',
    projectId: 'notes-app-kuznetsov-ffe77', // Используй этот Project ID!
    authDomain: 'notes-app-kuznetsov-ffe77.firebaseapp.com',
    storageBucket: 'notes-app-kuznetsov-ffe77.firebasestorage.app',
  );

  // КОНФИГУРАЦИЯ ДЛЯ ANDROID
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnXLocLm17hXFP3whB5SvNbSUgMVcakss',
    appId: '1:860700558221:android:37096406ba78f7972773c4',
    messagingSenderId: '860700558221',
    projectId: 'notes-app-kuznetsov-ffe77', // Используй тот же Project ID!
    storageBucket: 'notes-app-kuznetsov-ffe77.firebasestorage.app',
  );

  // КОНФИГУРАЦИЯ ДЛЯ iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATuB-8wZT4hpmjnVbBOjbnIfSZYAmU4wY',
    appId: '1:860700558221:ios:cc1975719ec782402773c4',
    messagingSenderId: '860700558221',
    projectId: 'notes-app-kuznetsov-ffe77', // Используй тот же Project ID!
    storageBucket: 'notes-app-kuznetsov-ffe77.firebasestorage.app',
    iosBundleId: 'com.company.kuznetsov',
  );

  // КОНФИГУРАЦИЯ ДЛЯ macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyATuB-8wZT4hpmjnVbBOjbnIfSZYAmU4wY',
    appId: '1:860700558221:ios:cc1975719ec782402773c4',
    messagingSenderId: '860700558221',
    projectId: 'notes-app-kuznetsov-ffe77', // Используй тот же Project ID!
    storageBucket: 'notes-app-kuznetsov-ffe77.firebasestorage.app',
    iosBundleId: 'com.company.kuznetsov',
  );
}