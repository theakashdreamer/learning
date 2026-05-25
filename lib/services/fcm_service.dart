import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FCMService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Permission
    await _messaging.requestPermission();

    // Token
    final token = await _messaging.getToken();
    debugPrint('📱 FCM TOKEN: $token');

    // FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('📩 FOREGROUND: ${message.notification?.title}');
    });

    // WHEN APP OPENED FROM BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('📲 OPENED FROM BG: ${message.data}');
    });
  }
}
