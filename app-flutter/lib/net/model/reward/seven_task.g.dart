// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seven_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SevenTask _$SevenTaskFromJson(Map<String, dynamic> json) => SevenTask(
      success: json['success'] as bool?,
      checked: json['checked'] as bool?,
      coins: (json['coins'] as num?)?.toInt(),
      income: (json['income'] as num?)?.toInt(),
      date: json['date'] as String?,
      isToday: json['isToday'] as bool?,
    );

Map<String, dynamic> _$SevenTaskToJson(SevenTask instance) => <String, dynamic>{
      'success': instance.success,
      'checked': instance.checked,
      'coins': instance.coins,
      'income': instance.income,
      'date': instance.date,
      'isToday': instance.isToday,
    };
