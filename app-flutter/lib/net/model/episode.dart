import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable(explicitToJson: true)
class Episode {
  int episodeId;
  int episodeNum;
  int? price;
  String? title;
  String? videoUrl;
  bool? locked;

  Episode(this.episodeId, this.episodeNum, this.price, this.videoUrl,
      this.title, this.locked);

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
