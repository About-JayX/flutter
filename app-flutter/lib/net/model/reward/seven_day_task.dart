import 'package:json_annotation/json_annotation.dart';
import 'seven_task.dart';

part 'seven_day_task.g.dart';

@JsonSerializable()
class SevenDayTask {
  String? checkFirstDate;
  final int? days;
  final bool? isTodayChecked;
  final List<SevenTask>? taskList;
  final List<SevenTask>? checkList;

  SevenDayTask({
    this.checkFirstDate,
    this.days,
    this.isTodayChecked,
    this.taskList,
    this.checkList,
  });

  factory SevenDayTask.fromJson(Map<String, dynamic> json) =>
      _$SevenDayTaskFromJson(json);

  Map<String, dynamic> toJson() => _$SevenDayTaskToJson(this);
}
