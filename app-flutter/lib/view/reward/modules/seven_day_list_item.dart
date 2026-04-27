import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/enums/reward_task.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/viewmodel/reward_view_model.dart';
import 'package:mobisen_app/net/model/reward/seven_day_task.dart';
import 'package:mobisen_app/net/model/reward/seven_task.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';

class SevenDayListItem extends MixedListItem {
  SevenDayTask? sevenDayTask;

  SevenDayListItem({required this.sevenDayTask});

  @override
  List<Widget> buildWidgets(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final rewardViewModel = Provider.of<RewardViewModel>(context);
    // final rewardViewModel = RewardViewModel(accountProvider: accountProvider);
    return [
      sevenDayTask != null && (sevenDayTask?.checkList ?? []).isNotEmpty
          ? SliverPadding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 0),
              sliver: SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(44, 29, 39, 1.0),
                    ),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 25, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckInList(taskList: sevenDayTask?.checkList ?? []),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          color: Colors.transparent,
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () async {
                              if (!(sevenDayTask?.isTodayChecked ?? true)) {
                                rewardViewModel.mainTask(
                                  context: context,
                                  id: RewardTask.checkIn.num,
                                  type: RewardTask.checkIn.value,
                                  status: RewardTaskStatus.go,
                                );
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                // constraints: const BoxConstraints(
                                //     minWidth: double.infinity),
                                color: Colors.transparent,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    child: Container(
                                      width: 272,
                                      alignment: Alignment.center,
                                      height: 50,
                                      color: !(sevenDayTask?.isTodayChecked ??
                                              true)
                                          ? const Color.fromRGBO(
                                              235, 71, 184, 1.0)
                                          : const Color.fromRGBO(
                                              255, 255, 255, 0.15),
                                      child: Text(
                                          // "${sevenDayTask?.isTodayChecked}"
                                          !(sevenDayTask?.isTodayChecked ??
                                                  true)
                                              ? S.current.check_in
                                              : S.current.checked_in,
                                          style: const TextStyle(
                                              height: 1,
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
          : const SliverToBoxAdapter(
              child: SizedBox(),
            )
    ];
  }
}

class CheckInList extends StatelessWidget {
  final List<SevenTask> taskList;
  const CheckInList({
    super.key,
    required this.taskList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  // List.generate(7, (index) => CheckInItem(taskItem: item, taskIndex: index)))
                  taskList
                      .asMap()
                      .map((index, item) => MapEntry(
                          index, CheckInItem(taskItem: item, taskIndex: index)))
                      .values
                      .toList()),
        ));
  }
}

class CheckInItem extends StatelessWidget {
  final SevenTask? taskItem;
  final int taskIndex;
  const CheckInItem({
    super.key,
    required this.taskItem,
    required this.taskIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              height: 64,
              // width: taskIndex <= 5 ? 44 : 55,
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10)
              // EdgeInsets.all((taskItem?.success ?? false) ? 12 : 0)
              ,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: (taskItem?.isToday ?? false) &&
                              !(taskItem?.checked ?? false)
                          ? [
                              const Color.fromRGBO(255, 166, 37, 1),
                              const Color.fromRGBO(255, 199, 0, 1),
                            ]
                          : [
                              const Color.fromRGBO(255, 255, 255, 0.1),
                              const Color.fromRGBO(255, 255, 255, 0.1),
                            ],
                      stops: const [0, 1])),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      child: Text("+${taskItem?.income}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ),
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          taskIndex <= 1
                              ? Assets.images.coinsr.image(
                                  fit: BoxFit.contain, width: 24, height: 24)
                              : taskIndex <= 3
                                  ? Assets.images.coinsrr.image(
                                      fit: BoxFit.contain,
                                      // width: 20,
                                      height: 24)
                                  : taskIndex <= 5
                                      ? Assets.images.coinsrrr.image(
                                          fit: BoxFit.contain,
                                          // width: 33.5,
                                          height: 24)
                                      : Assets.images.coinsBox.image(
                                          fit: BoxFit.contain,
                                          // width: 20,
                                          height: 24),
                          (taskItem?.checked ?? false)
                              ? Positioned(
                                  top: 6,
                                  child: Assets.images.check.image(
                                      fit: BoxFit.contain,
                                      width: 20,
                                      height: 20),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Text("${S.current.day} ${taskIndex + 1}",
                    //     // taskItem?.date != null
                    //     //     ? "${taskItem?.date}"
                    //     //     : "${S.current.day} ${taskIndex + 1}",
                    //     style: TextStyle(
                    //       height: 1,
                    //       fontSize: 8.5,
                    //       color: (taskItem?.checked ?? false)
                    //           ? Colors.white
                    //           : const Color.fromRGBO(126, 126, 126, 1),
                    //     )),
                  ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text("${S.current.day} ${taskIndex + 1}",
              // taskItem?.date != null
              //     ? "${taskItem?.date}"
              //     : "${S.current.day} ${taskIndex + 1}",
              style: TextStyle(
                height: 1,
                fontSize: 8.5,
                color: (taskItem?.checked ?? false)
                    ? Colors.white
                    : const Color.fromRGBO(126, 126, 126, 1),
              )),
          // const SizedBox(
          //   height: 10,
          // ),
          // Text(
          //     taskItem?.date != null
          //         ? "${taskItem?.date}"
          //         : "${S.current.day} ${taskIndex + 1}",
          //     style: TextStyle(
          //       height: 1,
          //       fontSize: 9,
          //       color: (taskItem?.success ?? false)
          //           ? Colors.white
          //           : const Color.fromRGBO(126, 126, 126, 1.0),
          //     )),
        ],
      ),
    );
  }
}
