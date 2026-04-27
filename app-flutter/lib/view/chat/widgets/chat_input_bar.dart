import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final VoidCallback onSend;
  final Function(String) onTextChanged;
  final String inputText;
  final VoidCallback onGiftTap;
  final VoidCallback onVoiceTap;
  final VoidCallback onVideoTap;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.onTextChanged,
    required this.inputText,
    required this.onGiftTap,
    required this.onVoiceTap,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = inputText.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: TextField(
                    onChanged: onTextChanged,
                    decoration: const InputDecoration(
                      hintText: 'Say something...',
                      hintStyle: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14,
                    ),
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: hasText ? onSend : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: hasText
                        ? const Color(0xFFF4A0A0)
                        : const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: hasText ? Colors.white : const Color(0xFF999999),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.card_giftcard,
                label: 'Virtual Gifts',
                onTap: onGiftTap,
              ),
              _buildActionButton(
                icon: Icons.phone,
                label: 'Voice Chat',
                onTap: onVoiceTap,
              ),
              _buildActionButton(
                icon: Icons.videocam,
                label: 'Video Chat',
                onTap: onVideoTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFFF4A0A0),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF4A0A0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
