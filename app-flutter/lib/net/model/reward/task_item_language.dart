import 'package:json_annotation/json_annotation.dart';

part 'task_item_language.g.dart';

@JsonSerializable()
class TaskItemLanguage {
  final String? title;

  const TaskItemLanguage({
    this.title,
  });

  factory TaskItemLanguage.fromJson(Map<String, dynamic> json) =>
      _$TaskItemLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$TaskItemLanguageToJson(this);
}
