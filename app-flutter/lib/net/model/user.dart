import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/util/text_utils.dart';
import 'membership.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  int id;
  String username;
  String? displayName;
  String? avatarUrl;
  String? email;
  bool? blocked;
  int coins;
  Membership? membership;
  @JsonKey(name: 'personalize_edit')
  int? personalizeEdit;

  // 个性化资料字段
  String? gender;
  String? birthDate;
  String? country;
  String? language;
  String? occupation;
  List<String>? interests;
  List<String>? personality;
  List<String>? chatPurpose;
  List<String>? communicationStyle;
  String? status;
  @JsonKey(name: 'is_status_public')
  bool? isStatusPublic;
  @JsonKey(name: 'blur_profile_card')
  bool? blurProfileCard;

  // VIP 滑动/撤回计数（本地存储，后端暂不支持）
  @JsonKey(name: 'daily_swipe_count')
  int? dailySwipeCount; // 今日滑动次数
  @JsonKey(name: 'daily_recall_count')
  int? dailyRecallCount; // 今日撤回次数
  @JsonKey(name: 'last_swipe_date')
  int? lastSwipeDate; // 最后滑动日期（时间戳，秒）
  @JsonKey(name: 'last_recall_date')
  int? lastRecallDate; // 最后撤回日期（时间戳，秒）

  String? _defaultAvatarUrl;
  String get ensureAvatarUrl {
    if (!TextUtils.isNullOrEmpty(avatarUrl)) {
      return avatarUrl!;
    }
    if (_defaultAvatarUrl == null) {
      String seed = email ?? username;
      final bytes = utf8.encode(seed.trim().toLowerCase());
      final digest = sha256.convert(bytes);
      _defaultAvatarUrl =
          "https://www.gravatar.com/avatar/${digest.toString()}?size=128&&d=identicon";
    }
    return _defaultAvatarUrl!;
  }

  User(
    this.id,
    this.username,
    this.email,
    this.blocked,
    this.coins,
    this.displayName,
    this.membership, {
    this.personalizeEdit,
    this.gender,
    this.birthDate,
    this.country,
    this.language,
    this.occupation,
    this.interests,
    this.personality,
    this.chatPurpose,
    this.communicationStyle,
    this.status,
    this.isStatusPublic,
    this.blurProfileCard,
    this.dailySwipeCount = 0,
    this.dailyRecallCount = 0,
    this.lastSwipeDate,
    this.lastRecallDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// 检查是否需要重置每日滑动计数
  bool get needsSwipeCountReset {
    if (lastSwipeDate == null) return true;
    final lastDate = DateTime.fromMillisecondsSinceEpoch(lastSwipeDate! * 1000);
    final now = DateTime.now();
    return lastDate.year != now.year ||
        lastDate.month != now.month ||
        lastDate.day != now.day;
  }

  /// 检查是否需要重置每日撤回计数
  bool get needsRecallCountReset {
    if (lastRecallDate == null) return true;
    final lastDate =
        DateTime.fromMillisecondsSinceEpoch(lastRecallDate! * 1000);
    final now = DateTime.now();
    return lastDate.year != now.year ||
        lastDate.month != now.month ||
        lastDate.day != now.day;
  }

  User copyWith({
    int? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? email,
    bool? blocked,
    int? coins,
    Membership? membership,
    int? personalizeEdit,
    String? gender,
    String? birthDate,
    String? country,
    String? language,
    String? occupation,
    List<String>? interests,
    List<String>? personality,
    List<String>? chatPurpose,
    List<String>? communicationStyle,
    String? status,
    bool? isStatusPublic,
    bool? blurProfileCard,
    int? dailySwipeCount,
    int? dailyRecallCount,
    int? lastSwipeDate,
    int? lastRecallDate,
  }) {
    return User(
      id ?? this.id,
      username ?? this.username,
      email ?? this.email,
      blocked ?? this.blocked,
      coins ?? this.coins,
      displayName ?? this.displayName,
      membership ?? this.membership,
      personalizeEdit: personalizeEdit ?? this.personalizeEdit,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      language: language ?? this.language,
      occupation: occupation ?? this.occupation,
      interests: interests ?? this.interests,
      personality: personality ?? this.personality,
      chatPurpose: chatPurpose ?? this.chatPurpose,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      status: status ?? this.status,
      isStatusPublic: isStatusPublic ?? this.isStatusPublic,
      blurProfileCard: blurProfileCard ?? this.blurProfileCard,
      dailySwipeCount: dailySwipeCount ?? this.dailySwipeCount,
      dailyRecallCount: dailyRecallCount ?? this.dailyRecallCount,
      lastSwipeDate: lastSwipeDate ?? this.lastSwipeDate,
      lastRecallDate: lastRecallDate ?? this.lastRecallDate,
    );
  }
}
