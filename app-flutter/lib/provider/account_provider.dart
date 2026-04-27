import 'dart:math';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/enums/reward_task.dart';
import 'package:mobisen_app/event_bus/event_bus.dart';
import 'package:mobisen_app/db/hive_helper.dart';
import 'package:mobisen_app/iap/iap_helper.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/net/model/account.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/net/model/watch_history.dart';
import 'package:mobisen_app/util/account_helper.dart';
import 'package:mobisen_app/net/model/reward/task_item.dart';
import 'package:mobisen_app/net/model/membership.dart';
import 'package:mobisen_app/net/model/user.dart';

class AccountProvider extends ChangeNotifier {
  Account? get account => AccountHelper.instance.account;

  List<Show> get savedShowsList => HiveHelper.instance.getSavedShows();
  List<WatchHistory> get watchHistoryList =>
      HiveHelper.instance.getWatchHistory();

  AccountProvider() {}

  void setAccount(Account? account) async {
    AccountHelper.instance.account = account;
    notifyListeners();
    await IAPHelper.instance.setAccount(account);
    await refreshSavedShows();
    eventBus.fire(UpdateRewardEvent(RewardTaskJob.refreshLogin));
  }

  Future<void> updateAccountProfile() async {
    try {
      if (account != null) {
        final user = await ApiService.instance.getAccountProfile(account);
        account?.user = user;
        AccountHelper.instance.account = account;
        notifyListeners();
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        setAccount(null);
      }
    }
  }

  Future<void> unlockEpisode(Episode episode) async {
    final unlockEpisode =
        await ApiService.instance.unlockEpisode(account, episode.episodeId);
    if (unlockEpisode.coins != null) {
      account?.user.coins = unlockEpisode.coins!;

      try {
        _rewardTask();
      } catch (e) {
        LogE(
            "AccountProvider extends ChangeNotifier - unlockEpisode - _rewardTask:\n$e");
      }
    }
    episode.locked = false;
    notifyListeners();
  }

  void _rewardTask() async {
    List<TaskItem> taskList = HiveHelper.instance.getRewardUserTaskList();
    LogD(
        "AccountProvider extends ChangeNotifier-taskList:\n${json.encode(taskList).toString()}");
    if (taskList.isNotEmpty) {
      TaskItem? taskIn = taskList.toList().cast<TaskItem?>().firstWhere(
            (item) =>
                item?.type.toString() ==
                rewardTaskStrings[RewardTask.unlockEpisode],
            orElse: () => null as TaskItem?, // Cast null to TaskItem?
          );
      if (taskIn != null) {
        eventBus.fire(UpdateRewardEvent(RewardTaskJob.unlockEpisode, args: {
          "type": taskIn?.type.toString(),
          "id": taskIn?.id,
        }));
      }
    }
  }

  Future<void> refreshSavedShows() async {
    if (account == null) {
      await HiveHelper.instance.replaceSavedShows([]);
    } else {
      await _loadSavedShows();
    }
    notifyListeners();
  }

  Future<void> _loadSavedShows() async {
    try {
      final shows = await ApiService.instance.savedShows(account, 0, 1000);
      await HiveHelper.instance.replaceSavedShows(shows.shows);
    } catch (_) {}
  }

  bool isShowSaved(Show show) {
    for (var s in savedShowsList) {
      if (s.showId == show.showId) {
        return true;
      }
    }
    return false;
  }

  Future<void> addSavedShow(Show show) async {
    await ApiService.instance.saveShow(account, show.showId);
    for (var s in savedShowsList) {
      if (s.showId == show.showId) {
        return;
      }
    }
    show.saveCount = (show.saveCount ?? 0) + 1;
    await HiveHelper.instance.addSavedShow(show);
    notifyListeners();
  }

  Future<void> removeSavedShow(Show show) async {
    await ApiService.instance.unsaveShow(account, show.showId);
    Show? existShow;
    for (var s in savedShowsList) {
      if (s.showId == show.showId) {
        existShow = s;
        break;
      }
    }
    if (existShow != null) {
      show.saveCount = max(0, (show.saveCount ?? 0) - 1);
    }
    await HiveHelper.instance.removeSavedShow(show);
    notifyListeners();
  }

  void addWatchHistory(WatchHistory history) async {
    await HiveHelper.instance.addWatchHistory(history);
    notifyListeners();
  }

  void clearWatchHistory() async {
    await HiveHelper.instance.clearWatchHistory();
    notifyListeners();
  }

  // ==================== VIP 状态管理 ====================

  /// 是否是 VIP
  bool get isVIP => account?.user.membership?.isValid ?? false;

  /// VIP 等级
  int? get vipLevel => account?.user.membership?.level;

  /// VIP 类型
  String? get vipType => account?.user.membership?.type;

  /// VIP 等级名称
  String? get vipLevelName => account?.user.membership?.levelName;

  /// VIP 剩余天数
  int? get vipRemainingDays => account?.user.membership?.remainingDays;

  /// 剩余视频时长（分钟）
  int get remainingVideoMinutes =>
      account?.user.membership?.remainingVideoMinutes ?? 0;

  /// 剩余语音时长（分钟）
  int get remainingVoiceMinutes =>
      account?.user.membership?.remainingVoiceMinutes ?? 0;

  /// 是否有视频时长
  bool get hasVideoMinutes => remainingVideoMinutes > 0;

  /// 是否有语音时长
  bool get hasVoiceMinutes => remainingVoiceMinutes > 0;

  // ==================== VIP 特权检查 ====================

  /// 是否有专属徽章
  bool get hasExclusiveBadge => isVIP;

  /// 是否有额外滑动次数
  bool get hasExtraSwipes => isVIP;

  /// 是否有滑动倒回
  bool get hasSwipeRewind => isVIP;

  /// 是否有聊天上锁
  bool get hasChatLock => isVIP;

  /// 是否有隐身浏览
  bool get hasIncognitoBrowsing => isVIP;

  /// 是否有隐藏在线状态
  bool get hasHideOnlineStatus => isVIP;

  /// 是否有资料完全隐私
  bool get hasFullProfilePrivacy => isVIP;

  /// 是否可以发起视频通话
  bool get canInitiateVideoCalls => isVIP && hasVideoMinutes;

  /// 是否可以发起语音通话
  bool get canInitiateVoiceCalls => isVIP && hasVoiceMinutes;

  /// 是否有高清视频
  bool get hasHDVideoQuality => isVIP;

  /// 是否有语音降噪
  bool get hasVoiceNoiseReduction => isVIP;

  /// 是否有美颜滤镜
  bool get hasBeautyFilters => isVIP;

  /// 是否可以查看访客
  bool get canViewProfileVisitors => isVIP;

  /// 是否可以自定义屏蔽词
  bool get canCustomBlockedKeywords => isVIP;

  /// 是否可以创建自定义话题
  bool get canCreateCustomTopic => isVIP;

  /// 是否可以购买时长包
  bool get canBuyDurationPacks => isVIP;

  // ==================== 滑动/撤回限制 ====================

  /// 每日免费滑动次数
  static const int dailyFreeSwipes = 5;

  /// 每日免费撤回次数
  static const int dailyFreeRecalls = 5;

  /// VIP 额外滑动次数
  static const int vipExtraSwipes = 8;

  /// 检查是否需要重置每日计数
  void _checkAndResetDailyCounts() {
    final user = account?.user;
    if (user == null) return;

    bool needsUpdate = false;
    int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // 检查滑动计数
    if (user.needsSwipeCountReset) {
      user.dailySwipeCount = 0;
      user.lastSwipeDate = now;
      needsUpdate = true;
    }

    // 检查撤回计数
    if (user.needsRecallCountReset) {
      user.dailyRecallCount = 0;
      user.lastRecallDate = now;
      needsUpdate = true;
    }

    if (needsUpdate) {
      notifyListeners();
    }
  }

  /// 检查是否可以滑动
  bool canSwipe() {
    if (isVIP) return true;

    _checkAndResetDailyCounts();
    final count = account?.user.dailySwipeCount ?? 0;
    return count < dailyFreeSwipes;
  }

  /// 记录滑动
  void recordSwipe() {
    if (isVIP) return;

    _checkAndResetDailyCounts();
    final user = account?.user;
    if (user != null) {
      user.dailySwipeCount = (user.dailySwipeCount ?? 0) + 1;
      user.lastSwipeDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      notifyListeners();
    }
  }

  /// 检查是否可以撤回
  bool canRecall() {
    if (isVIP) return true;

    _checkAndResetDailyCounts();
    final count = account?.user.dailyRecallCount ?? 0;
    return count < dailyFreeRecalls;
  }

  /// 记录撤回
  void recordRecall() {
    if (isVIP) return;

    _checkAndResetDailyCounts();
    final user = account?.user;
    if (user != null) {
      user.dailyRecallCount = (user.dailyRecallCount ?? 0) + 1;
      user.lastRecallDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      notifyListeners();
    }
  }

  // ==================== 时长管理 ====================

  /// 检查并重置每月时长
  void checkAndResetMonthlyBonus() {
    final membership = account?.user.membership;
    if (membership == null) return;
    if (!membership.needsMonthlyReset) return;

    final newMembership = membership.copyWith(
      monthlyVideoMinutesUsed: 0,
      monthlyVoiceMinutesUsed: 0,
      monthlyResetDate:
          Membership.getNextResetDate().millisecondsSinceEpoch ~/ 1000,
    );

    account?.user.membership = newMembership;
    notifyListeners();
  }

  /// 消耗视频时长
  Future<bool> consumeVideoMinutes(int minutes) async {
    if (!isVIP) return false;
    if (remainingVideoMinutes < minutes) return false;

    final membership = account?.user.membership;
    if (membership != null) {
      account?.user.membership = membership.copyWith(
        monthlyVideoMinutesUsed:
            (membership.monthlyVideoMinutesUsed ?? 0) + minutes,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 消耗语音时长
  Future<bool> consumeVoiceMinutes(int minutes) async {
    if (!isVIP) return false;
    if (remainingVoiceMinutes < minutes) return false;

    final membership = account?.user.membership;
    if (membership != null) {
      account?.user.membership = membership.copyWith(
        monthlyVoiceMinutesUsed:
            (membership.monthlyVoiceMinutesUsed ?? 0) + minutes,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 是否显示过期提醒（剩余7天内）
  bool get shouldShowExpireWarning {
    if (!isVIP) return false;
    final days = vipRemainingDays;
    if (days == null) return false;
    return days <= 7 && days > 0;
  }

  /// 获取过期提醒文案
  String get expireWarningText {
    final days = vipRemainingDays ?? 0;
    return 'Your VIP membership will expire in $days days';
  }

  // ==================== VIP 状态同步 ====================

  /// 同步 VIP 状态（从 RevenueCat 到本地和服务器）
  Future<void> syncVIPStatus() async {
    try {
      final isVIPActive = await IAPHelper.instance.isVIP();
      final expireDate = await IAPHelper.instance.getVIPExpireDate();

      if (account != null) {
        // 创建新的 Membership 对象
        Membership? newMembership;
        if (isVIPActive && expireDate != null) {
          newMembership = Membership(
            level: 1, // 默认 level，实际应根据购买的产品确定
            expirationTime: expireDate.millisecondsSinceEpoch ~/ 1000,
            type: 'vip',
            isActive: true,
            monthlyVideoMinutesTotal: 60,
            monthlyVoiceMinutesTotal: 120,
            monthlyResetDate:
                Membership.getNextResetDate().millisecondsSinceEpoch ~/ 1000,
          );
        }

        // 更新本地账户信息
        final updatedUser = User(
          account!.user.id,
          account!.user.username,
          account!.user.email,
          account!.user.blocked,
          account!.user.coins,
          account!.user.displayName,
          newMembership,
          personalizeEdit: account!.user.personalizeEdit,
          dailySwipeCount: account!.user.dailySwipeCount,
          dailyRecallCount: account!.user.dailyRecallCount,
          lastSwipeDate: account!.user.lastSwipeDate,
          lastRecallDate: account!.user.lastRecallDate,
        );

        final updatedAccount = Account(
          updatedUser,
          account!.jwt,
        );

        setAccount(updatedAccount);

        // 同时尝试同步到服务器（如果服务器支持）
        try {
          await updateAccountProfile();
        } catch (e) {
          // 服务器同步失败不影响本地状态
          print('服务器同步失败（可忽略）: $e');
        }
      }
    } catch (e) {
      print('同步 VIP 状态失败: $e');
    }
  }
}
