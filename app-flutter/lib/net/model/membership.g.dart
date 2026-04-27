// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Membership _$MembershipFromJson(Map<String, dynamic> json) => Membership(
      level: (json['level'] as num?)?.toInt(),
      expirationTime: (json['expirationTime'] as num?)?.toInt(),
      type: json['type'] as String?,
      isActive: json['isActive'] as bool?,
      startTime: (json['startTime'] as num?)?.toInt(),
      productId: json['productId'] as String?,
      monthlyVideoMinutesTotal:
          (json['monthlyVideoMinutesTotal'] as num?)?.toInt(),
      monthlyVideoMinutesUsed:
          (json['monthlyVideoMinutesUsed'] as num?)?.toInt(),
      monthlyVoiceMinutesTotal:
          (json['monthlyVoiceMinutesTotal'] as num?)?.toInt(),
      monthlyVoiceMinutesUsed:
          (json['monthlyVoiceMinutesUsed'] as num?)?.toInt(),
      monthlyResetDate: (json['monthlyResetDate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MembershipToJson(Membership instance) =>
    <String, dynamic>{
      'level': instance.level,
      'expirationTime': instance.expirationTime,
      'type': instance.type,
      'isActive': instance.isActive,
      'startTime': instance.startTime,
      'productId': instance.productId,
      'monthlyVideoMinutesTotal': instance.monthlyVideoMinutesTotal,
      'monthlyVideoMinutesUsed': instance.monthlyVideoMinutesUsed,
      'monthlyVoiceMinutesTotal': instance.monthlyVoiceMinutesTotal,
      'monthlyVoiceMinutesUsed': instance.monthlyVoiceMinutesUsed,
      'monthlyResetDate': instance.monthlyResetDate,
    };
