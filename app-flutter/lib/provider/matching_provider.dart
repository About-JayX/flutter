import 'package:flutter/material.dart';
import 'package:mobisen_app/model/matching/match_model.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:provider/provider.dart';

class MatchingProvider extends ChangeNotifier {
  List<UserCard> _userCards = [];
  List<UserCard> get userCards => _userCards;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  UserCard? get currentCard =>
      _userCards.isNotEmpty && _currentIndex < _userCards.length
          ? _userCards[_currentIndex]
          : null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  MatchFilter _filter = MatchFilter();
  MatchFilter get filter => _filter;

  List<GreetingRecord> _greetings = [];
  List<GreetingRecord> get greetings => _greetings;

  // VIP限制相关
  int _dailySwipeCount = 0;
  int get dailySwipeCount => _dailySwipeCount;

  static const int maxFreeSwipes = 6; // 非VIP用户每天最多滑动次数

  bool get hasReachedSwipeLimit => _dailySwipeCount >= maxFreeSwipes;

  // 筛选相关
  String? _selectedGender;
  String? get selectedGender => _selectedGender;

  RangeValues _ageRange = const RangeValues(18, 60);
  RangeValues get ageRange => _ageRange;

  /// 加载推荐用户
  Future<void> loadRecommendations({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentIndex = 0;
      _hasMore = true;
      _userCards.clear();
    }

    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: 调用 API 加载推荐用户
      await Future.delayed(const Duration(seconds: 1));

      // 模拟数据
      if (_currentPage == 1) {
        _userCards = [
          UserCard(
            userId: '1',
            username: 'Alice',
            displayName: 'Alice',
            avatarUrl:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
            age: 25,
            gender: 'female',
            location: 'New York',
            bio: 'Love traveling and photography 📸',
            interests: ['Travel', 'Photo', 'Music', 'Coffee'],
            purpose: '寻找朋友',
            photos: [
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
            ],
            isOnline: true,
            matchScore: 0.85,
          ),
          UserCard(
            userId: '2',
            username: 'Bob',
            displayName: 'Bob',
            avatarUrl:
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
            age: 28,
            gender: 'male',
            location: 'Los Angeles',
            bio: 'Foodie and cooking enthusiast 🍳',
            interests: ['Food', 'Cooking', 'Movie', 'Sports'],
            purpose: '兴趣交流',
            photos: [
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
            ],
            matchScore: 0.72,
          ),
          UserCard(
            userId: '3',
            username: 'Charlie',
            displayName: 'Charlie',
            avatarUrl:
                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
            age: 26,
            gender: 'male',
            location: 'Chicago',
            bio: 'Gamer and tech lover 🎮',
            interests: ['Game', 'Tech', 'Music', 'Reading'],
            purpose: '活动邀约',
            photos: [
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
            ],
            matchScore: 0.68,
          ),
          UserCard(
            userId: '4',
            username: 'Diana',
            displayName: 'Diana',
            avatarUrl:
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
            age: 24,
            gender: 'female',
            location: 'Miami',
            bio: 'Beach lover and yoga instructor 🧘‍♀️',
            interests: ['Yoga', 'Beach', 'Travel', 'Health'],
            purpose: '寻找朋友',
            photos: [
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
            ],
            isOnline: true,
            matchScore: 0.90,
          ),
          UserCard(
            userId: '5',
            username: 'Eve',
            displayName: 'Eve',
            avatarUrl:
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
            age: 27,
            gender: 'female',
            location: 'Seattle',
            bio: 'Artist and dreamer 🎨',
            interests: ['Art', 'Music', 'Reading', 'Coffee'],
            purpose: '兴趣交流',
            photos: [
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
            ],
            matchScore: 0.78,
          ),
          UserCard(
            userId: '6',
            username: 'Frank',
            displayName: 'Frank',
            avatarUrl:
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
            age: 30,
            gender: 'male',
            location: 'Boston',
            bio: 'Musician and traveler 🎸',
            interests: ['Music', 'Travel', 'Sports', 'Food'],
            purpose: '活动邀约',
            photos: [
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
            ],
            matchScore: 0.65,
          ),
          UserCard(
            userId: '7',
            username: 'Grace',
            displayName: 'Grace',
            avatarUrl:
                'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
            age: 23,
            gender: 'female',
            location: 'San Francisco',
            bio: 'Tech enthusiast and hiker 🥾',
            interests: ['Tech', 'Hiking', 'Reading', 'Coffee'],
            purpose: '寻找朋友',
            photos: [
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
            ],
            isOnline: true,
            matchScore: 0.82,
          ),
        ];
      }

      _hasMore = false;
      _currentPage++;
    } catch (e) {
      print('加载推荐用户失败: \$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 下一张卡片
  void nextCard() {
    if (_currentIndex < _userCards.length - 1) {
      _currentIndex++;
      notifyListeners();
    } else if (_hasMore) {
      loadRecommendations();
    }
  }

  /// 喜欢/感兴趣
  Future<void> likeUser(String userId) async {
    try {
      // TODO: 调用 API
      await Future.delayed(const Duration(milliseconds: 300));
      _dailySwipeCount++;
      nextCard();
    } catch (e) {
      print('喜欢用户失败: \$e');
    }
  }

  /// 不喜欢/跳过
  void dislikeUser(String userId) {
    _dailySwipeCount++;
    nextCard();
  }

  /// 倒回上一张
  void rewindCard() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  /// 打招呼
  Future<bool> sendGreeting({
    required String userId,
    String? message,
  }) async {
    try {
      // TODO: 调用 API 发送打招呼
      await Future.delayed(const Duration(seconds: 1));

      final greeting = GreetingRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromUserId: 'current_user_id',
        toUserId: userId,
        message: message,
        createdAt: DateTime.now(),
        expireAt: DateTime.now().add(const Duration(days: 7)),
      );

      _greetings.add(greeting);
      notifyListeners();
      return true;
    } catch (e) {
      print('发送打招呼失败: \$e');
    }
    return false;
  }

  /// 回复打招呼
  Future<void> respondToGreeting({
    required String greetingId,
    required bool accept,
  }) async {
    try {
      // TODO: 调用 API
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _greetings.indexWhere((g) => g.id == greetingId);
      if (index != -1) {
        _greetings[index] = _greetings[index].copyWith(
          status: accept ? GreetingStatus.accepted : GreetingStatus.rejected,
        );
        notifyListeners();
      }
    } catch (e) {
      print('回复打招呼失败: \$e');
    }
  }

  /// 加载打招呼记录
  Future<void> loadGreetings() async {
    try {
      // TODO: 调用 API
      await Future.delayed(const Duration(seconds: 1));

      _greetings = [];
      notifyListeners();
    } catch (e) {
      print('加载打招呼记录失败: \$e');
    }
  }

  /// 更新筛选条件
  void updateFilter(MatchFilter newFilter) {
    _filter = newFilter;
    loadRecommendations(refresh: true);
  }

  /// 更新性别筛选
  void updateGenderFilter(String? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  /// 更新年龄范围筛选
  void updateAgeRangeFilter(RangeValues ageRange) {
    _ageRange = ageRange;
    notifyListeners();
  }

  /// 应用筛选
  void applyFilter() {
    _filter = MatchFilter(
      gender: _selectedGender,
      minAge: _ageRange.start.toInt(),
      maxAge: _ageRange.end.toInt(),
    );
    loadRecommendations(refresh: true);
  }

  /// 重置每日滑动次数
  void resetDailySwipeCount() {
    _dailySwipeCount = 0;
    notifyListeners();
  }

  /// 清空数据
  void clear() {
    _userCards.clear();
    _currentIndex = 0;
    _hasMore = true;
    _greetings.clear();
    _dailySwipeCount = 0;
    notifyListeners();
  }

  int _currentPage = 1;

  /// 检查是否可以滑动（调用 AccountProvider 的逻辑）
  bool canSwipe(BuildContext context) {
    return context.read<AccountProvider>().canSwipe();
  }

  /// 记录滑动（调用 AccountProvider 的逻辑）
  void recordSwipe(BuildContext context) {
    context.read<AccountProvider>().recordSwipe();
  }

  /// 检查是否可以撤回
  bool canRecall(BuildContext context) {
    return context.read<AccountProvider>().canRecall();
  }

  /// 记录撤回
  void recordRecall(BuildContext context) {
    context.read<AccountProvider>().recordRecall();
  }

  /// 是否有滑动倒回特权
  bool hasSwipeRewind(BuildContext context) {
    return context.read<AccountProvider>().hasSwipeRewind;
  }
}
