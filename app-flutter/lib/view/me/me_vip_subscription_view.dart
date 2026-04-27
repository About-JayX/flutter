import 'package:flutter/material.dart';
import 'package:mobisen_app/util/view_utils.dart';

/// VIP订阅页面
/// 支持周卡/月卡切换展示
class MeVIPSubscriptionView extends StatefulWidget {
  const MeVIPSubscriptionView({super.key});

  @override
  State<MeVIPSubscriptionView> createState() => _MeVIPSubscriptionViewState();
}

class _MeVIPSubscriptionViewState extends State<MeVIPSubscriptionView> {
  bool _isWeekly = true;

  final List<String> _benefits = [
    'VIP Benefits',
    'Viewed Your Profile',
    'Unlock 1-on-1 Video & Voice Calls',
    'Monthly Bonus: 60 Mins Video Time + 120 Mins Voice Time (Expires at the end of the subscription period)',
    'Exclusive Member Badge',
    'Extra Daily Swipes',
    'Swipe Rewind (Undo Last Action)',
    'Chat Lock',
    'Hide Online Status',
    'Full Profile Privacy (Hide Age, Country, Gender)',
    'Higher Video Quality',
    'Voice Noise Reduction',
    'Beauty Filters',
    'Custom Blocked Keywords',
    'No limit on pinned items',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: const Text(
          'My Subscription',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 周卡/月卡切换
            _buildPlanToggle(context),
            const SizedBox(height: 24),
            // VIP特权列表
            _buildBenefitsList(context),
            const SizedBox(height: 24),
            // 价格按钮
            _buildPriceButton(context),
            const SizedBox(height: 24),
            // 订阅条款
            _buildTermsSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// 周卡/月卡切换
  Widget _buildPlanToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildPlanCard(
              title: 'Weekly Plan',
              price: '\$7.99',
              isSelected: _isWeekly,
              onTap: () => setState(() => _isWeekly = true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPlanCard(
              title: 'Monthly Plan',
              price: '\$24.99',
              isSelected: !_isWeekly,
              onTap: () => setState(() => _isWeekly = false),
              badge: 'Save 22% vs Weekly',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEB8B8B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected ? null : Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFEB8B8B).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : const Color(0xFFEB8B8B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFFEB8B8B),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// VIP特权列表
  Widget _buildBenefitsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            _benefits.map((benefit) => _buildBenefitItem(benefit)).toList(),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEB8B8B),
            ),
            child: const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 价格按钮
  Widget _buildPriceButton(BuildContext context) {
    final price = _isWeekly ? '\$7.99' : '\$24.99';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 200,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            // 执行购买
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEB8B8B),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// 订阅条款
  Widget _buildTermsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subscription Terms',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.',
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
