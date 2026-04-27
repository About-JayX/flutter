import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobisen_app/services/zego_call_service.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallActiveView extends StatefulWidget {
  final String roomID;
  final String targetUserID;
  final String userID;
  final String targetUserName;

  const VideoCallActiveView({
    super.key,
    required this.roomID,
    required this.targetUserID,
    required this.userID,
    this.targetUserName = '',
  });

  @override
  State<VideoCallActiveView> createState() => _VideoCallActiveViewState();
}

class _VideoCallActiveViewState extends State<VideoCallActiveView> {
  bool _isCameraOn = true;
  bool _isMicOn = true;
  bool _isInitialized = false;
  int _callDurationSeconds = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDurationSeconds++;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      _initVideoCall();
    } else {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('需要权限'),
            content: const Text('视频通话需要相机和麦克风权限，请在设置中开启'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('去设置'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _initVideoCall() async {
    try {
      await ZegoCallService().startVideoCall(
        widget.roomID,
        widget.userID,
        widget.targetUserID,
      );
      setState(() {
        _isInitialized = true;
      });
      _startCallTimer();
    } catch (e) {
      print('视频通话初始化失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('视频通话初始化失败: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _toggleCamera() async {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });
    await ZegoCallService().enableCamera(_isCameraOn);
  }

  void _toggleMic() async {
    setState(() {
      _isMicOn = !_isMicOn;
    });
    await ZegoCallService().enableMicrophone(_isMicOn);
  }

  void _switchCamera() async {
    await ZegoCallService().switchCamera();
  }

  void _endCall() async {
    _callTimer?.cancel();
    await ZegoCallService().endVideoCall();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    ZegoCallService().endVideoCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // 远程视频（全屏）
            if (_isInitialized)
              Positioned.fill(
                child: ZegoCallService().getRemoteView() ??
                    Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'Waiting for user to join...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),

            // 顶部安全区
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 返回按钮 + 文字
                    GestureDetector(
                      onTap: _endCall,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '返回',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 通话时长
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _formatDuration(_callDurationSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // 挂断按钮（红色文字按钮）
                    GestureDetector(
                      onTap: _endCall,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '挂断',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 用户信息（顶部居中）- 显示在视频上方
            if (_isInitialized)
              Positioned(
                top: MediaQuery.of(context).padding.top + 80,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 用户头像
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/chat_other_avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 用户名称
                    Text(
                      widget.targetUserName.isNotEmpty
                          ? widget.targetUserName
                          : 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // 本地视频预览（小窗口，右下角，底部工具栏上方）
            if (_isInitialized)
              Positioned(
                bottom: 180,
                right: 16,
                width: 100,
                height: 140,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ZegoCallService().getLocalView() ??
                        Container(color: Colors.grey),
                  ),
                ),
              ),

            // 底部控制栏
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 控制按钮行：翻转摄像头 | 挂断 | 静音
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 翻转摄像头
                      GestureDetector(
                        onTap: _switchCamera,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      // 挂断按钮（红色圆形）
                      GestureDetector(
                        onTap: _endCall,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFF6B6B),
                          ),
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      // 静音按钮
                      GestureDetector(
                        onTap: _toggleMic,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isMicOn
                                ? Colors.black.withOpacity(0.5)
                                : Colors.red.withOpacity(0.5),
                          ),
                          child: Icon(
                            _isMicOn ? Icons.mic : Icons.mic_off,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
