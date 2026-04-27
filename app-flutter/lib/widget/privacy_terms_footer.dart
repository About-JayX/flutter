import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/util/view_utils.dart';

class PrivacyTermsFooter extends StatelessWidget {
  const PrivacyTermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final textStyleUrl =
        textStyle?.copyWith(decoration: TextDecoration.underline);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: S.current.sign_in_policy_hint,
            style: textStyle,
          ),
          TextSpan(
            text: " ",
            style: textStyle,
          ),
          TextSpan(
            text: S.current.terms_of_service,
            style: textStyleUrl,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ViewUtils.toUrl(Urls.terms);
              },
          ),
          TextSpan(
            text: " & ",
            style: textStyle,
          ),
          TextSpan(
            text: S.current.privacy_policy,
            style: textStyleUrl,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ViewUtils.toUrl(Urls.privacyPolicy);
              },
          ),
        ],
      ),
    );
  }
}
