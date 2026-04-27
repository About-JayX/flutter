import 'package:flutter/services.dart';
import 'package:mobisen_app/util/log.dart';

enum NotificationManagerImportance {
  high(4),
  defaultImportance(3),
  low(2),
  min(1);

  final int num;
  const NotificationManagerImportance(this.num);
}

class NotificationService {
  static const MethodChannel _channel =
      MethodChannel('mobisen_app.android/notification');

  static Future<void> createNotificationChannel(String channelId,
      String channelName, NotificationManagerImportance importance) async {
    try {
      await _channel.invokeMethod('createNotificationChannel', {
        'channelId': channelId,
        'channelName': channelName,
        'importance': importance.num,
      });
    } on PlatformException catch (e) {
      LogE("Failed to create notification channel: '${e.message}'.");
    }
  }

  static Future<void> createMultipleNotificationChannels(
      List<Map<String, dynamic>> channels) async {
    try {
      await _channel.invokeMethod('createMultipleNotificationChannels', {
        'channels': channels,
      });
    } on PlatformException catch (e) {
      LogE("Failed to create multiple notification channels: '${e.message}'.");
    }
  }
}
