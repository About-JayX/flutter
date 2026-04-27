import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/net/model/episode.dart';

part 'show.g.dart';

@JsonSerializable(explicitToJson: true)
class Show {
  int showId;
  String title;
  String? desc;
  String coverUrl;
  List<Episode>? episodes;
  int? saveCount;

  Show(this.showId, this.title, this.desc, this.coverUrl, this.episodes,
      this.saveCount);

  factory Show.fromJson(Map<String, dynamic> json) => _$ShowFromJson(json);
  Map<String, dynamic> toJson() => _$ShowToJson(this);
}
