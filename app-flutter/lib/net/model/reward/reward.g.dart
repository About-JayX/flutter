// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
      sevenDayTask: json['sevenDayTask'] == null
          ? null
          : SevenDayTask.fromJson(json['sevenDayTask'] as Map<String, dynamic>),
      task: json['task'] == null
          ? null
          : Task.fromJson(json['task'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
      'sevenDayTask': instance.sevenDayTask,
      'task': instance.task,
    };
