import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/provider/configs_provider.dart';
import 'package:mobisen_app/widget/mixed_list/settings_base_mixed_list_item.dart';

class ProfileMixedListItem extends SettingsBaseMixedListItem {
  @override
  List<Widget> buildWidgets(BuildContext context) {
    return [
      buildItem(
        icon: const Icon(Icons.history),
        title: S.current.watch_history,
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.watchHistory);
        },
      ),
      buildItem(
        icon: const Icon(Icons.settings_outlined),
        title: S.current.settings,
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.settings);
        },
      ),
      buildItem(
        icon: const Icon(Icons.share),
        title: S.current.share,
        onTap: () {
          ViewUtils.shareApp();
        },
      ),
      buildItem(
        icon: const Icon(Icons.contact_support_outlined),
        title: S.current.contact_us,
        onTap: () {
          ViewUtils.toEmail(Urls.email);
        },
      ),
      buildItem(
        icon: const Icon(Icons.info_outline),
        title: S.current.about,
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.about);
        },
      ),
    ];
  }
}
