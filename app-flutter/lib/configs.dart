import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// RevenueCat API Keys
/// 测试环境: test_hFqSLztZPGIDZmatvJkTllokQFW
/// 生产环境: 需要替换为实际的 Android/iOS Key
class RevenueCatConfig {
  static const String _testKey = "test_hFqSLztZPGIDZmatvJkTllokQFW";
  static const String _androidProdKey = "goog_PRODUCTION_KEY_PLACEHOLDER";
  static const String _iosProdKey = "appl_PRODUCTION_KEY_PLACEHOLDER";

  static String get androidKey => kReleaseMode ? _androidProdKey : _testKey;

  static String get iosKey => kReleaseMode ? _iosProdKey : _testKey;

  /// RevenueCat Entitlement ID
  /// 必须与 Dashboard 中配置的 Entitlement 标识符一致
  static const String entitlementId = "wakme Pro";
}

/// ZEGO 配置
class ZegoConfig {
  // ZEGO AppID
  static const int appID = 630742642;

  // ZEGO AppSign
  static const String appSign =
      '6db8a8468a47b7abbc6aab1f1e7d79d91b761e6d4e927d5f1a2c665bb4bf55c3';

  // 环境配置
  static const bool isTestEnv = true; // 测试环境
}

class Configs {
  static late Configs instance;

  late final ConfigItem<String> locale;
  late final ConfigItem<String> account;
  late final ConfigItem<bool> autoUnlockNext;
  late final ConfigItem<int> firstLaunchTimeMillis;
  late final ConfigItem<bool> triedAutoPlayNewUser;
  // late final ConfigItem<bool> openNotification;
  late final ConfigItem<bool> notificationFirst;
  late final ConfigItem<bool> inAppReviewFirst;
  late final ConfigItem<bool> privacyPolicyAccepted;

  static init() async {
    instance = Configs._();
    await instance._initConfigs();
  }

  Configs._();

  Future<void> _initConfigs() async {
    final pref = await SharedPreferences.getInstance();
    locale = ConfigItem(pref, "locale", "en");
    account = ConfigItem(pref, "app_account", "");
    autoUnlockNext = ConfigItem(pref, "auto_unlock_next", false);
    firstLaunchTimeMillis = ConfigItem(pref, "first_launch_time_millis", 0);
    triedAutoPlayNewUser = ConfigItem(pref, "tried_auto_play_new_user", false);
    notificationFirst = ConfigItem(pref, "notification_first", false);
    // openNotification = ConfigItem(pref, "open_notification", false);
    inAppReviewFirst = ConfigItem(pref, "in_app_review_first", true);
    privacyPolicyAccepted = ConfigItem(pref, "privacy_policy_accepted", false);
  }
}

class ConfigItem<T> {
  final T _defaultValue;
  late T _value;
  final String _key;

  T get value => _value;
  set value(T v) {
    _value = v;
    _setValue(v);
  }

  ConfigItem(SharedPreferences pref, this._key, this._defaultValue) {
    T? v;
    try {
      if (_defaultValue is String) {
        v = pref.getString(_key) as T;
      } else if (_defaultValue is int) {
        v = pref.getInt(_key) as T;
      } else if (_defaultValue is double) {
        v = pref.getDouble(_key) as T;
      } else if (_defaultValue is bool) {
        v = pref.getBool(_key) as T;
      }
    } catch (e) {}
    _value = v ?? _defaultValue;
  }

  void _setValue(T v) async {
    try {
      final pref = await SharedPreferences.getInstance();
      if (_defaultValue is String) {
        await pref.setString(_key, v as String);
      } else if (_defaultValue is int) {
        await pref.setInt(_key, v as int);
      } else if (_defaultValue is double) {
        await pref.setDouble(_key, v as double);
      } else if (_defaultValue is bool) {
        await pref.setBool(_key, v as bool);
      }
    } catch (e) {}
  }
}
