import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/model/square/post_model.dart';
import 'package:mobisen_app/provider/square_provider.dart';
import 'package:mobisen_app/widget/square/post_card.dart';
import 'package:mobisen_app/widget/square/post_more_sheet.dart';
import 'package:mobisen_app/widget/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/log.dart';

class HomeSquareView extends StatefulWidget {
  const HomeSquareView({super.key});

  @override
  State<HomeSquareView> createState() => _HomeSquareViewState();
}

class _HomeSquareViewState extends State<HomeSquareView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SquareProvider>();
      provider.loadPosts();
      provider.loadTopics();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<SquareProvider>();
      if (!provider.isLoading && provider.hasMore) {
        provider.loadMore();
      }
    }
  }

  void _handleSayHi(String postId) {
    // TODO: Implement say hi functionality
  }

  void _handleMore(String postId) {
    LogD('_handleMore called with postId: $postId');
    final provider = context.read<SquareProvider>();
    LogD('Provider obtained, posts count: ${provider.posts.length}');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => PostMoreSheet(
        onNotInterested: () {
          LogD('onNotInterested called for postId: $postId');
          CustomDialog.show(
            context,
            title: 'Not Interested',
            description: 'We will show fewer posts like this.',
            showCancel: false,
            confirmText: 'Got it',
            onConfirm: () {
              LogD('onConfirm called - attempting to delete postId: $postId');
              LogD(
                  'Current posts before delete: ${provider.posts.map((p) => p.id).toList()}');
              provider.deletePost(postId).then((_) {
                LogD('deletePost completed successfully');
                LogD(
                    'Current posts after delete: ${provider.posts.map((p) => p.id).toList()}');
              }).catchError((e) {
                LogE('deletePost failed: $e');
              });
            },
          );
        },
        onReport: () {
          LogD('onReport called for postId: $postId');
          Navigator.pushNamed(context, RoutePaths.report);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const headerHeight = 93.5;
    const overlapHeight = 25.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<SquareProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  // 粉色顶部区域
                  Container(
                    height: headerHeight + statusBarHeight,
                    color: const Color(0xFFF3D2D0),
                  ),
                  // 灰色内容区域（Expanded 填充剩余空间）
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, -overlapHeight),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        child: Container(
                          color: const Color(0xFFF5F5F5),
                          child: RefreshIndicator(
                            onRefresh: () => provider.refresh(),
                            backgroundColor: Colors.white,
                            color: ThemeHelper.primaryColor,
                            triggerMode: RefreshIndicatorTriggerMode.anywhere,
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                // if (provider.topics.isNotEmpty)
                                //   SliverToBoxAdapter(
                                //     child: _buildTopicBar(provider),
                                //   ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 16,
                                  ),
                                ),
                                if (provider.isLoading &&
                                    provider.posts.isEmpty)
                                  const SliverFillRemaining(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (provider.posts.isEmpty)
                                  SliverFillRemaining(
                                    child: _buildEmptyState(),
                                  )
                                else
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        if (index == provider.posts.length) {
                                          return _buildLoadMoreIndicator(
                                              provider);
                                        }
                                        final post = provider.posts[index];
                                        return PostCard(
                                          post: post,
                                          onLike: () =>
                                              provider.toggleLike(post.id),
                                          onSayHi: () => _handleSayHi(post.id),
                                          onExpand: () {
                                            setState(() {
                                              final postIndex = provider.posts
                                                  .indexWhere(
                                                      (p) => p.id == post.id);
                                              if (postIndex != -1) {
                                                final updatedPost = provider
                                                    .posts[postIndex]
                                                    .copyWith(
                                                  isExpanded: !provider
                                                      .posts[postIndex]
                                                      .isExpanded,
                                                );
                                                provider.posts[postIndex] =
                                                    updatedPost;
                                              }
                                            });
                                          },
                                          onMore: () => _handleMore(post.id),
                                          removeTopMargin: index == 0,
                                          removeBottomMargin: index ==
                                              provider.posts.length - 1,
                                        );
                                      },
                                      childCount: provider.posts.length +
                                          (provider.hasMore ? 1 : 0),
                                    ),
                                  ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).padding.bottom +
                                            80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 圆环按钮（精确定位，与原版一致）
              Positioned(
                top: (headerHeight + statusBarHeight) - 38 - 30,
                right: 14.5,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, RoutePaths.postPublish),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF80576B),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF80576B),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share something!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator(SquareProvider provider) {
    if (!provider.hasMore && provider.posts.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No more posts',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }

    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTopicBar(SquareProvider provider) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.topics.length,
        itemBuilder: (context, index) {
          final topic = provider.topics[index];
          final isSelected = provider.selectedTopic == topic;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (selected) {
                provider.selectTopic(selected ? topic : null);
              },
              selectedColor: ThemeHelper.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF666666),
                fontSize: 13,
              ),
              backgroundColor: const Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? ThemeHelper.primaryColor
                      : const Color(0xFFE0E0E0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
