import 'package:flutter/material.dart';
import 'package:mobisen_app/db/hive_helper.dart';
import 'package:mobisen_app/model/privacy_settings.dart';

class PrivacyProvider extends ChangeNotifier {
  static const String _key = 'user_privacy_settings';

  PrivacySettings _settings = const PrivacySettings();

  PrivacySettings get settings => _settings;

  // 便捷访问器
  bool get showOnlineStatus => _settings.showOnlineStatus;
  bool get allowStrangerMessage => _settings.allowStrangerMessage;
  bool get allowStrangerCall => _settings.allowStrangerCall;
  ProfileVisibility get profileVisibility => _settings.profileVisibility;
  bool get anonymousBrowse => _settings.anonymousBrowse;
  bool get showLastSeen => _settings.showLastSeen;
  bool get allowSearchByPhone => _settings.allowSearchByPhone;
  bool get allowSearchByEmail => _settings.allowSearchByEmail;
  PhotoVisibility get photoVisibility => _settings.photoVisibility;
  bool get showLocation => _settings.showLocation;
  bool get showAge => _settings.showAge;
  bool get showGender => _settings.showGender;
  List<String> get blockedUsers => _settings.blockedUsers;
  List<String> get blockedKeywords => _settings.blockedKeywords;

  /// 初始化（从 Hive 加载）
  Future<void> initialize() async {
    await _loadSettings();
  }

  /// 加载设置（使用现有 HiveHelper）
  Future<void> _loadSettings() async {
    try {
      final json = HiveHelper.instance.privacySettingsBox.get(_key);
      if (json != null) {
        _settings = PrivacySettings.fromJson(Map<String, dynamic>.from(json));
        notifyListeners();
      }
    } catch (e) {
      print('加载隐私设置失败: $e');
    }
  }

  /// 保存设置到本地（使用现有 HiveHelper）
  Future<void> _saveSettings() async {
    try {
      await HiveHelper.instance.privacySettingsBox
          .put(_key, _settings.toJson());
    } catch (e) {
      print('保存隐私设置失败: $e');
    }
  }

  /// 更新设置
  Future<void> updateSettings(PrivacySettings newSettings) async {
    _settings = newSettings;
    await _saveSettings();
    notifyListeners();
  }

  /// 更新单个设置项
  Future<void> updateSetting({
    bool? showOnlineStatus,
    bool? allowStrangerMessage,
    bool? allowStrangerCall,
    ProfileVisibility? profileVisibility,
    bool? anonymousBrowse,
    bool? showLastSeen,
    bool? allowSearchByPhone,
    bool? allowSearchByEmail,
    PhotoVisibility? photoVisibility,
    bool? showLocation,
    bool? showAge,
    bool? showGender,
  }) async {
    _settings = _settings.copyWith(
      showOnlineStatus: showOnlineStatus,
      allowStrangerMessage: allowStrangerMessage,
      allowStrangerCall: allowStrangerCall,
      profileVisibility: profileVisibility,
      anonymousBrowse: anonymousBrowse,
      showLastSeen: showLastSeen,
      allowSearchByPhone: allowSearchByPhone,
      allowSearchByEmail: allowSearchByEmail,
      photoVisibility: photoVisibility,
      showLocation: showLocation,
      showAge: showAge,
      showGender: showGender,
    );

    await _saveSettings();
    notifyListeners();
  }

  /// 添加黑名单用户
  Future<void> blockUser(String userId) async {
    if (!_settings.blockedUsers.contains(userId)) {
      final newList = List<String>.from(_settings.blockedUsers)..add(userId);
      _settings = _settings.copyWith(blockedUsers: newList);
      await _saveSettings();
      notifyListeners();
    }
  }

  /// 移除黑名单用户
  Future<void> unblockUser(String userId) async {
    final newList = List<String>.from(_settings.blockedUsers)..remove(userId);
    _settings = _settings.copyWith(blockedUsers: newList);
    await _saveSettings();
    notifyListeners();
  }

  /// 添加屏蔽关键词
  Future<void> addBlockedKeyword(String keyword) async {
    if (!_settings.blockedKeywords.contains(keyword)) {
      final newList = List<String>.from(_settings.blockedKeywords)
        ..add(keyword);
      _settings = _settings.copyWith(blockedKeywords: newList);
      await _saveSettings();
      notifyListeners();
    }
  }

  /// 移除屏蔽关键词
  Future<void> removeBlockedKeyword(String keyword) async {
    final newList = List<String>.from(_settings.blockedKeywords)
      ..remove(keyword);
    _settings = _settings.copyWith(blockedKeywords: newList);
    await _saveSettings();
    notifyListeners();
  }

  /// 检查是否已拉黑某用户
  bool isUserBlocked(String userId) {
    return _settings.blockedUsers.contains(userId);
  }

  /// 检查消息是否包含屏蔽词
  bool containsBlockedKeyword(String message) {
    for (final keyword in _settings.blockedKeywords) {
      if (message.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  /// 重置为默认设置
  Future<void> resetToDefault() async {
    _settings = const PrivacySettings();
    await _saveSettings();
    notifyListeners();
  }

  /// 清理数据
  Future<void> clear() async {
    _settings = const PrivacySettings();
    try {
      await HiveHelper.instance.privacySettingsBox.delete(_key);
    } catch (e) {
      print('清除隐私设置失败: $e');
    }
    notifyListeners();
  }
}
