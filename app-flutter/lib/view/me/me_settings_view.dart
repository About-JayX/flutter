import 'package:flutter/material.dart';
import 'package:mobisen_app/app_router.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/util/screen_security.dart';
import 'package:mobisen_app/util/view_utils.dart';

/// 我的设置页面
class MeSettingsView extends StatelessWidget {
  const MeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildSettingsItem(
            context,
            title: 'Account & Security',
            onTap: () {},
          ),
          _buildSettingsItem(
            context,
            title: 'Privacy Settings',
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.privacySettings);
            },
          ),
          _buildSettingsItem(
            context,
            title: 'VIP Subscription',
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.vipSubscription);
            },
          ),
          _buildSettingsItem(
            context,
            title: 'Network Diagnostics',
            onTap: () {},
          ),
          _buildSettingsItem(
            context,
            title: 'Clear Cache',
            trailing: const Text(
              '0KB',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
            onTap: () {},
          ),
          _buildSettingsItem(
            context,
            title: 'Version',
            trailing: const Text(
              'Version 1.0',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
            onTap: () {},
          ),
          _buildSettingsItem(
            context,
            title: 'Terms of Service',
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutePaths.webView,
                arguments: CommonArgs(
                  url: Urls.terms,
                  title: 'Terms of Service',
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            title: 'Privacy Policy',
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutePaths.webView,
                arguments: CommonArgs(
                  url: Urls.privacyPolicy,
                  title: 'Privacy Policy',
                ),
              );
            },
          ),
          const Divider(height: 1),
          // 开关选项
          _buildSwitchItem(
            context,
            title: 'Tell us about your personality',
            value: false,
            onChanged: (value) {},
          ),
          _buildSwitchItem(
            context,
            title: 'Choose topics you want to chat about',
            value: false,
            onChanged: (value) {},
          ),
          _buildSwitchItem(
            context,
            title: 'What are you looking for',
            value: true,
            onChanged: (value) {},
          ),
          const SizedBox(height: 24),
          // 退出登录按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () => _showLogoutConfirm(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEB8B8B),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    Widget? trailing,
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
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: 4),
            ],
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
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log Out',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5A3D4A),
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF5A3D4A),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F2F2),
                    foregroundColor: const Color(0xFF5A3D4A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(S.current.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    // 禁用防截屏
                    await ScreenSecurity.disable();
                    // 执行退出登录
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB8B8B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(S.current.ok),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
