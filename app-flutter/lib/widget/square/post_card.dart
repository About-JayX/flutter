import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/model/square/post_model.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onSayHi;
  final VoidCallback onExpand;
  final VoidCallback onMore;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool removeTopMargin;
  final bool removeBottomMargin;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSayHi,
    required this.onExpand,
    required this.onMore,
    this.onComment,
    this.onShare,
    this.removeTopMargin = false,
    this.removeBottomMargin = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late PostModel _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id) {
      _post = widget.post;
    }
  }

  String get _friendStatusText {
    switch (widget.post.friendStatus) {
      case 'pending':
        return 'Pending';
      case 'chatting':
        return 'Chatting';
      default:
        return 'Say Hi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: widget.removeTopMargin ? 0 : 18.33,
        bottom: widget.removeBottomMargin ? 0 : 18.33,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(226, 219, 219, 1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Username + More button
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.black.withOpacity(.2),
                    width: 45,
                    height: 45,
                    child: widget.post.isAnonymous
                        ? const Icon(Icons.person_outline, color: Colors.grey)
                        : Image(
                            image: widget.post.avatarUrl != null
                                ? NetworkImage(widget.post.avatarUrl!)
                                : Assets.images.defaultAvatar.provider(),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                // CircleAvatar(
                //   radius: 20,
                //   backgroundImage: widget.post.avatarUrl != null
                //       ? NetworkImage(widget.post.avatarUrl!)
                //       : Assets.images.defaultAvatar.provider(),
                // ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.isAnonymous
                            ? (widget.post.anonymousName ?? 'Anonymous')
                            : widget.post.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      if (widget.post.isAnonymous)
                        const Text(
                          'Anonymous',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                    ],
                  ),
                ),
                // 过期标签
                if (widget.post.expireAt != null && !widget.post.isExpired)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.post.remainingTime!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: widget.onMore,
                  icon: const Icon(Icons.more_horiz,
                      color: Color.fromRGBO(189, 189, 189, 1), size: 30),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: double.infinity,
                height: 1,
                // padding: EdgeInsets.only(left: ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(221, 221, 221, .1),
                    Color.fromRGBO(221, 221, 221, 1),
                    Color.fromRGBO(221, 221, 221, .1),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hashtags
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.post.hashtagsHead,
                          style: const TextStyle(fontSize: 10),
                        ),
                        TextSpan(
                          text: widget.post.hashtagsCon,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(159, 159, 159, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // Content
                  _buildContent(),
                  // 图片网格
                  if (widget.post.images != null &&
                      widget.post.images!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildImageGrid(widget.post.images!),
                  ],
                  const SizedBox(height: 12),
                  // Date
                  Text(
                    _formatDate(widget.post.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Expire info
                  if (widget.post.expireHours != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'This post will expire in ${widget.post.expireHours} hours, Countdown: ${_formatCountdown(widget.post.expireHours!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),

            // Actions: Like + Friend Status
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Like button
                GestureDetector(
                  onTap: widget.onLike,
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 18,
                        color: widget.post.isLiked
                            ? const Color.fromRGBO(238, 151, 145, 1)
                            : const Color(0xFF9E9E9E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.post.likeCount}',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.post.isLiked
                              ? const Color.fromRGBO(238, 151, 145, 1)
                              : const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Comment button
                if (widget.onComment != null)
                  GestureDetector(
                    onTap: widget.onComment,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.comment_outlined,
                          size: 18,
                          color: Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.post.commentCount}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 16),
                // Share button
                if (widget.onShare != null)
                  GestureDetector(
                    onTap: widget.onShare,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.post.shareCount}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 16),
                // Friend status
                if (widget.post.friendStatus != 'none')
                  GestureDetector(
                    onTap: widget.onSayHi,
                    child: Text(
                      _friendStatusText,
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.post.friendStatus == 'chatting'
                            ? ThemeHelper.primaryColor
                            : const Color(0xFF9E9E9E),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (!widget.post.isLongContent) {
      return Text(
        widget.post.content,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF333333),
          height: 1.5,
        ),
      );
    }

    if (widget.post.isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.content,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF333333),
              height: 1.5,
            ),
          ),
          GestureDetector(
            onTap: widget.onExpand,
            child: const Text(
              'Collapse',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    // Truncated content with "more" button
    final truncated = widget.post.content.length > 150
        ? '${widget.post.content.substring(0, 150)}...'
        : widget.post.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          truncated,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            height: 1.5,
          ),
        ),
        GestureDetector(
          onTap: widget.onExpand,
          child: const Text(
            'more',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCountdown(int hours) {
    return '${hours.toString().padLeft(2, '0')}:00:00';
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    final imageCount = images.length;

    if (imageCount == 1) {
      // Single image - full width
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    // Multiple images - grid layout
    final crossAxisCount = imageCount == 2 ? 2 : (imageCount >= 4 ? 3 : 2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: imageCount > 4 ? 4 : imageCount,
          itemBuilder: (context, index) {
            final isLastWithMore = imageCount > 4 && index == 3;
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                if (isLastWithMore)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: Text(
                      '+${imageCount - 4}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
