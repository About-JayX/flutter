import 'package:flutter/material.dart';
import 'package:mobisen_app/net/model/homepage_category.dart';
import 'package:mobisen_app/widget/mixed_list/carousel_show_mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/grid_show_mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';
import 'package:mobisen_app/widget/show_item.dart';
import 'package:mobisen_app/styles/style_const.dart';

class HomepageCategoryMixedListItem extends MixedListItem {
  final HomepageCategory _data;
  HomepageCategoryMixedListItem(this._data);

  @override
  List<Widget> buildWidgets(BuildContext context) {
    switch (_data.style) {
      case "grid":
        return _buildGridStyle(context, _data);
      case "carousel":
        return _buildCarouselStyle(context, _data);
      default:
        return _buildDefaultStyle(context, _data);
    }
  }

  List<Widget> _buildGridStyle(
      BuildContext context, HomepageCategory category) {
    return [
      _buildTitleHeader(context, category.title),
      ...GridShowMixedListItem(shows: category.shows).buildWidgets(context)
    ];
  }

  List<Widget> _buildCarouselStyle(
      BuildContext context, HomepageCategory category) {
    return [
      SliverToBoxAdapter(
        child: CarouselShowMixedListItem(shows: category.shows),
      ),
    ];
  }

  List<Widget> _buildDefaultStyle(
      BuildContext context, HomepageCategory category) {
    final double screenW = MediaQuery.of(context).size.width;
    const double itemHorizontalDistance = 9.28;
    const double itemImageToTextVDistance = 6;
    final double itemW = (screenW -
            AppSize.screenPaddingHorizontal -
            2 * itemHorizontalDistance) /
        2.5;
    const int inlineCount = 2;
    final double itemH =
        (itemW * 4 / 3) + itemImageToTextVDistance + inlineCount * 15.74;
    return [
      _buildTitleHeader(context, category.title),
      SliverToBoxAdapter(
          child: Container(
        padding: const EdgeInsets.only(top: 11.11),
        // color: Colors.red.withOpacity(0.5),
        child: SizedBox(
          height: itemH,
          child: ListView.separated(
            // padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) =>
                const SizedBox(width: itemHorizontalDistance),
            itemCount: category.shows.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? AppSize.screenPaddingHorizontal : 0,
                  right: index == category.shows.length - 1
                      ? AppSize.screenPaddingHorizontal
                      : 0,
                ),
                width: itemW,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: ShowItem(show: category.shows[index]),
                ),
              );
            },
          ),
        ),
      )),
    ];
  }

  Widget _buildTitleHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        // color: Colors.green,
        padding: const EdgeInsets.fromLTRB(AppSize.screenPaddingHorizontal,
            13.2, AppSize.screenPaddingHorizontal, 0),
        child:
            // Container(
            // height: 22.59,
            // alignment: Alignment.centerLeft,
            // color: Colors.red,
            // child:
            Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              height: 22.59 / 16, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        // ),
      ),
    );
  }
}
