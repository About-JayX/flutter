import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/firebase_options.dart';
import 'package:mobisen_app/iap/iap_helper.dart';
import 'package:mobisen_app/messaging/firebase_messaging.dart';
import 'package:mobisen_app/messaging/loc_notification_helper.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/remote_configs.dart';
import 'package:mobisen_app/util/account_helper.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/util/screen_security.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/widget/image_loader.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  bool _hasNavigated = false;
  bool _isAndroid12OrAbove = false;
  bool _sdkChecked = false;

  @override
  void initState() {
    super.initState();
    _setSplashUIMode();
    _checkAndroidVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppAndRoute();
    });
  }

  /// Flutter Splash 模式：状态栏透明可见 + 导航栏隐藏
  void _setSplashUIMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  /// 恢复正常模式：显示状态栏 + 显示导航栏
  void _exitSplashUIMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _checkAndroidVersion() async {
    LogD('StartupView: checking Android version...');
    LogD('StartupView: Platform.isAndroid=${Platform.isAndroid}');
    LogD('StartupView: Platform.version=${Platform.version}');

    if (!Platform.isAndroid) {
      LogD('StartupView: not Android, skipping version check');
      if (mounted) {
        setState(() {
          _sdkChecked = true;
        });
      }
      return;
    }
    try {
      // Use device_info_plus to get accurate Android SDK version
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      LogD('StartupView: DeviceInfo SDK version=$sdkInt');
      LogD('StartupView: DeviceInfo release=${androidInfo.version.release}');
      LogD('StartupView: isAndroid12OrAbove=${sdkInt >= 31}');

      if (mounted) {
        setState(() {
          _isAndroid12OrAbove = sdkInt >= 31;
          _sdkChecked = true;
        });
      }
    } catch (e) {
      LogE('StartupView: failed to check Android version:\n$e');
      if (mounted) {
        setState(() {
          _sdkChecked = true;
        });
      }
    }
  }

  Future<void> _initializeAppAndRoute() async {
    if (_hasNavigated) return;

    final stopwatch = Stopwatch()..start();

    try {
      await _runBackgroundInitializations();
    } catch (e, stackTrace) {
      LogE('StartupView: background initialization error:\n$e\n$stackTrace');
    }

    stopwatch.stop();
    LogD(
        'StartupView: background initializations took ${stopwatch.elapsedMilliseconds}ms');

    FlutterNativeSplash.remove();

    _hasNavigated = true;
    _handleStartupFlow();
  }

  Future<void> _runBackgroundInitializations() async {
    await Future.wait([
      _initFirebaseWrapper(),
      _initImageLoader(),
      _initApiService(),
      _initNotifications(),
      _initIAP(),
      _initAppsFlyer(),
    ]);

    TrackHelper.instance.track(event: TrackEvents.appLaunch);
    TrackHelper.instance.updateUserProperties();

    _initATT();
  }

  Future<void> _initFirebaseWrapper() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      await _withTimeout(
        RemoteConfigs.init(),
        const Duration(seconds: 5),
        'RemoteConfigs.init',
      );
      LogD('StartupView: Firebase initialized');
    } catch (e) {
      LogE('StartupView: Firebase init error:\n$e');
    }
  }

  Future<void> _initImageLoader() async {
    try {
      await ImageLoader.init();
      LogD('StartupView: ImageLoader initialized');
    } catch (e) {
      LogE('StartupView: ImageLoader init error:\n$e');
    }
  }

  Future<void> _initApiService() async {
    try {
      await ApiService.instance.initBaseCommonParams();
      LogD('StartupView: ApiService initialized');
    } catch (e) {
      LogE('StartupView: ApiService init error:\n$e');
    }
  }

  Future<void> _initNotifications() async {
    try {
      await _withTimeout(
        FirebaseMessagingService().initNotifications(),
        const Duration(seconds: 5),
        'FirebaseMessaging.initNotifications',
      );
      await LocNotificationHelper().initialize();
      LogD('StartupView: Notifications initialized');
    } catch (e) {
      LogE('StartupView: Notifications init error:\n$e');
    }
  }

  Future<void> _initIAP() async {
    try {
      await _withTimeout(
        IAPHelper.instance.tryInit(AccountHelper.instance.account),
        const Duration(seconds: 5),
        'IAPHelper.tryInit',
      );
      LogD('StartupView: IAP initialized');
    } catch (e) {
      LogE('StartupView: IAP init error:\n$e');
    }
  }

  Future<void> _initAppsFlyer() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    try {
      final appsFlyerOptions = AppsFlyerOptions(
        afDevKey: 'iqrHtzTjBQopULkBdC6mpe',
        appId: Platform.isAndroid ? 'mobisen_app.android' : '6636523706',
        showDebug: kDebugMode,
        timeToWaitForATTUserAuthorization: 30,
        disableAdvertisingIdentifier: false,
        disableCollectASA: false,
        manualStart: true,
      );
      final appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
      await _withTimeout(
        appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true,
          registerOnDeepLinkingCallback: true,
        ),
        const Duration(seconds: 5),
        'AppsFlyer.initSdk',
      );
      appsflyerSdk.startSDK();
      LogD('StartupView: AppsFlyer initialized');
    } catch (e) {
      LogE('StartupView: AppsFlyer init error:\n$e');
    }
  }

  Future<void> _withTimeout(
    Future<void> future,
    Duration timeout,
    String name,
  ) async {
    try {
      await future.timeout(timeout);
    } on TimeoutException {
      LogW('StartupView: $name timed out after ${timeout.inSeconds}s');
    }
  }

  void _initATT() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      LogE('StartupView: ATT init error:\n$e');
    }
  }

  Future<void> _handleStartupFlow() async {
    try {
      final account = AccountHelper.instance.account;
      final isLoggedIn = account != null && account.jwt.isNotEmpty;

      LogD('StartupView: isLoggedIn=$isLoggedIn');

      if (!isLoggedIn) {
        LogD('StartupView: not logged in -> navigate to login');
        _replaceTo(RoutePaths.login);
        return;
      }

      // 已登录用户启用防截屏
      if (context.mounted) {
        await ScreenSecurity.enable(context);
      }

      // 从后端获取最新用户资料（包括 personalizeEdit 状态）
      try {
        LogD('StartupView: fetching fresh profile from backend...');
        final freshUser = await ApiService.instance.getAccountProfile(account);
        account.user = freshUser;
        AccountHelper.instance.account = account;
        LogD(
            'StartupView: profile updated from backend, personalizeEdit=${freshUser.personalizeEdit}');
      } catch (e) {
        LogE(
            'StartupView: failed to fetch profile from backend, using local data:\n$e');
        // 后端获取失败时，继续使用本地数据
      }

      final personalizeEdit = account.user.personalizeEdit;
      final isPersonalized = personalizeEdit == 1;

      LogD(
          'StartupView: personalizeEdit=$personalizeEdit -> isPersonalized=$isPersonalized');

      if (!isPersonalized) {
        LogD('StartupView: not personalized -> navigate to personalizeEdit');
        _replaceTo(RoutePaths.personalizeEdit);
        return;
      }

      LogD('StartupView: logged in and personalized -> navigate to home');
      _replaceTo(RoutePaths.home);
    } catch (e, stackTrace) {
      LogE('StartupView: error during startup flow:\n$e\n$stackTrace');
      _replaceTo(RoutePaths.login);
    }
  }

  void _replaceTo(String routeName) {
    if (!mounted) return;
    _exitSplashUIMode();
    Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    LogD('StartupView: build() called');
    LogD('StartupView: _sdkChecked=$_sdkChecked');
    LogD('StartupView: Platform.isAndroid=${Platform.isAndroid}');
    LogD('StartupView: _isAndroid12OrAbove=$_isAndroid12OrAbove');

    if (!_sdkChecked) {
      LogD('StartupView: SDK not checked yet, showing legacy splash');
      return _buildLegacySplash();
    }
    if (Platform.isAndroid && _isAndroid12OrAbove) {
      LogD('StartupView: Android 12+, showing Android 12 splash');
      return _buildAndroid12Splash();
    }
    LogD('StartupView: showing legacy splash');
    return _buildLegacySplash();
  }

  Widget _buildAndroid12Splash() {
    return Container(
      color: const Color(0xFFFDCFCC),
      child: Center(
        child: Image.asset(
          'assets/images/splash_icon.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLegacySplash() {
    return Image.asset(
      'assets/images/splash_bg.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
