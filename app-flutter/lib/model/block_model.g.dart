// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedUser _$BlockedUserFromJson(Map<String, dynamic> json) => BlockedUser(
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      blockedAt: DateTime.parse(json['blockedAt'] as String),
      reason: json['reason'] as String?,
      isPermanent: json['isPermanent'] as bool? ?? true,
      expireAt: json['expireAt'] == null
          ? null
          : DateTime.parse(json['expireAt'] as String),
    );

Map<String, dynamic> _$BlockedUserToJson(BlockedUser instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'blockedAt': instance.blockedAt.toIso8601String(),
      'reason': instance.reason,
      'isPermanent': instance.isPermanent,
      'expireAt': instance.expireAt?.toIso8601String(),
    };

BlockedKeyword _$BlockedKeywordFromJson(Map<String, dynamic> json) =>
    BlockedKeyword(
      keyword: json['keyword'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRegex: json['isRegex'] as bool? ?? false,
      caseSensitive: json['caseSensitive'] as bool? ?? false,
    );

Map<String, dynamic> _$BlockedKeywordToJson(BlockedKeyword instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRegex': instance.isRegex,
      'caseSensitive': instance.caseSensitive,
    };

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: json['id'] as String,
      reporterId: json['reporterId'] as String,
      reportedUserId: json['reportedUserId'] as String,
      type: $enumDecode(_$ReportTypeEnumMap, json['type']),
      reason: json['reason'] as String,
      description: json['description'] as String?,
      evidence: (json['evidence'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
          ReportStatus.pending,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'reportedUserId': instance.reportedUserId,
      'type': _$ReportTypeEnumMap[instance.type]!,
      'reason': instance.reason,
      'description': instance.description,
      'evidence': instance.evidence,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$ReportStatusEnumMap[instance.status]!,
    };

const _$ReportTypeEnumMap = {
  ReportType.harassment: 'harassment',
  ReportType.spam: 'spam',
  ReportType.inappropriate: 'inappropriate',
  ReportType.fake: 'fake',
  ReportType.scam: 'scam',
  ReportType.other: 'other',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'pending',
  ReportStatus.processing: 'processing',
  ReportStatus.resolved: 'resolved',
  ReportStatus.rejected: 'rejected',
};
