import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/widget/image_loader.dart';

/// 首页Tab - 我的模块（无信息状态）
class MeTabView extends StatelessWidget {
  const MeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final account = accountProvider.account;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 渐变背景区域
              _buildGradientHeader(context, accountProvider),
              // 统计按钮行
              _buildStatsRow(context),
              const SizedBox(height: 16),
              // VIP按钮
              _buildVIPButton(context),
              const SizedBox(height: 16),
              // Album/Videos 切换
              _buildAlbumVideoTabs(context),
              const SizedBox(height: 16),
              // 照片网格区域
              _buildPhotoGrid(context),
              const SizedBox(height: 16),
              // Wallet入口
              _buildWalletEntry(context),
              const SizedBox(height: 32),
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
          // 右上角设置按钮
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 设置按钮
                  GestureDetector(
                    onTap: () {
                      if (ViewUtils.jumpToLogin(context, accountProvider))
                        return;
                      Navigator.pushNamed(context, RoutePaths.settings);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 更多按钮
                  GestureDetector(
                    onTap: () {
                      // 显示更多弹窗
                    },
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
          ),
          // 头像和基本信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // 头像
                GestureDetector(
                  onTap: () {
                    if (ViewUtils.jumpToLogin(context, accountProvider)) return;
                    Navigator.pushNamed(context, RoutePaths.meProfile);
                  },
                  child: Stack(
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
                      // 在线状态指示器
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
                ),
                const SizedBox(width: 16),
                // 用户信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account?.user.displayName ?? 'Guest',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${account?.user.username ?? '--'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'ID ${account?.user.id ?? '------'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
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

  /// 统计按钮行
  Widget _buildStatsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatButton(
              context,
              title: '0 Likes',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatButton(
              context,
              title: 'Who Likes Me',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatButton(
              context,
              title: 'My Feed',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatButton(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.add_circle_outline,
              size: 16,
              color: Color(0xFFEB8B8B),
            ),
          ],
        ),
      ),
    );
  }

  /// VIP按钮
  Widget _buildVIPButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.vipSubscription);
        },
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF5A0A0),
                Color(0xFFEB8B8B),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEB8B8B).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'VIP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Unlock VIP, Get More Perks',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Album/Videos 切换标签
  Widget _buildAlbumVideoTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTabButton(
            context,
            title: 'Album',
            isSelected: true,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            context,
            title: 'Videos',
            isSelected: false,
            onTap: () {},
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

  /// 照片网格
  Widget _buildPhotoGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
          padding: const EdgeInsets.all(12),
          children: [
            // 添加照片按钮
            GestureDetector(
              onTap: () {
                // 显示照片/视频设置弹窗
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add,
                  size: 40,
                  color: Color(0xFFCCCCCC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Wallet入口
  Widget _buildWalletEntry(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.walletDetails);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 24,
                color: Color(0xFF333333),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
