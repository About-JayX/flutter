import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/notification/page_change_notification.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/styles/style_const.dart';
import 'package:mobisen_app/view/base_widget.dart';
import 'package:mobisen_app/view/home/home_tabs.dart';
import 'package:mobisen_app/viewmodel/saved_show_list_view_model.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/widget/mixed_list/grid_show_mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';
import 'package:mobisen_app/widget/show_takein_item.dart';

class SavedShowListView extends StatelessWidget {
  const SavedShowListView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).my_list),
        centerTitle: false,
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSize.screenPaddingHorizontal),
            child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, RoutePaths.watchHistory),
                child: ClipOval(
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    color: const Color.fromRGBO(255, 255, 255, 0.12),
                    child: Assets.images.history.image(
                        fit: BoxFit.contain, width: 15.89, height: 15.89),
                  ),
                )),
          )
        ],
      )
      // AppBar(
      //   centerTitle: false,
      //   title: Text(S.of(context).my_list),
      // )
      ,
      body: BaseWidget(
        builder: (context, model, child) => model.shows.isEmpty
            ? _buildEmptyView(context)
            : MixedListView(
                bottomNavPadding: true,
                loading: model.loading,
                onRefresh: () async {
                  await model.refresh();
                },
                data: [
                  GridShowMixedListItem(
                      shows: [
                        ...model.shows,
                        Show(
                            99999,
                            '1',
                            '1',
                            'https://images.mobisen.com/2324342.png',
                            null,
                            null)
                      ],
                      insertItemChild: const ShowTakeInItem(),
                      insertItemIndex: model.shows.length)
                ],
              ),
        model: SavedShowListViewModel(accountProvider: accountProvider),
        onModelReady: (model) => model.initModel(),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                  opacity: 0.5,
                  child: Assets.images.emptyPlaylist.image(width: 200)),
              const SizedBox(height: 8),
              Opacity(opacity: 0.5, child: Text(S.current.empty_list_hint)),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  PageChangeNotification(HomeTabs.home).dispatch(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    S.current.watch_stories,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
