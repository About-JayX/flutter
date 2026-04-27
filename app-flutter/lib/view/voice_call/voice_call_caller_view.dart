import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/call_provider.dart';
import 'package:mobisen_app/services/zego_im_service.dart';

class VoiceCallCallerView extends StatefulWidget {
  final String roomID;
  final String targetUserID;
  final String targetUserName;

  const VoiceCallCallerView({
    super.key,
    required this.roomID,
    required this.targetUserID,
    this.targetUserName = '',
  });

  @override
  State<VoiceCallCallerView> createState() => _VoiceCallCallerViewState();
}

class _VoiceCallCallerViewState extends State<VoiceCallCallerView> {
  Timer? _timeoutTimer;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    _startTimeoutTimer();
    _listenForResponse();
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (mounted && !_isCancelled) {
        _showTimeoutDialog();
      }
    });
  }

  void _listenForResponse() {
    ZegoIMService().callResponseStream.listen((response) {
      if (!mounted || _isCancelled) return;

      if (response.roomID == widget.roomID) {
        _timeoutTimer?.cancel();

        if (response.type == 'voice_call_accept') {
          // 对方接受，进入通话页面
          _enterVoiceCall();
        } else if (response.type == 'voice_call_reject') {
          // 对方拒绝
          _showRejectedDialog();
        }
      }
    });
  }

  void _enterVoiceCall() {
    final accountProvider = context.read<AccountProvider>();
    final currentUserID = accountProvider.account?.user.username ?? '';

    Navigator.pushReplacementNamed(
      context,
      RoutePaths.voiceCallActive,
      arguments: {
        'roomID': widget.roomID,
        'userID': currentUserID,
        'targetUserID': widget.targetUserID,
        'targetUserName': widget.targetUserName,
      },
    );
  }

  void _showRejectedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('呼叫被拒绝'),
        content: const Text('对方拒绝了您的语音通话请求'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('无人接听'),
        content: const Text('对方未响应您的语音通话请求'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _cancelCall() {
    _isCancelled = true;
    _timeoutTimer?.cancel();
    context.read<CallProvider>().endCall();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
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
            Text(
              widget.targetUserName.isNotEmpty
                  ? widget.targetUserName
                  : 'Ollie',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Status
            const Text(
              'Ringing...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            // End Call Button
            GestureDetector(
              onTap: _cancelCall,
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
}
