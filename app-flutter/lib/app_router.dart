import 'package:flutter/material.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/view/home/home_redirect_view.dart';
import 'package:mobisen_app/view/profile/about_view.dart';
import 'package:mobisen_app/view/profile/login_view.dart';
import 'package:mobisen_app/view/profile/settings_view.dart';
import 'package:mobisen_app/view/profile/watch_history_view.dart';
import 'package:mobisen_app/view/video/show_view.dart';
import 'package:mobisen_app/view/profile/wallet_detail_view.dart';
import 'package:mobisen_app/view/reward/reward_view.dart';
import 'package:mobisen_app/view/webview/webview.dart';
import 'package:mobisen_app/view/test/test_view.dart';
import 'package:mobisen_app/view/profile/personalize_edit.dart';
import 'package:mobisen_app/view/startup/startup_view.dart';
import 'package:mobisen_app/view/square/post_publish_view.dart';
import 'package:mobisen_app/view/square/topic_select_view.dart';
import 'package:mobisen_app/view/report/report_view.dart';
import 'package:mobisen_app/view/chat/chat_view.dart';
import 'package:mobisen_app/view/voice_call/voice_call_caller_view.dart';
import 'package:mobisen_app/view/voice_call/voice_call_receiver_view.dart';
import 'package:mobisen_app/view/voice_call/voice_call_active_view.dart';
import 'package:mobisen_app/view/video_call/video_call_caller_view.dart';
import 'package:mobisen_app/view/video_call/video_call_receiver_view.dart';
import 'package:mobisen_app/view/video_call/video_call_active_view.dart';
import 'package:mobisen_app/view/interest/interest_view.dart';
import 'package:mobisen_app/view/profile/vip_subscription_view.dart';
import 'package:mobisen_app/view/matching/interest_cards_view.dart';
import 'package:mobisen_app/view/matching/edit_card_view.dart';
import 'package:mobisen_app/view/matching/greetings_view.dart';
import 'package:mobisen_app/view/profile/privacy_settings_view.dart';
import 'package:mobisen_app/view/profile/blocked_users_view.dart';
import 'package:mobisen_app/view/profile/blocked_keywords_view.dart';
import 'package:mobisen_app/view/report/report_user_view.dart';
import 'package:mobisen_app/view/me/me_profile_view.dart';
import 'package:mobisen_app/view/me/hide_personal_info_view.dart';
import 'package:mobisen_app/view/me/store_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    CommonArgs? commonArgs = args is CommonArgs ? args : null;
    switch (settings.name) {
      case RoutePaths.home:
        return _buildRoute(
            builder: (context) => const HomeRedirectView(),
            screenName: TrackScreenNames.main);
      case RoutePaths.reward:
        return _buildRoute(
            builder: (context) => RewardView(
                  goBack: commonArgs?.goBack,
                ),
            screenName: TrackScreenNames.reward);
      case RoutePaths.login:
        return _buildRoute(
            builder: (context) => const LoginView(),
            screenName: TrackScreenNames.login);
      case RoutePaths.show:
        return _buildRoute(
            builder: (context) => ShowView(
                  showId: commonArgs?.showId ?? -1,
                ),
            screenName: TrackScreenNames.show);
      case RoutePaths.settings:
        return _buildRoute(
            builder: (context) => const SettingsView(),
            screenName: TrackScreenNames.settings);
      case RoutePaths.about:
        return _buildRoute(
            builder: (context) => const AboutView(),
            screenName: TrackScreenNames.about);
      case RoutePaths.watchHistory:
        return _buildRoute(
            builder: (context) => const WatchHistoryView(),
            screenName: TrackScreenNames.watchHistory);
      case RoutePaths.walletDetails:
        return _buildRoute(
            builder: (context) => const WalletDetailView(),
            screenName: TrackScreenNames.walletDetails);
      case RoutePaths.webView:
        return _buildRoute(
            builder: (context) => WebView(
                  url: commonArgs?.url,
                  title: commonArgs?.title,
                ),
            screenName: TrackScreenNames.webView);
      case RoutePaths.test:
        return _buildRoute(
            builder: (context) => const TestView(),
            screenName: TrackScreenNames.test);
      case RoutePaths.personalizeEdit:
        return _buildRoute(
            builder: (context) => const PersonalizeEditView(),
            screenName: TrackScreenNames.personalizeEdit);
      case RoutePaths.startup:
        return _buildRoute(
            builder: (context) => const StartupView(),
            screenName: TrackScreenNames.startup);
      case RoutePaths.postPublish:
        return _buildRoute(
            builder: (context) => const PostPublishView(),
            screenName: TrackScreenNames.postPublish);
      case RoutePaths.topicSelect:
        return _buildRoute(
            builder: (context) => const TopicSelectView(),
            screenName: TrackScreenNames.topicSelect);
      case RoutePaths.report:
        return _buildRoute(
            builder: (context) => const ReportView(),
            screenName: TrackScreenNames.report);
      case RoutePaths.chat:
        return _buildRoute(
            builder: (context) => const ChatView(),
            screenName: TrackScreenNames.chat);
      case RoutePaths.voiceCallCaller:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            builder: (context) => VoiceCallCallerView(
                  roomID: args?['roomID'] ?? '',
                  targetUserID: args?['targetUserID'] ?? '',
                  targetUserName: args?['targetUserName'] ?? '',
                ),
            screenName: TrackScreenNames.voiceCallCaller);
      case RoutePaths.voiceCallReceiver:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            builder: (context) => VoiceCallReceiverView(
                  roomID: args?['roomID'] ?? '',
                  callerID: args?['callerID'] ?? '',
                  callerName: args?['callerName'] ?? '',
                ),
            screenName: TrackScreenNames.voiceCallReceiver);
      case RoutePaths.voiceCallActive:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            builder: (context) => VoiceCallActiveView(
                  roomID: args?['roomID'] ?? '',
                  userID: args?['userID'] ?? '',
                  targetUserID: args?['targetUserID'] ?? '',
                  targetUserName: args?['targetUserName'] ?? '',
                ),
            screenName: TrackScreenNames.voiceCallActive);
      case RoutePaths.videoCallCaller:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            builder: (context) => VideoCallCallerView(
                  roomID: args?['roomID'] ?? '',
                  targetUserID: args?['targetUserID'] ?? '',
                  targetUserName: args?['targetUserName'] ?? '',
                ),
            screenName: TrackScreenNames.videoCallCaller);
      case RoutePaths.videoCallReceiver:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            builder: (context) => VideoCallReceiverView(
                  roomID: args?['roomID'] ?? '',
                  callerID: args?['callerID'] ?? '',
                  callerName: args?['callerName'] ?? '',
                ),
            screenName: TrackScreenNames.videoCallReceiver);
      case RoutePaths.videoCallActive:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            builder: (context) => VideoCallActiveView(
                  roomID: args?['roomID'] ?? '',
                  targetUserID: args?['targetUserID'] ?? '',
                  userID: args?['userID'] ?? '',
                  targetUserName: args?['targetUserName'] ?? '',
                ),
            screenName: TrackScreenNames.videoCallActive);
      case RoutePaths.vipSubscription:
        return _buildRoute(
            builder: (context) => const VIPSubscriptionView(),
            screenName: TrackScreenNames.vipSubscription);
      case RoutePaths.interest:
        return _buildRoute(
            builder: (context) => const InterestView(),
            screenName: TrackScreenNames.interest);
      case RoutePaths.interestCards:
        return _buildRoute(
            builder: (context) => const InterestCardsView(),
            screenName: TrackScreenNames.interestCards);
      case RoutePaths.greetings:
        return _buildRoute(
            builder: (context) => const GreetingsView(),
            screenName: TrackScreenNames.greetings);
      case RoutePaths.privacySettings:
        return _buildRoute(
            builder: (context) => const PrivacySettingsView(),
            screenName: TrackScreenNames.privacySettings);
      case RoutePaths.blockedUsers:
        return _buildRoute(
            builder: (context) => const BlockedUsersView(),
            screenName: TrackScreenNames.blockedUsers);
      case RoutePaths.blockedKeywords:
        return _buildRoute(
            builder: (context) => const BlockedKeywordsView(),
            screenName: TrackScreenNames.blockedKeywords);
      case RoutePaths.reportUser:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            builder: (context) => ReportUserView(
                  userId: args?['userId'] ?? '',
                  username: args?['username'] ?? '',
                ),
            screenName: TrackScreenNames.reportUser);
      case RoutePaths.meProfile:
        return _buildRoute(
            builder: (context) => const MeProfileView(),
            screenName: TrackScreenNames.meProfile);
      case RoutePaths.hidePersonalInfo:
        return _buildRoute(
            builder: (context) => const HidePersonalInfoView(),
            screenName: TrackScreenNames.hidePersonalInfo);
      case RoutePaths.store:
        return _buildRoute(
            builder: (context) => const StoreView(),
            screenName: TrackScreenNames.store);
      case RoutePaths.editCard:
        return _buildRoute(
            builder: (context) => const EditCardView(),
            screenName: TrackScreenNames.editCard);
      default:
        return _buildRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('Error: ${settings.name}'),
                  ),
                ),
            screenName: TrackScreenNames.error);
    }
  }

  static Route<dynamic> _buildRoute(
      {required WidgetBuilder builder, required String screenName}) {
    TrackHelper.instance.trackScreenView(screenName: screenName);
    return MaterialPageRoute(builder: (context) {
      ApiService.instance.initCommonParams(context);
      return builder(context);
    });
  }
}

class CommonArgs {
  int? showId;
  String? url;
  String? title;
  bool? goBack;

  CommonArgs({
    this.showId,
    this.url,
    this.title,
    this.goBack,
  });

  factory CommonArgs.fromMap(Map<String, dynamic> args) {
    return CommonArgs(
      showId: args['showId'],
      url: args['url'],
      title: args['title'],
      goBack: args['goBack'],
    );
  }
}
