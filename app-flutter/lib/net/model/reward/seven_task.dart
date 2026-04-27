import 'package:json_annotation/json_annotation.dart';

part 'seven_task.g.dart';

@JsonSerializable()
class SevenTask {
  bool? success;
  bool? checked;
  int? coins;
  int? income;
  String? date;
  bool? isToday;

  SevenTask({
    this.success,
    this.checked,
    this.coins,
    this.income,
    this.date,
    this.isToday,
  });

  factory SevenTask.fromJson(Map<String, dynamic> json) =>
      _$SevenTaskFromJson(json);

  Map<String, dynamic> toJson() => _$SevenTaskToJson(this);
}
