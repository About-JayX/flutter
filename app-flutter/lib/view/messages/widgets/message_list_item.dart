import 'package:flutter/material.dart';
import 'package:mobisen_app/provider/message_provider.dart';

class MessageListItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const MessageListItem({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: conversation.isPinned
              ? const Color(0xFFE8E8E8)
              : const Color(0xFFF5F5F5),
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFFE0E0E0),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.name,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage,
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.time,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                if (conversation.unreadCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D4F),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      conversation.unreadCount > 99
                          ? '99+'
                          : conversation.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFE0E0E0),
          ),
          child: conversation.isSystem
              ? const Icon(
                  Icons.settings,
                  color: Color(0xFF999999),
                  size: 24,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    conversation.avatar.isNotEmpty
                        ? conversation.avatar
                        : 'assets/images/default_avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        if (conversation.isLocked)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFF999999),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }
}
