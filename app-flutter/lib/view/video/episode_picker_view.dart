import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/util/text_utils.dart';

class EpisodePickerView extends StatefulWidget {
  final Show show;
  final Episode currentEpisode;
  final bool Function(Episode episode) onSelectEpisode;

  const EpisodePickerView(
      {super.key,
      required this.show,
      required this.currentEpisode,
      required this.onSelectEpisode});

  @override
  State<EpisodePickerView> createState() => _EpisodePickerViewState();
}

class _EpisodePickerViewState extends State<EpisodePickerView> {
  @override
  Widget build(BuildContext context) {
    final show = widget.show;
    final episodes = show.episodes ?? [];
    final currentEpisode = widget.currentEpisode;
    return SafeArea(
      child: SizedBox(
        height: 460,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        show.title,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close_rounded)),
                  ],
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: episodes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 4, mainAxisSpacing: 4, crossAxisCount: 5),
                itemBuilder: (context, index) {
                  return _buildItemView(episodes[index], currentEpisode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView(Episode episode, Episode currentEpisode) {
    String? title = episode.title;
    if (TextUtils.isNullOrEmpty(title)) {
      title = "${episode.episodeNum}";
    }
    return Card(
      child: InkWell(
          onTap: () {
            if (widget.onSelectEpisode(episode)) {
              Navigator.pop(context);
            }
          },
          child: Stack(
            children: [
              Container(
                color: currentEpisode.episodeId == episode.episodeId
                    ? Theme.of(context).primaryColor
                    : null,
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: AutoSizeText(
                  title!,
                  maxLines: 2,
                  minFontSize: 12,
                  maxFontSize: 22,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                  wrapWords: false,
                ),
              ),
              if (episode.locked == true)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(4)),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 12,
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
