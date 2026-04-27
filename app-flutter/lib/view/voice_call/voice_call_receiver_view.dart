import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/call_provider.dart';

class VoiceCallReceiverView extends StatefulWidget {
  final String roomID;
  final String callerID;
  final String callerName;

  const VoiceCallReceiverView({
    super.key,
    required this.roomID,
    required this.callerID,
    required this.callerName,
  });

  @override
  State<VoiceCallReceiverView> createState() => _VoiceCallReceiverViewState();
}

class _VoiceCallReceiverViewState extends State<VoiceCallReceiverView> {
  void _acceptCall() async {
    final accountProvider = context.read<AccountProvider>();
    final userID = accountProvider.account?.user.username ?? '';

    // 发送接受响应（语音通话）
    await context
        .read<CallProvider>()
        .sendCallResponse(true, callType: 'voice');

    // 进入语音通话页面
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.voiceCallActive,
        arguments: {
          'roomID': widget.roomID,
          'userID': userID,
          'targetUserID': widget.callerID,
          'targetUserName': widget.callerName,
        },
      );
    }
  }

  void _rejectCall() async {
    // 发送拒绝响应（语音通话）
    await context
        .read<CallProvider>()
        .sendCallResponse(false, callType: 'voice');

    // 关闭页面
    if (mounted) {
      Navigator.pop(context);
    }
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
              widget.callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Status
            const Text(
              'Incoming Voice Call...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Decline
                Column(
                  children: [
                    GestureDetector(
                      onTap: _rejectCall,
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
                    const SizedBox(height: 8),
                    const Text(
                      'Decline',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                // Accept
                Column(
                  children: [
                    GestureDetector(
                      onTap: _acceptCall,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF52C41A),
                        ),
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
