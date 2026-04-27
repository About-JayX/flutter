import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/widget/dialog/me_dialogs.dart';
import 'package:mobisen_app/widget/image_loader.dart';

/// 我的主页页面
/// 支持自己可见和他人可见两种状态
class MeProfileView extends StatefulWidget {
  final bool isOwnProfile;

  const MeProfileView({
    super.key,
    this.isOwnProfile = true,
  });

  @override
  State<MeProfileView> createState() => _MeProfileViewState();
}

class _MeProfileViewState extends State<MeProfileView> {
  bool _isPhotosTab = true;
  bool _isInfoHidden = false;

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 渐变背景头部
              _buildGradientHeader(context, accountProvider),
              // 照片/视频切换
              _buildPhotoVideoTabs(context),
              const SizedBox(height: 16),
              // 照片/视频网格
              _buildMediaGrid(context),
              const SizedBox(height: 24),
              // 个人信息标签
              if (!_isInfoHidden) ...[
                _buildProfileTags(context),
                const SizedBox(height: 24),
              ],
              // 隐藏信息提示
              if (_isInfoHidden) ...[
                _buildHiddenInfoPlaceholder(context),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 渐变背景头部
  Widget _buildGradientHeader(
      BuildContext context, AccountProvider accountProvider) {
    final account = accountProvider.account;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8B4B8),
            Color(0xFFD4A5D4),
            Color(0xFFC8B5E8),
          ],
        ),
      ),
      child: Column(
        children: [
          // 顶部导航栏
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const Spacer(),
                if (!widget.isOwnProfile)
                  GestureDetector(
                    onTap: () => _showMoreActions(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 头像和基本信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // 头像
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: account != null
                            ? ImageLoader.avatar(
                                url: account.user.ensureAvatarUrl)
                            : Assets.images.defaultAvatar
                                .image(fit: BoxFit.cover),
                      ),
                    ),
                    // 在线状态
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CD964),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // 用户信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            account?.user.displayName ?? 'Album',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              // 复制ID
                            },
                            child: const Icon(
                              Icons.copy,
                              color: Colors.white70,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ollie ID ${account?.user.id ?? '234423'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      if (!_isInfoHidden) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoTag('Female'),
                            const SizedBox(width: 12),
                            _buildInfoTag('24'),
                            const SizedBox(width: 12),
                            _buildInfoTag('USA'),
                            const SizedBox(width: 12),
                            _buildInfoTag('English'),
                          ],
                        ),
                      ],
                      if (_isInfoHidden) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 30,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 50,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoTag(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: Colors.white.withOpacity(0.95),
      ),
    );
  }

  /// 照片/视频切换标签
  Widget _buildPhotoVideoTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTabButton(
            context,
            title: 'Photos',
            isSelected: _isPhotosTab,
            onTap: () => setState(() => _isPhotosTab = true),
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            context,
            title: 'Video Clips',
            isSelected: !_isPhotosTab,
            onTap: () => setState(() => _isPhotosTab = false),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEB8B8B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected ? null : Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  /// 媒体网格
  Widget _buildMediaGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _buildMediaItem(
              isVideo: !_isPhotosTab,
              isLocked: false,
            ),
            _buildMediaItem(
              isVideo: !_isPhotosTab,
              isLocked: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaItem({
    required bool isVideo,
    required bool isLocked,
  }) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          // 显示解锁提示
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF5F5F5),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 媒体内容
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isLocked
                  ? Container(
                      color: const Color(0xFF999999),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Unlock',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Assets.images.defaultAvatar.image(fit: BoxFit.cover),
            ),
            // 视频播放按钮
            if (isVideo && !isLocked)
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Color(0xFFEB8B8B),
                    size: 24,
                  ),
                ),
              ),
            // 菜单按钮
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu,
                  color: Color(0xFF666666),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 个人信息标签
  Widget _buildProfileTags(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTagSection('What are you looking for', [
            'Just Chatting',
            'Just Chatting',
            'Just Chatting',
          ]),
          const SizedBox(height: 16),
          _buildTagSection('Personality', [
            'Just Chatting',
            'Just Chatting',
            'Just Chatting',
          ]),
          const SizedBox(height: 16),
          _buildTagSection('Hobbies & Interests', [
            'Just Chatting',
            'Just Chatting',
            'Just Chatting',
          ]),
          const SizedBox(height: 16),
          _buildTagSection('Communication Style', [
            'Just Chatting',
            'Just Chatting',
            'Just Chatting',
          ]),
        ],
      ),
    );
  }

  Widget _buildTagSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => _buildTag(tag)).toList(),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5C6C6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 隐藏信息占位
  Widget _buildHiddenInfoPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHiddenSection('What are you looking for'),
          const SizedBox(height: 16),
          _buildHiddenSection('Personality'),
          const SizedBox(height: 16),
          _buildHiddenSection('Hobbies & Interests'),
        ],
      ),
    );
  }

  Widget _buildHiddenSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock,
                size: 16,
                color: Color(0xFF999999),
              ),
              const SizedBox(width: 6),
              Text(
                'Message hidden by the user',
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 显示更多操作弹窗
  void _showMoreActions(BuildContext context) {
    MeDialogs.showMoreActions(
      context,
      actions: [
        MeActionItem(
          title: 'Report',
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.reportUser);
          },
        ),
        MeActionItem(
          title: 'Block',
          onTap: () => _showBlockConfirm(context),
          isDestructive: true,
        ),
      ],
    );
  }

  /// 显示拉黑确认弹窗
  void _showBlockConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Block',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5A3D4A),
          ),
        ),
        content: const Text(
          'Are you sure you want to block this user?',
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
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 执行拉黑操作
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB8B8B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
