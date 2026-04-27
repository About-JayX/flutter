import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobisen_app/app_router.dart';
import 'package:mobisen_app/routes/application.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/util/text_utils.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/util/track_helper.dart';

class LocNotificationHelper {
  /// Using singleton pattern for initialization
  static final LocNotificationHelper _instance =
      LocNotificationHelper._internal();
  factory LocNotificationHelper() => _instance;
  LocNotificationHelper._internal();

  /// FlutterLocalNotificationsPlugin is a plugin for handling local notifications, providing functionality to send and receive local notifications in Flutter applications.
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialization function
  Future<void> initialize() async {
    /// AndroidInitializationSettings is a class used to set up local notification initialization on Android.
    /// Using app_icon as a parameter means that on Android, the application icon will be used as the icon for local notifications.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_ic_notification');

    /// 15.1 is DarwinInitializationSettings; older versions seem to use IOSInitializationSettings (some examples use this).
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    /// Initialization
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        try {
          final jPayload = json.decode(response.payload!);
          if (jPayload is Map && jPayload.isNotEmpty) {
            onSelectNotification(Map<String, dynamic>.from(jPayload));
          }
        } catch (e) {
          LogE(
              "LocNotificationHelper-initialize_onDidReceiveNotificationResponse:\n$e");
        }
      }
    });
  }

  /// Show notification
  Future<void> showNotification(RemoteMessage message) async {
    try {
      /// Configure notification
      /// Android notification
      /// 'your channel id': used to specify the ID of the notification channel.
      /// 'your channel name': used to specify the name of the notification channel.
      /// 'your channel description': used to specify the description of the notification channel.
      /// Importance.max: used to specify the importance of the notification, set to the highest level.
      /// Priority.high: used to specify the priority of the notification, set to high priority.
      /// 'ticker': used to specify the hint text for the notification, i.e., the text content that appears in the notification center.
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'important_loc', // id
        'Important Local', // title
        channelDescription: 'Important Local Notifications.',
        importance: Importance.max,
        priority: Priority.max,
      );

      /// iOS notification
      const String darwinNotificationCategoryPlain = 'plainCategory';
      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        categoryIdentifier:
            darwinNotificationCategoryPlain, // Notification category
      );

      /// Create cross-platform notification
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidNotificationDetails, iOS: iosNotificationDetails);

      /// Initiate a notification
      await _notificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: json.encode(message.data).toString(),
      );
    } catch (e) {
      LogE("LocNotificationHelper-showNotification:\n$e");
    }
  }

  Future<void> onSelectNotification(Map<String, dynamic> payload) async {
    try {
      BuildContext? globalContext =
          Application.navigatorKey.currentState?.context;
      if (globalContext != null &&
          (payload['route'] != null &&
              RoutePaths.doesPathExist(payload['route'].toString()))) {
        final path = payload['route'];
        final pArgs = json.decode(json.encode(payload).toString());
        pArgs.forEach((key, value) {
          if (value is String) {
            var parsedValue = TextUtils.parseString(value);
            if (parsedValue != null) {
              pArgs[key] = parsedValue;
            }
          }
        });
        final CommonArgs args = CommonArgs.fromMap(pArgs);
        Future.delayed(const Duration(seconds: 1), () {
          if (globalContext.mounted) {
            Navigator.pushNamed(
              globalContext,
              path,
              arguments: args, //CommonArgs(showId:1)
            );
          }
        });
      }
    } catch (e) {
      LogE("LocNotificationHelper-_onSelectNotification-mainLogic:\n$e");
    }

    TrackHelper.instance.track(
      event: TrackEvents.notification,
      action: TrackValues.click,
    );
  }
}
