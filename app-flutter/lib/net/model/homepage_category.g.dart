// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homepage_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomepageCategory _$HomepageCategoryFromJson(Map<String, dynamic> json) =>
    HomepageCategory(
      json['title'] as String,
      (json['shows'] as List<dynamic>)
          .map((e) => Show.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['style'] as String?,
    );

Map<String, dynamic> _$HomepageCategoryToJson(HomepageCategory instance) =>
    <String, dynamic>{
      'title': instance.title,
      'shows': instance.shows.map((e) => e.toJson()).toList(),
      'style': instance.style,
    };
