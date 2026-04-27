import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobisen_app/db/hive_type_adapters.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/net/model/reward/task_item.dart';
import 'package:mobisen_app/net/model/reward/task_item_language.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/net/model/watch_history.dart';

class HiveHelper {
  static late HiveHelper _instance;
  static HiveHelper get instance => _instance;

  static Future<void> init() async {
    _instance = HiveHelper._();
    await _instance._initHive();
  }

  HiveHelper._();

  late Box rewardUserTasksBox;
  late Box savedShowsBox;
  late Box watchHistoryBox;
  late Box privacySettingsBox;
  late Box blockedUsersBox;
  late Box blockedKeywordsBox;
  late Box conversationsBox;
  late Box chatMessagesBox;

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ShowAdapter());
    Hive.registerAdapter(TaskItemAdapter());
    // Hive.registerAdapter(TaskItemLanguageAdapter());
    Hive.registerAdapter(EpisodeAdapter());
    Hive.registerAdapter(WatchHistoryAdapter());
    Hive.registerAdapter(PrivacySettingsAdapter());
    Hive.registerAdapter(BlockedUserAdapter());
    Hive.registerAdapter(BlockedKeywordAdapter());
    Hive.registerAdapter(ConversationAdapter());
    savedShowsBox = await _openHiveBoxOrReset("saved_shows");
    rewardUserTasksBox = await _openHiveBoxOrReset("reward_user_tasks");
    watchHistoryBox = await _openHiveBoxOrReset("watch_history");
    privacySettingsBox = await _openHiveBoxOrReset("privacy_settings");
    blockedUsersBox = await _openHiveBoxOrReset("blocked_users");
    blockedKeywordsBox = await _openHiveBoxOrReset("blocked_keywords");
    conversationsBox = await _openHiveBoxOrReset("conversations");
    chatMessagesBox = await _openHiveBoxOrReset("chat_messages");
  }

  Future<Box> _openHiveBoxOrReset(String name) async {
    try {
      return await Hive.openBox(name);
    } catch (e) {
      // todo report
      Hive.deleteBoxFromDisk(name);
    }
    return await Hive.openBox(name);
  }

  List<TaskItem> getRewardUserTaskList() {
    final List<TaskItem> rewardUserTaskList = [];
    try {
      rewardUserTaskList
          .addAll(rewardUserTasksBox.values.toList().cast<TaskItem>().reversed);
    } catch (e) {
      LogE("HiveHelper-getRewardUserTaskList：\n$e");
    }
    return rewardUserTaskList;
  }

  Future<void> replaceRewardUserTask(List<TaskItem> taskList) async {
    try {
      await rewardUserTasksBox.clear();
      await rewardUserTasksBox.addAll(taskList.reversed);
    } catch (e) {
      LogE("HiveHelper-replaceRewardUserTask：\n$e");
    }
  }

  Future<void> addRewardUserTask(TaskItem task) async {
    try {
      await removeRewardUserTask(task);
      await rewardUserTasksBox.add(task);
    } catch (e) {}
  }

  Future<void> updateRewardUserTask(TaskItem updatedTask) async {
    try {
      int existIndex = rewardUserTasksBox.values
          .toList()
          .cast<TaskItem>()
          .indexWhere((task) => task.id == updatedTask.id);
      if (existIndex >= 0) {
        await rewardUserTasksBox.putAt(existIndex, updatedTask);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removeRewardUserTask(TaskItem task) async {
    try {
      int existIndex = rewardUserTasksBox.values
          .toList()
          .cast<TaskItem>()
          .indexWhere((s) => s.id == task.id);
      if (existIndex >= 0) {
        await rewardUserTasksBox.deleteAt(existIndex);
      }
    } catch (e) {}
  }

  List<Show> getSavedShows() {
    final List<Show> shows = [];
    try {
      shows.addAll(savedShowsBox.values.toList().cast<Show>().reversed);
    } catch (e) {}
    return shows;
  }

  Future<void> replaceSavedShows(List<Show> shows) async {
    try {
      await savedShowsBox.clear();
      await savedShowsBox.addAll(shows.reversed);
    } catch (e) {}
  }

  Future<void> addSavedShow(Show show) async {
    try {
      await removeSavedShow(show);
      await savedShowsBox.add(show);
    } catch (e) {}
  }

  Future<void> removeSavedShow(Show show) async {
    try {
      int existIndex = savedShowsBox.values
          .toList()
          .cast<Show>()
          .indexWhere((s) => s.showId == show.showId);
      if (existIndex >= 0) {
        await savedShowsBox.deleteAt(existIndex);
      }
    } catch (e) {}
  }

  List<WatchHistory> getWatchHistory() {
    final List<WatchHistory> history = [];
    try {
      history.addAll(
          watchHistoryBox.values.toList().cast<WatchHistory>().reversed);
    } catch (e) {}
    return history;
  }

  Future<void> clearWatchHistory() async {
    try {
      await watchHistoryBox.clear();
    } catch (e) {}
  }

  Future<void> addWatchHistory(WatchHistory history) async {
    try {
      await removeWatchHistory(history);
      await watchHistoryBox.add(history);
    } catch (e) {}
  }

  Future<void> removeWatchHistory(WatchHistory history) async {
    try {
      int existIndex = watchHistoryBox.values
          .toList()
          .cast<WatchHistory>()
          .indexWhere((h) => h.show.showId == history.show.showId);
      if (existIndex >= 0) {
        await watchHistoryBox.deleteAt(existIndex);
      }
    } catch (e) {}
  }
}
