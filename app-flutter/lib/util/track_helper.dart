import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mobisen_app/configs.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/util/account_helper.dart';
import 'package:mobisen_app/util/log.dart';

class TrackHelper {
  static final TrackHelper _instance = TrackHelper._();
  static TrackHelper get instance => _instance;

  late FacebookAppEvents facebookAppEvents;

  Map<String, Object> get _commonParams => {
        TrackParams.appUserId: "${AccountHelper.instance.account?.user.id}",
        TrackParams.appLang: Configs.instance.locale.value,
        TrackParams.daysSinceFirstLaunch: "${_calculateDaysSinceFirstLaunch()}",
        TrackParams.membershipLevel:
            (AccountHelper.instance.account?.user.membership?.level ?? 0) != 0
                ? TrackValues.pro
                : TrackValues.regular,
      };

  int _calculateDaysSinceFirstLaunch() {
    int nowUtcMillis = DateTime.now().millisecondsSinceEpoch;
    int differenceInMilliseconds =
        nowUtcMillis - Configs.instance.firstLaunchTimeMillis.value;
    const int millisecondsPerDay = 1000 * 60 * 60 * 24;
    int daysSinceFirstUse = differenceInMilliseconds ~/ millisecondsPerDay;
    return daysSinceFirstUse;
  }

  TrackHelper._() {
    facebookAppEvents = FacebookAppEvents();
  }

  void track(
      {required String event,
      String? action,
      Map<String, dynamic>? params}) async {
    try {
      /// User tracking is not performed in debug mode
      if (kDebugMode) return;
      // LogE(
      //     "'product env user action track': I don't wanna see you in debug mode");

      Map<String, dynamic> parameters = Map.from(_commonParams);
      if (params != null) {
        parameters.addAll(params);
      }

      Map<String, Object> newParams = {};
      parameters.forEach((key, value) {
        if (value is String) {
          if (value.length >= 100) {
            newParams[key] = value.substring(0, 99);
          } else {
            newParams[key] = value;
          }
        } else {
          newParams[key] = value;
        }
      });

      if (action != null) {
        newParams[TrackParams.action] = action;
      }
      await FirebaseAnalytics.instance
          .logEvent(name: event, parameters: newParams);
      // if (kDebugMode) {
      //   print("track event: $event, params: $newParams");
      // }
    } catch (e) {
      LogE("TrackHelper-track:\n$e");
    }
  }

  void trackScreenView({required String screenName}) async {
    Map<String, Object>? params = _commonParams;
    try {
      await FirebaseAnalytics.instance
          .logScreenView(screenName: screenName, parameters: params);
      if (kDebugMode) {
        print("track screen_view: $screenName, params: $params");
      }
    } catch (e) {
      // todo report
    }
  }

  void updateUserProperties() async {
    try {
      await FirebaseAnalytics.instance.setUserProperty(
          name: TrackParams.appUserId,
          value: "${AccountHelper.instance.account?.user.id}");
      await FirebaseAnalytics.instance.setUserProperty(
          name: TrackParams.appLang, value: Configs.instance.locale.value);
    } catch (e) {
      // todo report
    }
  }
}
