# UME - 北美青年即时通讯 AI 社交软件

## 项目介绍

UME 是莫比森（Mobisen）旗下面向北美青年群体的即时通讯 AI 社交软件。本项目为 UME 的 Flutter 客户端，支持 iOS 和 Android 双平台，提供视频流媒体、即时通讯、AI 社交互动、应用内购买（IAP）、奖励系统等功能。

## 技术栈

- **框架**: Flutter (SDK >=3.4.1)
- **语言**: Dart
- **状态管理**: Provider
- **路由**: 手动 MaterialPageRoute
- **代码生成**: json_serializable, build_runner
- **国际化**: flutter_intl
- **UI 主题**: 强制暗黑模式 (ThemeMode.dark)

## 核心依赖

### Firebase 生态
- `firebase_core` - Firebase 核心
- `firebase_auth` - 身份认证
- `firebase_analytics` - 数据分析
- `firebase_crashlytics` - 崩溃报告
- `firebase_messaging` - 推送通知
- `firebase_remote_config` - 远程配置

### 网络与数据
- `dio` + `dio_http2_adapter` - HTTP 客户端
- `hive` + `hive_flutter` - 本地存储
- `shared_preferences` - 轻量配置存储

### 视频与媒体
- `video_player` - 视频播放
- `chewie` - 视频播放器 UI
- `extended_image` - 高级图片加载
- `image_picker` - 图片选择

### 认证与支付
- `google_sign_in` - Google 登录
- `sign_in_with_apple` - Apple 登录
- `flutter_facebook_auth` - Facebook 登录
- `purchases_flutter` (RevenueCat) - 应用内购买

### 其他
- `appsflyer_sdk` - 归因追踪
- `webview_flutter` - 内嵌网页
- `flutter_local_notifications` - 本地通知
- `permission_handler` - 权限管理

## 项目架构

```
lib/
├── main.dart              # 应用入口，初始化 Firebase、Hive、IAP、追踪
├── app_router.dart        # 路由配置，手动 MaterialPageRoute
├── constants.dart         # 路由路径等常量定义
├── configs.dart           # 全局配置
├── db/
│   └── hive_helper.dart   # Hive 数据库初始化
├── provider/              # Provider 状态管理
│   ├── account_provider.dart
│   ├── configs_provider.dart
│   ├── locale_provider.dart
│   └── remote_message_provider.dart
├── routes/                # 页面路由
├── util/                  # 工具类
├── widget/                # 公共组件
├── generated/l10n.dart    # 国际化生成文件
└── lifeCircle/            # 生命周期管理

local-packages/
└── video_player_android/  # video_player Android 本地覆盖包

test/                      # 测试文件
assets/
├── images/                # 图片资源
├── fonts/                 # 字体资源 (MiSansVF)
└── icon/                  # 应用图标
```

## 环境要求

- **Flutter SDK**: >=3.4.1, <4.0.0
- **Dart SDK**: 随 Flutter SDK 附带
- **Android**: minSdk 21+
- **iOS**: 需要 Xcode 和 CocoaPods (`pod install`)

## 安装与运行

### 1. 安装依赖

```bash
flutter pub get
```

> iOS 用户需要额外运行：
> ```bash
cd ios && pod install
```

### 2. 配置 Firebase

- Android: 放置 `google-services.json` 到 `android/app/`
- iOS: 放置 `GoogleService-Info.plist` 到 `ios/Runner/`

### 3. 运行代码生成（修改模型后）

```bash
flutter pub run build_runner build
```

### 4. 运行应用

```bash
# 调试模式
flutter run

# 指定设备
flutter run -d <device_id>
```

## 打包流程

### Android

```bash
# 调试 APK
flutter build apk --debug

# 发布 APK
flutter build apk --release

# App Bundle (Google Play 推荐)
flutter build appbundle
```

### iOS

```bash
# 构建 iOS
flutter build ios

# 发布构建
flutter build ios --release
```

## 代码规范

- 使用 `flutter analyze` 运行静态分析
- 遵循 `analysis_options.yaml` 中的 lint 规则
- 使用 `flutter_lints` 推荐的代码规范

## 测试

```bash
flutter test
```

## 注意事项

1. **自定义视频播放器**: `video_player_android` 使用本地包覆盖，更新前需充分测试
2. **暗黑模式**: 应用强制使用暗黑主题，不可切换
3. **DevicePreview**: Debug 模式下启用设备预览功能
4. **初始路由**: 应用启动路由为 `RoutePaths.startup`（非 `/`）
5. **字体**: 使用自定义字体 `MiSansVF`

## 版本信息

- 当前版本: `1.7.0+170`

## 更多资源

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言指南](https://dart.dev/guides)
