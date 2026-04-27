import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';

class TrackUtils {
  static Map<String, dynamic> showEpisode({Show? show, Episode? episode}) {
    Map<String, dynamic> params = {};
    if (show != null) {
      params[TrackParams.showId] = "${show.showId}";
      params[TrackParams.showTitle] = show.title;
    }
    if (episode != null) {
      params[TrackParams.episodeId] = "${episode.episodeId}";
      params[TrackParams.episodeNum] = "${episode.episodeNum}";
    }
    return params;
  }
}
