import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobisen_app/model/square/post_model.dart';
import 'package:mobisen_app/model/square/comment_model.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/util/log.dart';

class SquareProvider extends ChangeNotifier {
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<String> _topics = [];
  List<String> get topics => _topics;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _currentPage = 1;
  static const int _pageSize = 12;

  String? _selectedTopic;
  String? get selectedTopic => _selectedTopic;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService.instance;

  Future<void> loadPosts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _posts.clear();
      _errorMessage = null;
    }

    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = _apiService.handleResponse(
        await _apiService.request(
          '/api/feed/posts',
          queryParams: {
            'page': _currentPage.toString(),
            'limit': _pageSize.toString(),
            if (_selectedTopic != null && _selectedTopic != 'All Categories')
              'purpose': _selectedTopic,
          },
        ),
      );

      if (response.status == '0' && response.data != null) {
        final List<dynamic> postsData = response.data is List
            ? response.data
            : (response.data['posts'] ?? []);
        final List<PostModel> newPosts = postsData.map((json) {
          // Safe tags parsing for object array format
          List<Map<String, dynamic>> getTags(dynamic tags) {
            if (tags == null) return [];
            if (tags is List) {
              return tags.map((t) {
                if (t is Map) {
                  return {'emoji': t['emoji'] ?? '', 'text': t['text'] ?? ''};
                }
                return {'emoji': '', 'text': t.toString()};
              }).toList();
            }
            if (tags is String) {
              try {
                final decoded = jsonDecode(tags);
                if (decoded is List) {
                  return decoded.map((t) {
                    if (t is Map) {
                      return {
                        'emoji': t['emoji'] ?? '',
                        'text': t['text'] ?? ''
                      };
                    }
                    return {'emoji': '', 'text': t.toString()};
                  }).toList();
                }
              } catch (e) {}
            }
            return [];
          }

          final tags = getTags(json['tags']);
          final firstTag = tags.isNotEmpty ? tags[0] : null;

          return PostModel(
            id: json['id'] ?? '',
            username: json['userNickName'] ?? json['username'] ?? 'Anonymous',
            avatarUrl: json['avatar'],
            hashtagsHead: firstTag != null ? '${firstTag['emoji']} ' : '',
            hashtagsCon: firstTag != null
                ? '${firstTag['text']}'
                : (json['purpose'] ?? ''),
            content: json['content'] ?? '',
            createdAt: json['createdAt'] != null
                ? DateTime.parse(json['createdAt'])
                : DateTime.now(),
            likeCount: json['likeCount'] ?? 0,
            isLiked: json['isLiked'] ?? false,
            friendStatus: 'none',
            commentCount: json['commentCount'] ?? 0,
            isAnonymous: json['isAnonymous'] == 1,
            tags: tags.isNotEmpty
                ? tags.map((t) => '${t['emoji']}${t['text']}').toList()
                : null,
            images: json['images'] != null
                ? List<String>.from(json['images'])
                : null,
          );
        }).toList();

        if (refresh) {
          _posts = newPosts;
        } else {
          _posts.addAll(newPosts);
        }

        _hasMore = newPosts.length == _pageSize;
        _currentPage++;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = 'Failed to load posts. Please try again.';
      print('Failed to load posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    await loadPosts();
  }

  Future<void> refresh() async {
    await loadPosts(refresh: true);
  }

  Future<void> loadTopics() async {
    try {
      _topics = [
        'Daily Life Sharing',
        'Hobby & Interest Chat',
        'Casual Chat',
        'Make New Friends',
        'Emotional Support',
        'All Categories',
      ];
      notifyListeners();
    } catch (e) {
      print('Failed to load topics: $e');
    }
  }

  void selectTopic(String? topic) {
    _selectedTopic = topic;
    loadPosts(refresh: true);
  }

  Future<bool> publishPost({
    required String content,
    String? topic,
    List<String>? images,
    PostVisibility visibility = PostVisibility.everyone,
    String? purpose,
    bool allowGreetings = true,
    int? expireHours,
    bool isAnonymous = false,
    List<Map<String, String>>? tags,
  }) async {
    try {
      final response = _apiService.handleResponse(
        await _apiService.request(
          '/api/feed/post',
          method: HttpMethod.post,
          body: {
            'content': content,
            'purpose': purpose ?? topic,
            'visibility': visibility == PostVisibility.everyone
                ? 'public'
                : visibility == PostVisibility.friends
                    ? 'friends'
                    : 'only_me',
            'images': images,
            'tags': tags,
            'isAnonymous': isAnonymous,
          },
        ),
      );

      if (response.status == '0') {
        await refresh();
        return true;
      }
    } catch (e) {
      print('Failed to publish post: $e');
    }
    return false;
  }

  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final newIsLiked = !post.isLiked;
    final newLikeCount = newIsLiked ? post.likeCount + 1 : post.likeCount - 1;

    _posts[index] = post.copyWith(
      isLiked: newIsLiked,
      likeCount: newLikeCount < 0 ? 0 : newLikeCount,
    );
    notifyListeners();

    try {
      await _apiService.request(
        '/api/feed/like',
        method: HttpMethod.post,
        body: {'postId': postId},
      );
    } catch (e) {
      _posts[index] = post;
      notifyListeners();
      print('Failed to toggle like: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    LogD('deletePost called with postId: $postId');

    // 1. 立即从本地列表移除（UI 立刻更新）
    LogD('Removing post from local list immediately');
    _posts.removeWhere((post) => post.id == postId);
    LogD('Post removed from list. Current count: ${_posts.length}');
    notifyListeners();
    LogD('notifyListeners called');

    // 2. 异步调用 API（后台执行，不影响 UI）
    try {
      LogD('Making API request to delete post: $postId');
      await _apiService.request(
        '/api/feed/post/$postId',
        method: HttpMethod.post,
      );
      LogD('API request successful');
    } catch (e) {
      LogE('API call failed, but post already removed from UI: $e');
      // 可选：如果 API 失败，可以重新加载列表或显示提示
    }
  }

  Future<List<CommentModel>> loadComments(String postId, {int page = 1}) async {
    try {
      final response = _apiService.handleResponse(
        await _apiService.request(
          '/api/feed/comments',
          queryParams: {
            'postId': postId,
            'page': page,
            'limit': 20,
          },
        ),
      );

      if (response.status == '0' && response.data != null) {
        final List<dynamic> commentsData = response.data['comments'] ?? [];
        return commentsData.map((json) {
          return CommentModel(
            id: json['id'] ?? '',
            postId: postId,
            username: json['username'] ?? 'Anonymous',
            content: json['content'] ?? '',
            createdAt: json['createdAt'] != null
                ? DateTime.parse(json['createdAt'])
                : DateTime.now(),
            parentId: json['parentId'],
          );
        }).toList();
      }
    } catch (e) {
      print('Failed to load comments: $e');
    }
    return [];
  }

  Future<bool> addComment(String postId, String content,
      {String? parentId}) async {
    try {
      final response = _apiService.handleResponse(
        await _apiService.request(
          '/api/feed/comment',
          method: HttpMethod.post,
          body: {
            'postId': postId,
            'content': content,
            if (parentId != null) 'parentId': parentId,
          },
        ),
      );

      if (response.status == '0') {
        final index = _posts.indexWhere((post) => post.id == postId);
        if (index != -1) {
          final post = _posts[index];
          _posts[index] = post.copyWith(
            commentCount: (post.commentCount ?? 0) + 1,
          );
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      print('Failed to add comment: $e');
    }
    return false;
  }

  Future<bool> deleteComment(String postId, String commentId) async {
    try {
      await _apiService.request(
        '/api/feed/comment/$commentId',
        method: HttpMethod.post,
      );

      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        _posts[index] = post.copyWith(
          commentCount:
              (post.commentCount ?? 0) > 0 ? (post.commentCount ?? 0) - 1 : 0,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('Failed to delete comment: $e');
    }
    return false;
  }

  void cleanExpiredPosts() {
    _posts.removeWhere((post) => post.isExpired);
    notifyListeners();
  }
}
