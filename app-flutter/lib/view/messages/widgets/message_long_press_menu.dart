import 'package:flutter/material.dart';

class MessageLongPressMenu extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onPin;
  final VoidCallback onLock;
  final VoidCallback onCancel;

  const MessageLongPressMenu({
    super.key,
    required this.onDelete,
    required this.onPin,
    required this.onLock,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _buildMenuItem(
              text: 'Delete Chat Only',
              onTap: onDelete,
              textColor: const Color(0xFFFF4D4F),
            ),
            _buildDivider(),
            _buildMenuItem(
              text: 'Pin Chat',
              onTap: onPin,
            ),
            _buildDivider(),
            _buildMenuItem(
              text: 'Lock Chat',
              onTap: onLock,
            ),
            _buildDivider(),
            _buildMenuItem(
              text: 'Cancel',
              onTap: onCancel,
              textColor: const Color(0xFF999999),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required VoidCallback onTap,
    Color textColor = const Color(0xFF333333),
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Color(0xFFE0E0E0),
      indent: 16,
      endIndent: 16,
    );
  }
}
