// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homepage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Homepage _$HomepageFromJson(Map<String, dynamic> json) => Homepage(
      (json['categories'] as List<dynamic>)
          .map((e) => HomepageCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomepageToJson(Homepage instance) => <String, dynamic>{
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };
