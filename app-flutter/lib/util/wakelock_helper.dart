import 'dart:math';

import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockHelper {
  static int _wakeCount = 0;

  static void enable() {
    _wakeCount++;
    if (_wakeCount == 1) {
      try {
        WakelockPlus.enable();
      } catch (e) {}
    }
  }

  static void disable() {
    _wakeCount = max(0, _wakeCount - 1);
    if (_wakeCount == 0) {
      try {
        WakelockPlus.disable();
      } catch (e) {}
    }
  }
}
