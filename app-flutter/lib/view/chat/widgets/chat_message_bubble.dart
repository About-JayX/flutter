import 'package:flutter/material.dart';
import 'package:mobisen_app/provider/chat_provider.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onLongPress;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              _buildAvatar(),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFF4A0A0) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildMessageContent(isMe),
              ),
            ),
            if (isMe) ...[
              const SizedBox(width: 8),
              _buildAvatar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFE0E0E0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          message.isMe
              ? 'assets/images/chat_me_avatar.jpg'
              : 'assets/images/chat_other_avatar.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMessageContent(bool isMe) {
    switch (message.type) {
      case MessageContentType.voiceCall:
      case MessageContentType.videoCall:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              message.type == MessageContentType.voiceCall
                  ? Icons.phone
                  : Icons.videocam,
              size: 20,
              color: isMe ? Colors.white : const Color(0xFF333333),
            ),
            const SizedBox(width: 8),
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF333333),
                fontSize: 14,
              ),
            ),
          ],
        );
      case MessageContentType.text:
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                message.text,
                style: TextStyle(
                  color: isMe ? Colors.white : const Color(0xFF333333),
                  fontSize: 14,
                ),
              ),
            ),
            if (message.status == MessageStatus.sending)
              const SizedBox(width: 4),
            if (message.status == MessageStatus.sending)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            if (message.status == MessageStatus.failed)
              const SizedBox(width: 4),
            if (message.status == MessageStatus.failed)
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 16,
              ),
          ],
        );
    }
  }
}
