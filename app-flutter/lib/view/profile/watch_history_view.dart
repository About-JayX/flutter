import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/styles/style_const.dart';
import 'package:mobisen_app/widget/mixed_list/grid_show_mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';

class WatchHistoryView extends StatelessWidget {
  const WatchHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final shows = accountProvider.watchHistoryList.map((h) => h.show).toList();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ClipOval(
                    child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  color: const Color.fromRGBO(255, 255, 255, 0.12),
                  child: Assets.images.arrowBackRound
                      .image(fit: BoxFit.contain, width: 11),
                ))
              ]),
            )),
        title: Text(S.current.watch_history),
        centerTitle: true,
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSize.screenPaddingHorizontal),
            child: GestureDetector(
                onTap: () {
                  ViewUtils.showDialogInfo(
                    context,
                    title: S.current.watch_history_clear_check_msg,
                    onBtnOk: () {
                      accountProvider.clearWatchHistory();
                    },
                    onBtnCancel: () {},
                  );
                },
                child: ClipOval(
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    color: const Color.fromRGBO(255, 255, 255, 0.12),
                    child: Assets.images.trash.image(
                        fit: BoxFit.contain, width: 15.89, height: 15.89),
                  ),
                )),
          )
        ],
      )
      // ViewUtils.buildCommonAppBar(
      //   context,
      //   title: Text(S.current.watch_history),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           ViewUtils.showDialogInfo(
      //             context,
      //             title: S.current.watch_history_clear_check_msg,
      //             onBtnOk: () {
      //               accountProvider.clearWatchHistory();
      //             },
      //             onBtnCancel: () {},
      //           );
      //         },
      //         icon: const Icon(Icons.cleaning_services_rounded)),
      //   ],
      // )
      ,
      body: MixedListView(
        data: [
          if (shows.isNotEmpty) GridShowMixedListItem(shows: shows),
        ],
      ),
    );
  }
}
