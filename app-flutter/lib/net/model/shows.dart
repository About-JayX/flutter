import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/net/model/show.dart';

part 'shows.g.dart';

@JsonSerializable(explicitToJson: true)
class Shows {
  List<Show> shows;

  Shows(this.shows);

  factory Shows.fromJson(Map<String, dynamic> json) => _$ShowsFromJson(json);
  Map<String, dynamic> toJson() => _$ShowsToJson(this);
}
