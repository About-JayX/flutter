import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/model/square/post_model.dart';

class TopicSelectView extends StatefulWidget {
  const TopicSelectView({super.key});

  @override
  State<TopicSelectView> createState() => _TopicSelectViewState();
}

class _TopicSelectViewState extends State<TopicSelectView> {
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

  String? _selectedTopicId;
  final ScrollController _scrollController = ScrollController();

  void _selectTopic(String id) {
    setState(() {
      _selectedTopicId = id;
    });
  }

  void _handleDone() {
    Navigator.pop(context, _selectedTopicId);
  }

  bool get _hasSelection => _selectedTopicId != null;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
        ),
        title: const Text(
          'Add Hashtags',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(3),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(left: 33, top: 33),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final topic = _topics[index];
                    final isSelected = _selectedTopicId == topic.id;
                    return GestureDetector(
                      onTap: () => _selectTopic(topic.id),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.67, vertical: 4.67),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ThemeHelper.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                topic.emoji,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 12),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      (MediaQuery.sizeOf(context).width) *
                                          (3 / 4),
                                ),
                                child: Text(
                                  topic.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _topics.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _hasSelection ? _handleDone : null,
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(162.33, 51.67), // 直接固定按钮尺寸
                          backgroundColor: ThemeHelper.primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFBDBDBD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                  ])
              ),
            ),
          ],
        ),
      ),
    );
  }
}