import 'package:flutter/material.dart';

class PostMoreSheet extends StatelessWidget {
  final VoidCallback onNotInterested;
  final VoidCallback onReport;

  const PostMoreSheet({
    super.key,
    required this.onNotInterested,
    required this.onReport,
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
            const SizedBox(height: 8),
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Not Interested
            _buildActionButton(
              text: 'Not Interested',
              onTap: () {
                Navigator.pop(context);
                onNotInterested();
              },
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            // Report
            _buildActionButton(
              text: 'Report',
              onTap: () {
                Navigator.pop(context);
                onReport();
              },
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            // Cancel
            _buildActionButton(
              text: 'Cancel',
              onTap: () => Navigator.pop(context),
              isCancel: true,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onTap,
    bool isCancel = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isCancel ? FontWeight.w600 : FontWeight.normal,
            color: isCancel ? const Color(0xFF333333) : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }
}
