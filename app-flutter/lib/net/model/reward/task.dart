import 'package:json_annotation/json_annotation.dart';
import 'task_item.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  List<TaskItem>? taskList;

  Task({
    this.taskList,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
