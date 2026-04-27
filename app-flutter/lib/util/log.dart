import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

const String _tag = "Log";

var _logger = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: LongPrettyPrinter(methodCount: 2, warpLen: 1000)
    // printer: PrettyPrinter(
    //   methodCount: 2,
    //   errorMethodCount: 8,
    //   lineLength: 120,
    //   colors: true,
    // ),
    );

LogV(String msg) {
  _logger.v("$_tag :: $msg");
}

LogD(String msg) {
  _logger.d("$_tag :: $msg");
}

LogI(String msg) {
  _logger.i("$_tag :: $msg");
}

LogW(String msg) {
  _logger.w("$_tag :: $msg");
}

LogE(String msg) {
  _logger.e("$_tag :: $msg");
}

LogWTF(String msg) {
  _logger.wtf("$_tag :: $msg");
}

/// support long log
class LongPrettyPrinter extends PrettyPrinter {
  final int warpLen;

  @override
  LongPrettyPrinter({
    this.warpLen = 1000,
    stackTraceBeginIndex = 0,
    methodCount = 2,
    errorMethodCount = 8,
    lineLength = 120,
    colors = true,
    printEmojis = true,
    printTime = false,
    noBoxingByDefault = false,
  }) : super(
          stackTraceBeginIndex: stackTraceBeginIndex,
          methodCount: methodCount,
          errorMethodCount: errorMethodCount,
          lineLength: lineLength,
          colors: colors,
          printEmojis: printEmojis,
          printTime: printTime,
          noBoxingByDefault: noBoxingByDefault,
        );

  @override
  String stringifyMessage(message) {
    var msg = super.stringifyMessage(message);
    var i = 0;
    var len = warpLen;
    var newStr = "";
    while (msg.length > i + len) {
      var next = i + len;
      var last = msg.indexOf("\n", i);
      if (last < i + 1 || last > next) {
        newStr += msg.substring(i, next) + "\n";
        i = next;
      } else {
        newStr += msg.substring(i, last);
        i = last;
      }
    }
    if (i + len > msg.length) {
      newStr += msg.substring(i);
    }
    return newStr;
  }
}
