import 'dart:io';

import 'package:intl/intl.dart';

class TextUtils {
  static dynamic parseString(String input) {
    try {
      return int.parse(input);
    } catch (e) {
      // TODO
    }

    if (input.toLowerCase() == 'true') {
      return true;
    } else if (input.toLowerCase() == 'false') {
      return false;
    }

    return null;
  }

  static isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  static String formatNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}m';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }

  static String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

  static String camelToSnake(String input) {
    return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match match) {
      return '${match.group(1)}_${match.group(2)}';
    }).toLowerCase();
  }

  static String snakeToCamel(String input) {
    return input.replaceAllMapped(RegExp(r'_([a-z])'), (Match match) {
      return match.group(1)!.toUpperCase();
    });
  }

  static String getPlatform() {
    if (Platform.isAndroid) {
      return "android";
    }
    if (Platform.isFuchsia) {
      return "fuchsia";
    }
    if (Platform.isIOS) {
      return "ios";
    }
    if (Platform.isLinux) {
      return "linux";
    }
    if (Platform.isMacOS) {
      return "macos";
    }
    if (Platform.isWindows) {
      return "windows";
    }
    return "other";
  }
}
