import 'package:flutter/material.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';

abstract class SettingsBaseMixedListItem extends MixedListItem {
  Widget buildItem(
      {required Widget icon,
      required String title,
      Function()? onTap,
      Widget? trailing}) {
    return SliverToBoxAdapter(
      child: ListTile(
        onTap: onTap,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: icon,
        ),
        title: Text(title),
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
      ),
    );
  }
}
