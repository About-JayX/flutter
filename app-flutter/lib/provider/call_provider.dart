import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobisen_app/services/zego_im_service.dart';
import 'package:mobisen_app/services/zego_call_service.dart';

enum CallStatus {
  idle,
  calling, // 正在呼叫
  ringing, // 正在响铃
  connecting, // 正在连接
  connected, // 已连接（通话中）
  ended, // 已结束
  rejected, // 被拒绝
  timeout, // 超时
}

class CallProvider extends ChangeNotifier {
  static final CallProvider _instance = CallProvider._internal();
  factory CallProvider() => _instance;
  CallProvider._internal();

  CallStatus _status = CallStatus.idle;
  String? _currentRoomID;
  String? _targetUserID;
  String? _callerName;
  String? _callerID;

  // 通话状态
  CallStatus get status => _status;
  String? get currentRoomID => _currentRoomID;
  String? get targetUserID => _targetUserID;
  String? get callerName => _callerName;
  String? get callerID => _callerID;

  // 通话状态监听
  final _statusController = StreamController<CallStatus>.broadcast();
  Stream<CallStatus> get statusStream => _statusController.stream;

  /// 发起呼叫
  void startCalling(String roomID, String targetUserID) {
    _status = CallStatus.calling;
    _currentRoomID = roomID;
    _targetUserID = targetUserID;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 收到呼叫（响铃）
  void startRinging(String roomID, String callerID, String callerName) {
    _status = CallStatus.ringing;
    _currentRoomID = roomID;
    _callerID = callerID;
    _callerName = callerName;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 接受呼叫
  void acceptCall() {
    _status = CallStatus.connecting;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 连接成功（进入通话）
  void connected() {
    _status = CallStatus.connected;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 结束通话
  void endCall() {
    _status = CallStatus.ended;
    _currentRoomID = null;
    _targetUserID = null;
    _callerName = null;
    _callerID = null;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 被拒绝
  void rejected() {
    _status = CallStatus.rejected;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 超时
  void timeout() {
    _status = CallStatus.timeout;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 重置状态
  void reset() {
    _status = CallStatus.idle;
    _currentRoomID = null;
    _targetUserID = null;
    _callerName = null;
    _callerID = null;
    notifyListeners();
    _statusController.add(_status);
  }

  /// 发送视频呼叫邀请
  Future<void> sendVideoCallInvite(
    String targetUserID,
    String roomID, {
    String callerName = '',
  }) async {
    await ZegoIMService().sendVideoCallInvite(
      targetUserID,
      roomID,
      callerName: callerName,
    );
    startCalling(roomID, targetUserID);
  }

  /// 发送语音呼叫邀请
  Future<void> sendVoiceCallInvite(
    String targetUserID,
    String roomID, {
    String callerName = '',
  }) async {
    await ZegoIMService().sendVoiceCallInvite(
      targetUserID,
      roomID,
      callerName: callerName,
    );
    startCalling(roomID, targetUserID);
  }

  /// 发送呼叫响应（接受/拒绝）
  Future<void> sendCallResponse(bool accepted,
      {String callType = 'video'}) async {
    if (_callerID != null && _currentRoomID != null) {
      await ZegoIMService().sendCallResponse(
        _callerID!,
        _currentRoomID!,
        accepted,
        callType: callType,
      );
      if (accepted) {
        acceptCall();
      } else {
        endCall();
      }
    }
  }

  /// 开始视频通话（进入房间）
  Future<void> startVideoCall(String userID, String targetUserID) async {
    if (_currentRoomID != null) {
      await ZegoCallService().startVideoCall(
        _currentRoomID!,
        userID,
        targetUserID,
      );
      connected();
    }
  }

  /// 结束视频通话
  Future<void> endVideoCall() async {
    await ZegoCallService().endVideoCall();
    endCall();
  }

  @override
  void dispose() {
    _statusController.close();
    super.dispose();
  }
}
