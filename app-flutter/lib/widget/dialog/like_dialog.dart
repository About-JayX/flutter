import 'package:flutter/material.dart';
import 'custom_dialog_base.dart';

/// 喜欢弹窗
/// 左滑卡片后弹出，支持快捷消息选择和自定义输入（最多两行）
class LikeDialog extends StatefulWidget {
  final String userName;
  final String? avatarUrl;
  final List<String> quickMessages;
  final Function(String message)? onSend;
  final VoidCallback? onCancel;

  const LikeDialog({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.quickMessages = const [
      'Hi! 👋',
      'Hello! Nice to meet you',
      'You look great!',
      'Want to chat?',
    ],
    this.onSend,
    this.onCancel,
  });

  static Future<void> show({
    required BuildContext context,
    required String userName,
    String? avatarUrl,
    List<String>? quickMessages,
    Function(String message)? onSend,
  }) {
    return CustomDialogBase.show(
      context: context,
      barrierDismissible: true,
      builder: (context) => LikeDialog(
        userName: userName,
        avatarUrl: avatarUrl,
        quickMessages: quickMessages ??
            const [
              'Hi! 👋',
              'Hello! Nice to meet you',
              'You look great!',
              'Want to chat?',
            ],
        onSend: onSend,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  State<LikeDialog> createState() => _LikeDialogState();
}

class _LikeDialogState extends State<LikeDialog> {
  final TextEditingController _messageController = TextEditingController();
  String? _selectedQuickMessage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onQuickMessageSelected(String message) {
    setState(() {
      _selectedQuickMessage = message;
      _messageController.text = message;
    });
  }

  void _onSend() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSend?.call(message);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialogBase(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 关闭按钮
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: widget.onCancel,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 用户头像
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF6B9D),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: widget.avatarUrl != null
                    ? Image.network(
                        widget.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),

            const SizedBox(height: 16),

            // 标题
            Text(
              'Like ${widget.userName}!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Send a message to start chatting',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            // 快捷消息
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: widget.quickMessages.map((message) {
                final isSelected = _selectedQuickMessage == message;
                return GestureDetector(
                  onTap: () => _onQuickMessageSelected(message),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFF6B9D)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isSelected ? Colors.white : const Color(0xFF666666),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 自定义输入框
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 2,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _onSend(),
                decoration: InputDecoration(
                  hintText: 'Or write your own message...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFFFF6B9D),
                    ),
                    onPressed: _onSend,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 发送按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B9D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}
