# AGENTS.md - Mobisen App

## Project Overview

Flutter mobile app (iOS/Android) with video streaming, in-app purchases (RevenueCat), Firebase auth/analytics, rewards system. Uses Provider for state management.

## Developer Commands

```bash
# Standard Flutter commands
flutter pub get          # Install dependencies
flutter analyze         # Run linter (analysis_options.yaml)
flutter run              # Run app

# Build commands
flutter build apk --debug   # Debug APK
flutter build apk --release # Release APK
flutter build ios           # iOS build
```

## Architecture

- **Entry**: `lib/main.dart` (initializes Firebase, Hive, IAP, tracking)
- **Routing**: `lib/app_router.dart` - Manual `MaterialPageRoute` with `RouteSettings`
- **State**: Provider (`lib/provider/`)
  - `ConfigsProvider`, `LocaleProvider`, `AccountProvider`, `RemoteMessageProvider`
- **Routes**: Defined in `lib/constants.dart` (`RoutePaths` class)
- **Initial route**: `RoutePaths.test` (not `/` - see main.dart line 148)

## Key Dependencies

- Firebase: `firebase_core`, `firebase_auth`, `firebase_analytics`, `firebase_crashlytics`, `firebase_messaging`, `firebase_remote_config`
- Networking: `dio`, `dio_http2_adapter`
- Video: `video_player`, `chewie` (uses local override in `local-packages/video_player_android`)
- Storage: `hive`, `hive_flutter`, `shared_preferences`
- IAP: `purchases_flutter` (RevenueCat)
- Auth: `google_sign_in`, `sign_in_with_apple`, `flutter_facebook_auth`
- Tracking: `appsflyer_sdk`

## Important Patterns

1. **Code Generation**: Uses `json_serializable` and `build_runner`. Run `flutter pub run build_runner build` after modifying model files.
2. **Custom Video Player**: Local package override for `video_player_android` - don't update without testing
3. **Dark Mode**: Hardcoded to `ThemeMode.dark` (main.dart line 152)
4. **Localization**: `flutter_intl` enabled - generates `lib/generated/l10n.dart`

## Testing

- Test files in `test/` directory
- Standard Flutter test runner: `flutter test`

## Quirks & Constraints

- `DevicePreview` enabled in debug mode (main.dart line 57-58)
- Custom font: `MiSansVF` from `assets/fonts/mi_sans_latin.ttf`
- iOS requires `pod install` after `flutter pub get`
- Firebase requires `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
