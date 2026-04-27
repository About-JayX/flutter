// import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobisen_app/util/log.dart';
// import 'package:mobisen_app/util/permission_mange_util.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:mobisen_app/provider/remote_message_provider.dart';
import 'package:mobisen_app/messaging/loc_notification_helper.dart';
import 'package:mobisen_app/messaging/channel/notification_service.dart';
import 'package:mobisen_app/routes/application.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// If you're going to use other Firebase services in the background, such as Firestore,
  /// make sure you call `initializeApp` before using other Firebase services.
  // LogI("Background notification");
  // FirebaseMessagingService.handleMessage(message);
}

// List<String> messagingIds = [];

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      /// Create a notification channel
      _createCustomNotificationChannel();
      // if (Platform.isAndroid) {
      //   await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      //     alert: true, // Show banner notifications
      //     badge: true, // Show badge
      //     sound: true, // Play sound
      //   );
      // }

      /// Get Firebase Cloud Messaging token
      final fCMToken = await _firebaseMessaging.getToken();

      /// Background notification callback
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      /// Foreground notification listener
      FirebaseMessaging.onMessage.listen(inAppMessagingHandler);

      /// Listen for opening the app via system notification when in the background
      FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);

      /// To receive notifications whenever the token is updated
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        // TODO: If necessary send token to application server.
        // This callback is triggered whenever a new token is generated.
      }).onError((err) {
        /// Error getting token.
        LogE(
            "initNotifications-FirebaseMessaging.instance.onTokenRefresh.listen:\n$err");
      });
      // LogD("message-Token:\n$fCMToken");
    } catch (e) {
      LogE("initNotifications:\n$e");
    }
  }

  void _createCustomNotificationChannel() {
    NotificationService.createNotificationChannel(
        "video", "Video", NotificationManagerImportance.high);
  }

  void onMessageOpenedApp(RemoteMessage message) {
    LogI("Opened notification");
    handleMessage(message);
    LocNotificationHelper().onSelectNotification(message.data);
  }

  void inAppMessagingHandler(RemoteMessage? message) {
    /// If the message is not null
    if (message == null) return;

    /// User clicks the notification, enter the specific page
    // Get.toNamed("/home", arguments: message);
    // LogI("Foreground notification");
    handleMessage(message);
    LocNotificationHelper().showNotification(message);
  }

  static void handleMessage(RemoteMessage? message) {
    // LogD("Handling a background message: \n${message?.toMap()}");
    // LogD("messageId: \n${message?.messageId}");
    // LogD("payload: \n${message?.data}");

    BuildContext? globalContext =
        Application.navigatorKey.currentState?.context;
    if (globalContext != null) {
      final remoteMessageProvider =
          Provider.of<RemoteMessageProvider>(globalContext, listen: false);
      if (message != null) {
        remoteMessageProvider.addMessage(message);
      }
    }
  }
}
