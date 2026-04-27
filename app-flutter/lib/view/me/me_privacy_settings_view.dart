import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/privacy_provider.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/widget/dialog/me_dialogs.dart';

/// 隐私设置页面
class MePrivacySettingsView extends StatelessWidget {
  const MePrivacySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ),
      body: Consumer<PrivacyProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              _buildSettingsItem(
                context,
                title: 'Hide Personal Info Settings',
                onTap: () {
                  Navigator.pushNamed(context, RoutePaths.hidePersonalInfo);
                },
              ),
              _buildSwitchItem(
                context,
                title: 'Go Incognito',
                isVIP: true,
                value: provider.anonymousBrowse,
                onChanged: (value) {
                  final accountProvider = context.read<AccountProvider>();
                  if (!accountProvider.isVIP) {
                    MeDialogs.showUnlockPrivateMode(
                      context,
                      onGetVIP: () {
                        Navigator.pushNamed(
                            context, RoutePaths.vipSubscription);
                      },
                    );
                    return;
                  }
                  provider.updateSetting(anonymousBrowse: value);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isVIP = false,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
                if (isVIP) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'VIP',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFA000),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFEB8B8B),
            activeTrackColor: const Color(0xFFEB8B8B).withOpacity(0.3),
            inactiveThumbColor: const Color(0xFFCCCCCC),
            inactiveTrackColor: const Color(0xFFEEEEEE),
          ),
        ],
      ),
    );
  }
}
