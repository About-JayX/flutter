import 'package:flutter/material.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';
import 'package:mobisen_app/widget/show_item.dart';
import 'package:mobisen_app/styles/style_const.dart';

class GridShowMixedListItem extends MixedListItem {
  List<Show> shows;
  Widget? insertItemChild;
  int insertItemIndex;

  GridShowMixedListItem({
    required this.shows,
    this.insertItemChild,
    this.insertItemIndex = 0,
  });

  @override
  List<Widget> buildWidgets(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    const double itemHorizontalDistance = 9.28;
    const double itemImageToTextVDistance = 6;
    final double itemW = (screenW -
            2 * AppSize.screenPaddingHorizontal -
            2 * itemHorizontalDistance) /
        3;
    const int inlineCount = 2;
    final double itemH =
        (itemW * 4 / 3) + itemImageToTextVDistance + inlineCount * 15.74;
    return [
      SliverPadding(
        padding: const EdgeInsets.only(
            left: AppSize.screenPaddingHorizontal,
            right: AppSize.screenPaddingHorizontal,
            top: 11.11),
        sliver: SliverGrid.builder(
          itemCount: shows.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: itemHorizontalDistance,
            mainAxisSpacing: 11.6,
            childAspectRatio: itemW / itemH, //9.2 / 17
          ),
          itemBuilder: (context, index) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              child: insertItemChild != null &&
                      (insertItemIndex >= 0 &&
                          insertItemIndex <= (shows.length - 1) &&
                          index == insertItemIndex)
                  ? insertItemChild
                  : ShowItem(show: shows[index])),
        ),
      )
    ];
  }
}
