import 'package:json_annotation/json_annotation.dart';

part 'block_model.g.dart';

/// 举报类型
enum ReportType {
  harassment, // 骚扰
  spam, // 垃圾信息
  inappropriate, // 不当内容
  fake, // 虚假信息
  scam, // 诈骗
  other, // 其他
}

/// 举报状态
enum ReportStatus {
  pending, // 待处理
  processing, // 处理中
  resolved, // 已解决
  rejected, // 已驳回
}

@JsonSerializable()
class BlockedUser {
  final String userId;
  final String username;
  final String? avatarUrl;
  final DateTime blockedAt;
  final String? reason;
  final bool isPermanent;
  final DateTime? expireAt;

  const BlockedUser({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.blockedAt,
    this.reason,
    this.isPermanent = true,
    this.expireAt,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserFromJson(json);
  Map<String, dynamic> toJson() => _$BlockedUserToJson(this);

  /// 检查是否已过期
  bool get isExpired {
    if (isPermanent) return false;
    if (expireAt == null) return false;
    return DateTime.now().isAfter(expireAt!);
  }
}

@JsonSerializable()
class BlockedKeyword {
  final String keyword;
  final DateTime createdAt;
  final bool isRegex;
  final bool caseSensitive;

  const BlockedKeyword({
    required this.keyword,
    required this.createdAt,
    this.isRegex = false,
    this.caseSensitive = false,
  });

  factory BlockedKeyword.fromJson(Map<String, dynamic> json) =>
      _$BlockedKeywordFromJson(json);
  Map<String, dynamic> toJson() => _$BlockedKeywordToJson(this);

  /// 检查文本是否匹配
  bool matches(String text) {
    if (isRegex) {
      try {
        final regex = RegExp(
          keyword,
          caseSensitive: caseSensitive,
        );
        return regex.hasMatch(text);
      } catch (e) {
        return false;
      }
    } else {
      if (caseSensitive) {
        return text.contains(keyword);
      } else {
        return text.toLowerCase().contains(keyword.toLowerCase());
      }
    }
  }
}

@JsonSerializable()
class Report {
  final String id;
  final String reporterId;
  final String reportedUserId;
  final ReportType type;
  final String reason;
  final String? description;
  final List<String>? evidence;
  final DateTime createdAt;
  final ReportStatus status;

  const Report({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    required this.type,
    required this.reason,
    this.description,
    this.evidence,
    required this.createdAt,
    this.status = ReportStatus.pending,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
