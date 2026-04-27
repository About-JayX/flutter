import 'package:flutter/material.dart';
import 'custom_dialog_base.dart';

/// VIP限制弹窗
/// 非VIP用户滑动第7张卡片时弹出，提示升级VIP
class VIPLimitDialog extends StatelessWidget {
  final int currentSwipeCount;
  final int maxFreeSwipes;
  final VoidCallback? onUpgrade;
  final VoidCallback? onCancel;

  const VIPLimitDialog({
    super.key,
    this.currentSwipeCount = 6,
    this.maxFreeSwipes = 6,
    this.onUpgrade,
    this.onCancel,
  });

  static Future<void> show({
    required BuildContext context,
    int currentSwipeCount = 6,
    int maxFreeSwipes = 6,
    VoidCallback? onUpgrade,
  }) {
    return CustomDialogBase.show(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x99000000),
      builder: (context) => VIPLimitDialog(
        currentSwipeCount: currentSwipeCount,
        maxFreeSwipes: maxFreeSwipes,
        onUpgrade: onUpgrade,
        onCancel: () => Navigator.pop(context),
      ),
    );
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
                onTap: onCancel,
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

            // VIP图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.diamond,
                size: 40,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // 标题
            const Text(
              'Swipe Limit Reached',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 12),

            // 提示内容
            Text(
              'You\'ve used $currentSwipeCount of your $maxFreeSwipes free swipes today.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Upgrade to VIP for unlimited swipes and exclusive features!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // VIP特权列表
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildFeatureItem(
                    icon: Icons.all_inclusive,
                    text: 'Unlimited swipes',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    icon: Icons.favorite,
                    text: 'See who liked you',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    icon: Icons.chat_bubble,
                    text: 'Unlimited messages',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    icon: Icons.star,
                    text: 'Priority matching',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 升级按钮
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B9D).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(26),
                  onTap: () {
                    onCancel?.call();
                    onUpgrade?.call();
                  },
                  child: const Center(
                    child: Text(
                      'Upgrade to VIP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 稍后按钮
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Maybe Later',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFFFFA500),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
