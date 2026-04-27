import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/provider/call_provider.dart';
import 'package:mobisen_app/services/zego_call_service.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallActiveView extends StatefulWidget {
  final String roomID;
  final String userID;
  final String targetUserID;
  final String targetUserName;

  const VoiceCallActiveView({
    super.key,
    required this.roomID,
    required this.userID,
    required this.targetUserID,
    this.targetUserName = '',
  });

  @override
  State<VoiceCallActiveView> createState() => _VoiceCallActiveViewState();
}

class _VoiceCallActiveViewState extends State<VoiceCallActiveView> {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isInitialized = false;
  int _callDurationSeconds = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final micStatus = await Permission.microphone.request();

    if (micStatus.isGranted) {
      _initVoiceCall();
    } else {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('需要权限'),
            content: const Text('语音通话需要麦克风权限，请在设置中开启'),
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

  Future<void> _initVoiceCall() async {
    try {
      print('========== 语音通话初始化开始 ==========');

      // 1. 配置音频（关键！）
      print('1. 配置音频...');
      await ZegoExpressEngine.instance.muteMicrophone(false);
      print('✅ 麦克风已启用');

      await ZegoExpressEngine.instance.setAudioRouteToSpeaker(true);
      print('✅ 音频路由已设置为扬声器');

      await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
      print('✅ 音频采集设备已启用');

      // 2. 加入房间
      print('2. 加入房间...');
      await ZegoCallService().joinRoom(widget.roomID, widget.userID, '');
      print('✅ 加入房间成功: ${widget.roomID}');

      // 3. 设置流ID
      final localStreamID = 'stream_${widget.userID}';
      final remoteStreamID = 'stream_${widget.targetUserID}';

      // 4. 开始推流（只推音频）
      print('3. 开始推流...');
      await ZegoCallService().startPublishing(localStreamID);
      print('✅ 推流成功: $localStreamID');

      // 5. 开始拉流（只拉音频，不需要viewID）
      print('4. 开始拉流...');
      await ZegoExpressEngine.instance.startPlayingStream(remoteStreamID);
      print('✅ 拉流成功: $remoteStreamID');

      setState(() {
        _isInitialized = true;
      });

      _startCallTimer();

      print('========== 语音通话初始化完成 ==========');
    } catch (e) {
      print('❌ 语音通话初始化失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('语音通话初始化失败: $e')),
        );
      }
    }
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

  void _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    await ZegoExpressEngine.instance.muteMicrophone(_isMuted);
  }

  void _toggleSpeaker() async {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    await ZegoExpressEngine.instance.setAudioRouteToSpeaker(_isSpeakerOn);
  }

  void _endCall() async {
    _callTimer?.cancel();

    // 停止推流和拉流
    await ZegoCallService().stopPublishing();
    await ZegoExpressEngine.instance
        .stopPlayingStream('stream_${widget.targetUserID}');

    // 离开房间
    await ZegoCallService().leaveRoom();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Avatar
            Container(
              width: 120,
              height: 120,
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
            const SizedBox(height: 24),
            // Name
            Consumer<CallProvider>(
              builder: (context, provider, child) {
                return Text(
                  widget.targetUserName.isNotEmpty
                      ? widget.targetUserName
                      : (provider.callerName ?? 'Ollie'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Status
            if (!_isInitialized)
              const Text(
                'Connecting...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              )
            else
              const Text(
                'Voice Call',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            const Spacer(),
            // Timer
            Text(
              _formatDuration(_callDurationSeconds),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Spacer(),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mute button
                _buildControlButton(
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                  label: _isMuted ? 'Muted' : 'Mute',
                  onTap: _toggleMute,
                  isActive: _isMuted,
                ),
                // Speaker button
                _buildControlButton(
                  icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                  label: _isSpeakerOn ? 'Speaker' : 'Earpiece',
                  onTap: _toggleSpeaker,
                  isActive: !_isSpeakerOn,
                ),
              ],
            ),
            const SizedBox(height: 40),
            // End Call Button
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
            const SizedBox(height: 16),
            const Text(
              'End Call',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.white : Colors.white24,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
