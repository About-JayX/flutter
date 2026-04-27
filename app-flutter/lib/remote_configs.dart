import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mobisen_app/util/text_utils.dart';

class RemoteConfigs {
  static late RemoteConfigs instance;

  static Future<void> init() async {
    instance = RemoteConfigs._();
    await instance._init();
  }

  late FirebaseRemoteConfig _remoteConfig;

  RemoteConfigs._();

  Future<void> _init() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.setDefaults(const {});
    _remoteConfig.fetchAndActivate();
  }

  bool getInAppReviewBool() {
    return _getBoolWithDefault("in_app_review", true);
  }

  bool _getBoolWithDefault(String key, bool defValue) {
    bool result = _remoteConfig.getBool(key);
    if (result == null) {
      return defValue;
    }
    return result;
  }

  String getPurchaseSubItemsAndroidString() {
    return _getStringWithDefault("purchase_sub_items_android_v2",
        "{\"items\":[{\"id\":\"android_pro:android-pro-weekly\",\"type\":\"week\"},{\"id\":\"android_pro:android-pro-monthly\",\"type\":\"month\"},{\"id\":\"android_pro:android-pro-yearly\",\"type\":\"year\"}]}");
  }

  String getPurchaseSubItemsIOSString() {
    return _getStringWithDefault("purchase_sub_items_ios_v2",
        "{\"items\":[{\"id\":\"ios_pro_weekly\",\"type\":\"week\"},{\"id\":\"ios_pro_monthly\",\"type\":\"month\"},{\"id\":\"ios_pro_yearly\",\"type\":\"year\"}]}");
  }

  String getPurchaseItemsAndroidString() {
    return _getStringWithDefault("purchase_items_android_v2",
        "{\"items\":[{\"id\":\"android_coins_new_user\",\"coins\":200,\"type\":\"new_user\"},{\"id\":\"android_coins_100\",\"coins\":100,\"type\":\"normal\"},{\"id\":\"android_coins_500\",\"coins\":500,\"extraCoins\":75,\"type\":\"normal\"},{\"id\":\"android_coins_1000\",\"coins\":1000,\"extraCoins\":250,\"type\":\"normal\"},{\"id\":\"android_coins_2000\",\"coins\":2000,\"extraCoins\":600,\"type\":\"normal\"},{\"id\":\"android_coins_3000\",\"coins\":3000,\"extraCoins\":1200,\"type\":\"normal\"},{\"id\":\"android_coins_5000\",\"coins\":5000,\"extraCoins\":2500,\"type\":\"normal\"}]}");
  }

  String getPurchaseItemsIOSString() {
    return _getStringWithDefault("purchase_items_ios_v2",
        "{\"items\":[{\"id\":\"ios_coins_new_user\",\"coins\":300,\"type\":\"new_user\"},{\"id\":\"ios_coins_100\",\"coins\":100,\"type\":\"normal\"},{\"id\":\"ios_coins_500\",\"coins\":500,\"extraCoins\":75,\"type\":\"normal\"},{\"id\":\"ios_coins_1000\",\"coins\":1000,\"extraCoins\":250,\"type\":\"normal\"},{\"id\":\"ios_coins_2000\",\"coins\":2000,\"extraCoins\":600,\"type\":\"normal\"},{\"id\":\"ios_coins_3000\",\"coins\":3000,\"extraCoins\":1200,\"type\":\"normal\"},{\"id\":\"ios_coins_5000\",\"coins\":5000,\"extraCoins\":2500,\"type\":\"normal\"}]}");
  }

  // 新增 VIP 商品配置（周会员和月会员）
  String getVIPItemsAndroidString() {
    return _getStringWithDefault("vip_items_android",
        "{\"items\":[{\"id\":\"android_vip_weekly\",\"type\":\"week\",\"level\":1},{\"id\":\"android_vip_monthly\",\"type\":\"month\",\"level\":2}]}");
  }

  String getVIPItemsIOSString() {
    return _getStringWithDefault("vip_items_ios",
        "{\"items\":[{\"id\":\"ios_vip_weekly\",\"type\":\"week\",\"level\":1},{\"id\":\"ios_vip_monthly\",\"type\":\"month\",\"level\":2}]}");
  }

  String _getStringWithDefault(String key, String defValue) {
    final str = _remoteConfig.getString(key);
    if (TextUtils.isNullOrEmpty(str)) {
      return defValue;
    }
    return str;
  }
}
