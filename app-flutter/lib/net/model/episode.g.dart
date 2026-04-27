// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
      (json['episodeId'] as num).toInt(),
      (json['episodeNum'] as num).toInt(),
      (json['price'] as num?)?.toInt(),
      json['videoUrl'] as String?,
      json['title'] as String?,
      json['locked'] as bool?,
    );

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'episodeId': instance.episodeId,
      'episodeNum': instance.episodeNum,
      'price': instance.price,
      'title': instance.title,
      'videoUrl': instance.videoUrl,
      'locked': instance.locked,
    };
