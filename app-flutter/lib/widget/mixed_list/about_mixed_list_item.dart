import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/net/model/account.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/widget/mixed_list/settings_base_mixed_list_item.dart';

class AboutMixedListItem extends SettingsBaseMixedListItem {
  @override
  List<Widget> buildWidgets(BuildContext context) {
    return [
      _buildAboutHeader(context),
      buildItem(
        icon: const Icon(Icons.description_outlined),
        title: S.current.terms_of_service,
        onTap: () {
          ViewUtils.toUrl(Urls.terms);
        },
      ),
      buildItem(
        icon: const Icon(Icons.policy_outlined),
        title: S.current.privacy_policy,
        onTap: () {
          ViewUtils.toUrl(Urls.privacyPolicy);
        },
      ),
      buildItem(
        icon: const Icon(Icons.delete_outline),
        title: S.current.delete_account,
        onTap: () {
          _deleteAccount(context);
        },
      ),
    ];
  }

  Widget _buildAboutHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 32),
        ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Assets.images.appIcon.image(width: 100, height: 100)),
        const SizedBox(height: 16),
        Text(
          S.current.app_name,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
      ]),
    );
  }

  void _deleteAccount(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();
    if (ViewUtils.jumpToLogin(context, accountProvider)) {
      return;
    }
    final account = accountProvider.account!;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).cancel)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteAccountConfirm(context, account);
                    },
                    child: Text(S.of(context).delete))
              ],
              title: Text(S.of(context).delete_account),
              content: Text(
                  S.of(context).delete_account_desc(account.user.username)),
            ));
  }

  void _deleteAccountConfirm(BuildContext context, Account account) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).cancel)),
                TextButton(
                    onPressed: () async {
                      try {
                        await ApiService.instance.deleteAccount(account);
                        ViewUtils.showToast(S.current.delete_account_success);
                        if (context.mounted) {
                          final accountProvider =
                              context.read<AccountProvider>();
                          accountProvider.setAccount(null);
                          ViewUtils.toHome(context);
                        }
                      } catch (e) {
                        ViewUtils.showToast(S.current.error_try_again_later);
                      }
                    },
                    child: Text(S.of(context).delete))
              ],
              title: Text(S.of(context).delete_account),
              content: Text(
                  S.of(context).delete_account_confirm(account.user.username)),
            ));
  }
}
