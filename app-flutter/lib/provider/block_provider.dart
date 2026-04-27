import 'package:flutter/material.dart';
import 'package:mobisen_app/db/hive_helper.dart';
import 'package:mobisen_app/model/block_model.dart';

class BlockProvider extends ChangeNotifier {
  List<BlockedUser> _blockedUsers = [];
  List<BlockedKeyword> _blockedKeywords = [];

  List<BlockedUser> get blockedUsers => List.unmodifiable(_blockedUsers);
  List<BlockedKeyword> get blockedKeywords =>
      List.unmodifiable(_blockedKeywords);

  /// 初始化（从 Hive 加载）
  Future<void> initialize() async {
    await _loadBlockedUsers();
    await _loadBlockedKeywords();
  }

  /// 加载黑名单用户（使用现有 HiveHelper）
  Future<void> _loadBlockedUsers() async {
    try {
      final box = HiveHelper.instance.blockedUsersBox;
      _blockedUsers = box.values
          .map((json) => BlockedUser.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      // 清理过期记录
      _blockedUsers.removeWhere((user) => user.isExpired);

      notifyListeners();
    } catch (e) {
      print('加载黑名单失败: $e');
    }
  }

  /// 加载屏蔽词（使用现有 HiveHelper）
  Future<void> _loadBlockedKeywords() async {
    try {
      final box = HiveHelper.instance.blockedKeywordsBox;
      _blockedKeywords = box.values
          .map((json) =>
              BlockedKeyword.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      notifyListeners();
    } catch (e) {
      print('加载屏蔽词失败: $e');
    }
  }

  /// 拉黑用户
  Future<void> blockUser({
    required String userId,
    required String username,
    String? avatarUrl,
    String? reason,
    bool isPermanent = true,
    DateTime? expireAt,
  }) async {
    // 检查是否已拉黑
    if (isUserBlocked(userId)) return;

    final blockedUser = BlockedUser(
      userId: userId,
      username: username,
      avatarUrl: avatarUrl,
      blockedAt: DateTime.now(),
      reason: reason,
      isPermanent: isPermanent,
      expireAt: expireAt,
    );

    // 保存到本地（使用现有 HiveHelper）
    try {
      await HiveHelper.instance.blockedUsersBox
          .put(userId, blockedUser.toJson());
    } catch (e) {
      print('保存黑名单到本地失败: $e');
    }

    _blockedUsers.add(blockedUser);
    notifyListeners();
  }

  /// 解除拉黑
  Future<void> unblockUser(String userId) async {
    // 从本地删除（使用现有 HiveHelper）
    try {
      await HiveHelper.instance.blockedUsersBox.delete(userId);
    } catch (e) {
      print('从本地删除黑名单失败: $e');
    }

    _blockedUsers.removeWhere((user) => user.userId == userId);
    notifyListeners();
  }

  /// 检查是否已拉黑
  bool isUserBlocked(String userId) {
    return _blockedUsers
        .any((user) => user.userId == userId && !user.isExpired);
  }

  /// 获取拉黑信息
  BlockedUser? getBlockedUserInfo(String userId) {
    try {
      return _blockedUsers.firstWhere(
        (user) => user.userId == userId && !user.isExpired,
      );
    } catch (e) {
      return null;
    }
  }

  /// 添加屏蔽词
  Future<void> addBlockedKeyword({
    required String keyword,
    bool isRegex = false,
    bool caseSensitive = false,
  }) async {
    // 检查是否已存在
    if (_blockedKeywords.any((k) => k.keyword == keyword)) return;

    final blockedKeyword = BlockedKeyword(
      keyword: keyword,
      createdAt: DateTime.now(),
      isRegex: isRegex,
      caseSensitive: caseSensitive,
    );

    // 保存到本地（使用现有 HiveHelper）
    final key = 'keyword_${DateTime.now().millisecondsSinceEpoch}';
    try {
      await HiveHelper.instance.blockedKeywordsBox
          .put(key, blockedKeyword.toJson());
    } catch (e) {
      print('保存屏蔽词到本地失败: $e');
    }

    _blockedKeywords.add(blockedKeyword);
    notifyListeners();
  }

  /// 删除屏蔽词
  Future<void> removeBlockedKeyword(String keyword) async {
    // 找到并删除（使用现有 HiveHelper）
    try {
      final box = HiveHelper.instance.blockedKeywordsBox;
      final entries = box.toMap().entries.where((entry) {
        final json = Map<String, dynamic>.from(entry.value);
        return json['keyword'] == keyword;
      });

      for (final entry in entries) {
        await box.delete(entry.key);
      }
    } catch (e) {
      print('从本地删除屏蔽词失败: $e');
    }

    _blockedKeywords.removeWhere((k) => k.keyword == keyword);
    notifyListeners();
  }

  /// 检查文本是否包含屏蔽词
  bool containsBlockedKeyword(String text) {
    for (final keyword in _blockedKeywords) {
      if (keyword.matches(text)) {
        return true;
      }
    }
    return false;
  }

  /// 过滤文本中的屏蔽词
  String filterBlockedKeywords(String text) {
    String filtered = text;
    for (final keyword in _blockedKeywords) {
      if (keyword.isRegex) continue; // 正则屏蔽词不替换

      final pattern =
          keyword.caseSensitive ? keyword.keyword : '(?i)${keyword.keyword}';
      filtered = filtered.replaceAll(
        RegExp(pattern),
        '*' * keyword.keyword.length,
      );
    }
    return filtered;
  }

  /// 提交举报
  Future<bool> submitReport({
    required String reportedUserId,
    required ReportType type,
    required String reason,
    String? description,
    List<String>? evidence,
  }) async {
    try {
      final report = Report(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        reporterId: '', // 从当前用户获取
        reportedUserId: reportedUserId,
        type: type,
        reason: reason,
        description: description,
        evidence: evidence,
        createdAt: DateTime.now(),
      );

      // TODO: 发送到服务器
      print('Report submitted: ${report.toJson()}');
      return true;
    } catch (e) {
      print('提交举报失败: $e');
      return false;
    }
  }

  /// 清理过期黑名单
  Future<void> cleanExpiredBlocks() async {
    final expiredUsers = _blockedUsers.where((user) => user.isExpired).toList();

    for (final user in expiredUsers) {
      try {
        await HiveHelper.instance.blockedUsersBox.delete(user.userId);
      } catch (e) {
        print('删除过期黑名单失败: $e');
      }
    }

    _blockedUsers.removeWhere((user) => user.isExpired);
    notifyListeners();
  }

  /// 清空所有数据
  Future<void> clear() async {
    try {
      await HiveHelper.instance.blockedUsersBox.clear();
      await HiveHelper.instance.blockedKeywordsBox.clear();
    } catch (e) {
      print('清空黑名单数据失败: $e');
    }
    _blockedUsers.clear();
    _blockedKeywords.clear();
    notifyListeners();
  }
}
