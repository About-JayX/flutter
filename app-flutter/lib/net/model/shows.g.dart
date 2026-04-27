// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shows.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shows _$ShowsFromJson(Map<String, dynamic> json) => Shows(
      (json['shows'] as List<dynamic>)
          .map((e) => Show.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShowsToJson(Shows instance) => <String, dynamic>{
      'shows': instance.shows.map((e) => e.toJson()).toList(),
    };
