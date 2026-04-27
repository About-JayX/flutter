import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/view/base_widget.dart';
import 'package:mobisen_app/viewmodel/reward_view_model.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';
import 'package:mobisen_app/widget/loading.dart';
import 'modules/seven_day_list_item.dart';
import 'modules/task_list_item.dart';

class RewardView extends StatelessWidget {
  final bool? goBack;
  const RewardView({
    super.key,
    this.goBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    return BaseWidget(
        builder: (context, model, child) => Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(150),
              child: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(235, 71, 184, 0.35),
                            Color.fromRGBO(235, 71, 184, 0),
                          ],
                          stops: [
                            0,
                            1
                          ]),
                      image: DecorationImage(
                        image: Assets.images.rewardHeadBg.image().image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SafeArea(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (goBack == true &&
                                      Navigator.canPop(context))
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                            Icons.arrow_back_ios_new_rounded),
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(S.of(context).earn_rewards,
                                        style: const TextStyle(
                                            height: 1,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              )),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            decoration: const BoxDecoration(
                              // border: Border.all(color: Colors.white),
                              // borderRadius: BorderRadius.circular(30),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.images.coin.image(
                                    fit: BoxFit.contain, width: 18, height: 18),
                                const SizedBox(width: 8),
                                Text("${S.current.my_coins}: ",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    )),
                                Text(
                                  '${accountProvider.account?.user.coins ?? 0}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(235, 71, 184, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))),
                centerTitle: false,
                // leading: IconButton(
                //           onPressed: () => Navigator.pop(context),
                //           icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              ),
            ),
            body: model.reward != null &&
                    model.reward?.sevenDayTask != null &&
                    model.reward?.task != null
                ? MixedListView(
                    bottomNavPadding: true,
                    loading: model.loading,
                    error: model.error,
                    onRefresh: () async {
                      await model.refresh();
                    },
                    data: [
                        SevenDayListItem(
                            sevenDayTask: model.reward?.sevenDayTask),
                        TaskListItem(task: model.reward?.task),
                      ])
                : EmptyTask(
                    loading: model.loading,
                    error: model.error,
                    onRefresh: () async {
                      await model.refresh();
                    },
                  )),
        model: RewardViewModel(accountProvider: accountProvider),
        onModelReady: (model) => model.initModel());
  }
}

class EmptyTask extends StatelessWidget {
  final bool loading;
  final bool error;
  final Function()? onRefresh;
  const EmptyTask({
    super.key,
    this.loading = false,
    this.error = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: ((context, constraints) => ListView(
              children: [
                SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (loading
                              ? const Loading()
                              : (error
                                  ? Center(
                                      child: GestureDetector(
                                          onTap: onRefresh,
                                          child: const Icon(
                                            Icons.refresh,
                                            size: 50,
                                          )))
                                  : const SizedBox()))
                        ]))
              ],
            )));
  }
}
