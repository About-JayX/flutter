import 'package:flutter/material.dart';
import 'package:mobisen_app/services/zego_im_service.dart';
import 'package:zego_zim/zego_zim.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _loading = false;
  String _inputText = '';
  bool _showGiftPanel = false;
  bool _isKeyboardVisible = false;

  List<ChatMessage> get messages => _messages;
  bool get loading => _loading;
  String get inputText => _inputText;
  bool get showGiftPanel => _showGiftPanel;
  bool get isKeyboardVisible => _isKeyboardVisible;

  // ===== 新增 ZIM 相关代码 =====
  final ZegoIMService _imService = ZegoIMService();

  // 连接状态
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // 是否正在加载历史消息
  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;

  ChatProvider() {
    _loadMockData();
    _initZIMListeners();
  }

  /// 初始化 ZIM 监听器（新增）
  void _initZIMListeners() {
    // 监听连接状态
    _imService.connectionStateStream.listen((state) {
      _isConnected = state == ZIMConnectionState.connected;
      notifyListeners();
    });

    // 监听新消息
    _imService.messageStream.listen((message) {
      _handleZIMMessage(message);
    });
  }

  /// 登录 IM（新增）
  Future<void> loginIM(String userID, String userName, String token) async {
    await _imService.login(userID, userName, token);
  }

  /// 处理 ZIM 新消息（新增）
  void _handleZIMMessage(ZIMMessage message) {
    if (message is ZIMTextMessage) {
      final chatMessage = ChatMessage(
        id: message.messageID.toString(),
        text: message.message,
        isMe: false,
        type: MessageContentType.text,
        time: DateTime.fromMillisecondsSinceEpoch(message.timestamp),
        status: MessageStatus.sent,
      );
      _messages.add(chatMessage);
      notifyListeners();
    }
  }

  /// 加载历史消息（新增）
  Future<void> loadHistoryMessages(String conversationID) async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      // TODO: 调用 ZIM API 加载历史消息
      await Future.delayed(Duration(seconds: 1)); // 模拟加载

      _isLoadingHistory = false;
      notifyListeners();
    } catch (e) {
      _isLoadingHistory = false;
      notifyListeners();
      throw Exception('加载历史消息失败: $e');
    }
  }

  void _loadMockData() {
    _messages = [
      ChatMessage(
        id: '1',
        text: 'Hi! I also like movies.',
        isMe: false,
        type: MessageContentType.text,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageStatus.sent,
      ),
      ChatMessage(
        id: '2',
        text: 'Hi! I also like movies.',
        isMe: true,
        type: MessageContentType.text,
        time: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MessageStatus.sent,
      ),
      ChatMessage(
        id: '3',
        text: 'Voice Call: Canceled',
        isMe: false,
        type: MessageContentType.voiceCall,
        time: DateTime.now().subtract(const Duration(minutes: 20)),
        status: MessageStatus.sent,
        callDuration: '0:00',
      ),
      ChatMessage(
        id: '4',
        text: 'Video Call: Canceled',
        isMe: false,
        type: MessageContentType.videoCall,
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        status: MessageStatus.sent,
        callDuration: '0:00',
      ),
      ChatMessage(
        id: '5',
        text: 'Voice Call: 2:34:56',
        isMe: true,
        type: MessageContentType.voiceCall,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        status: MessageStatus.sent,
        callDuration: '2:34:56',
      ),
      ChatMessage(
        id: '6',
        text: 'Video Call: 1:22:56',
        isMe: true,
        type: MessageContentType.videoCall,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        status: MessageStatus.sent,
        callDuration: '1:22:56',
      ),
    ];
    notifyListeners();
  }

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  /// 发送消息（扩展：集成 ZIM）
  Future<void> sendMessage(String conversationID) async {
    if (_inputText.trim().isEmpty) return;

    // 先添加到本地列表（乐观更新）- 保留现有逻辑
    final tempMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _inputText,
      isMe: true,
      type: MessageContentType.text,
      time: DateTime.now(),
      status: MessageStatus.sending,
    );
    _messages.add(tempMessage);
    _inputText = '';
    notifyListeners();

    try {
      // 发送到 ZIM 服务器（新增）
      await _imService.sendTextMessage(conversationID, tempMessage.text);

      // 更新状态为已发送
      final index = _messages.indexWhere((m) => m.id == tempMessage.id);
      if (index != -1) {
        _messages[index] =
            _messages[index].copyWith(status: MessageStatus.sent);
        notifyListeners();
      }
    } catch (e) {
      // 发送失败，更新状态
      final index = _messages.indexWhere((m) => m.id == tempMessage.id);
      if (index != -1) {
        _messages[index] =
            _messages[index].copyWith(status: MessageStatus.failed);
        notifyListeners();
      }
    }
  }

  void toggleGiftPanel() {
    _showGiftPanel = !_showGiftPanel;
    notifyListeners();
  }

  void hideGiftPanel() {
    _showGiftPanel = false;
    notifyListeners();
  }

  void setKeyboardVisible(bool visible) {
    _isKeyboardVisible = visible;
    if (visible) {
      _showGiftPanel = false;
    }
    notifyListeners();
  }

  void deleteMessage(String id) {
    final index = _messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(isDeleted: true);
      notifyListeners();
    }
  }

  /// 置顶消息
  void pinMessage(String id) {
    final index = _messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      _messages[index] =
          _messages[index].copyWith(isPinned: !_messages[index].isPinned);
      notifyListeners();
    }
  }

  /// 锁定消息
  void lockMessage(String id) {
    final index = _messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      _messages[index] =
          _messages[index].copyWith(isLocked: !_messages[index].isLocked);
      notifyListeners();
    }
  }

  Future<void> loadMoreMessages() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _loading = false;
    notifyListeners();
  }

  List<GiftItem> getGiftItems() {
    return List.generate(
      10,
      (index) => GiftItem(
        id: 'gift_$index',
        name: 'Plane',
        image: 'assets/images/gift_plane.png',
        price: 12,
      ),
    );
  }
}

// 扩展现有枚举
enum MessageContentType {
  text,
  voiceCall,
  videoCall,
  gift,
  system,
  image, // 新增：图片
  voice, // 新增：语音消息
  file, // 新增：文件
  location, // 新增：位置
}

enum MessageStatus {
  sending,
  sent,
  delivered, // 新增：已送达
  read, // 新增：已读
  failed, // 新增：发送失败
}

class ChatMessage {
  // ===== 现有字段保留（不变） =====
  String id;
  String text;
  bool isMe;
  MessageContentType type;
  DateTime time;
  MessageStatus status;
  String? callDuration;

  // ===== 新增字段 =====
  String? conversationId; // 会话ID
  String? senderId; // 发送者ID
  String? receiverId; // 接收者ID
  String? mediaUrl; // 媒体文件URL
  int? duration; // 语音/视频时长（秒）
  bool isPinned; // 是否置顶
  bool isDeleted; // 是否已删除
  bool isLocked; // 是否上锁
  String? replyToMessageId; // 回复的消息ID
  String? replyToContent; // 回复的消息内容
  List<String> reactions; // 表情反应列表
  bool isForwarded; // 是否转发
  String? forwardedFrom; // 转发来源

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.type,
    required this.time,
    this.status = MessageStatus.sending,
    this.callDuration,
    // 新增字段（可选）
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.mediaUrl,
    this.duration,
    this.isPinned = false,
    this.isDeleted = false,
    this.isLocked = false,
    this.replyToMessageId,
    this.replyToContent,
    this.reactions = const [],
    this.isForwarded = false,
    this.forwardedFrom,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isMe,
    MessageContentType? type,
    DateTime? time,
    MessageStatus? status,
    String? callDuration,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? mediaUrl,
    int? duration,
    bool? isPinned,
    bool? isDeleted,
    bool? isLocked,
    String? replyToMessageId,
    String? replyToContent,
    List<String>? reactions,
    bool? isForwarded,
    String? forwardedFrom,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      type: type ?? this.type,
      time: time ?? this.time,
      status: status ?? this.status,
      callDuration: callDuration ?? this.callDuration,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      duration: duration ?? this.duration,
      isPinned: isPinned ?? this.isPinned,
      isDeleted: isDeleted ?? this.isDeleted,
      isLocked: isLocked ?? this.isLocked,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyToContent: replyToContent ?? this.replyToContent,
      reactions: reactions ?? this.reactions,
      isForwarded: isForwarded ?? this.isForwarded,
      forwardedFrom: forwardedFrom ?? this.forwardedFrom,
    );
  }
}

class GiftItem {
  final String id;
  final String name;
  final String image;
  final int price;

  GiftItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });
}
