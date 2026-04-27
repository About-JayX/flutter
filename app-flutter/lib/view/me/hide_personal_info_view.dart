import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/model/privacy_settings.dart' as privacy;
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/privacy_provider.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/widget/dialog/me_dialogs.dart';

/// 隐藏个人资料信息设置页面
class HidePersonalInfoView extends StatelessWidget {
  const HidePersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: const Text(
          'Hide Personal Info Settings',
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
              _buildSwitchItem(
                context,
                title: 'Hide Age',
                isVIP: true,
                value: !provider.showAge,
                onChanged: (value) => _handleToggle(context, provider, () {
                  provider.updateSetting(showAge: !value);
                }),
              ),
              _buildSwitchItem(
                context,
                title: 'Hide Country',
                isVIP: true,
                value: !provider.showLocation,
                onChanged: (value) => _handleToggle(context, provider, () {
                  provider.updateSetting(showLocation: !value);
                }),
              ),
              _buildSwitchItem(
                context,
                title: 'Last Seen Time',
                isVIP: false,
                value: provider.showLastSeen,
                onChanged: (value) {
                  provider.updateSetting(showLastSeen: value);
                },
              ),
              _buildSwitchItem(
                context,
                title: 'Hide Gender',
                isVIP: true,
                value: !provider.showGender,
                onChanged: (value) => _handleToggle(context, provider, () {
                  provider.updateSetting(showGender: !value);
                }),
              ),
              _buildSwitchItem(
                context,
                title: 'Online Status',
                isVIP: true,
                value: provider.showOnlineStatus,
                onChanged: (value) => _handleToggle(context, provider, () {
                  provider.updateSetting(showOnlineStatus: value);
                }),
              ),
              const Divider(height: 1),
              // 谁可以看到我的资料
              _buildSectionTitle('Who Can See My Profile'),
              _buildRadioItem(
                context,
                title: 'Everyone',
                isVIP: false,
                isSelected: provider.profileVisibility ==
                    privacy.ProfileVisibility.everyone,
                onTap: () => provider.updateSetting(
                    profileVisibility: privacy.ProfileVisibility.everyone),
              ),
              _buildRadioItem(
                context,
                title: 'Only Friends',
                isVIP: true,
                isSelected: provider.profileVisibility ==
                    privacy.ProfileVisibility.friends,
                onTap: () => _handleToggle(context, provider, () {
                  provider.updateSetting(
                      profileVisibility: privacy.ProfileVisibility.friends);
                }),
              ),
              _buildRadioItem(
                context,
                title: 'Only Me',
                isVIP: true,
                isSelected: provider.profileVisibility ==
                    privacy.ProfileVisibility.nobody,
                onTap: () => _handleToggle(context, provider, () {
                  provider.updateSetting(
                      profileVisibility: privacy.ProfileVisibility.nobody);
                }),
              ),
              const Divider(height: 1),
              _buildSwitchItem(
                context,
                title: 'Full Profile Privacy',
                isVIP: true,
                value: false,
                onChanged: (value) => _handleToggle(context, provider, () {}),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleToggle(
      BuildContext context, PrivacyProvider provider, VoidCallback onSuccess) {
    final accountProvider = context.read<AccountProvider>();
    if (!accountProvider.isVIP) {
      MeDialogs.showUnlockPrivateMode(
        context,
        onGetVIP: () {
          Navigator.pushNamed(context, RoutePaths.vipSubscription);
        },
      );
      return;
    }
    onSuccess();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF666666),
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

  Widget _buildRadioItem(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isVIP = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
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
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFEB8B8B)
                      : const Color(0xFFCCCCCC),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEB8B8B),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// 扩展ProfileVisibility枚举
enum ProfileVisibility {
  everyone,
  friends,
  nobody,
}
