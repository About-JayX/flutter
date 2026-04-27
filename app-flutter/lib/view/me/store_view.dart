import 'package:flutter/material.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/util/view_utils.dart';

/// 商店页面
/// 支持视频时长包、语音时长包、钻石等商品展示
class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  StoreTab _currentTab = StoreTab.diamonds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ),
      body: Column(
        children: [
          // Tab切换
          _buildTabBar(context),
          const SizedBox(height: 16),
          // 内容区域
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentTab) {
      case StoreTab.video:
        return 'Video Chat Pack';
      case StoreTab.voice:
        return 'Voice Chat Pack';
      case StoreTab.diamonds:
        return 'Get Diamonds';
    }
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              title: 'Video',
              isSelected: _currentTab == StoreTab.video,
              onTap: () => setState(() => _currentTab = StoreTab.video),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(
              title: 'Voice',
              isSelected: _currentTab == StoreTab.voice,
              onTap: () => setState(() => _currentTab = StoreTab.voice),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(
              title: 'Diamonds',
              isSelected: _currentTab == StoreTab.diamonds,
              onTap: () => setState(() => _currentTab = StoreTab.diamonds),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEB8B8B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected ? null : Border.all(color: const Color(0xFFEEEEEE)),
        ),
        alignment: Alignment.center,
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

  Widget _buildContent(BuildContext context) {
    switch (_currentTab) {
      case StoreTab.video:
        return _buildDurationPacks(context, isVideo: true);
      case StoreTab.voice:
        return _buildDurationPacks(context, isVideo: false);
      case StoreTab.diamonds:
        return _buildDiamondsList(context);
    }
  }

  /// 时长包列表（视频/语音）
  Widget _buildDurationPacks(BuildContext context, {required bool isVideo}) {
    final items = [
      {'duration': '30 mins', 'price': '150 Diamonds'},
      {'duration': '60 mins', 'price': '280 Diamonds'},
      {'duration': '120 mins', 'price': '520 Diamonds'},
      {'duration': '300 mins', 'price': '1000 Diamonds'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item['duration']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB8B8B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    item['price']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 钻石列表
  Widget _buildDiamondsList(BuildContext context) {
    final items = [
      {'amount': '35 Diamonds', 'price': '\$0.99'},
      {'amount': '200 Diamonds', 'price': '\$4.99'},
      {'amount': '450 Diamonds', 'price': '\$9.99'},
      {'amount': '1,100 Diamonds (Bonus 100)', 'price': '\$19.99'},
      {'amount': '3,400 Diamonds (Bonus 600)', 'price': '\$49.99'},
      {'amount': '8,000 Diamonds (Bonus 2,000)', 'price': '\$99.99'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) {
          return _buildDiamondsFooter(context);
        }

        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['amount']!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB8B8B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    item['price']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiamondsFooter(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _currentTab = StoreTab.voice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB8B8B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Voice Chat Pack',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _currentTab = StoreTab.video),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB8B8B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Video Chat Pack',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Prices are in US dollars.\nPayment will be charged to your Apple account upon purchase.\nAll purchases of virtual items are final and non-refundable.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF999999),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

enum StoreTab {
  video,
  voice,
  diamonds,
}
