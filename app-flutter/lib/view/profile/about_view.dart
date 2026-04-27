import 'package:flutter/material.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/widget/mixed_list/about_mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: Text(S.current.about),
      ),
      body: MixedListView(
        data: [
          AboutMixedListItem(),
        ],
      ),
    );
  }
}
