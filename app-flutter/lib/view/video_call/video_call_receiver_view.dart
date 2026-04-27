import 'package:flutter/material.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/call_provider.dart';
import 'package:provider/provider.dart';

class VideoCallReceiverView extends StatefulWidget {
  final String roomID;
  final String callerID;
  final String callerName;

  const VideoCallReceiverView({
    super.key,
    required this.roomID,
    required this.callerID,
    required this.callerName,
  });

  @override
  State<VideoCallReceiverView> createState() => _VideoCallReceiverViewState();
}

class _VideoCallReceiverViewState extends State<VideoCallReceiverView> {
  void _acceptCall() async {
    final accountProvider = context.read<AccountProvider>();
    final userID = accountProvider.account?.user.username ?? '';

    // 发送接受响应（视频通话）
    await context
        .read<CallProvider>()
        .sendCallResponse(true, callType: 'video');

    // 进入视频通话页面
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.videoCallActive,
        arguments: {
          'roomID': widget.roomID,
          'targetUserID': widget.callerID,
          'userID': userID,
          'targetUserName': widget.callerName,
        },
      );
    }
  }

  void _rejectCall() async {
    // 发送拒绝响应（视频通话）
    await context
        .read<CallProvider>()
        .sendCallResponse(false, callType: 'video');

    // 关闭页面
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/video_call_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
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
                'Incoming Video Call...',
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
                  // End Call
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
                            Icons.videocam,
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
      ),
    );
  }
}
