import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/call_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/chat_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/view/chat/widgets/chat_message_bubble.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/view/chat/widgets/chat_input_bar.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/view/chat/widgets/chat_gift_panel.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/view/chat/widgets/chat_more_menu.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/widget/vip/vip_feature_lock.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'Ollie',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            // 语音通话按钮
            Consumer<AccountProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: provider.canInitiateVoiceCalls
                        ? const Color(0xFF333333)
                        : Colors.grey,
                  ),
                  onPressed: () => _onVoiceTap(context, provider),
                );
              },
            ),
            // 视频通话按钮
            Consumer<AccountProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: Icon(
                    Icons.videocam,
                    color: provider.canInitiateVideoCalls
                        ? const Color(0xFF333333)
                        : Colors.grey,
                  ),
                  onPressed: () => _onVideoTap(context, provider),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Color(0xFF333333)),
              onPressed: () => _showMoreMenu(context),
            ),
          ],
        ),
        body: Consumer<ChatProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // Interest tag
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, size: 16, color: Color(0xFF999999)),
                      SizedBox(width: 4),
                      Text(
                        'Want to try a new restaurant #',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Messages list
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider
                          .messages[provider.messages.length - 1 - index];
                      return ChatMessageBubble(
                        message: message,
                        onLongPress: () =>
                            _onMessageLongPress(context, message, provider),
                      );
                    },
                  ),
                ),
                // 3 days notice
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Only messages from last 3 days shown',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12,
                    ),
                  ),
                ),
                // Input bar
                ChatInputBar(
                  onSend: () {
                    provider.sendMessage('conversation_id');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  },
                  onTextChanged: provider.setInputText,
                  inputText: provider.inputText,
                  onGiftTap: provider.toggleGiftPanel,
                  onVoiceTap: () {
                    final accountProvider = context.read<AccountProvider>();
                    _onVoiceTap(context, accountProvider);
                  },
                  onVideoTap: () {
                    final accountProvider = context.read<AccountProvider>();
                    _onVideoTap(context, accountProvider);
                  },
                ),
                // Gift panel
                if (provider.showGiftPanel)
                  ChatGiftPanel(
                    gifts: provider.getGiftItems(),
                    onGiftSelected: (gift) {
                      provider.hideGiftPanel();
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ChatMoreMenu(
        onReport: () {
          Navigator.pop(context);
        },
        onBlock: () {
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _onMessageLongPress(
      BuildContext context, ChatMessage message, ChatProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (!message.isDeleted) ...[
                ListTile(
                  leading: const Icon(Icons.copy, color: Color(0xFF333333)),
                  title: const Text('Copy'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    message.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                    color: const Color(0xFF333333),
                  ),
                  title: Text(message.isPinned ? 'Unpin' : 'Pin'),
                  onTap: () {
                    provider.pinMessage(message.id);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    message.isLocked ? Icons.lock_open : Icons.lock,
                    color: const Color(0xFF333333),
                  ),
                  title: Text(message.isLocked ? 'Unlock' : 'Lock'),
                  onTap: () {
                    provider.lockMessage(message.id);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Color(0xFFFF4D4F)),
                  title: const Text('Delete',
                      style: TextStyle(color: Color(0xFFFF4D4F))),
                  onTap: () {
                    provider.deleteMessage(message.id);
                    Navigator.pop(context);
                  },
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _onVoiceTap(BuildContext context, AccountProvider accountProvider) {
    // 检查 VIP 和时长
    if (!accountProvider.isVIP) {
      _showVIPRequiredDialog(context, 'Voice Calls');
      return;
    }

    if (!accountProvider.hasVoiceMinutes) {
      _showNoMinutesDialog(context, 'voice');
      return;
    }

    _startVoiceCall(context, accountProvider);
  }

  Future<void> _startVoiceCall(
      BuildContext context, AccountProvider accountProvider) async {
    final currentUserID = accountProvider.account?.user.username ?? '';

    // 根据当前用户ID确定对方ID（固定ID配对）
    final targetUserID =
        currentUserID == 'xiaomi12345' ? 'others12345' : 'xiaomi12345';

    print('语音通话 - 当前用户: $currentUserID, 目标用户: $targetUserID');

    // 生成房间ID
    final ids = [currentUserID, targetUserID]..sort();
    final roomID = 'voice_room_${ids.join('_')}';

    // 发送语音呼叫邀请
    await context.read<CallProvider>().sendVoiceCallInvite(
          targetUserID,
          roomID,
          callerName:
              accountProvider.account?.user.displayName ?? currentUserID,
        );

    // 跳转到语音拨号中页面
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        RoutePaths.voiceCallCaller,
        arguments: {
          'roomID': roomID,
          'targetUserID': targetUserID,
          'targetUserName': targetUserID == 'xiaomi12345' ? 'Xiaomi' : 'Others',
        },
      );
    }
  }

  void _onVideoTap(BuildContext context, AccountProvider accountProvider) {
    // 检查 VIP 和时长
    if (!accountProvider.isVIP) {
      _showVIPRequiredDialog(context, 'Video Calls');
      return;
    }

    if (!accountProvider.hasVideoMinutes) {
      _showNoMinutesDialog(context, 'video');
      return;
    }

    _startVideoCall(context, accountProvider);
  }

  Future<void> _startVideoCall(
      BuildContext context, AccountProvider accountProvider) async {
    final currentUserID = accountProvider.account?.user.username ?? '';

    // 根据当前用户ID确定对方ID（固定ID配对）
    final targetUserID =
        currentUserID == 'xiaomi12345' ? 'others12345' : 'xiaomi12345';

    print('当前用户: $currentUserID, 目标用户: $targetUserID');

    // 生成房间ID
    final ids = [currentUserID, targetUserID]..sort();
    final roomID = 'room_${ids.join('_')}';

    // 发送呼叫邀请
    await context.read<CallProvider>().sendVideoCallInvite(
          targetUserID,
          roomID,
          callerName:
              accountProvider.account?.user.displayName ?? currentUserID,
        );

    // 跳转到拨号中页面
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        RoutePaths.videoCallCaller,
        arguments: {
          'roomID': roomID,
          'targetUserID': targetUserID,
          'targetUserName': targetUserID == 'xiaomi12345' ? 'Xiaomi' : 'Others',
        },
      );
    }
  }

  void _showVIPRequiredDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => VIPFeatureLock(
        featureName: featureName,
        onUpgrade: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, RoutePaths.vipSubscription);
        },
      ),
    );
  }

  void _showNoMinutesDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No $type minutes left'),
        content: Text(
          'You have used all your monthly $type minutes. Upgrade to get more!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RoutePaths.vipSubscription);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeHelper.primaryColor,
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

enum CallType { voice, video }
