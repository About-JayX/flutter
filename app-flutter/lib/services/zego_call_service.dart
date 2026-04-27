import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:mobisen_app/configs.dart';

class ZegoCallService {
  static final ZegoCallService _instance = ZegoCallService._internal();
  factory ZegoCallService() => _instance;
  ZegoCallService._internal();

  bool _isInitialized = false;
  String? _currentRoomID;
  String? _localUserID;

  // 通话状态监听
  final _callStateController = StreamController<CallState>.broadcast();
  Stream<CallState> get callStateStream => _callStateController.stream;

  // 视频视图
  Widget? _localView;
  Widget? _remoteView;
  int? _localViewID;
  int? _remoteViewID;

  // 流ID
  String? _localStreamID;
  String? _remoteStreamID;

  /// 初始化 Express SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 创建引擎配置
      final profile = ZegoEngineProfile(
        ZegoConfig.appID,
        ZegoScenario.Default,
        appSign: ZegoConfig.appSign,
      );

      // 初始化引擎
      await ZegoExpressEngine.createEngineWithProfile(profile);

      // 注册回调
      _registerCallbacks();

      _isInitialized = true;
      print('Zego Express SDK 初始化成功');
    } catch (e) {
      print('Zego Express SDK 初始化失败: $e');
      throw Exception('Express 初始化失败: $e');
    }
  }

  /// 注册引擎回调
  void _registerCallbacks() {
    // 房间状态更新
    ZegoExpressEngine.onRoomStateUpdate = (String roomID, ZegoRoomState state,
        int errorCode, Map<String, dynamic> extendedData) {
      print('房间状态更新: $roomID, 状态: $state, 错误码: $errorCode');
      if (state == ZegoRoomState.Connected) {
        _callStateController.add(CallState.connected);
      } else if (state == ZegoRoomState.Disconnected) {
        _callStateController.add(CallState.disconnected);
      }
    };

    // 用户加入房间
    ZegoExpressEngine.onRoomUserUpdate =
        (String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
      print('房间用户更新: $roomID, 类型: $updateType, 用户: ${userList.length}');
      if (updateType == ZegoUpdateType.Add) {
        _callStateController.add(CallState.userJoined);
      } else {
        _callStateController.add(CallState.userLeft);
      }
    };
  }

  /// 创建本地视频视图
  Future<void> createLocalView() async {
    _localView = await ZegoExpressEngine.instance.createCanvasView((viewID) {
      _localViewID = viewID;
      print('本地视频视图创建成功: $viewID');
    });
  }

  /// 创建远程视频视图
  Future<void> createRemoteView() async {
    _remoteView = await ZegoExpressEngine.instance.createCanvasView((viewID) {
      _remoteViewID = viewID;
      print('远程视频视图创建成功: $viewID');
    });
  }

  /// 获取本地视频 Widget
  Widget? getLocalView() => _localView;

  /// 获取远程视频 Widget
  Widget? getRemoteView() => _remoteView;

  /// 销毁视频视图
  Future<void> destroyViews() async {
    if (_localViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(_localViewID!);
      _localViewID = null;
      _localView = null;
    }
    if (_remoteViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(_remoteViewID!);
      _remoteViewID = null;
      _remoteView = null;
    }
  }

  /// 加入房间（发起或接听通话）
  Future<void> joinRoom(String roomID, String userID, String token) async {
    if (!_isInitialized) {
      throw Exception('Express SDK 未初始化');
    }

    try {
      _currentRoomID = roomID;
      _localUserID = userID;

      final user = ZegoUser(userID, userID);

      await ZegoExpressEngine.instance.loginRoom(roomID, user);
      print('加入房间成功: $roomID');
    } catch (e) {
      print('加入房间失败: $e');
      throw Exception('加入房间失败: $e');
    }
  }

  /// 开始预览本地视频
  Future<void> startPreview(int viewID) async {
    final canvas = ZegoCanvas(viewID);
    await ZegoExpressEngine.instance.startPreview(canvas: canvas);
  }

  /// 开始推流（发送音视频）
  Future<void> startPublishing(String streamID) async {
    await ZegoExpressEngine.instance.startPublishingStream(streamID);
    print('开始推流: $streamID');
  }

  /// 开始拉流（接收对方音视频）
  Future<void> startPlaying(String streamID, int viewID) async {
    final canvas = ZegoCanvas(viewID);
    await ZegoExpressEngine.instance
        .startPlayingStream(streamID, canvas: canvas);
    print('开始拉流: $streamID');
  }

  /// 停止推流
  Future<void> stopPublishing() async {
    await ZegoExpressEngine.instance.stopPublishingStream();
  }

  /// 停止拉流
  Future<void> stopPlaying(String streamID) async {
    await ZegoExpressEngine.instance.stopPlayingStream(streamID);
  }

  /// 离开房间
  Future<void> leaveRoom() async {
    if (_currentRoomID != null) {
      await ZegoExpressEngine.instance.logoutRoom(_currentRoomID!);
      _currentRoomID = null;
      print('离开房间成功');
    }
  }

  /// 开始视频通话（完整流程）
  Future<void> startVideoCall(
    String roomID,
    String userID,
    String targetUserID,
  ) async {
    // 1. 创建视频视图
    await createLocalView();
    await createRemoteView();

    // 2. 开始预览本地视频
    if (_localViewID != null) {
      await startPreview(_localViewID!);
    }

    // 3. 配置音频（关键！）
    print('========== 音频配置开始 ==========');

    // 3.1 取消麦克风静音
    await ZegoExpressEngine.instance.muteMicrophone(false);
    print('✅ 麦克风已启用（取消静音）');

    // 3.2 设置音频输出为扬声器
    await ZegoExpressEngine.instance.setAudioRouteToSpeaker(true);
    print('✅ 音频路由已设置为扬声器');

    // 3.3 检查音频状态
    final isMuted = await ZegoExpressEngine.instance.isMicrophoneMuted();
    print('📊 麦克风当前状态: ${isMuted ? "静音" : "正常"}');

    // 3.4 启用音频采集
    await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
    print('✅ 音频采集设备已启用');

    print('========== 音频配置完成 ==========');

    // 4. 加入房间
    await joinRoom(roomID, userID, '');

    // 5. 设置流ID
    _localStreamID = 'stream_$userID';
    _remoteStreamID = 'stream_$targetUserID';

    // 6. 开始推流
    await startPublishing(_localStreamID!);

    // 7. 开始拉流
    if (_remoteViewID != null) {
      await startPlaying(_remoteStreamID!, _remoteViewID!);
    }
  }

  /// 结束视频通话
  Future<void> endVideoCall() async {
    // 1. 停止推流
    await stopPublishing();

    // 2. 停止拉流
    if (_remoteStreamID != null) {
      await stopPlaying(_remoteStreamID!);
    }

    // 3. 离开房间
    await leaveRoom();

    // 4. 销毁视频视图
    await destroyViews();

    _localStreamID = null;
    _remoteStreamID = null;
  }

  /// 切换摄像头
  Future<void> switchCamera() async {
    await ZegoExpressEngine.instance.useFrontCamera(true);
  }

  /// 开启/关闭摄像头
  Future<void> enableCamera(bool enable) async {
    await ZegoExpressEngine.instance.enableCamera(enable);
  }

  /// 开启/关闭麦克风
  Future<void> enableMicrophone(bool enable) async {
    await ZegoExpressEngine.instance.muteMicrophone(!enable);
  }

  /// 销毁引擎
  Future<void> destroy() async {
    await destroyViews();
    await ZegoExpressEngine.destroyEngine();
    _callStateController.close();
    _isInitialized = false;
  }
}

enum CallState {
  idle,
  connecting,
  connected,
  disconnected,
  userJoined,
  userLeft,
}
