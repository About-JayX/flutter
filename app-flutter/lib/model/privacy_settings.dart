import 'package:json_annotation/json_annotation.dart';

part 'privacy_settings.g.dart';

/// 资料可见范围
enum ProfileVisibility {
  everyone, // 所有人
  friends, // 仅好友
  nobody, // 仅自己
}

/// 照片可见范围
enum PhotoVisibility {
  everyone, // 所有人
  friends, // 仅好友
  vip, // 仅 VIP
  nobody, // 仅自己
}

@JsonSerializable()
class PrivacySettings {
  final bool showOnlineStatus; // 是否显示在线状态
  final bool allowStrangerMessage; // 是否允许陌生人私信
  final bool allowStrangerCall; // 是否允许陌生人通话
  final ProfileVisibility profileVisibility; // 资料可见范围
  final bool anonymousBrowse; // 匿名浏览模式
  final bool showLastSeen; // 是否显示最后在线时间
  final bool allowSearchByPhone; // 是否允许通过手机号搜索
  final bool allowSearchByEmail; // 是否允许通过邮箱搜索
  final PhotoVisibility photoVisibility; // 照片可见范围
  final bool showLocation; // 是否显示位置信息
  final bool showAge; // 是否显示年龄
  final bool showGender; // 是否显示性别
  final List<String> blockedUsers; // 黑名单用户ID列表
  final List<String> blockedKeywords; // 屏蔽关键词列表

  const PrivacySettings({
    this.showOnlineStatus = true,
    this.allowStrangerMessage = false,
    this.allowStrangerCall = false,
    this.profileVisibility = ProfileVisibility.everyone,
    this.anonymousBrowse = false,
    this.showLastSeen = true,
    this.allowSearchByPhone = false,
    this.allowSearchByEmail = false,
    this.photoVisibility = PhotoVisibility.everyone,
    this.showLocation = false,
    this.showAge = true,
    this.showGender = true,
    this.blockedUsers = const [],
    this.blockedKeywords = const [],
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsFromJson(json);
  Map<String, dynamic> toJson() => _$PrivacySettingsToJson(this);

  PrivacySettings copyWith({
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
    List<String>? blockedUsers,
    List<String>? blockedKeywords,
  }) {
    return PrivacySettings(
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowStrangerMessage: allowStrangerMessage ?? this.allowStrangerMessage,
      allowStrangerCall: allowStrangerCall ?? this.allowStrangerCall,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      anonymousBrowse: anonymousBrowse ?? this.anonymousBrowse,
      showLastSeen: showLastSeen ?? this.showLastSeen,
      allowSearchByPhone: allowSearchByPhone ?? this.allowSearchByPhone,
      allowSearchByEmail: allowSearchByEmail ?? this.allowSearchByEmail,
      photoVisibility: photoVisibility ?? this.photoVisibility,
      showLocation: showLocation ?? this.showLocation,
      showAge: showAge ?? this.showAge,
      showGender: showGender ?? this.showGender,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      blockedKeywords: blockedKeywords ?? this.blockedKeywords,
    );
  }
}

/// 隐私设置扩展
extension PrivacySettingsExtension on PrivacySettings {
  /// 检查是否允许某用户查看资料
  bool canViewProfile(String userId, bool isFriend) {
    switch (profileVisibility) {
      case ProfileVisibility.everyone:
        return true;
      case ProfileVisibility.friends:
        return isFriend;
      case ProfileVisibility.nobody:
        return false;
    }
  }

  /// 检查是否允许某用户查看照片
  bool canViewPhotos(String userId, bool isFriend, bool isVip) {
    switch (photoVisibility) {
      case PhotoVisibility.everyone:
        return true;
      case PhotoVisibility.friends:
        return isFriend;
      case PhotoVisibility.vip:
        return isVip;
      case PhotoVisibility.nobody:
        return false;
    }
  }

  /// 检查是否允许发送消息
  bool canReceiveMessage(String userId, bool isFriend) {
    if (blockedUsers.contains(userId)) return false;
    if (isFriend) return true;
    return allowStrangerMessage;
  }

  /// 检查是否允许通话
  bool canReceiveCall(String userId, bool isFriend) {
    if (blockedUsers.contains(userId)) return false;
    if (isFriend) return true;
    return allowStrangerCall;
  }
}
