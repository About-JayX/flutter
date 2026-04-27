import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/text_utils.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/track_utils.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/view/base_widget.dart';
import 'package:mobisen_app/viewmodel/show_buttons_view_model.dart';

class ShowButtonsView extends StatelessWidget {
  final Show show;
  final Episode episode;
  final Function() onShowEpisodePicker;
  static const double _buttonWidth = 72;

  const ShowButtonsView(
      {super.key,
      required this.show,
      required this.episode,
      required this.onShowEpisodePicker});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final isShowSaved = accountProvider.isShowSaved(show);
    return BaseWidget(
        builder: (context, model, child) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildIconButton(
                    icon: isShowSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: isShowSaved ? Colors.yellow.shade600 : null,
                    text: TextUtils.formatNumber((show.saveCount ?? 0)),
                    onTap: () {
                      TrackHelper.instance.track(
                          event: TrackEvents.show,
                          action: isShowSaved
                              ? TrackValues.unsave
                              : TrackValues.save,
                          params: TrackUtils.showEpisode(
                              show: show, episode: episode));
                      if (ViewUtils.jumpToLogin(context, accountProvider)) {
                        return;
                      }
                      if (isShowSaved) {
                        model.unsaveShow();
                      } else {
                        model.saveShow();
                      }
                    }),
                _buildIconButton(
                    icon: Icons.format_list_bulleted_rounded,
                    text: S.current.series,
                    iconWidth: 36,
                    onTap: () {
                      onShowEpisodePicker();
                    }),
                const SizedBox(height: 8),
                _buildIconButton(
                    icon: Icons.share,
                    text: "",
                    iconWidth: 36,
                    onTap: () {
                      ViewUtils.shareApp();
                    }),
              ],
            ),
        model: ShowButtonsViewModel(
          accountProvider: accountProvider,
          show: show,
        ),
        onModelReady: (model) => model.initModel());
  }

  Widget _buildIconButton(
      {required IconData icon,
      required String text,
      Color? color,
      double iconWidth = 40,
      Function()? onTap}) {
    return _buildButton(
        icon: Icon(
          icon,
          size: iconWidth,
          color: color,
        ),
        text: text,
        onTap: onTap);
  }

  Widget _buildButton(
      {required Widget icon, required String text, Function()? onTap}) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          width: _buttonWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }
}
