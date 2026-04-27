// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchHistory _$WatchHistoryFromJson(Map<String, dynamic> json) => WatchHistory(
      Show.fromJson(json['show'] as Map<String, dynamic>),
      Episode.fromJson(json['episode'] as Map<String, dynamic>),
      (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$WatchHistoryToJson(WatchHistory instance) =>
    <String, dynamic>{
      'show': instance.show.toJson(),
      'episode': instance.episode.toJson(),
      'time': instance.time,
    };
