// 新增枚举
enum PostVisibility {
  everyone, // 所有人可见
  friends, // 仅好友可见
  vip, // 仅 VIP 可见
  private, // 仅自己可见
}

enum PostStatus {
  active, // 正常
  expired, // 已过期
  deleted, // 已删除
  underReview, // 审核中
  rejected, // 未通过审核
}

class PostModel {
  // ===== 现有字段保留（不变） =====
  final String id;
  final String username;
  final String? avatarUrl;
  final String hashtagsHead;
  final String hashtagsCon;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final bool isLiked;
  final String friendStatus;
  final int? expireHours;
  final bool isExpanded;
  final bool isLongContent;

  // ===== 新增字段 =====
  final List<String>? images; // 图片列表
  final PostVisibility visibility; // 可见范围
  final PostStatus status; // 帖子状态
  final String? purpose; // 交友目的
  final bool allowGreetings; // 是否允许打招呼
  final int? commentCount; // 评论数
  final int? shareCount; // 分享数
  final bool isAnonymous; // 是否匿名
  final String? anonymousName; // 匿名名称
  final DateTime? expireAt; // 过期时间
  final List<String>? tags; // 标签列表
  final String? location; // 位置信息

  PostModel({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.hashtagsHead,
    required this.hashtagsCon,
    required this.content,
    required this.createdAt,
    this.likeCount = 0,
    this.isLiked = false,
    this.friendStatus = 'none',
    this.expireHours,
    this.isExpanded = false,
    this.isLongContent = false,
    // 新增字段（可选，有默认值）
    this.images,
    this.visibility = PostVisibility.everyone,
    this.status = PostStatus.active,
    this.purpose,
    this.allowGreetings = true,
    this.commentCount,
    this.shareCount,
    this.isAnonymous = false,
    this.anonymousName,
    this.expireAt,
    this.tags,
    this.location,
  });

  PostModel copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    String? hashtagsHead,
    String? hashtagsCon,
    String? content,
    DateTime? createdAt,
    int? likeCount,
    bool? isLiked,
    String? friendStatus,
    int? expireHours,
    bool? isExpanded,
    bool? isLongContent,
    List<String>? images,
    PostVisibility? visibility,
    PostStatus? status,
    String? purpose,
    bool? allowGreetings,
    int? commentCount,
    int? shareCount,
    bool? isAnonymous,
    String? anonymousName,
    DateTime? expireAt,
    List<String>? tags,
    String? location,
  }) {
    return PostModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hashtagsHead: hashtagsHead ?? this.hashtagsHead,
      hashtagsCon: hashtagsCon ?? this.hashtagsCon,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      friendStatus: friendStatus ?? this.friendStatus,
      expireHours: expireHours ?? this.expireHours,
      isExpanded: isExpanded ?? this.isExpanded,
      isLongContent: isLongContent ?? this.isLongContent,
      images: images ?? this.images,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      purpose: purpose ?? this.purpose,
      allowGreetings: allowGreetings ?? this.allowGreetings,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      anonymousName: anonymousName ?? this.anonymousName,
      expireAt: expireAt ?? this.expireAt,
      tags: tags ?? this.tags,
      location: location ?? this.location,
    );
  }

  /// 检查是否已过期
  bool get isExpired {
    if (expireAt == null) return false;
    return DateTime.now().isAfter(expireAt!);
  }

  /// 获取剩余时间文本
  String? get remainingTime {
    if (expireAt == null) return null;
    final diff = expireAt!.difference(DateTime.now());

    if (diff.inDays > 0) {
      return '${diff.inDays}天后过期';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}小时后过期';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}分钟后过期';
    } else {
      return '即将过期';
    }
  }
}

class TopicModel {
  final String id;
  final String emoji;
  final String text;
  final bool isSelected;

  TopicModel({
    required this.id,
    required this.emoji,
    required this.text,
    this.isSelected = false,
  });

  TopicModel copyWith({
    String? id,
    String? emoji,
    String? text,
    bool? isSelected,
  }) {
    return TopicModel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class DurationOption {
  final String id;
  final String label;
  final int? hours; // null for permanent

  const DurationOption({
    required this.id,
    required this.label,
    this.hours,
  });
}

class PublishFormModel {
  String content;
  String? selectedTopicId;
  String visibilityDuration;
  bool allowGreetingsViaTopics;
  bool sameTopicsOnly;
  bool allowEveryone;

  PublishFormModel({
    this.content = '',
    this.selectedTopicId,
    this.visibilityDuration = 'permanent',
    this.allowGreetingsViaTopics = true,
    this.sameTopicsOnly = false,
    this.allowEveryone = true,
  });
}
