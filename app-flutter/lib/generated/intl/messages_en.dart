// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(episodes) =>
      "${Intl.plural(episodes, zero: '≈ 0 episode', one: '≈ 1 episode', other: '≈ ${episodes} episodes')}";

  static String m1(coins) =>
      "${Intl.plural(coins, zero: '0 coin', one: '1 coin', other: '${coins} coins')}";

  static String m2(username) =>
      "Are you sure you want to delete the account ${username}?";

  static String m3(username) =>
      "Warning: Deleting your account, ${username}, is not the same as logging out.\n\nOnce you delete your account, all your data, including saved preferences and history, will be permanently erased.\n\nAll active subscriptions or purchases linked to your account will no longer be associated with it and cannot be recovered.\n\nThis action is permanent and cannot be undone.\n\nPlease confirm only if you are sure you want to proceed.";

  static String m4(coins, price) =>
      "You can top up ${coins} for only ${price}, are you sure you want to give it up?";

  static String m5(store) =>
      "- Your ${store} account will be automatically charged for renewal within 24 hours before the end of the subscription period.\n- If you want to cancel your subscription, please go to the subscription management page of ${store} to cancel.\n- Due to network and other reasons, the purchase process may be delayed. Please refresh the page after the purchase is successful.\n- If you have any questions, please contact us.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "about_eposides_num": m0,
        "app_name": MessageLookupByLibrary.simpleMessage("Ume"),
        "auto_unlock_next_video":
            MessageLookupByLibrary.simpleMessage("Auto unlock next video"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "bonus": MessageLookupByLibrary.simpleMessage("Bonus"),
        "can_be_changed_in_settings":
            MessageLookupByLibrary.simpleMessage("Can be changed in settings"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "check_in": MessageLookupByLibrary.simpleMessage("Check in"),
        "checked_in": MessageLookupByLibrary.simpleMessage("Checked in"),
        "claim": MessageLookupByLibrary.simpleMessage("Claim"),
        "coins": MessageLookupByLibrary.simpleMessage("Coins"),
        "coins_all_supper": MessageLookupByLibrary.simpleMessage("COINS"),
        "coins_num": m1,
        "consumption": MessageLookupByLibrary.simpleMessage("Consumption"),
        "contact_us": MessageLookupByLibrary.simpleMessage("Contact Us"),
        "daily_check_in":
            MessageLookupByLibrary.simpleMessage("Daily Check-in"),
        "daily_check_in_des0":
            MessageLookupByLibrary.simpleMessage("You have checked in for"),
        "daily_check_in_des2":
            MessageLookupByLibrary.simpleMessage("day straight!"),
        "daily_tasks": MessageLookupByLibrary.simpleMessage("Daily Tasks"),
        "day": MessageLookupByLibrary.simpleMessage("Day"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Delete account"),
        "delete_account_confirm": m2,
        "delete_account_desc": m3,
        "delete_account_success": MessageLookupByLibrary.simpleMessage(
            "Success, will be fully processed within 15 days"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "earn_rewards": MessageLookupByLibrary.simpleMessage("Earn Rewards"),
        "empty_list_hint":
            MessageLookupByLibrary.simpleMessage("It\'s empty here"),
        "empty_page": MessageLookupByLibrary.simpleMessage("Empty Page"),
        "empty_refresh_prompt": MessageLookupByLibrary.simpleMessage(
            "Something is wrong, tap to refresh"),
        "enjoy_all_dramas_for_free":
            MessageLookupByLibrary.simpleMessage("Enjoy all dramas for free"),
        "error_toast": MessageLookupByLibrary.simpleMessage(
            "Error, please try again later"),
        "error_try_again_later": MessageLookupByLibrary.simpleMessage(
            "Something is wrong, try again later"),
        "expires_in": MessageLookupByLibrary.simpleMessage("Expires in"),
        "free_watch": MessageLookupByLibrary.simpleMessage("Free Watch"),
        "give_up": MessageLookupByLibrary.simpleMessage("Give up"),
        "go": MessageLookupByLibrary.simpleMessage("Go"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "income": MessageLookupByLibrary.simpleMessage("Income"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "log_out": MessageLookupByLibrary.simpleMessage("Log out"),
        "log_out_check_msg": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to log out?"),
        "login_app": MessageLookupByLibrary.simpleMessage("Login App"),
        "login_success":
            MessageLookupByLibrary.simpleMessage("Login successful"),
        "miss_out_stories_prompt": MessageLookupByLibrary.simpleMessage(
            "Don\'t miss out the stories in between"),
        "mobisen_pro": MessageLookupByLibrary.simpleMessage("Ume Pro"),
        "month": MessageLookupByLibrary.simpleMessage("month"),
        "monthly_pro": MessageLookupByLibrary.simpleMessage("Monthly Pro"),
        "my_bonus": MessageLookupByLibrary.simpleMessage("My bonus"),
        "my_coins": MessageLookupByLibrary.simpleMessage("My Coins"),
        "my_list": MessageLookupByLibrary.simpleMessage("My List"),
        "my_wallet": MessageLookupByLibrary.simpleMessage("My Wallet"),
        "network_error": MessageLookupByLibrary.simpleMessage("Network error"),
        "new_user_product_give_up_msg": m4,
        "new_user_product_msg": MessageLookupByLibrary.simpleMessage(
            "Exclusive for new users. Time limited"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "phone_login_not_supported": MessageLookupByLibrary.simpleMessage(
            "Phone login is not supported yet"),
        "popular": MessageLookupByLibrary.simpleMessage("Popular"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "purchase_successful":
            MessageLookupByLibrary.simpleMessage("Purchase successful"),
        "purchase_tips": m5,
        "redirect": MessageLookupByLibrary.simpleMessage("Redirect"),
        "rewards": MessageLookupByLibrary.simpleMessage("Rewards"),
        "series": MessageLookupByLibrary.simpleMessage("Series"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "share_app": MessageLookupByLibrary.simpleMessage("Share"),
        "share_app_msg": MessageLookupByLibrary.simpleMessage(
            "Ume: Amazing short dramas waiting for you. Start watching now!"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Sign in"),
        "sign_in_email_conflict_prompt": MessageLookupByLibrary.simpleMessage(
            "An account with this email already exists but with different provider"),
        "sign_in_error": MessageLookupByLibrary.simpleMessage("Sign in error"),
        "sign_in_policy_hint": MessageLookupByLibrary.simpleMessage(
            "If you continue, you agree to our"),
        "sign_in_with": MessageLookupByLibrary.simpleMessage("Sign in with"),
        "tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
        "terms_of_service":
            MessageLookupByLibrary.simpleMessage("Terms of Service"),
        "this_episode": MessageLookupByLibrary.simpleMessage("This episode"),
        "top_up": MessageLookupByLibrary.simpleMessage("Top Up"),
        "try_again_later":
            MessageLookupByLibrary.simpleMessage("Please try again later"),
        "unlock_all_series":
            MessageLookupByLibrary.simpleMessage("Unlock All Series"),
        "unlock_btn": MessageLookupByLibrary.simpleMessage("Unlock Now"),
        "unlock_episode":
            MessageLookupByLibrary.simpleMessage("Unlock episode"),
        "vip_all_supper": MessageLookupByLibrary.simpleMessage("VIP"),
        "watch_ad": MessageLookupByLibrary.simpleMessage("Watch ad"),
        "watch_episode": MessageLookupByLibrary.simpleMessage("Watch episode"),
        "watch_history": MessageLookupByLibrary.simpleMessage("Watch History"),
        "watch_history_clear_check_msg": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to clear the watch history?"),
        "watch_stories": MessageLookupByLibrary.simpleMessage("Watch stories"),
        "week": MessageLookupByLibrary.simpleMessage("week"),
        "weekly_pro": MessageLookupByLibrary.simpleMessage("Weekly Pro"),
        "year": MessageLookupByLibrary.simpleMessage("year"),
        "yearly_pro": MessageLookupByLibrary.simpleMessage("Yearly Pro")
      };
}
