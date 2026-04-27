import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mobisen_app/db/hive_helper.dart';
import 'package:mobisen_app/util/account_helper.dart';
import 'package:mobisen_app/app_router.dart';
import 'package:mobisen_app/configs.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/configs_provider.dart';
import 'package:mobisen_app/provider/locale_provider.dart';
import 'package:mobisen_app/provider/remote_message_provider.dart';
import 'package:mobisen_app/provider/message_provider.dart';
import 'package:mobisen_app/provider/call_provider.dart';
import 'package:mobisen_app/provider/chat_provider.dart';
import 'package:mobisen_app/provider/privacy_provider.dart';
import 'package:mobisen_app/provider/block_provider.dart';
import 'package:mobisen_app/provider/square_provider.dart';
import 'package:mobisen_app/provider/matching_provider.dart';
import 'package:mobisen_app/services/zego_im_service.dart';
import 'package:mobisen_app/services/zego_call_service.dart';
import 'package:mobisen_app/util/account_helper.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/view/video_call/video_call_receiver_view.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:mobisen_app/routes/application.dart';
import 'package:mobisen_app/lifeCircle/app_lifecycle_manager.dart';
import 'package:mobisen_app/widget/debug_button.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 设置沉浸式状态栏：透明背景 + 黑色文字
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await Configs.init();
  if (Configs.instance.firstLaunchTimeMillis.value <= 0) {
    Configs.instance.firstLaunchTimeMillis.value =
        DateTime.now().millisecondsSinceEpoch;
  }

  await HiveHelper.init();
  await AccountHelper.init();

  // 初始化 ZEGO SDK
  await _initializeZegoSDK();

  runApp(
      // DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp())
      const MyApp());
}

Future<void> _initializeZegoSDK() async {
  try {
    // 初始化 ZIM SDK（启用详细日志）
    print('========== ZIM SDK 初始化开始 ==========');
    print('AppID: ${ZegoConfig.appID}');
    print('AppSign: ${ZegoConfig.appSign.substring(0, 20)}...');

    await ZegoIMService().initialize();

    print('ZIM SDK 初始化完成');
    print('========== ZIM SDK 初始化结束 ==========');

    // 自动登录 ZIM（如果用户已登录）
    await _autoLoginZIM();

    // 初始化音视频 SDK
    await ZegoCallService().initialize();

    // 监听呼叫邀请
    _listenForCallInvites();

    print('ZEGO Express SDK 初始化完成');
  } catch (e, stackTrace) {
    print('========== ZEGO SDK 初始化错误 ==========');
    print('错误: $e');
    print('堆栈: $stackTrace');
    print('==========================================');
    // 记录错误但不阻断应用启动
  }
}

Future<void> _autoLoginZIM() async {
  try {
    final account = AccountHelper.instance.account;
    if (account != null) {
      print('检测到已登录用户，自动登录 ZIM: ${account.user.username}');
      await ZegoIMService().login(
        account.user.username,
        account.user.displayName ?? account.user.username,
        '', // 测试环境 token 为空
      );
      print('ZIM 自动登录成功: ${account.user.username}');
    } else {
      print('没有已登录用户，跳过 ZIM 自动登录');
    }
  } catch (e) {
    print('ZIM 自动登录失败: $e');
  }
}

void _listenForCallInvites() {
  ZegoIMService().callInviteStream.listen((invite) {
    print('收到呼叫邀请: ${invite.callerID}, 类型: ${invite.type}');

    // 设置 CallProvider 状态（重要！）
    final callProvider = CallProvider();
    callProvider.startRinging(
        invite.roomID, invite.callerID, invite.callerName);
    print(
        'CallProvider 状态已更新: callerID=${invite.callerID}, roomID=${invite.roomID}');

    // 使用 navigatorKey 全局弹出接听页面 (路由方式)
    final context = Application.navigatorKey.currentContext;
    if (context != null) {
      // 根据呼叫类型选择不同的接听页面
      if (invite.type == 'voice_call_invite') {
        // 语音通话
        Navigator.pushNamed(
          context,
          RoutePaths.voiceCallReceiver,
          arguments: {
            'roomID': invite.roomID,
            'callerID': invite.callerID,
            'callerName': invite.callerName,
          },
        );
      } else {
        // 视频通话
        Navigator.pushNamed(
          context,
          RoutePaths.videoCallReceiver,
          arguments: {
            'roomID': invite.roomID,
            'callerID': invite.callerID,
            'callerName': invite.callerName,
          },
        );
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLifecycleManager().startListening();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConfigsProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => RemoteMessageProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => CallProvider()),
        ChangeNotifierProvider(
            create: (context) => PrivacyProvider()..initialize()),
        ChangeNotifierProvider(
            create: (context) => BlockProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => SquareProvider()),
        ChangeNotifierProvider(create: (context) => MatchingProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            // showPerformanceOverlay: true,
            // checkerboardOffscreenLayers: true,
            // checkerboardRasterCacheImages: true,
            // builder: (context, child) {
            //   return DebugButton(
            //     child: MediaQuery(
            //       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            //       child: BotToastInit()(context, child),
            //     ),
            //   );
            // },
            builder: BotToastInit(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
              RefreshLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: localeProvider.locale,
            initialRoute: RoutePaths.startup,
            navigatorKey: Application.navigatorKey,
            navigatorObservers: [BotToastNavigatorObserver()],
            onGenerateRoute: AppRouter.generateRoute,
            themeMode: ThemeMode.light,
            theme: ThemeHelper.lightTheme,
          );
        },
      ),
    );
  }
}
