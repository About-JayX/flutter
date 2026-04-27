import 'package:flutter/widgets.dart';
import 'package:mobisen_app/routes/application.dart';

class ScreenUtil {
  static MediaQueryData get mediaQueryData => MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first);

  static double get bottomPadding => mediaQueryData.viewPadding.bottom;

  static double get topPadding => mediaQueryData.viewPadding.top;
  // static final BuildContext? _globalContext =
  //     Application.navigatorKey.currentState?.context;
  //
  // static MediaQueryData? get mediaQueryData =>
  //     _globalContext != null ? MediaQuery.of(_globalContext!) : null;
  //
  // static double get bottomPadding => mediaQueryData?.viewPadding.bottom ?? 0.0;
  //
  // static double get topPadding => mediaQueryData?.viewPadding.top ?? 0.0;
}
