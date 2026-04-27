import 'package:flutter/material.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';
import 'package:mobisen_app/widget/mixed_list/settings_mixed_list_item.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: Text(S.current.settings),
      ),
      body: MixedListView(
        data: [
          SettingsMixedListItem(),
        ],
      ),
    );
  }
}
