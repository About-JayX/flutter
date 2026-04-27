class RoutePaths {
  static const String home = "/";
  static const String login = "/login";
  static const String show = "/show";
  static const String settings = "/settings";
  static const String watchHistory = "/watchHistory";
  static const String about = "/about";
  static const String walletDetails = "/walletDetail";
  static const String webView = "/webView";
  static const String reward = "/reward";
  static const String test = "/test";
  static const String personalizeEdit = "/personalizeEdit";
  static const String startup = "/startup";
  static const String postPublish = "/post-publish";
  static const String topicSelect = "/topic-select";
  static const String report = "/report";
  static const String chat = "/chat";
  static const String voiceCallCaller = "/voice-call-caller";
  static const String voiceCallReceiver = "/voice-call-receiver";
  static const String voiceCallActive = "/voice-call-active";
  static const String videoCallCaller = "/video-call-caller";
  static const String videoCallReceiver = "/video-call-receiver";
  static const String videoCallActive = "/video-call-active";
  static const String vipSubscription = "/vip_subscription";
  static const String interestCards = "/interest-cards";
  static const String privacySettings = "/privacy-settings";
  static const String blockedUsers = "/blocked-users";
  static const String blockedKeywords = "/blocked-keywords";
  static const String reportUser = "/report-user";
  static const String greetings = "/greetings";
  static const String meProfile = "/me-profile";
  static const String hidePersonalInfo = "/hide-personal-info";
  static const String store = "/store";
  static const String editCard = "/edit-card";

  static const Set<String> allPaths = {
    home,
    login,
    show,
    settings,
    watchHistory,
    about,
    walletDetails,
    webView,
    reward,
    test,
    personalizeEdit,
    startup,
    postPublish,
    topicSelect,
    report,
    chat,
    voiceCallCaller,
    voiceCallReceiver,
    voiceCallActive,
    videoCallCaller,
    videoCallReceiver,
    videoCallActive,
    vipSubscription,
    interestCards,
    privacySettings,
    blockedUsers,
    blockedKeywords,
    reportUser,
    greetings,
    meProfile,
    hidePersonalInfo,
    store,
    editCard,
  };

  static bool doesPathExist(String path) {
    return allPaths.contains(path);
  }
}

class ApiEndPoints {
  static const String firebaseAuth = "/api/auth/firebaseAuth";
  static const String profile = "/api/users/profile";
  static const String userInfo = "/api/users/profile";
  static const String homepage = "/api/v1/homepage";
  static const String reward = "/api/v1/reward";
  static const String signInDetail = "/api/v1/checkInDetail";
  static const String signIn = "/api/v1/checkIn";
  static const String getTaskList = "/api/v1/getTaskList";
  static const String finishTask = "/api/v1/finishTask";
  static const String showDetail = "/api/v1/showDetail";
  static const String saveShow = "/api/v1/saveShow";
  static const String unsaveShow = "/api/v1/unsaveShow";
  static const String savedShows = "/api/v1/savedShows";
  static const String unlockEpisode = "/api/v1/unlockEpisode";
  static const String consumptionRecords = "/api/v1/consumptionRecords";
  static const String incomeRecords = "/api/v1/incomeRecords";
  static const String deleteAccount = "/api/v1/deleteAccount";
  static const String markPersonalized = "/api/users/personalize";
  static const String uploadAvatar = "/api/users/avatar";
  static const String isEarlyUser = "/api/users/is-early-user";
}

class Urls {
  static const String privacyPolicy = "https://mobisen.com/privacy";
  static const String terms = "https://mobisen.com/terms";
  static const String shareUrl = "https://mobisen.onelink.me/2QAp/share";
  static const String email = "contact@mobisen.com";
}

class TrackEvents {
  static const String appLaunch = "app_launch";
  static const String playback = "playback";
  static const String show = "show";
  static const String iap = "iap";
  static const String account = "account";
  static const String checkIn = "check_in";
  static const String task = "task";
  static const String inAppReview = "in_app_review";
  static const String notification = "notification";
}

class TrackParams {
  static const String action = "action";
  static const String showId = "show_id";
  static const String showTitle = "show_title";
  static const String episodeId = "episode_id";
  static const String episodeNum = "episode_num";
  static const String eventSource = "event_source";
  static const String productId = "product_id";
  static const String provider = "provider";
  static const String debug = "debug";
  static const String appUserId = "app_user_id";
  static const String appLang = "app_lang";
  static const String membershipLevel = "membership_level";
  static const String daysSinceFirstLaunch = "days_since_first_launch";
  static const String day = "day";
  static const String id = "id";
  static const String type = "type";
  static const String title = "title";
}

class TrackValues {
  static const String playStart = "play_start";
  static const String play5s = "play_5s";
  static const String playComplete = "play_complete";
  static const String showDetails = "show_details";
  static const String save = "save";
  static const String unsave = "unsave";
  static const String unlockClick = "unlock_click";
  static const String unlockSuccess = "unlock_success";
  static const String clickItem = "click_item";
  static const String success = "success";
  static const String fail = "fail";
  static const String showLoginDetails = "show_login_details";
  static const String loginClick = "login_click";
  static const String loginSuccess = "login_success";
  static const String checkIn = "check_in";
  static const String click = "click";
  static const String go = "go";
  static const String claim = "claim";
  static const String done = "done";
  static const String regular = "regular";
  static const String pro = "pro";
  static const String show = "show";
}

class TrackScreenNames {
  static const String main = "main";
  static const String home = "home";
  static const String myList = "my_list";
  static const String messages = "messages";
  static const String reward = "reward";
  static const String profile = "profile";
  static const String login = "login";
  static const String show = "show";
  static const String settings = "settings";
  static const String watchHistory = "watch_history";
  static const String walletDetails = "wallet_details";
  static const String about = "about";
  static const String error = "error";
  static const String webView = "webView";
  static const String test = "test";
  static const String personalizeEdit = "personalize_edit";
  static const String startup = "startup";
  static const String postPublish = "post_publish";
  static const String topicSelect = "topic_select";
  static const String report = "report";
  static const String chat = "chat";
  static const String voiceCallCaller = "voice_call_caller";
  static const String voiceCallReceiver = "voice_call_receiver";
  static const String voiceCallActive = "voice_call_active";
  static const String videoCallCaller = "video_call_caller";
  static const String videoCallReceiver = "video_call_receiver";
  static const String videoCallActive = "video_call_active";
  static const String vipSubscription = "vip_subscription";
  static const String interestCards = "interest_cards";
  static const String matching = "matching";
  static const String privacySettings = "privacy_settings";
  static const String blockedUsers = "blocked_users";
  static const String blockedKeywords = "blocked_keywords";
  static const String reportUser = "report_user";
  static const String greetings = "greetings";
  static const String meProfile = "me_profile";
  static const String hidePersonalInfo = "hide_personal_info";
  static const String store = "store";
  static const String editCard = "edit_card";
}
