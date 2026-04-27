import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/configs_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/locale_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/util/permission_mange_util.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/widget/mixed_list/settings_base_mixed_list_item.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class SettingsMixedListItem extends SettingsBaseMixedListItem {
  @override
  List<Widget> buildWidgets(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final configsProvider = context.watch<ConfigsProvider>();
    final autoUnlockNext = configsProvider.configs.autoUnlockNext;
    return [
      buildItem(
        icon: const Icon(Icons.language_rounded),
        title: S.current.language,
        onTap: () {
          _showLanguageDialog(context, localeProvider);
        },
        trailing: const SizedBox(),
      ),
      buildItem(
        icon: const Icon(Icons.notifications_none_rounded),
        title: S.current.notifications,
        onTap: () {
          PermissionMangeUtil.goToSystemSetting();
        },
        trailing: const SizedBox(),
      ),
      buildItem(
        icon: const Icon(Icons.auto_awesome_motion_outlined),
        title: S.current.auto_unlock_next_video,
        onTap: () {
          autoUnlockNext.value = !autoUnlockNext.value;
          configsProvider.onConfigChanged();
        },
        trailing: Checkbox(
          value: autoUnlockNext.value,
          onChanged: (bool? newValue) {
            if (newValue != null) {
              autoUnlockNext.value = newValue;
              configsProvider.onConfigChanged();
            }
          },
        ),
      ),
      if (accountProvider.account != null)
        buildItem(
          icon: const Icon(Icons.star, color: Colors.amber),
          title: 'VIP 会员',
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.vipSubscription);
          },
          trailing: Text(
            accountProvider.isVIP ? '已开通' : '未开通',
            style: TextStyle(
              color: accountProvider.isVIP ? Colors.amber : Colors.grey,
            ),
          ),
        ),
      if (accountProvider.account != null)
        buildItem(
          icon: const Icon(Icons.privacy_tip, color: ThemeHelper.primaryColor),
          title: '隐私设置',
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.privacySettings);
          },
          trailing: const SizedBox(),
        ),
      if (accountProvider.account != null)
        buildItem(
          icon: const Icon(Icons.block, color: Colors.red),
          title: '黑名单',
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.blockedUsers);
          },
          trailing: const SizedBox(),
        ),
      if (accountProvider.account != null)
        buildItem(
          icon: const Icon(Icons.filter_alt, color: Colors.orange),
          title: '屏蔽词管理',
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.blockedKeywords);
          },
          trailing: const SizedBox(),
        ),
      if (accountProvider.account != null)
        buildItem(
          icon: const Icon(Icons.logout_rounded),
          title: S.current.log_out,
          onTap: () {
            ViewUtils.showDialogInfo(
              context,
              title: S.current.log_out_check_msg,
              onBtnCancel: () {},
              onBtnOk: () {
                accountProvider.setAccount(null);
              },
            );
          },
          trailing: const SizedBox(),
        ),
    ];
  }

  void _showLanguageDialog(
      BuildContext context, LocaleProvider localeProvider) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(S.of(context).cancel))
                ],
                title: Text(S.of(context).language),
                // ignore: sized_box_for_whitespace
                content: Container(
                  width: double.minPositive,
                  child: SingleChildScrollView(
                    child: Column(
                      children: AppLocale.values
                          .map((locale) => ListTile(
                                onTap: () {
                                  localeProvider.setLocale(locale);
                                  ViewUtils.toHome(context);
                                  // Navigator.pop(context);
                                },
                                title: Text(locale.displayName),
                              ))
                          .toList(),
                    ),
                  ),
                )));
  }
}
