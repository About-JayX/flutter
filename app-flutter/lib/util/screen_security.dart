import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:mobisen_app/widget/custom_toast.dart';

/// 屏幕安全工具类 - 防止截屏并显示警告
class ScreenSecurity {
  static bool _isEnabled = false;

  /// 启用防截屏（Android: 阻止截屏 + 检测截屏事件）
  static Future<void> enable(BuildContext context) async {
    if (_isEnabled) return;

    try {
      // 阻止截屏和录屏
      await ScreenProtector.preventScreenshotOn();

      // 监听截屏事件（iOS支持，Android不支持检测，但阻止仍然有效）
      ScreenProtector.addListener(
        () {
          // 用户尝试截屏时显示警告
          if (context.mounted) {
            showScreenshotWarning(context);
          }
        },
        (isCaptured) {
          // 屏幕录制状态变化
          if (isCaptured && context.mounted) {
            showScreenshotWarning(context);
          }
        },
      );

      _isEnabled = true;
      print('🔒 Screen security enabled with screenshot detection');
    } catch (e) {
      print('🔴 Failed to enable screen security: $e');
    }
  }

  /// 禁用防截屏
  static Future<void> disable() async {
    if (!_isEnabled) return;

    try {
      // 移除截屏监听
      ScreenProtector.removeListener();

      // 允许截屏
      await ScreenProtector.preventScreenshotOff();

      _isEnabled = false;
      print('🔓 Screen security disabled');
    } catch (e) {
      print('🔴 Failed to disable screen security: $e');
    }
  }

  /// 显示截屏警告提示
  static void showScreenshotWarning(BuildContext context) {
    CustomToast.show(
      context,
      message: 'Screenshots are not allowed',
      icon: Icons.warning_amber_rounded,
      duration: 2500,
    );
  }

  static bool get isEnabled => _isEnabled;
}
