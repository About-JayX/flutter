import 'package:json_annotation/json_annotation.dart';
import 'task_item_language.dart';

part 'task_item.g.dart';

@JsonSerializable()
class TaskItem {
  int? id;
  int? type;
  String? recurrence;
  int? income;
  String? title;
  dynamic? extraInfo;
  int? requiredTimes;
  String? status;
  bool? claimable;
  int? count;
  String? taskLoadTime;
  dynamic? language;

  TaskItem({
    this.id,
    this.type,
    this.recurrence,
    this.income,
    this.title,
    this.extraInfo,
    this.requiredTimes,
    this.status,
    this.claimable,
    this.taskLoadTime,
    this.language,
    int? count,
  }) : count = count ?? 0;

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  Map<String, dynamic> toJson() => _$TaskItemToJson(this);
}
