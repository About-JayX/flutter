import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';

part 'watch_history.g.dart';

@JsonSerializable(explicitToJson: true)
class WatchHistory {
  Show show;
  Episode episode;
  int time;

  WatchHistory(this.show, this.episode, this.time);

  factory WatchHistory.fromJson(Map<String, dynamic> json) =>
      _$WatchHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$WatchHistoryToJson(this);
}
