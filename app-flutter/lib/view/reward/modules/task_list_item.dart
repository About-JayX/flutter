import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/enums/reward_task.dart';
// import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/viewmodel/reward_view_model.dart';
import 'package:mobisen_app/net/model/reward/task.dart';
import 'package:mobisen_app/net/model/reward/task_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';

class TaskListItem extends MixedListItem {
  Task? task;

  TaskListItem({required this.task});

  @override
  List<Widget> buildWidgets(BuildContext context) {
    List<TaskItem> dailyTask = [];
    List<TaskItem> normalTask = [];
    if (task?.taskList != null) {
      for (var item in (task?.taskList ?? [])) {
        if (item.recurrence == 'daily') {
          dailyTask.add(item);
        } else {
          normalTask.add(item);
        }
      }
    }
    return task != null && (task?.taskList ?? []).isNotEmpty
        ? [
            // const SliverToBoxAdapter(
            //     child: SizedBox(
            //   height: 30,
            // )),
            normalTask.isNotEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TaskTitle(taskTitle: S.current.tasks),
                  ))
                : const SliverToBoxAdapter(child: SizedBox()),
            normalTask.isNotEmpty
                ? SliverList.builder(
                    itemCount: normalTask.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TaskItem1(
                          taskItem: normalTask[index], taskIndex: index);
                    },
                  )
                : const SliverToBoxAdapter(child: SizedBox()),

            dailyTask.isNotEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TaskTitle(taskTitle: S.current.daily_tasks),
                  ))
                : const SliverToBoxAdapter(child: SizedBox()),
            dailyTask.isNotEmpty
                ? SliverList.builder(
                    itemCount: dailyTask.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TaskItem1(
                          taskItem: dailyTask[index], taskIndex: index);
                    },
                  )
                : const SliverToBoxAdapter(child: SizedBox()),
          ]
        : [
            const SliverToBoxAdapter(
              child: SizedBox(),
            )
          ];
  }
}

class TaskTitle extends StatelessWidget {
  final String taskTitle;
  const TaskTitle({
    super.key,
    required this.taskTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      child: Text(taskTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }
}

class TaskItem1 extends StatelessWidget {
  final TaskItem? taskItem;
  final int taskIndex;
  const TaskItem1({
    super.key,
    required this.taskItem,
    required this.taskIndex,
  });

  @override
  Widget build(BuildContext context) {
    final rewardViewModel = Provider.of<RewardViewModel>(context);
    return Container(
        margin: const EdgeInsets.only(left: 18, right: 18, top: 16),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: const Color.fromRGBO(
                14, 14, 14, 1.0), // taskItem?.status == 'done' ? 0.6 : 1.0
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Opacity(
                        opacity: taskItem?.status == 'done' ? 0.6 : 1.0,
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    taskItem?.language != null &&
                                            taskItem?.language['title'] != null
                                        ? taskItem?.language['title']
                                        : '',
                                    style: const TextStyle(
                                      height: 1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Assets.images.coin.image(
                                        fit: BoxFit.contain,
                                        width: 20,
                                        height: 20),
                                    // const SizedBox(height: 8),
                                    Text(
                                        " + ${taskItem?.income} ${S.current.coins}",
                                        style: const TextStyle(
                                          height: 1,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ]),
                        ))),
                GestureDetector(
                    onTap: () {
                      if (!(taskItem?.status == 'go' ||
                          taskItem?.status == 'claim')) return;
                      rewardViewModel.mainTask(
                          context: context,
                          id: taskItem?.id,
                          type: taskItem?.type.toString(),
                          status: taskItem?.status == 'go'
                              ? RewardTaskStatus.go
                              : taskItem?.status == 'claim'
                                  ? RewardTaskStatus.claim
                                  : RewardTaskStatus.none,
                          task: taskItem);
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(19)),
                      child: Container(
                        alignment: Alignment.center,
                        width: 109,
                        height: 38,
                        // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        color: taskItem?.status == 'done'
                            ? Colors.black
                            : const Color.fromRGBO(235, 71, 184, 1.0),
                        child: Text(
                            taskItem?.status == 'done'
                                ? S.current.done
                                : taskItem?.status == 'claim'
                                    ? S.current.claim
                                    : S.current.go,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
