/// 用户卡片模型
class UserCard {
  final String userId;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final int? age;
  final String? gender;
  final String? location;
  final String? bio;
  final List<String> interests;
  final String? purpose;
  final List<String> photos;
  final bool isOnline;
  final DateTime? lastActive;
  final double matchScore; // 匹配度分数

  UserCard({
    required this.userId,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.age,
    this.gender,
    this.location,
    this.bio,
    required this.interests,
    this.purpose,
    required this.photos,
    this.isOnline = false,
    this.lastActive,
    this.matchScore = 0.0,
  });

  factory UserCard.fromJson(Map<String, dynamic> json) {
    return UserCard(
      userId: json['userId'],
      username: json['username'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      age: json['age'],
      gender: json['gender'],
      location: json['location'],
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
      purpose: json['purpose'],
      photos: List<String>.from(json['photos'] ?? []),
      isOnline: json['isOnline'] ?? false,
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : null,
      matchScore: json['matchScore']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'age': age,
      'gender': gender,
      'location': location,
      'bio': bio,
      'interests': interests,
      'purpose': purpose,
      'photos': photos,
      'isOnline': isOnline,
      'lastActive': lastActive?.toIso8601String(),
      'matchScore': matchScore,
    };
  }
}

/// 打招呼记录
class GreetingRecord {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String? message;
  final DateTime createdAt;
  final GreetingStatus status;
  final DateTime? expireAt;

  GreetingRecord({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.message,
    required this.createdAt,
    this.status = GreetingStatus.pending,
    this.expireAt,
  });

  factory GreetingRecord.fromJson(Map<String, dynamic> json) {
    return GreetingRecord(
      id: json['id'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      status: GreetingStatus.values[json['status'] ?? 0],
      expireAt:
          json['expireAt'] != null ? DateTime.parse(json['expireAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': status.index,
      'expireAt': expireAt?.toIso8601String(),
    };
  }

  /// 检查是否已过期
  bool get isExpired {
    if (expireAt == null) return false;
    return DateTime.now().isAfter(expireAt!);
  }

  GreetingRecord copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    String? message,
    DateTime? createdAt,
    GreetingStatus? status,
    DateTime? expireAt,
  }) {
    return GreetingRecord(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      expireAt: expireAt ?? this.expireAt,
    );
  }
}

enum GreetingStatus {
  pending, // 待回复
  accepted, // 已接受
  rejected, // 已拒绝
  expired, // 已过期
}

/// 匹配筛选条件
class MatchFilter {
  final int? minAge;
  final int? maxAge;
  final String? gender;
  final String? location;
  final List<String>? interests;
  final String? purpose;
  final bool? isOnline;

  MatchFilter({
    this.minAge,
    this.maxAge,
    this.gender,
    this.location,
    this.interests,
    this.purpose,
    this.isOnline,
  });

  Map<String, dynamic> toJson() {
    return {
      'minAge': minAge,
      'maxAge': maxAge,
      'gender': gender,
      'location': location,
      'interests': interests,
      'purpose': purpose,
      'isOnline': isOnline,
    };
  }
}
