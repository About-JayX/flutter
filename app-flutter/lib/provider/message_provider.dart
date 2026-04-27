import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  bool _loading = false;

  List<Conversation> get conversations => _conversations;
  bool get loading => _loading;

  MessageProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _conversations = [
      Conversation(
        id: '1',
        name: 'Ollie',
        avatar: 'assets/images/chat_other_avatar.png',
        lastMessage: 'Your profile card is...',
        time: '3:27 PM',
        unreadCount: 9,
        isPinned: false,
        isLocked: false,
        type: MessageType.text,
      ),
      Conversation(
        id: '2',
        name: 'Ollie',
        avatar: 'assets/images/chat_other_avatar.png',
        lastMessage: '[Video Call]',
        time: 'Mar 24, 2026',
        unreadCount: 99,
        isPinned: false,
        isLocked: false,
        type: MessageType.videoCall,
      ),
      Conversation(
        id: '3',
        name: 'System Messages',
        avatar: '',
        lastMessage: 'App Updated. Enjo...',
        time: '3:27 PM',
        unreadCount: 12,
        isPinned: false,
        isLocked: false,
        type: MessageType.system,
        isSystem: true,
      ),
      Conversation(
        id: '4',
        name: 'Ollie',
        avatar: 'assets/images/chat_other_avatar.png',
        lastMessage: '[Gift]',
        time: 'Mar 24, 2026',
        unreadCount: 99,
        isPinned: false,
        isLocked: false,
        type: MessageType.gift,
      ),
      Conversation(
        id: '5',
        name: 'Ollie',
        avatar: 'assets/images/chat_other_avatar.png',
        lastMessage: '[Voice Call]',
        time: 'Mar 24, 2026',
        unreadCount: 99,
        isPinned: false,
        isLocked: false,
        type: MessageType.voiceCall,
      ),
    ];
    notifyListeners();
  }

  void pinConversation(String id) {
    final index = _conversations.indexWhere((c) => c.id == id);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(isPinned: true);
      _sortConversations();
      notifyListeners();
    }
  }

  void lockConversation(String id) {
    final index = _conversations.indexWhere((c) => c.id == id);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(isLocked: true);
      notifyListeners();
    }
  }

  void deleteConversation(String id) {
    _conversations.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void _sortConversations() {
    _conversations.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });
  }

  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _loading = false;
    notifyListeners();
  }
}

enum MessageType { text, voiceCall, videoCall, gift, system }

class Conversation {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isPinned;
  final bool isLocked;
  final MessageType type;
  final bool isSystem;

  Conversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isPinned,
    required this.isLocked,
    required this.type,
    this.isSystem = false,
  });

  Conversation copyWith({
    String? id,
    String? name,
    String? avatar,
    String? lastMessage,
    String? time,
    int? unreadCount,
    bool? isPinned,
    bool? isLocked,
    MessageType? type,
    bool? isSystem,
  }) {
    return Conversation(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isLocked: isLocked ?? this.isLocked,
      type: type ?? this.type,
      isSystem: isSystem ?? this.isSystem,
    );
  }
}
