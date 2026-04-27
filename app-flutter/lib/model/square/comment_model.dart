class CommentModel {
  final String id;
  final String postId;
  final String username;
  final String? avatarUrl;
  final String content;
  final DateTime createdAt;
  final String? parentId;
  final bool isOwn;

  CommentModel({
    required this.id,
    required this.postId,
    required this.username,
    this.avatarUrl,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.isOwn = false,
  });

  CommentModel copyWith({
    String? id,
    String? postId,
    String? username,
    String? avatarUrl,
    String? content,
    DateTime? createdAt,
    String? parentId,
    bool? isOwn,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      parentId: parentId ?? this.parentId,
      isOwn: isOwn ?? this.isOwn,
    );
  }
}
