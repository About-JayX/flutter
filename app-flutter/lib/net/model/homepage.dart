import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/net/model/homepage_category.dart';

part 'homepage.g.dart';

@JsonSerializable(explicitToJson: true)
class Homepage {
  List<HomepageCategory> categories;

  Homepage(this.categories);

  factory Homepage.fromJson(Map<String, dynamic> json) =>
      _$HomepageFromJson(json);
  Map<String, dynamic> toJson() => _$HomepageToJson(this);
}
