import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/iap/iap_helper.dart';
import 'package:mobisen_app/iap/model/vip_product_wrapper.dart';
import 'package:mobisen_app/provider/account_provider.dart';

class VIPSubscriptionView extends StatefulWidget {
  const VIPSubscriptionView({Key? key}) : super(key: key);

  @override
  State<VIPSubscriptionView> createState() => _VIPSubscriptionViewState();
}

class _VIPSubscriptionViewState extends State<VIPSubscriptionView> {
  List<VIPProductWrapper> _vipItems = [];
  bool _isLoading = true;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _loadVIPItems();
  }

  Future<void> _loadVIPItems() async {
    final accountProvider = context.read<AccountProvider>();
    if (accountProvider.account == null) return;

    try {
      final items =
          await IAPHelper.instance.getVIPItems(accountProvider.account!);
      setState(() {
        _vipItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _purchaseVIP(VIPProductWrapper item) async {
    final accountProvider = context.read<AccountProvider>();
    if (accountProvider.account == null) return;

    setState(() => _isPurchasing = true);

    try {
      await IAPHelper.instance.purchaseVIP(accountProvider.account!, item);

      // 更新账户信息（从 RevenueCat 同步 VIP 状态到本地）
      await accountProvider.syncVIPStatus();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('购买成功'),
            content: const Text('恭喜您成为 VIP 会员！'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('购买失败: $e')),
        );
      }
    } finally {
      setState(() => _isPurchasing = false);
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isPurchasing = true);

    try {
      final customerInfo = await IAPHelper.instance.restorePurchases();
      if (customerInfo != null) {
        final accountProvider = context.read<AccountProvider>();
        await accountProvider.updateAccountProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('购买已恢复')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('恢复失败: $e')),
        );
      }
    } finally {
      setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('VIP 会员'),
        actions: [
          TextButton(
            onPressed: _isPurchasing ? null : _restorePurchases,
            child: const Text('恢复购买'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // VIP 状态卡片
                  if (accountProvider.isVIP)
                    _buildVIPStatusCard(accountProvider),

                  const SizedBox(height: 24),

                  // VIP 特权说明（14项）
                  Text(
                    'VIP 特权',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitsList(),

                  const SizedBox(height: 32),

                  // 套餐列表
                  Text(
                    '选择套餐',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._vipItems.map((item) => _buildVIPCard(item)),

                  const SizedBox(height: 24),

                  // 服务条款
                  const Text(
                    '订阅会自动续费，可随时在设置中取消',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildVIPStatusCard(AccountProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                provider.vipLevelName ?? 'VIP',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (provider.vipRemainingDays != null)
            Text(
              '剩余 ${provider.vipRemainingDays} 天',
              style: const TextStyle(color: Colors.white70),
            ),
          const SizedBox(height: 8),
          // 显示剩余时长
          Row(
            children: [
              Icon(Icons.videocam,
                  color: Colors.white.withOpacity(0.8), size: 16),
              const SizedBox(width: 4),
              Text(
                '视频: ${provider.remainingVideoMinutes} 分钟',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(Icons.phone, color: Colors.white.withOpacity(0.8), size: 16),
              const SizedBox(width: 4),
              Text(
                '语音: ${provider.remainingVoiceMinutes} 分钟',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {'icon': Icons.verified, 'text': '专属会员徽章'},
      {'icon': Icons.swipe, 'text': '每日额外滑动次数 (+8次)'},
      {'icon': Icons.undo, 'text': '滑动倒回（撤销上一次操作）'},
      {'icon': Icons.lock, 'text': '聊天上锁'},
      {'icon': Icons.visibility_off, 'text': '隐身浏览'},
      {'icon': Icons.circle_notifications, 'text': '隐藏在线状态'},
      {'icon': Icons.privacy_tip, 'text': '资料完全隐私'},
      {'icon': Icons.videocam, 'text': '解锁1v1视频通话（每月60分钟）'},
      {'icon': Icons.phone, 'text': '解锁1v1语音通话（每月120分钟）'},
      {'icon': Icons.hd, 'text': '更高清画质'},
      {'icon': Icons.mic, 'text': '语音降噪'},
      {'icon': Icons.face, 'text': '美颜滤镜'},
      {'icon': Icons.visibility, 'text': '查看谁看过你'},
      {'icon': Icons.block, 'text': '自定义屏蔽骚扰词'},
    ];

    return Column(
      children: benefits
          .map((benefit) => ListTile(
                leading: Icon(benefit['icon'] as IconData, color: Colors.amber),
                title: Text(benefit['text'] as String),
                dense: true,
              ))
          .toList(),
    );
  }

  Widget _buildVIPCard(VIPProductWrapper item) {
    // 月会员标记为推荐
    final isPopular = item.type == 'month';
    // 根据类型显示周期标签
    final periodTag = item.type == 'week' ? '周卡' : '月卡';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _isPurchasing ? null : () => _purchaseVIP(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 周期标签
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPopular ? Colors.orange : Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            periodTag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        if (isPopular)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '推荐',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                item.priceString,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
