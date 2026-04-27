// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => TaskItem(
      id: (json['id'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      recurrence: json['recurrence'] as String?,
      income: (json['income'] as num?)?.toInt(),
      title: json['title'] as String?,
      extraInfo: json['extraInfo'],
      requiredTimes: (json['requiredTimes'] as num?)?.toInt(),
      status: json['status'] as String?,
      claimable: json['claimable'] as bool?,
      taskLoadTime: json['taskLoadTime'] as String?,
      language: json['language'],
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskItemToJson(TaskItem instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'recurrence': instance.recurrence,
      'income': instance.income,
      'title': instance.title,
      'extraInfo': instance.extraInfo,
      'requiredTimes': instance.requiredTimes,
      'status': instance.status,
      'claimable': instance.claimable,
      'count': instance.count,
      'taskLoadTime': instance.taskLoadTime,
      'language': instance.language,
    };
