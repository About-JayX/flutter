import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class Conversation {
  final String conversationId;
  final String peerId;
  final String peerName;
  final String? peerAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isPinned;
  final bool isLocked;
  final bool isMuted;
  final DateTime? draftTime;
  final String? draftContent;

  const Conversation({
    required this.conversationId,
    required this.peerId,
    required this.peerName,
    this.peerAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isLocked = false,
    this.isMuted = false,
    this.draftTime,
    this.draftContent,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  Conversation copyWith({
    String? conversationId,
    String? peerId,
    String? peerName,
    String? peerAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isPinned,
    bool? isLocked,
    bool? isMuted,
    DateTime? draftTime,
    String? draftContent,
  }) {
    return Conversation(
      conversationId: conversationId ?? this.conversationId,
      peerId: peerId ?? this.peerId,
      peerName: peerName ?? this.peerName,
      peerAvatar: peerAvatar ?? this.peerAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isLocked: isLocked ?? this.isLocked,
      isMuted: isMuted ?? this.isMuted,
      draftTime: draftTime ?? this.draftTime,
      draftContent: draftContent ?? this.draftContent,
    );
  }
}
