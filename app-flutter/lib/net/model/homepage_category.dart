import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/net/model/show.dart';

part 'homepage_category.g.dart';

@JsonSerializable(explicitToJson: true)
class HomepageCategory {
  String title;
  List<Show> shows;
  String? style;

  HomepageCategory(this.title, this.shows, this.style);

  factory HomepageCategory.fromJson(Map<String, dynamic> json) =>
      _$HomepageCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$HomepageCategoryToJson(this);
}
