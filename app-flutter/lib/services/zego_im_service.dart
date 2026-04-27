import 'dart:async';
import 'dart:convert';

import 'package:zego_zim/zego_zim.dart';
import 'package:mobisen_app/configs.dart';

/// 呼叫邀请数据模型
class CallInvite {
  final String type;
  final String roomID;
  final String callerID;
  final String callerName;
  final int timestamp;

  CallInvite({
    required this.type,
    required this.roomID,
    required this.callerID,
    required this.callerName,
    required this.timestamp,
  });

  factory CallInvite.fromJson(Map<String, dynamic> json) {
    return CallInvite(
      type: json['type'] as String,
      roomID: json['roomID'] as String,
      callerID: json['callerID'] as String,
      callerName: json['callerName'] as String,
      timestamp: json['timestamp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'roomID': roomID,
      'callerID': callerID,
      'callerName': callerName,
      'timestamp': timestamp,
    };
  }
}

/// 呼叫响应数据模型
class CallResponse {
  final String type;
  final String roomID;
  final String responderID;

  CallResponse({
    required this.type,
    required this.roomID,
    required this.responderID,
  });

  factory CallResponse.fromJson(Map<String, dynamic> json) {
    return CallResponse(
      type: json['type'] as String,
      roomID: json['roomID'] as String,
      responderID: json['responderID'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'roomID': roomID,
      'responderID': responderID,
    };
  }

  /// 判断是否是语音通话响应
  bool get isVoice => type.startsWith('voice_call_');

  /// 判断是否是视频通话响应
  bool get isVideo => type.startsWith('video_call_');

  /// 判断是否接受
  bool get isAccepted => type.endsWith('_accept');

  /// 判断是否拒绝
  bool get isRejected => type.endsWith('_reject');
}

class ZegoIMService {
  static final ZegoIMService _instance = ZegoIMService._internal();
  factory ZegoIMService() => _instance;
  ZegoIMService._internal();

  ZIM? _zim;
  bool _isInitialized = false;
  String? _currentUserID;

  // 连接状态监听
  final _connectionStateController =
      StreamController<ZIMConnectionState>.broadcast();
  Stream<ZIMConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  // 消息接收监听
  final _messageController = StreamController<ZIMMessage>.broadcast();
  Stream<ZIMMessage> get messageStream => _messageController.stream;

  // 呼叫邀请监听
  final _callInviteController = StreamController<CallInvite>.broadcast();
  Stream<CallInvite> get callInviteStream => _callInviteController.stream;

  // 呼叫响应监听
  final _callResponseController = StreamController<CallResponse>.broadcast();
  Stream<CallResponse> get callResponseStream => _callResponseController.stream;

  /// 初始化 ZIM SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 创建 ZIM 配置
      final config = ZIMAppConfig()
        ..appID = ZegoConfig.appID
        ..appSign = ZegoConfig.appSign;

      // 初始化 ZIM
      _zim = ZIM.create(config);

      // 注册事件监听
      _registerEventHandlers();

      _isInitialized = true;
      print('ZIM SDK 初始化成功');
    } catch (e) {
      print('ZIM SDK 初始化失败: $e');
      throw Exception('ZIM 初始化失败: $e');
    }
  }

  /// 注册事件处理器
  void _registerEventHandlers() {
    // 连接状态变化
    ZIMEventHandler.onConnectionStateChanged = (ZIM zim,
        ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData) {
      _connectionStateController.add(state);
      print('ZIM 连接状态变化: $state, 事件: $event');
    };

    // 收到点对点消息 - 使用新版 API
    ZIMEventHandler.onPeerMessageReceived = (ZIM zim,
        List<ZIMMessage> messageList,
        ZIMMessageReceivedInfo info,
        String fromUserID) {
      for (var message in messageList) {
        _messageController.add(message);
        _handleCallMessage(message);
      }
      print('收到来自 $fromUserID 的消息: ${messageList.length} 条');
    };
  }

  /// 处理呼叫相关消息
  void _handleCallMessage(ZIMMessage message) {
    if (message is ZIMTextMessage) {
      try {
        final data = jsonDecode(message.message);
        final type = data['type'] as String?;

        if (type == 'video_call_invite' || type == 'voice_call_invite') {
          final invite = CallInvite.fromJson(data);
          _callInviteController.add(invite);
          print('收到呼叫邀请: ${invite.callerID}, 类型: $type');
        } else if (type == 'video_call_accept' ||
            type == 'video_call_reject' ||
            type == 'voice_call_accept' ||
            type == 'voice_call_reject') {
          final response = CallResponse.fromJson(data);
          _callResponseController.add(response);
          print('收到呼叫响应: ${response.type}');
        }
      } catch (e) {
        print('解析呼叫消息失败: $e');
      }
    }
  }

  /// 登录 ZIM - 适配新版 API: login(userID, config)
  Future<void> login(String userID, String userName, String token) async {
    if (!_isInitialized) {
      throw Exception('ZIM 未初始化');
    }

    try {
      _currentUserID = userID;

      // 新版 API: login(userID, config) - token 在 config 中
      final loginConfig = ZIMLoginConfig()
        ..userName = userName
        ..token = token;

      await _zim?.login(userID, loginConfig);
      print('ZIM 登录成功: $userID');
    } catch (e) {
      print('ZIM 登录失败: $e');
      throw Exception('ZIM 登录失败: $e');
    }
  }

  /// 发送文本消息 - 适配新版 API
  Future<void> sendTextMessage(String conversationID, String content) async {
    if (!_isInitialized) return;

    try {
      final message = ZIMTextMessage(message: content);
      final config = ZIMMessageSendConfig();

      // 新版 API: sendMessage(message, toConversationID, conversationType, config)
      await _zim?.sendMessage(
        message,
        conversationID,
        ZIMConversationType.peer,
        config,
      );
      print('消息发送成功');
    } catch (e) {
      print('消息发送失败: $e');
      throw Exception('消息发送失败: $e');
    }
  }

  /// 发送视频呼叫邀请
  Future<void> sendVideoCallInvite(
    String targetUserID,
    String roomID, {
    String callerName = '',
  }) async {
    if (!_isInitialized) return;

    final invite = CallInvite(
      type: 'video_call_invite',
      roomID: roomID,
      callerID: _currentUserID ?? '',
      callerName: callerName.isNotEmpty ? callerName : (_currentUserID ?? ''),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await sendTextMessage(targetUserID, jsonEncode(invite.toJson()));
    print('发送视频呼叫邀请给: $targetUserID, 房间: $roomID');
  }

  /// 发送语音呼叫邀请
  Future<void> sendVoiceCallInvite(
    String targetUserID,
    String roomID, {
    String callerName = '',
  }) async {
    if (!_isInitialized) return;

    final invite = CallInvite(
      type: 'voice_call_invite',
      roomID: roomID,
      callerID: _currentUserID ?? '',
      callerName: callerName.isNotEmpty ? callerName : (_currentUserID ?? ''),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await sendTextMessage(targetUserID, jsonEncode(invite.toJson()));
    print('发送语音呼叫邀请给: $targetUserID, 房间: $roomID');
  }

  /// 发送呼叫响应（接受/拒绝）
  Future<void> sendCallResponse(
    String targetUserID,
    String roomID,
    bool accepted, {
    String callType = 'video',
  }) async {
    if (!_isInitialized) return;

    final prefix = callType == 'voice' ? 'voice_call_' : 'video_call_';
    final response = CallResponse(
      type: accepted ? '${prefix}accept' : '${prefix}reject',
      roomID: roomID,
      responderID: _currentUserID ?? '',
    );

    await sendTextMessage(targetUserID, jsonEncode(response.toJson()));
    print('发送呼叫响应: ${response.type}');
  }

  /// 登出
  Future<void> logout() async {
    await _zim?.logout();
    _currentUserID = null;
    print('ZIM 登出成功');
  }

  /// 销毁资源
  void dispose() {
    _zim?.destroy();
    _connectionStateController.close();
    _messageController.close();
    _callInviteController.close();
    _callResponseController.close();
    _isInitialized = false;
  }
}
