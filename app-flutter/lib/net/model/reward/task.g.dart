// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      taskList: (json['taskList'] as List<dynamic>?)
          ?.map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'taskList': instance.taskList,
    };
