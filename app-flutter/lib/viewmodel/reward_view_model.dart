import 'dart:async';
// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/event_bus/event_bus.dart';
import 'package:mobisen_app/enums/reward_task.dart';
import 'package:mobisen_app/db/hive_helper.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/util/permission_mange_util.dart';
import 'package:mobisen_app/lifeCircle/app_lifecycle_manager.dart';
// import 'package:mobisen_app/net/model/reward/reward_mock_data.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/net/model/reward/reward.dart';
import 'package:mobisen_app/net/model/reward/seven_day_task.dart';
import 'package:mobisen_app/net/model/reward/seven_task.dart';
import 'package:mobisen_app/net/model/reward/task.dart';
import 'package:mobisen_app/net/model/reward/task_item.dart';
import 'package:mobisen_app/viewmodel/account_view_model.dart';

class RewardViewModel extends AccountViewModel {
  final Reward _reward;
  get reward => _reward;

  List<TaskItem> get rewardUserTaskList =>
      HiveHelper.instance.getRewardUserTaskList();

  RewardViewModel({required super.accountProvider}) : _reward = Reward();

  late final StreamSubscription<UpdateRewardEvent> _updateRewardEvent;

  StreamSubscription<AppLifecycleState>? lifecycleSubscription;

  @override
  void initModel() async {
    _updateRewardEvent = eventBus.on<UpdateRewardEvent>().listen((event) async {
      // LogD("_updateRewardEvent =eventBus.on<UpdateRewardEvent>:\n${json.encode(event.args).toString()}");
      if (event.job == RewardTaskJob.refresh) {
        refresh();
      }
      if (event.job == RewardTaskJob.refreshLogin) {
        //LogI("event.job == RewardTaskJob.refreshLogin");
        // await updateTask(
        //     rewardTaskStrings[RewardTask.login]!, RewardTaskStatus.go);
        await HiveHelper.instance.replaceRewardUserTask([]);
        refresh();
      }

      if (event.job == RewardTaskJob.watchEpisode ||
          event.job == RewardTaskJob.unlockEpisode) {
        if (event.args != null &&
            event.args?['type'] != null &&
            event.args?['id'] != null) {
          // LogD("event.job == ${event.job}\ntype == ${event.args?['type']}");
          updateTask(
              event.args?['id'], event.args?['type'], RewardTaskStatus.go);
        }
      }
    });
    await refresh();
  }

  @override
  void dispose() {
    lifecycleSubscription?.cancel();
    lifecycleSubscription = null;
    _updateRewardEvent.cancel();
    super.dispose();
  }

  Future<void> refresh() async {
    setLoading(true, error: false);
    //LogI("setLoading--ing..");
    bool success = false;
    success = await _fetchReward();
    // for (var i = 0; i < 3 && !success; i++) {
    //   success = await _fetchReward();
    // }
    //LogD("setLoading--success: $success");
    setLoading(false, error: !success);
  }

  Future<bool> _fetchReward() async {
    try {
      SevenDayTask sevenDayTask = await _fetchCheckIn();
      await Future.delayed(const Duration(seconds: 0));
      Task task = await _fetchTask();
      if (sevenDayTask != null && task != null) {
        _reward?.sevenDayTask = sevenDayTask;
        _reward?.task = task;
        return true;
      }
    } catch (_) {
      ViewUtils.showToast(S.current.error_toast);
      LogE("_fetchReward: \n$_");
    }
    return false;
  }

  Future<SevenDayTask> _fetchCheckIn() async {
    SevenDayTask sevenDayTask = SevenDayTask();
    try {
      // Reward rewardMock = Reward.fromJson(json.decode(
      //     accountProvider?.account == null
      //         ? JsonString.rewardMockData
      //         : JsonString.rewardLoginMockData));
      // sevenDayTask = rewardMock.sevenDayTask!;
      sevenDayTask =
          await ApiService.instance.getSignInDetail(accountProvider.account);
      List<SevenTask>? taskList = sevenDayTask.checkList;
      if (taskList != null && taskList.isNotEmpty) {
        for (int i = 0; i < taskList.length; i++) {
          SevenTask item = taskList[i];
          int todayIndex = sevenDayTask.isTodayChecked == true
              ? ((sevenDayTask.days ?? 0) % 7 - 1)
              : (sevenDayTask.days ?? 0) % 7;
          if (i == todayIndex) {
            item.isToday = true;
            break;
          }
        }
      }
    } catch (_) {
      LogE("_fetchCheckIn: \n$_");
      return null as SevenDayTask;
    }
    return sevenDayTask;
  }

  Future<Task> _fetchTask() async {
    Task tasks = Task();
    try {
      // Reward rewardMock = Reward.fromJson(json.decode(
      //     accountProvider?.account == null
      //         ? JsonString.rewardMockData
      //         : JsonString.rewardLoginMockData));
      // tasks = rewardMock.task!;
      tasks = await ApiService.instance.getTaskList(accountProvider.account);
      //LogD("_fetchTask-tasks.taskList: \n${json.encode(tasks.taskList)}");

      /// data filter
      /// filter type
      tasks.taskList = (tasks.taskList ?? []).where((task) {
        return RewardTask.values
            .any((rewardTask) => rewardTask.value == task.type.toString());
      }).toList();

      /// filter status
      if ((tasks.taskList ?? []).isNotEmpty) {
        // LogD("_fetchTask-rewardUserTaskList Exist: \n${json.encode(rewardUserTaskList)}");
        for (int i = 0; i < (tasks.taskList ?? []).length; i++) {
          (tasks.taskList ?? [])[i].status = 'go';
          if (rewardUserTaskList.isNotEmpty) {
            for (int ii = 0; ii < rewardUserTaskList.length; ii++) {
              // Ensure that we are accessing the correct index
              if ((tasks.taskList ?? [])[i].id == rewardUserTaskList[ii].id) {
                if ((rewardUserTaskList[ii].status ?? 'go') == 'claim') {
                  // Changed i to ii
                  (tasks.taskList ?? [])[i].status = 'claim';
                }
              }
            }
          }
          if (accountProvider?.account != null &&
              ((tasks.taskList ?? [])[i].type.toString() ==
                  rewardTaskStrings[RewardTask.login])) {
            (tasks.taskList ?? [])[i].status = 'claim';
          }

          if ((tasks.taskList ?? [])[i].type ==
              RewardTask.openNotification.num) {
            if (await PermissionMangeUtil.checkPermissionStatus(
                    PermissionType.notification)
                .isGranted) {
              (tasks.taskList ?? [])[i].status = 'claim';
            }
          }
        }
      }

      /// db
      await HiveHelper.instance
          .replaceRewardUserTask(tasks?.taskList ?? []); //tasks?.taskList ?? []
    } catch (_) {
      LogE("_fetchTask: \n$_");
      return null as Task;
    }
    return tasks;
  }

  Future<void> mainTask(
      {@required BuildContext? context,
      @required int? id,
      @required String? type,
      RewardTaskStatus? status,
      TaskItem? task}) async {
    /// sign in
    if (accountProvider?.account == null) {
      /// job
      //LogI("task-singIn-ing..");
      await Navigator.pushNamed(context!, RoutePaths.login);

      /// update
      //LogI("task-singIn-update(success)");
      // await updateTask(
      //     rewardTaskStrings[RewardTask.login]!, RewardTaskStatus.go);
      await HiveHelper.instance.replaceRewardUserTask([]);
      refresh();

      return;
    }

    /// track
    try {
      if (type == rewardTaskStrings[RewardTask.checkIn]) {
        int days = (reward?.sevenDayTask?.days ?? 1) + 1;
        final trackParams = {TrackParams.day: days.toString()};
        //LogD("trackParams:\n$trackParams");
        TrackHelper.instance.track(
            event: TrackEvents.checkIn,
            action: TrackValues.click,
            params: trackParams);
      }
      if (type != rewardTaskStrings[RewardTask.checkIn] && status != null) {
        String trackValues = TrackValues.go;
        if (status == RewardTaskStatus.go) {
          trackValues = TrackValues.go;
        } else if (status == RewardTaskStatus.claim) {
          trackValues = TrackValues.claim;
        }
        //LogD("trackValues:\n$trackValues");
        final trackParams = {
          TrackParams.id: task?.id.toString(),
          TrackParams.title: task?.language['title'].toString(),
          TrackParams.type: task?.type.toString(),
        };
        //LogD("trackParams:\n$trackParams");
        TrackHelper.instance.track(
            event: TrackEvents.task, action: trackValues, params: trackParams);
      }
    } catch (e) {
      LogE("TrackHelper - reward：\n$e");
    }

    /// task job check in
    if (type == RewardTask.checkIn.value) {
      /// job
      bool result = await _checkIn();
      if (!result) return;

      /// update
      //LogI("task-check in-update(success)");
      refresh();
      accountProvider.updateAccountProfile();

      return;
    }

    /// task job main
    /// job
    if (type != rewardTaskStrings[RewardTask.checkIn]) {
      /// task job main go
      if (status == RewardTaskStatus.go) {
        //LogD("task-task job main-RewardTaskStatus.go:\ntype: $type");
        if (type == RewardTask.openNotification.value) {
          bool result =
              await _openNotification(id!, type!, RewardTaskStatus.go);
          if (!result) return;
        }

        if (type == rewardTaskStrings[RewardTask.ad] && task != null) {
          if (task.extraInfo == null ||
              (task.extraInfo != null && task.extraInfo["url"] == null)) {
            ViewUtils.showToast(S.current.error_toast);
            return;
          }
          if (context!.mounted) {
            bool result = await _redirectUrl(context, task.extraInfo["url"]);
            if (!result) return;
          }
        }

        if (type == rewardTaskStrings[RewardTask.share]) {
          bool result = await _share();
          if (!result) return;
        }

        if (type == rewardTaskStrings[RewardTask.watchEpisode]) {
          if (context!.mounted) {
            bool result = await _watchEpisode(context, id!);
            if (!result) return;
          }
        }

        if (type == rewardTaskStrings[RewardTask.unlockEpisode]) {
          if (context!.mounted) {
            bool result = await _unlockEpisode(context, id!);
            if (!result) return;
          }
        }
      }
      if (status == RewardTaskStatus.claim && task != null && task.id != null) {
        try {
          //LogD("task-RewardTaskStatus.claim-ing..:\ntype: $type;id:${task.id!}");
          var cancel = BotToast.showLoading();
          await ApiService.instance
              .finishTask(accountProvider.account, task.id!);
          cancel();
          //LogD("task-RewardTaskStatus.claim-success-taskId: ${task.id}");
        } catch (_) {
          ViewUtils.showToast(S.current.error_toast);
          LogE("task-RewardTaskStatus.claim-fail-taskId: ${task.id}：\n$_");
          return;
        }
      }

      /// update
      updateTask(id!, type!, status!, task: task);
    }
  }

  Future<bool> _checkIn() async {
    try {
      //LogI("task-check in-ing..");
      var cancel = BotToast.showLoading();
      await ApiService.instance.signIn(accountProvider.account);
      cancel();

      // int days = (reward?.sevenDayTask?.days ?? 1) + 1;
      // final trackParams = {TrackParams.day: days.toString()};
      // LogI("trackParams:\n$trackParams");
      // TrackHelper.instance.track(
      //     event: TrackEvents.checkIn,
      //     action: TrackValues.checkIn,
      //     params: trackParams);

      //LogD("task-check in-success");
      return true;
    } catch (_) {
      ViewUtils.showToast(S.current.error_toast);
      LogE("task-check in-fail：\n$_");
      return false;
    }
  }

  Future<bool> _redirectUrl(
    BuildContext? context,
    String? url,
  ) async {
    //LogI("task-ad-ing..");
    ViewUtils.toUrl(url!);
    await Future.delayed(const Duration(seconds: 1));
    //LogI("task-ad-success");
    return true;
  }

  Future<bool> _openNotification(
      int id, String type, RewardTaskStatus status) async {
    //LogI("task-openNotification-ing..");
    PermissionMangeUtil.goToSystemSetting();
    // await Future.delayed(const Duration(seconds: 1));

    lifecycleSubscription =
        AppLifecycleManager().lifecycleStream.listen((state) async {
      //LogD("🔥❎🔥❎🔥AppLifecycleManager:AppLifecycleState\n$state");
      if (state == AppLifecycleState.resumed) {
        lifecycleSubscription?.cancel();
        lifecycleSubscription = null;
        try {
          bool permissionStatus =
              await PermissionMangeUtil.checkPermissionStatus(
                      PermissionType.notification)
                  .isGranted;
          //LogD("🔥🔥🔥🔥permissionStatus:\n$permissionStatus");
          if (permissionStatus == true) {
            updateTask(id, type, status);
          }
        } catch (e) {
          LogE(
              "AppLifecycleManager-PermissionMangeUtil.permissionsHandle:\n$e");
        }
      }
    });
    // AppLifecycleManager().lifecycleStream.listen((state) async {
    //   LogD("🔥❎🔥❎🔥AppLifecycleManager:AppLifecycleState\n$state");
    //   if (state == AppLifecycleState.resumed) {
    //     AppLifecycleManager().cancelAllSubscriptions();
    //     try {
    //       bool permissionStatus = await PermissionMangeUtil.permissionsHandle(
    //           PermissionType.notification);
    //       LogD("🔥🔥🔥🔥permissionStatus:\n$permissionStatus");
    //       if (permissionStatus == true) {
    //         updateTask(id, type, status);
    //       }
    //     } catch (e) {
    //       LogE(
    //           "AppLifecycleManager-PermissionMangeUtil.permissionsHandle:\n$e");
    //     }
    //   }
    // });
    //LogI("task-openNotification-success");
    return false;
  }

  Future<bool> _share() async {
    //LogI("task-share-ing..");
    await ViewUtils.shareApp();
    //LogD("task-share-success");
    return true;
  }

  Future<bool> _watchEpisode(BuildContext? context, int id) async {
    //LogI("task-watchEpisode-ing..");
    if (context!.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      eventBus.fire(SwitchTabEvent(0));
    }
    //LogD("task-watchEpisode-success");
    return false;
  }

  Future<bool> _unlockEpisode(BuildContext? context, int id) async {
    //LogI("task-unlockEpisode-ing..");
    if (context!.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      eventBus.fire(SwitchTabEvent(0));
    }
    //LogI("task-unlockEpisode-success");
    return false;
  }

  Future<void> updateTask(
    int id,
    String type,
    RewardTaskStatus status, {
    TaskItem? task,
  }) async {
    //LogD("updateTask-type:\n$type");
    List<TaskItem> taskList = _reward.task?.taskList ?? [];
    if (taskList.isNotEmpty) {
      TaskItem? taskIn = taskList.toList().cast<TaskItem?>().firstWhere(
            (item) => item?.id == id,
            orElse: () => null as TaskItem?, // Cast null to TaskItem?
          );
      if (taskIn != null) {
        /// job
        if (status == RewardTaskStatus.go) {
          //LogD("updateTask-type:\n$type-job:gotoclaim");
          // int count = taskIn.count!;
          int times = taskIn.extraInfo is Map &&
                  taskIn.extraInfo.containsKey('requiredTimes')
              ? int.parse(taskIn.extraInfo['requiredTimes'].toString())
              : 1;
          //LogD("updateTask-times:\n$times");
          if ((taskIn?.count ?? 0) < times) {
            taskIn?.count = (taskIn?.count ?? 0) + 1;
            if ((taskIn?.count ?? 0) == times) {
              taskIn.status = "claim";
              taskIn?.count = 0;
            }
          }
        }
        if (status == RewardTaskStatus.claim) {
          taskList.removeWhere((item) => item.id == taskIn.id);
          accountProvider.updateAccountProfile();
        }

        /// update
        /// db
        if (status == RewardTaskStatus.go) {
          await HiveHelper.instance.updateRewardUserTask(taskIn);
        }
        if (status == RewardTaskStatus.claim) {
          await HiveHelper.instance.removeRewardUserTask(taskIn);
        }

        /// vm
        //LogD("updateTask-taskIn:\n${json.encode(taskIn)}");
        notifyListeners();

        /// track
        // String trackValues = TrackValues.go;
        // if (status == RewardTaskStatus.go) {
        //   trackValues = TrackValues.go;
        // } else if (status == RewardTaskStatus.claim) {
        //   if (taskIn.recurrence == 'oneTime') {
        //     trackValues = TrackValues.done;
        //   } else {
        //     trackValues = TrackValues.claim;
        //   }
        // }
        // LogI("trackValues:\n$trackValues");
        // final trackParams = {
        //   TrackParams.id: taskIn.id.toString(),
        //   TrackParams.title: taskIn.language['title'].toString(),
        //   TrackParams.type: taskIn.type.toString(),
        // };
        // LogI("trackParams:\n$trackParams");
        // TrackHelper.instance.track(
        //     event: TrackEvents.task, action: trackValues, params: trackParams);
      }
    }
  }
}
