import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';

/// VIP 功能锁定提示组件
class VIPFeatureLock extends StatelessWidget {
  final String featureName;
  final VoidCallback? onUpgrade;

  const VIPFeatureLock({
    super.key,
    required this.featureName,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 锁定图标
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock,
                size: 32,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            // 标题
            Text(
              '$featureName is a VIP Feature',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // 描述
            Text(
              'Upgrade to VIP to unlock this feature and more!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // 升级按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUpgrade ??
                    () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/vip_subscription');
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeHelper.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade to VIP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 稍后按钮
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Later',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// VIP 徽章组件
class VIPBadge extends StatelessWidget {
  final double size;

  const VIPBadge({
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.375,
        vertical: size * 0.125,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ThemeHelper.primaryColor, Color(0xFFFF1493)],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.diamond,
            size: size * 0.8,
            color: Colors.white,
          ),
          SizedBox(width: size * 0.125),
          Text(
            'VIP',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// VIP 过期提醒弹窗
class VIPExpireDialog extends StatelessWidget {
  final int remainingDays;
  final VoidCallback? onRenew;

  const VIPExpireDialog({
    super.key,
    required this.remainingDays,
    this.onRenew,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.access_time, color: Colors.orange[600]),
          const SizedBox(width: 8),
          const Text('VIP Expiring Soon'),
        ],
      ),
      content: Text(
        'Your VIP membership will expire in $remainingDays days. Renew now to keep your privileges!',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Later'),
        ),
        ElevatedButton(
          onPressed: onRenew ??
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/vip_subscription');
              },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeHelper.primaryColor,
          ),
          child: const Text('Renew'),
        ),
      ],
    );
  }
}
