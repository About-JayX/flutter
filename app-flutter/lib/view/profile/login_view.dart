import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/screen_security.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/configs.dart';
import 'package:mobisen_app/widget/custom_dialog.dart';
import 'package:mobisen_app/widget/custom_toast.dart';
import 'package:mobisen_app/widget/loading_overlay.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();

    TrackHelper.instance.track(
        event: TrackEvents.account, action: TrackValues.showLoginDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.33),
          child: Column(
            children: [
              const Spacer(flex: 3),
              _buildLogoBubble(),
              const Spacer(flex: 4),
              if (Platform.isIOS) ...[
                _buildAppleButton(),
                const SizedBox(height: 10.67),
                _buildPhoneButton(),
              ] else ...[
                _buildGoogleButton(),
                const SizedBox(height: 10.67),
                _buildPhoneButton(),
              ],
              const SizedBox(height: 30.33),
              _buildPrivacyFooter(),
              const SizedBox(height: 86),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBubble() {
    return Assets.images.loginUme.image(
      width: 160,
      height: 140,
      fit: BoxFit.contain,
    );
  }

  Widget _buildAppleButton() {
    return GestureDetector(
      onTap: () => signInWith(context, AuthMethod.apple),
      child: Assets.images.loginContinuewithapple.image(
        width: double.infinity,
        height: 56,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: () => signInWith(context, AuthMethod.google),
      child: Assets.images.loginContinuewithgoogle.image(
        width: double.infinity,
        height: 56,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPhoneButton() {
    return GestureDetector(
      onTap: () {
        ViewUtils.showToast(S.current.phone_login_not_supported);
      },
      child: Assets.images.loginPhonenumber.image(
        width: double.infinity,
        height: 56,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPrivacyFooter() {
    const baseStyle = TextStyle(
      fontSize: 12,
      color: Color(0xFF80576B),
      fontFamily: 'MiSansVF',
      height: 1.4,
    );
    final linkStyle = baseStyle.copyWith(
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'By continuing, you agree to our ',
            style: baseStyle,
          ),
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => ViewUtils.toUrl(Urls.terms),
          ),
          const TextSpan(
            text: ' and\nCommunity Guidelines, and confirm our ',
            style: baseStyle,
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => ViewUtils.toUrl(Urls.privacyPolicy),
          ),
          const TextSpan(
            text: '.',
            style: baseStyle,
          ),
        ],
      ),
    );
  }

  AuthMethod? _loadingMethod;

  void signInWith(BuildContext context, AuthMethod method) async {
    if (_loadingMethod != null) {
      return;
    }

    // Check privacy policy before login
    if (!Configs.instance.privacyPolicyAccepted.value) {
      _showPrivacyDialogAndThen(() => _doSignIn(context, method));
      return;
    }

    await _doSignIn(context, method);
  }

  void _showPrivacyDialogAndThen(VoidCallback onConfirmed) {
    CustomDialog.show(
      context,
      title: "Welcome to Ume",
      description:
          "By continuing, you agree to our Terms of Service and Privacy Policy.",
      onCancel: () {
        // Cancel also marks as read, but don't proceed with login
        Configs.instance.privacyPolicyAccepted.value = true;
      },
      onConfirm: () {
        // Confirm marks as read and proceeds with login
        Configs.instance.privacyPolicyAccepted.value = true;
        onConfirmed();
      },
    );
  }

  Future<void> _doSignIn(BuildContext context, AuthMethod method) async {
    setState(() {
      _loadingMethod = method;
    });

    // 显示加载弹窗
    LoadingOverlay.show(context);

    final trackParams = {TrackParams.provider: method.name.toLowerCase()};
    TrackHelper.instance.track(
        event: TrackEvents.account,
        action: TrackValues.loginClick,
        params: trackParams);

    try {
      OAuthCredential? credential;
      switch (method) {
        case AuthMethod.google:
          print('🔵 [Google Sign-In] Step 1: Starting Google Sign-In...');
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          print(
              '🟢 [Google Sign-In] Step 2: User selected account: ${googleUser?.email ?? "null (user cancelled or error)"}');

          if (googleUser == null) {
            print(
                '🔴 [Google Sign-In] Error: User cancelled the sign-in or no account selected');
            break;
          }

          print('🔵 [Google Sign-In] Step 3: Getting authentication tokens...');
          final GoogleSignInAuthentication? googleAuth =
              await googleUser.authentication;
          print('🟢 [Google Sign-In] Step 4: Authentication result obtained');

          if (googleAuth != null) {
            print('🟢 [Google Sign-In] Step 5: Token details:');
            print(
                '   - Access Token: ${googleAuth.accessToken != null ? "✅ Present (length: ${googleAuth.accessToken!.length})" : "❌ null"}');
            print(
                '   - ID Token: ${googleAuth.idToken != null ? "✅ Present (length: ${googleAuth.idToken!.length})" : "❌ null"}');
            print(
                '   - Server Auth Code: ${googleAuth.serverAuthCode ?? "null"}');

            print(
                '🔵 [Google Sign-In] Step 6: Creating Firebase credential...');
            credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            print(
                '🟢 [Google Sign-In] Step 7: Firebase credential created successfully');
          } else {
            print(
                '🔴 [Google Sign-In] Error: Failed to get authentication tokens');
          }
          break;
        case AuthMethod.apple:
          final rawNonce = generateNonce();
          final nonce = sha256ofString(rawNonce);
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );
          credential = OAuthProvider("apple.com").credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          );
          break;
        case AuthMethod.facebook:
          final rawNonce = generateNonce();
          final nonce = sha256ofString(rawNonce);
          final LoginResult loginResult = await FacebookAuth.instance.login(
            loginTracking: LoginTracking.limited,
            nonce: nonce,
          );
          if (Platform.isIOS) {
            switch (loginResult.accessToken!.type) {
              case AccessTokenType.classic:
                final token = loginResult.accessToken as ClassicToken;
                credential = FacebookAuthProvider.credential(
                  token.authenticationToken!,
                );
                break;
              case AccessTokenType.limited:
                final token = loginResult.accessToken as LimitedToken;
                credential = OAuthCredential(
                  providerId: 'facebook.com',
                  signInMethod: 'oauth',
                  idToken: token.tokenString,
                  rawNonce: rawNonce,
                );
                break;
            }
          } else {
            credential = FacebookAuthProvider.credential(
              loginResult.accessToken!.tokenString,
            );
          }
          break;
      }
      if (credential != null) {
        print(
            '🔵 [Firebase Auth] Step 8: Signing in with Firebase credential...');
        final UserCredential firebaseResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print('🟢 [Firebase Auth] Step 9: Firebase sign-in successful');
        print('   - Firebase User ID: ${firebaseResult.user?.uid ?? "null"}');
        print(
            '   - Firebase User Email: ${firebaseResult.user?.email ?? "null"}');
        print(
            '   - Firebase User DisplayName: ${firebaseResult.user?.displayName ?? "null"}');
        print(
            '   - Firebase User PhotoURL: ${firebaseResult.user?.photoURL ?? "null"}');

        print('🔵 [API] Step 10: Calling backend API loginWithFirebase...');
        final account =
            await ApiService.instance.loginWithFirebase(firebaseResult);
        print('🟢 [API] Step 11: Backend API login successful');

        if (context.mounted) {
          print('🔵 [UI] Step 12: Updating account state...');
          context.read<AccountProvider>().setAccount(account);
          final personalizeEdit = account.user.personalizeEdit;
          final isPersonalized = personalizeEdit == 1;
          print(
              '🟢 [UI] Step 13: Account state updated, isPersonalized: $isPersonalized');

          // 启用防截屏
          await ScreenSecurity.enable(context);

          // 显示登录成功提示
          ViewUtils.showToast(S.current.login_success);

          if (isPersonalized) {
            print('🔵 [Navigation] Step 14: Navigating to Home...');
            ViewUtils.toHome(context);
          } else {
            print('🔵 [Navigation] Step 14: Navigating to PersonalizeEdit...');
            Navigator.of(context).pushNamedAndRemoveUntil(
                RoutePaths.personalizeEdit, (route) => false);
          }
        }

        TrackHelper.instance.track(
            event: TrackEvents.account,
            action: TrackValues.loginSuccess,
            params: trackParams);
        TrackHelper.instance.updateUserProperties();

        TrackHelper.instance.facebookAppEvents
            .logEvent(name: FacebookAppEvents.eventNameCompletedRegistration);

        print('✅ [Google Sign-In] Complete: Login flow finished successfully!');
      } else {
        print(
            '🔴 [Google Sign-In] Error: Credential is null, cannot proceed with Firebase auth');
      }
    } catch (e) {
      print('🔴 [Google Sign-In] Error caught: $e');
      if (e is FirebaseAuthException) {
        print('🔴 [Google Sign-In] FirebaseAuthException code: ${e.code}');
        print(
            '🔴 [Google Sign-In] FirebaseAuthException message: ${e.message}');
      }
      if (e is DioException) {
        print('🔴 [Google Sign-In] DioException type: ${e.type}');
        print('🔴 [Google Sign-In] DioException message: ${e.message}');
        if (e.response != null) {
          print(
              '🔴 [Google Sign-In] DioException status code: ${e.response?.statusCode}');
          print(
              '🔴 [Google Sign-In] DioException response data: ${e.response?.data}');
        }

        // Token 过期或认证失败，退出 Google 登录
        if (e.response?.statusCode == 401 ||
            e.type == DioExceptionType.connectionTimeout) {
          print(
              '🔵 [Google Sign-In] Signing out from Google due to auth error...');
          await GoogleSignIn().signOut();
          print('🟢 [Google Sign-In] Google sign out completed');
        }
      }
      if (context.mounted) {
        String desc = S.current.try_again_later;
        if (e is FirebaseAuthException &&
            e.code.contains("account-exists-with-different-credential")) {
          desc = S.current.sign_in_email_conflict_prompt;
        }

        // 显示错误 Toast
        CustomToast.show(
          context,
          message: desc,
          duration: 2500,
        );
      }
    } finally {
      // 隐藏加载弹窗
      LoadingOverlay.hide();
      setState(() {
        _loadingMethod = null;
      });
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

enum AuthMethod { apple, google, facebook }
