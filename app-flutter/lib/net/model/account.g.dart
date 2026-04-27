// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['jwt'] as String,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'user': instance.user.toJson(),
      'jwt': instance.jwt,
    };
