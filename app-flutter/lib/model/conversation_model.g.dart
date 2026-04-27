// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      conversationId: json['conversationId'] as String,
      peerId: json['peerId'] as String,
      peerName: json['peerName'] as String,
      peerAvatar: json['peerAvatar'] as String?,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      draftTime: json['draftTime'] == null
          ? null
          : DateTime.parse(json['draftTime'] as String),
      draftContent: json['draftContent'] as String?,
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'peerId': instance.peerId,
      'peerName': instance.peerName,
      'peerAvatar': instance.peerAvatar,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'isPinned': instance.isPinned,
      'isLocked': instance.isLocked,
      'isMuted': instance.isMuted,
      'draftTime': instance.draftTime?.toIso8601String(),
      'draftContent': instance.draftContent,
    };
