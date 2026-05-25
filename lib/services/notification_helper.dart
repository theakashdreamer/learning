import 'package:flutter/services.dart';

class NotificationHelper {
  static const platform = MethodChannel('com.technosys.ambulancepassenger/custom_notification');

  static Future<void> showCustomNotification(String title, String body) async {
    try {
      await platform.invokeMethod('showNotification', {
        'title': title,
        'body': body,
      });
    } on PlatformException catch (e) {
      print("Failed to show notification: ${e.message}");
    }
  }
}
