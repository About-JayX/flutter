import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/model/privacy_settings.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/privacy_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class PrivacySettingsView extends StatelessWidget {
  const PrivacySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Settings',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PrivacyProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              // 在线状态
              _buildSectionHeader('Online Status'),
              _buildSwitchTile(
                title: 'Show Online Status',
                subtitle: 'Other users can see if you are online',
                value: provider.showOnlineStatus,
                onChanged: (value) =>
                    provider.updateSetting(showOnlineStatus: value),
              ),
              _buildSwitchTile(
                title: 'Show Last Seen',
                subtitle: 'Other users can see your last online time',
                value: provider.showLastSeen,
                onChanged: (value) =>
                    provider.updateSetting(showLastSeen: value),
              ),

              const Divider(height: 1),

              // 资料可见性
              _buildSectionHeader('Profile Visibility'),
              _buildListTile(
                title: 'Profile Visibility',
                subtitle: _getVisibilityText(provider.profileVisibility),
                onTap: () => _showVisibilityPicker(context, provider),
              ),
              _buildListTile(
                title: 'Photo Visibility',
                subtitle: _getPhotoVisibilityText(provider.photoVisibility),
                onTap: () => _showPhotoVisibilityPicker(context, provider),
              ),
              _buildSwitchTile(
                title: 'Show Age',
                value: provider.showAge,
                onChanged: (value) => provider.updateSetting(showAge: value),
              ),
              _buildSwitchTile(
                title: 'Show Gender',
                value: provider.showGender,
                onChanged: (value) => provider.updateSetting(showGender: value),
              ),
              _buildSwitchTile(
                title: 'Show Location',
                subtitle: 'Display location info in your profile',
                value: provider.showLocation,
                onChanged: (value) =>
                    provider.updateSetting(showLocation: value),
              ),

              const Divider(height: 1),

              // 消息和通话
              _buildSectionHeader('Messages & Calls'),
              _buildSwitchTile(
                title: 'Allow Stranger Messages',
                subtitle: 'Non-friends can send you messages',
                value: provider.allowStrangerMessage,
                onChanged: (value) =>
                    provider.updateSetting(allowStrangerMessage: value),
              ),
              _buildSwitchTile(
                title: 'Allow Stranger Calls',
                subtitle: 'Non-friends can call you',
                value: provider.allowStrangerCall,
                onChanged: (value) =>
                    provider.updateSetting(allowStrangerCall: value),
              ),

              const Divider(height: 1),

              // 搜索
              _buildSectionHeader('Search'),
              _buildSwitchTile(
                title: 'Allow Search by Phone',
                value: provider.allowSearchByPhone,
                onChanged: (value) =>
                    provider.updateSetting(allowSearchByPhone: value),
              ),
              _buildSwitchTile(
                title: 'Allow Search by Email',
                value: provider.allowSearchByEmail,
                onChanged: (value) =>
                    provider.updateSetting(allowSearchByEmail: value),
              ),

              const Divider(height: 1),

              // 其他
              _buildSectionHeader('Other'),
              _buildSwitchTile(
                title: 'Anonymous Browse',
                subtitle: 'Browse profiles without leaving visitor records',
                value: provider.anonymousBrowse,
                onChanged: (value) =>
                    provider.updateSetting(anonymousBrowse: value),
              ),

              const SizedBox(height: 32),

              // 重置按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () => _showResetConfirmDialog(context, provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reset to Default'),
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              )
            : null,
        value: value,
        onChanged: onChanged,
        activeColor: ThemeHelper.primaryColor,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF999999)),
        onTap: onTap,
      ),
    );
  }

  String _getVisibilityText(ProfileVisibility visibility) {
    switch (visibility) {
      case ProfileVisibility.everyone:
        return 'Everyone';
      case ProfileVisibility.friends:
        return 'Friends Only';
      case ProfileVisibility.nobody:
        return 'Only Me';
    }
  }

  String _getPhotoVisibilityText(PhotoVisibility visibility) {
    switch (visibility) {
      case PhotoVisibility.everyone:
        return 'Everyone';
      case PhotoVisibility.friends:
        return 'Friends Only';
      case PhotoVisibility.vip:
        return 'VIP Only';
      case PhotoVisibility.nobody:
        return 'Only Me';
    }
  }

  void _showVisibilityPicker(BuildContext context, PrivacyProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Visibility',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            ...ProfileVisibility.values.map((visibility) => ListTile(
                  title: Text(_getVisibilityText(visibility)),
                  trailing: provider.profileVisibility == visibility
                      ? const Icon(Icons.check, color: ThemeHelper.primaryColor)
                      : null,
                  onTap: () {
                    provider.updateSetting(profileVisibility: visibility);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showPhotoVisibilityPicker(
      BuildContext context, PrivacyProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Photo Visibility',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            ...PhotoVisibility.values.map((visibility) => ListTile(
                  title: Text(_getPhotoVisibilityText(visibility)),
                  trailing: provider.photoVisibility == visibility
                      ? const Icon(Icons.check, color: ThemeHelper.primaryColor)
                      : null,
                  onTap: () {
                    provider.updateSetting(photoVisibility: visibility);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context, PrivacyProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Privacy Settings'),
        content: const Text(
            'Are you sure you want to reset all privacy settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.resetToDefault();
              Navigator.pop(context);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
