// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seven_day_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SevenDayTask _$SevenDayTaskFromJson(Map<String, dynamic> json) => SevenDayTask(
      checkFirstDate: json['checkFirstDate'] as String?,
      days: (json['days'] as num?)?.toInt(),
      isTodayChecked: json['isTodayChecked'] as bool?,
      taskList: (json['taskList'] as List<dynamic>?)
          ?.map((e) => SevenTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      checkList: (json['checkList'] as List<dynamic>?)
          ?.map((e) => SevenTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SevenDayTaskToJson(SevenDayTask instance) =>
    <String, dynamic>{
      'checkFirstDate': instance.checkFirstDate,
      'days': instance.days,
      'isTodayChecked': instance.isTodayChecked,
      'taskList': instance.taskList,
      'checkList': instance.checkList,
    };
