// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
      allowStrangerMessage: json['allowStrangerMessage'] as bool? ?? false,
      allowStrangerCall: json['allowStrangerCall'] as bool? ?? false,
      profileVisibility: $enumDecodeNullable(
              _$ProfileVisibilityEnumMap, json['profileVisibility']) ??
          ProfileVisibility.everyone,
      anonymousBrowse: json['anonymousBrowse'] as bool? ?? false,
      showLastSeen: json['showLastSeen'] as bool? ?? true,
      allowSearchByPhone: json['allowSearchByPhone'] as bool? ?? false,
      allowSearchByEmail: json['allowSearchByEmail'] as bool? ?? false,
      photoVisibility: $enumDecodeNullable(
              _$PhotoVisibilityEnumMap, json['photoVisibility']) ??
          PhotoVisibility.everyone,
      showLocation: json['showLocation'] as bool? ?? false,
      showAge: json['showAge'] as bool? ?? true,
      showGender: json['showGender'] as bool? ?? true,
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      blockedKeywords: (json['blockedKeywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) =>
    <String, dynamic>{
      'showOnlineStatus': instance.showOnlineStatus,
      'allowStrangerMessage': instance.allowStrangerMessage,
      'allowStrangerCall': instance.allowStrangerCall,
      'profileVisibility':
          _$ProfileVisibilityEnumMap[instance.profileVisibility]!,
      'anonymousBrowse': instance.anonymousBrowse,
      'showLastSeen': instance.showLastSeen,
      'allowSearchByPhone': instance.allowSearchByPhone,
      'allowSearchByEmail': instance.allowSearchByEmail,
      'photoVisibility': _$PhotoVisibilityEnumMap[instance.photoVisibility]!,
      'showLocation': instance.showLocation,
      'showAge': instance.showAge,
      'showGender': instance.showGender,
      'blockedUsers': instance.blockedUsers,
      'blockedKeywords': instance.blockedKeywords,
    };

const _$ProfileVisibilityEnumMap = {
  ProfileVisibility.everyone: 'everyone',
  ProfileVisibility.friends: 'friends',
  ProfileVisibility.nobody: 'nobody',
};

const _$PhotoVisibilityEnumMap = {
  PhotoVisibility.everyone: 'everyone',
  PhotoVisibility.friends: 'friends',
  PhotoVisibility.vip: 'vip',
  PhotoVisibility.nobody: 'nobody',
};
