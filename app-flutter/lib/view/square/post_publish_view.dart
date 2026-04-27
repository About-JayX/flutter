import 'dart:io';
import 'package:mobisen_app/util/theme_helper.dart';

import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/model/square/post_model.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/square_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/widget/custom_dialog.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/widget/square/duration_picker_dialog.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/widget/square/toggle_switch.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/widget/vip/vip_feature_lock.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class PostPublishView extends StatefulWidget {
  const PostPublishView({super.key});

  @override
  State<PostPublishView> createState() => _PostPublishViewState();
}

class _PostPublishViewState extends State<PostPublishView> {
  final TextEditingController _contentController = TextEditingController();
  final PublishFormModel _form = PublishFormModel();
  bool _hasContent = false;
  int _charCount = 0;
  static const int _maxChars = 800;

  // 新增：图片选择
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _selectedImages = [];

  // 新增：可见范围
  PostVisibility _visibility = PostVisibility.everyone;

  // 新增：匿名发布
  bool _isAnonymous = false;

  // 新增：交友目的
  String? _selectedPurpose;
  final List<String> _purposes = [
    'Daily Life Sharing',
    'Hobby & Interest Chat',
    'Casual Chat',
    'Make New Friends',
    'Emotional Support',
    'All Categories'
  ];

  final List<TopicModel> _topics = [
    TopicModel(
        id: '1', emoji: '🥾', text: 'Need to get outside this weekend #'),
    TopicModel(id: '2', emoji: '🍳', text: 'Want to try a new restaurant #'),
    TopicModel(
        id: '3', emoji: '🎸', text: 'Learning guitar, need motivation #'),
    TopicModel(id: '4', emoji: '🎬', text: 'Looking for a movie buddy #'),
    TopicModel(id: '5', emoji: '📚', text: 'In a reading slump, need recs'),
    TopicModel(id: '6', emoji: '☕', text: 'Need caffeine to function'),
    TopicModel(id: '7', emoji: '🍕', text: 'Ordering takeout = self-care'),
    TopicModel(id: '8', emoji: '🛋️', text: 'Doing nothing, zero guilt'),
    TopicModel(id: '9', emoji: '🌙', text: 'Up too late for no reason'),
    TopicModel(
        id: '10', emoji: '📺', text: 'Binge-watching something I won\'t admit'),
    TopicModel(
        id: '11',
        emoji: '🎵',
        text: 'Need a playlist and someone to send it to'),
    TopicModel(
        id: '12', emoji: '🍳', text: 'Attempting to cook, probably failing'),
  ];

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _contentController.removeListener(_onContentChanged);
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    setState(() {
      _charCount = _contentController.text.length;
      _hasContent = _contentController.text.trim().isNotEmpty;
      if (_charCount > _maxChars) {
        _showMaxCharWarning();
      }
    });
  }

  void _showMaxCharWarning() {
    CustomDialog.showSingleButton(
      context,
      title: 'Maximum character limit reached.',
      description:
          'You have reached the maximum character limit of $_maxChars.',
      confirmText: 'Got it',
      icon: Icons.warning_amber_rounded,
    );
  }

  void _showNoContentWarning() {
    CustomDialog.showSingleButton(
      context,
      title: 'Enter Post Content',
      description: 'Please enter some content before publishing.',
      confirmText: 'Got it',
      icon: Icons.warning_amber_rounded,
    );
  }

  void _showBackConfirmDialog() {
    if (_hasContent) {
      CustomDialog.showWithWarning(
        context,
        title: 'Set Password:',
        description:
            'You can save this content to publish later from your drafts.',
        cancelText: 'Discard',
        confirmText: 'Save',
        onCancel: () {
          Navigator.pop(context);
        },
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImages() async {
    final images = await _imagePicker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
        if (_selectedImages.length > 9) {
          _selectedImages = _selectedImages.sublist(0, 9);
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _handlePublish() async {
    if (!_hasContent && _selectedImages.isEmpty) {
      _showNoContentWarning();
      return;
    }

    // TODO: 上传图片获取 URL
    final imageUrls = <String>[];

    final provider = context.read<SquareProvider>();
    final selectedTopic = _topics.firstWhere(
      (t) => t.id == _form.selectedTopicId,
      orElse: () => _topics.last,
    );
    final success = await provider.publishPost(
      content: _contentController.text.trim(),
      topic: selectedTopic.text,
      images: imageUrls.isNotEmpty ? imageUrls : null,
      visibility: _visibility,
      purpose: _selectedPurpose,
      allowGreetings: _form.allowGreetingsViaTopics,
      expireHours: _form.visibilityDuration == 'permanent'
          ? null
          : int.parse(_form.visibilityDuration.replaceAll('h', '')),
      isAnonymous: _isAnonymous,
      tags: [
        {'emoji': selectedTopic.emoji, 'text': selectedTopic.text}
      ],
    );

    if (success) {
      if (mounted) {
        CustomDialog.showSingleButton(
          context,
          title: 'Success',
          description: 'Your post has been published!',
          confirmText: 'OK',
          onConfirm: () => Navigator.pop(context),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('发布失败，请重试')),
        );
      }
    }
  }

  void _selectTopic(String topicId) {
    setState(() {
      _form.selectedTopicId = topicId;
    });
  }

  void _showDurationPicker() {
    showDialog(
      context: context,
      builder: (context) => DurationPickerDialog(
        selectedDuration: _form.visibilityDuration,
        onSelect: (duration) {
          setState(() {
            _form.visibilityDuration = duration;
          });
        },
      ),
    );
  }

  void _showCustomTopicInput(AccountProvider accountProvider) {
    // 检查 VIP 权限
    if (!accountProvider.canCreateCustomTopic) {
      showDialog(
        context: context,
        builder: (context) => VIPFeatureLock(
          featureName: 'Custom Topics',
          onUpgrade: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RoutePaths.vipSubscription);
          },
        ),
      );
      return;
    }

    // TODO: 实现自定义话题输入
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Topic'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter your custom topic...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeHelper.primaryColor,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String get _selectedTopicText {
    final topic = _topics.firstWhere(
      (t) => t.id == _form.selectedTopicId,
      orElse: () => _topics.last,
    );
    return topic.text;
  }

  String get _durationText {
    switch (_form.visibilityDuration) {
      case '4h':
        return '4 Hours';
      case '24h':
        return '24 Hours';
      default:
        return 'Permanent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: _showBackConfirmDialog,
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
        ),
        title: const Text(
          'Share Your Mood',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: _hasContent ? _handlePublish : null,
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Post'),
              style: TextButton.styleFrom(
                backgroundColor: _hasContent
                    ? ThemeHelper.primaryColor
                    : const Color(0xFFBDBDBD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content input
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: 
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 26, right: 26, top: 15.67, bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child:
                            TextField(
                              controller: _contentController,
                              maxLines: 6,
                              maxLength: _maxChars,
                              decoration: const InputDecoration(
                                hintText: 'Say something...',
                                hintStyle: TextStyle(color: Color(0xFF999999)),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: InputBorder.none,   // 未聚焦时去掉黑线
                                focusedBorder: InputBorder.none,   // 聚焦时去掉黑线
                                contentPadding: EdgeInsets.all(0),
                                counterText: '',
                              ),
                            ),
                      ),
                      
                      // Character count
                      Padding(
                        padding: const EdgeInsets.only(left: 26, right: 23, bottom: 18.33),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$_charCount/$_maxChars',
                            style: TextStyle(
                              fontSize: 12,
                              color: _charCount >= _maxChars
                                  ? ThemeHelper.primaryColor
                                  : const Color(0xFF999999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) 
              ,
            ),

            const SizedBox(height: 24),
            // Purpose selection - 使用_purposes内容，垂直排列
            const Text(
              'Who can see this post? (Filter by chat purpose)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _purposes.map((purpose) {
                final isSelected = _selectedPurpose == purpose;
                return 
                  // Column(
                  //   children: [
                        GestureDetector(
                          onTap: () => setState(() => _selectedPurpose = purpose),
                          child: Container(
                            // width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.67, vertical: 4.67),
                            margin: const EdgeInsets.only(bottom: 11.33),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? ThemeHelper.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: isSelected
                                    ? ThemeHelper.primaryColor
                                    : Colors.white,
                              ),
                            ),
                            child: Text(
                              purpose,
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    isSelected ? Colors.white : Color.fromRGBO(42, 42, 42, 1),
                              ),
                            ),
                          ),
                        )
                  // ])
                ;
              }).toList(),
            ),
            const SizedBox(height: 24),
            // // 可见范围
            // const Text(
            //   'Visibility',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: Color(0xFF333333),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Column(
            //   children: [
            //     RadioListTile<PostVisibility>(
            //       title: const Text('Everyone'),
            //       subtitle: const Text('All users can see'),
            //       value: PostVisibility.everyone,
            //       groupValue: _visibility,
            //       onChanged: (value) => setState(() => _visibility = value!),
            //     ),
            //     RadioListTile<PostVisibility>(
            //       title: const Text('Friends Only'),
            //       subtitle: const Text('Only friends can see'),
            //       value: PostVisibility.friends,
            //       groupValue: _visibility,
            //       onChanged: (value) => setState(() => _visibility = value!),
            //     ),
            //     RadioListTile<PostVisibility>(
            //       title: const Text('VIP Only'),
            //       subtitle: const Text('Only VIP users can see'),
            //       value: PostVisibility.vip,
            //       groupValue: _visibility,
            //       onChanged: (value) => setState(() => _visibility = value!),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),
            // 交友目的
            // const Text(
            //   'Purpose',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: Color(0xFF333333),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Wrap(
            //   spacing: 8,
            //   children: _purposes
            //       .map((purpose) => ChoiceChip(
            //             label: Text(purpose),
            //             selected: _selectedPurpose == purpose,
            //             onSelected: (selected) {
            //               setState(() =>
            //                   _selectedPurpose = selected ? purpose : null);
            //             },
            //           ))
            //       .toList(),
            // ),
            // const SizedBox(height: 24),
            // Toggle switches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Allow greetings via topics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                CustomToggleSwitch(
                  value: _form.allowGreetingsViaTopics,
                  onChanged: (value) {
                    setState(() {
                      _form.allowGreetingsViaTopics = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sub-options
            _buildToggleOption(
              'Only users with the same topics can greet you',
              _form.sameTopicsOnly,
              (value) => setState(() => _form.sameTopicsOnly = value),
            ),
            _buildToggleOption(
              'Everyone',
              _form.allowEveryone,
              (value) => setState(() => _form.allowEveryone = value),
            ),
            const SizedBox(height: 24),
            // Add Hashtags
            _buildActionRow(
              'Add Hashtags',
              onTap: () => Navigator.pushNamed(context, RoutePaths.topicSelect),
            ),
            const SizedBox(height: 12),
            // Post Visibility Duration
            _buildActionRow(
              'Post Visibility Duration',
              trailing: _durationText,
              onTap: _showDurationPicker,
            ),
            const SizedBox(height: 125),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
      String text, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          CustomToggleSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    String title, {
    String? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
            Row(
              children: [
                if (trailing != null)
                  Text(
                    trailing,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF999999),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
