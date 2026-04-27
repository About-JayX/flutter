import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class CustomDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String description,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    bool showCancel = true,
    IconData? icon,
    Color? iconColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CustomDialogContent(
          title: title,
          description: description,
          onCancel: onCancel,
          onConfirm: onConfirm,
          cancelText: cancelText,
          confirmText: confirmText,
          showCancel: showCancel,
          icon: icon,
          iconColor: iconColor,
        );
      },
    );
  }

  static void showSingleButton(
    BuildContext context, {
    required String title,
    required String description,
    VoidCallback? onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? iconColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CustomDialogContent(
          title: title,
          description: description,
          onConfirm: onConfirm,
          confirmText: confirmText,
          cancelText: cancelText,
          showCancel: false,
          icon: icon,
          iconColor: iconColor,
        );
      },
    );
  }

  static void showWithWarning(
    BuildContext context, {
    required String title,
    required String description,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    String cancelText = 'Discard',
    String confirmText = 'Save',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CustomDialogContent(
          title: title,
          description: description,
          onCancel: onCancel,
          onConfirm: onConfirm,
          cancelText: cancelText,
          confirmText: confirmText,
          icon: Icons.warning_amber_rounded,
          iconColor: ThemeHelper.primaryColor,
        );
      },
    );
  }

  static void showVIPRequired(
    BuildContext context, {
    VoidCallback? onConfirm,
    String confirmText = 'Go Premium',
    String cancelText = 'Cancel',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CustomDialogContent(
          title: '',
          description:
              'Only VIP users can initiate video/voice calls.\nUpgrade to VIP to unlock calls and get 600 free minutes monthly.',
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: onConfirm,
          cancelText: cancelText,
          confirmText: confirmText,
          showCancel: true,
        );
      },
    );
  }

  static void showVIPExpired(
    BuildContext context, {
    VoidCallback? onConfirm,
    String confirmText = 'Go Premium',
    String cancelText = 'Cancel',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CustomDialogContent(
          title: '',
          description:
              'Your complimentary minutes have expired. VIP members may purchase chat packs to continue.',
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: onConfirm,
          cancelText: cancelText,
          confirmText: confirmText,
          showCancel: true,
        );
      },
    );
  }
}

class _CustomDialogContent extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String cancelText;
  final String confirmText;
  final bool showCancel;
  final IconData? icon;
  final Color? iconColor;

  const _CustomDialogContent({
    required this.title,
    required this.description,
    this.onCancel,
    this.onConfirm,
    required this.cancelText,
    required this.confirmText,
    this.showCancel = true,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 48,
                color: iconColor ?? ThemeHelper.primaryColor,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5A3D4A),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x00EB47B8),
                    ThemeHelper.primaryColor,
                    Color(0x00EB47B8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5A3D4A),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            if (showCancel)
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      text: cancelText,
                      isPrimary: false,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCancel?.call();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DialogButton(
                      text: confirmText,
                      isPrimary: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm?.call();
                      },
                    ),
                  ),
                ],
              )
            else
              _DialogButton(
                text: confirmText,
                isPrimary: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? ThemeHelper.primaryColor : const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? Colors.white : const Color(0xFF5A3D4A),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
