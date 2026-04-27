import 'package:json_annotation/json_annotation.dart';
import 'seven_day_task.dart';
import 'task.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward {
  SevenDayTask? sevenDayTask;
  Task? task;

  Reward({
    this.sevenDayTask,
    this.task,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  Map<String, dynamic> toJson() => _$RewardToJson(this);
}
