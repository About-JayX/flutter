// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : (json['id'] as num).toInt()),
      json['username'] as String,
      json['email'] as String?,
      json['blocked'] as bool?,
      (json['coins'] is String
          ? int.tryParse(json['coins']) ?? 0
          : (json['coins'] as num).toInt()),
      json['displayName'] as String?,
      json['membership'] == null
          ? null
          : Membership.fromJson(json['membership'] as Map<String, dynamic>),
      personalizeEdit: (json['personalize_edit'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String?,
      occupation: json['occupation'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      personality: (json['personality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      chatPurpose: (json['chatPurpose'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      communicationStyle: (json['communicationStyle'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as String?,
      isStatusPublic: json['is_status_public'] as bool?,
      blurProfileCard: json['blur_profile_card'] as bool?,
      dailySwipeCount: (json['daily_swipe_count'] as num?)?.toInt() ?? 0,
      dailyRecallCount: (json['daily_recall_count'] as num?)?.toInt() ?? 0,
      lastSwipeDate: (json['last_swipe_date'] as num?)?.toInt(),
      lastRecallDate: (json['last_recall_date'] as num?)?.toInt(),
    )..avatarUrl = json['avatarUrl'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'email': instance.email,
      'blocked': instance.blocked,
      'coins': instance.coins,
      'membership': instance.membership?.toJson(),
      'personalize_edit': instance.personalizeEdit,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'country': instance.country,
      'language': instance.language,
      'occupation': instance.occupation,
      'interests': instance.interests,
      'personality': instance.personality,
      'chatPurpose': instance.chatPurpose,
      'communicationStyle': instance.communicationStyle,
      'status': instance.status,
      'is_status_public': instance.isStatusPublic,
      'blur_profile_card': instance.blurProfileCard,
      'daily_swipe_count': instance.dailySwipeCount,
      'daily_recall_count': instance.dailyRecallCount,
      'last_swipe_date': instance.lastSwipeDate,
      'last_recall_date': instance.lastRecallDate,
    };
