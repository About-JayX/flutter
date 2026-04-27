import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewUtils {
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height >
        1.1;
  }

  static void toUrl(String url,
      {bool throwError = false, bool outApp = true}) async {
    try {
      if (!await launchUrl(Uri.parse(url),
          mode: outApp
              ? LaunchMode.externalApplication
              : LaunchMode.platformDefault)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (throwError) {
        rethrow;
      }
    }
  }

  static void toEmail(String email, {bool throwError = false}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Feedback',
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      if (throwError) {
        rethrow;
      }
    }
  }

  static void toHome(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RoutePaths.home, (route) => false);
  }

  static void showDialogInfo(BuildContext context,
      {String? title,
      String? desc,
      Function()? onBtnCancel,
      Function()? onBtnOk}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: desc != null ? Text(desc) : null,
          actions: <Widget>[
            if (onBtnCancel != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onBtnCancel();
                },
                child: Text(S.current.cancel),
              ),
            if (onBtnOk != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onBtnOk();
                },
                child: Text(S.current.ok),
              ),
          ],
        );
      },
    );
  }

  static AppBar buildCommonAppBar(
    BuildContext context, {
    Widget? title,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      title: title,
      centerTitle: true,
      actions: actions,
      bottom: bottom,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }

  static Widget buildVideoAppBar(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: SizedBox(
            height: Theme.of(context).appBarTheme.toolbarHeight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
          ),
        ));
  }

  static bool jumpToLogin(
      BuildContext context, AccountProvider? accountProvider) {
    if (accountProvider?.account != null) {
      return false;
    } else {
      Navigator.pushNamed(context, RoutePaths.login);
      return true;
    }
  }

  static void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
    );
  }

  static Future<void> shareApp() async {
    await Share.share("${S.current.share_app_msg}\n\n${Urls.shareUrl}");
  }
}
