// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Show _$ShowFromJson(Map<String, dynamic> json) => Show(
      (json['showId'] as num).toInt(),
      json['title'] as String,
      json['desc'] as String?,
      json['coverUrl'] as String,
      (json['episodes'] as List<dynamic>?)
          ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['saveCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShowToJson(Show instance) => <String, dynamic>{
      'showId': instance.showId,
      'title': instance.title,
      'desc': instance.desc,
      'coverUrl': instance.coverUrl,
      'episodes': instance.episodes?.map((e) => e.toJson()).toList(),
      'saveCount': instance.saveCount,
    };
