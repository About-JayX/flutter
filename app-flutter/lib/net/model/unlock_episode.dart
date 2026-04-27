import 'package:json_annotation/json_annotation.dart';

part 'unlock_episode.g.dart';

@JsonSerializable(explicitToJson: true)
class UnlockEpisode {
  int? coins;

  UnlockEpisode(this.coins);

  factory UnlockEpisode.fromJson(Map<String, dynamic> json) =>
      _$UnlockEpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$UnlockEpisodeToJson(this);
}
