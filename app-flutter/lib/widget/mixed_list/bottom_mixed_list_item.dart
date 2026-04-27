import 'package:flutter/material.dart';
import 'package:mobisen_app/styles/style_const.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';

class BottomMixedListItem extends MixedListItem {
  @override
  List<Widget> buildWidgets(BuildContext context) {
    return [
      SliverToBoxAdapter(
          child: SizedBox(
        height: AppSize.bottomNavigationHeight,
      )
          //     Container(
          //   color: Colors.red,
          //   height: totalHeight,
          // ),
          )
    ];
  }
}
