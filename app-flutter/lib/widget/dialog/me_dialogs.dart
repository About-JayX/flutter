import 'package:flutter/material.dart';

/// 我的模块专用弹窗组件
class MeDialogs {
  /// 显示底部操作弹窗（更多操作：Report/Block/Cancel）
  static void showMoreActions(
    BuildContext context, {
    required List<MeActionItem> actions,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MoreActionsSheet(actions: actions),
    );
  }

  /// 显示照片/视频设置弹窗（付费版）
  static void showPhotoVideoSettingsPaid(
    BuildContext context, {
    required VoidCallback onConfirm,
    int initialCount = 5,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _PhotoVideoSettingsDialog(
        isPaid: true,
        initialCount: initialCount,
        onConfirm: onConfirm,
      ),
    );
  }

  /// 显示照片/视频设置弹窗（免费版）
  static void showPhotoVideoSettingsFree(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _PhotoVideoSettingsDialog(
        isPaid: false,
        onConfirm: onConfirm,
      ),
    );
  }

  /// 显示解锁私密模式弹窗（非VIP提示）
  static void showUnlockPrivateMode(
    BuildContext context, {
    required VoidCallback onGetVIP,
    VoidCallback? onContinue,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _UnlockPrivateModeDialog(
        onGetVIP: onGetVIP,
        onContinue: onContinue,
      ),
    );
  }
}

/// 底部操作项
class MeActionItem {
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const MeActionItem({
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}

/// 底部操作弹窗
class _MoreActionsSheet extends StatelessWidget {
  final List<MeActionItem> actions;

  const _MoreActionsSheet({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部指示条
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // 操作按钮列表
            ...actions.map((action) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: _ActionButton(
                    title: action.title,
                    isDestructive: action.isDestructive,
                    onTap: () {
                      Navigator.pop(context);
                      action.onTap();
                    },
                  ),
                )),
            // Cancel按钮
            Padding(
              padding: const EdgeInsets.all(16),
              child: _ActionButton(
                title: 'Cancel',
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 52,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDestructive
                  ? const Color(0xFFFF3B30)
                  : const Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}

/// 照片/视频设置弹窗
class _PhotoVideoSettingsDialog extends StatefulWidget {
  final bool isPaid;
  final int? initialCount;
  final VoidCallback onConfirm;

  const _PhotoVideoSettingsDialog({
    required this.isPaid,
    this.initialCount,
    required this.onConfirm,
  });

  @override
  State<_PhotoVideoSettingsDialog> createState() =>
      _PhotoVideoSettingsDialogState();
}

class _PhotoVideoSettingsDialogState extends State<_PhotoVideoSettingsDialog> {
  bool _isFree = true;
  int _count = 5;

  @override
  void initState() {
    super.initState();
    if (widget.initialCount != null) {
      _count = widget.initialCount!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Free选项
            _buildOption(
              title: 'Free',
              isSelected: _isFree,
              onTap: () => setState(() => _isFree = true),
            ),
            const SizedBox(height: 12),
            // Paid选项
            _buildOption(
              title: 'Paid',
              isSelected: !_isFree,
              onTap: () => setState(() => _isFree = false),
            ),
            // 数量选择器（仅付费版显示）
            if (widget.isPaid && !_isFree) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                        _count > 1 ? () => setState(() => _count--) : null,
                    icon: const Icon(Icons.remove, color: Color(0xFFEB8B8B)),
                  ),
                  Container(
                    width: 60,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_count',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _count++),
                    icon: const Icon(Icons.add, color: Color(0xFFEB8B8B)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            // Confirm按钮
            SizedBox(
              width: 140,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB8B8B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFEB8B8B)
                    : const Color(0xFFCCCCCC),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 14, color: Color(0xFFEB8B8B))
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isSelected
                  ? const Color(0xFF333333)
                  : const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

/// 解锁私密模式弹窗
class _UnlockPrivateModeDialog extends StatelessWidget {
  final VoidCallback onGetVIP;
  final VoidCallback? onContinue;

  const _UnlockPrivateModeDialog({
    required this.onGetVIP,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unlock Private Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5A3D4A),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x00EB8B8B),
                    Color(0xFFEB8B8B),
                    Color(0x00EB8B8B),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hide your online status, browse privately, and control who sees your profile with a VIP subscription.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5A3D4A),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            // Get VIP按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onGetVIP();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB8B8B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.workspace_premium, size: 20),
                label: const Text(
                  'Get VIP!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Continue with Premium按钮
            if (onContinue != null)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onContinue!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F2F2),
                    foregroundColor: const Color(0xFF5A3D4A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Continue with Premium',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
