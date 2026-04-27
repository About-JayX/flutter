import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/model/matching/match_model.dart';
import 'package:mobisen_app/provider/matching_provider.dart';
import 'package:mobisen_app/widget/dialog/like_dialog.dart';
import 'package:mobisen_app/widget/dialog/filter_dialog.dart';
import 'package:mobisen_app/widget/dialog/vip_limit_dialog.dart';

class InterestCardsView extends StatefulWidget {
  const InterestCardsView({super.key});

  @override
  State<InterestCardsView> createState() => _InterestCardsViewState();
}

class _InterestCardsViewState extends State<InterestCardsView>
    with TickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardAnimation;

  double _dragStartX = 0;
  double _dragPosition = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchingProvider>().loadRecommendations(refresh: true);
    });

    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _cardAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
    _isDragging = true;
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      _dragPosition = details.globalPosition.dx - _dragStartX;
    });
  }

  void _onPanEnd(DragEndDetails details, MatchingProvider provider) {
    if (!_isDragging) return;

    final velocity = details.velocity.pixelsPerSecond.dx;
    final threshold = MediaQuery.of(context).size.width * 0.25;

    if (_dragPosition.abs() > threshold || velocity.abs() > 500) {
      // 滑动超过阈值，执行喜欢/不喜欢
      final isLike = _dragPosition < 0; // 左滑喜欢
      _animateCardOut(isLike, provider);
    } else {
      // 滑动未超过阈值，回弹
      _resetCardPosition();
    }

    _isDragging = false;
    _dragPosition = 0;
  }

  void _animateCardOut(bool isLike, MatchingProvider provider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final endOffset = isLike ? -screenWidth : screenWidth;

    _cardAnimation = Tween<Offset>(
      begin: Offset(_dragPosition / screenWidth, 0),
      end: Offset(endOffset / screenWidth, 0),
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOut,
    ));

    _cardAnimationController.forward(from: 0).then((_) {
      _handleSwipeAction(isLike, provider);
      _cardAnimationController.reset();
    });
  }

  void _resetCardPosition() {
    final screenWidth = MediaQuery.of(context).size.width;

    _cardAnimation = Tween<Offset>(
      begin: Offset(_dragPosition / screenWidth, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _cardAnimationController.forward(from: 0).then((_) {
      _cardAnimationController.reset();
    });
  }

  void _handleSwipeAction(bool isLike, MatchingProvider provider) {
    final card = provider.currentCard;
    if (card == null) return;

    // 检查VIP限制
    if (provider.hasReachedSwipeLimit) {
      _showVIPLimitDialog();
      return;
    }

    if (isLike) {
      // 左滑 - 喜欢
      provider.likeUser(card.userId);
      _showLikeDialog(card);
    } else {
      // 右滑 - 不喜欢
      provider.dislikeUser(card.userId);
    }
  }

  void _showLikeDialog(UserCard card) {
    LikeDialog.show(
      context: context,
      userName: card.displayName ?? card.username,
      avatarUrl: card.avatarUrl,
      onSend: (message) {
        final provider = context.read<MatchingProvider>();
        provider.sendGreeting(
          userId: card.userId,
          message: message,
        );
      },
    );
  }

  void _showFilterDialog(MatchingProvider provider) {
    FilterDialog.show(
      context: context,
      initialGender: provider.selectedGender,
      initialAgeRange: provider.ageRange,
      onConfirm: (gender, ageRange) {
        provider.updateGenderFilter(gender);
        provider.updateAgeRangeFilter(ageRange);
        provider.applyFilter();
      },
    );
  }

  void _showVIPLimitDialog() {
    VIPLimitDialog.show(
      context: context,
      currentSwipeCount: MatchingProvider.maxFreeSwipes,
      maxFreeSwipes: MatchingProvider.maxFreeSwipes,
      onUpgrade: () {
        Navigator.pushNamed(context, RoutePaths.vipSubscription);
      },
    );
  }

  void _navigateToEditCard() {
    Navigator.pushNamed(context, RoutePaths.editCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Consumer<MatchingProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.userCards.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B9D),
                ),
              );
            }

            if (provider.userCards.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                // 顶部导航栏
                _buildAppBar(provider),

                // 卡片堆叠区域
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        // 背景卡片
                        ..._buildBackgroundCards(provider),

                        // 顶部卡片（可滑动）
                        _buildTopCard(provider),
                      ],
                    ),
                  ),
                ),

                // 底部操作栏
                _buildBottomActions(provider),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(MatchingProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),

          // 标题
          const Text(
            'Discover',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // Filter按钮
          GestureDetector(
            onTap: () => _showFilterDialog(provider),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.tune,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundCards(MatchingProvider provider) {
    final cards = provider.userCards;
    final currentIndex = provider.currentIndex;

    List<Widget> backgroundCards = [];

    for (int i = currentIndex + 2; i > currentIndex; i--) {
      if (i < cards.length) {
        final offset = i - currentIndex;
        backgroundCards.add(
          Positioned.fill(
            top: offset * 8.0,
            left: offset * 4.0,
            right: offset * 4.0,
            child: Opacity(
              opacity: 1.0 - (offset * 0.2),
              child: _buildCardContent(cards[i], isTop: false),
            ),
          ),
        );
      }
    }

    return backgroundCards;
  }

  Widget _buildTopCard(MatchingProvider provider) {
    final card = provider.currentCard;
    if (card == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final dragOffset = _isDragging ? _dragPosition / screenWidth : 0.0;

    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        final animatedOffset = _cardAnimation.value;
        final totalOffset =
            _isDragging ? Offset(dragOffset, 0) : animatedOffset;

        return Transform.translate(
          offset: Offset(totalOffset.dx * screenWidth, 0),
          child: Transform.rotate(
            angle: totalOffset.dx * 0.1,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: (details) => _onPanEnd(details, provider),
              child: _buildCardContent(card, isTop: true),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(UserCard card, {required bool isTop}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isTop
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // 照片区域
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 主照片
                  _buildCardImage(card),

                  // 渐变遮罩
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 在线状态
                  if (card.isOnline)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 匹配度
                  if (card.matchScore > 0)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B9D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(card.matchScore * 100).toInt()}% Match',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // 底部信息
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              card.displayName ?? card.username,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (card.age != null)
                              Text(
                                '${card.age}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (card.location != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                card.location!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        if (card.bio != null)
                          Text(
                            card.bio!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 兴趣标签区域
            if (card.interests.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: card.interests.map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        interest,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(UserCard card) {
    if (card.photos.isNotEmpty) {
      return Image.network(
        card.photos.first,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    }

    if (card.avatarUrl != null) {
      return Image.network(
        card.avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    }

    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.person,
          size: 80,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildBottomActions(MatchingProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // 主要操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 不喜欢按钮
              _buildActionButton(
                icon: Icons.close,
                color: const Color(0xFFFF5252),
                backgroundColor: const Color(0xFFFFEBEE),
                onPressed: () {
                  final card = provider.currentCard;
                  if (card != null) {
                    if (provider.hasReachedSwipeLimit) {
                      _showVIPLimitDialog();
                      return;
                    }
                    provider.dislikeUser(card.userId);
                  }
                },
              ),

              // Star chat按钮
              _buildStarChatButton(),

              // 喜欢按钮
              _buildActionButton(
                icon: Icons.favorite,
                color: const Color(0xFFFF6B9D),
                backgroundColor: const Color(0xFFFCE4EC),
                onPressed: () {
                  final card = provider.currentCard;
                  if (card != null) {
                    if (provider.hasReachedSwipeLimit) {
                      _showVIPLimitDialog();
                      return;
                    }
                    provider.likeUser(card.userId);
                    _showLikeDialog(card);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // VIP提示
          if (provider.hasReachedSwipeLimit)
            GestureDetector(
              onTap: _showVIPLimitDialog,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.diamond,
                      size: 16,
                      color: Color(0xFFFFA500),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Upgrade to VIP for unlimited swipes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFA500),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildStarChatButton() {
    return GestureDetector(
      onTap: _navigateToEditCard,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No more users',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adjust filters or try again later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context
                  .read<MatchingProvider>()
                  .loadRecommendations(refresh: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
