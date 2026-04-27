import 'package:json_annotation/json_annotation.dart';

part 'membership.g.dart';

/// VIP 特权枚举
enum VIPPrivilege {
  exclusiveBadge, // 1. 专属会员徽章
  extraDailySwipes, // 2. 每日额外滑动次数 (+8次)
  swipeRewind, // 3. 滑动倒回（撤销上一次操作）
  chatLock, // 4. 聊天上锁
  incognitoBrowsing, // 5. 隐身浏览
  hideOnlineStatus, // 6. 隐藏在线状态
  fullProfilePrivacy, // 7. 资料完全隐私（隐藏年龄、国家、性别）
  unlockVideoCalls, // 8. 解锁1v1视频通话
  unlockVoiceCalls, // 9. 解锁1v1语音通话
  monthlyVideoMinutes, // 10. 每月赠送60分钟视频时长
  monthlyVoiceMinutes, // 11. 每月赠送120分钟语音时长
  hdVideoQuality, // 12. 更高清画质
  voiceNoiseReduction, // 13. 语音降噪
  beautyFilters, // 14. 美颜滤镜
  viewProfileVisitors, // 15. 查看谁看过你
  customBlockedKeywords, // 16. 自定义屏蔽骚扰词
}

@JsonSerializable()
class Membership {
  final int? level; // 会员等级 (0=无, 1=basic, 2=premium, 3=ultimate)
  final int? expirationTime; // 过期时间戳 (秒)

  // 新增字段（可选，向后兼容）
  final String? type; // 套餐类型: basic/premium/ultimate
  final bool? isActive; // 是否有效
  final int? startTime; // 开始时间戳
  final String? productId; // 购买的产品ID

  // VIP 2.0 新增字段 - 每月赠送时长
  final int? monthlyVideoMinutesTotal; // 每月视频时长总额（默认60分钟）
  final int? monthlyVideoMinutesUsed; // 已使用视频时长
  final int? monthlyVoiceMinutesTotal; // 每月语音时长总额（默认120分钟）
  final int? monthlyVoiceMinutesUsed; // 已使用语音时长
  final int? monthlyResetDate; // 下次重置日期（时间戳，秒）

  const Membership({
    this.level,
    this.expirationTime,
    this.type,
    this.isActive,
    this.startTime,
    this.productId,
    this.monthlyVideoMinutesTotal,
    this.monthlyVideoMinutesUsed,
    this.monthlyVoiceMinutesTotal,
    this.monthlyVoiceMinutesUsed,
    this.monthlyResetDate,
  });

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);

  /// 检查会员是否有效
  bool get isValid {
    if (level == null || level == 0) return false;
    if (expirationTime == null) return false;
    return DateTime.now().millisecondsSinceEpoch < (expirationTime! * 1000);
  }

  /// 获取 VIP 等级名称
  String get levelName {
    switch (level) {
      case 1:
        return '周会员';
      case 2:
        return '月会员';
      default:
        return '普通用户';
    }
  }

  /// 获取剩余天数
  int? get remainingDays {
    if (!isValid) return null;
    final expireDate =
        DateTime.fromMillisecondsSinceEpoch(expirationTime! * 1000);
    return expireDate.difference(DateTime.now()).inDays;
  }

  /// 获取剩余视频时长
  int get remainingVideoMinutes {
    if (!isValid) return 0;
    final total = monthlyVideoMinutesTotal ?? 60;
    final used = monthlyVideoMinutesUsed ?? 0;
    return total - used;
  }

  /// 获取剩余语音时长
  int get remainingVoiceMinutes {
    if (!isValid) return 0;
    final total = monthlyVoiceMinutesTotal ?? 120;
    final used = monthlyVoiceMinutesUsed ?? 0;
    return total - used;
  }

  /// 检查是否需要重置每月时长
  bool get needsMonthlyReset {
    if (monthlyResetDate == null) return false;
    return DateTime.now().millisecondsSinceEpoch > (monthlyResetDate! * 1000);
  }

  /// 获取下次重置日期
  static DateTime getNextResetDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 1);
  }

  /// 检查是否有某特权（当前实现：所有有效VIP都有全部特权）
  bool hasPrivilege(VIPPrivilege privilege) => isValid;

  Membership copyWith({
    int? level,
    int? expirationTime,
    String? type,
    bool? isActive,
    int? startTime,
    String? productId,
    int? monthlyVideoMinutesTotal,
    int? monthlyVideoMinutesUsed,
    int? monthlyVoiceMinutesTotal,
    int? monthlyVoiceMinutesUsed,
    int? monthlyResetDate,
  }) {
    return Membership(
      level: level ?? this.level,
      expirationTime: expirationTime ?? this.expirationTime,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      productId: productId ?? this.productId,
      monthlyVideoMinutesTotal:
          monthlyVideoMinutesTotal ?? this.monthlyVideoMinutesTotal,
      monthlyVideoMinutesUsed:
          monthlyVideoMinutesUsed ?? this.monthlyVideoMinutesUsed,
      monthlyVoiceMinutesTotal:
          monthlyVoiceMinutesTotal ?? this.monthlyVoiceMinutesTotal,
      monthlyVoiceMinutesUsed:
          monthlyVoiceMinutesUsed ?? this.monthlyVoiceMinutesUsed,
      monthlyResetDate: monthlyResetDate ?? this.monthlyResetDate,
    );
  }
}
