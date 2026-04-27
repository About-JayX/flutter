import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/block_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class BlockedKeywordsView extends StatefulWidget {
  const BlockedKeywordsView({super.key});

  @override
  State<BlockedKeywordsView> createState() => _BlockedKeywordsViewState();
}

class _BlockedKeywordsViewState extends State<BlockedKeywordsView> {
  final TextEditingController _keywordController = TextEditingController();
  bool _isRegex = false;
  bool _caseSensitive = false;

  @override
  void dispose() {
    _keywordController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Blocked Keywords',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 添加屏蔽词区域
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    labelText: 'Keyword',
                    hintText: 'Enter keyword to block',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add, color: ThemeHelper.primaryColor),
                      onPressed: _addKeyword,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _isRegex,
                      onChanged: (value) =>
                          setState(() => _isRegex = value ?? false),
                      activeColor: ThemeHelper.primaryColor,
                    ),
                    const Text('Regex'),
                    const SizedBox(width: 16),
                    Checkbox(
                      value: _caseSensitive,
                      onChanged: (value) =>
                          setState(() => _caseSensitive = value ?? false),
                      activeColor: ThemeHelper.primaryColor,
                    ),
                    const Text('Case Sensitive'),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 屏蔽词列表
          Expanded(
            child: Consumer<BlockProvider>(
              builder: (context, provider, child) {
                final keywords = provider.blockedKeywords;

                if (keywords.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_alt,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No Blocked Keywords',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: keywords.length,
                  itemBuilder: (context, index) {
                    final keyword = keywords[index];
                    return Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 1),
                      child: ListTile(
                        title: Text(
                          keyword.keyword,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Wrap(
                          spacing: 8,
                          children: [
                            if (keyword.isRegex)
                              Chip(
                                label: const Text('Regex'),
                                labelStyle: const TextStyle(fontSize: 10),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    ThemeHelper.primaryColor.withOpacity(0.1),
                                side: BorderSide.none,
                              ),
                            if (keyword.caseSensitive)
                              Chip(
                                label: const Text('Case Sensitive'),
                                labelStyle: const TextStyle(fontSize: 10),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                side: BorderSide.none,
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeKeyword(keyword.keyword),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addKeyword() {
    final keyword = _keywordController.text.trim();
    if (keyword.isEmpty) return;

    final provider = context.read<BlockProvider>();
    provider.addBlockedKeyword(
      keyword: keyword,
      isRegex: _isRegex,
      caseSensitive: _caseSensitive,
    );

    _keywordController.clear();
    setState(() {
      _isRegex = false;
      _caseSensitive = false;
    });
  }

  void _removeKeyword(String keyword) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Keyword'),
        content: Text('Are you sure you want to delete "$keyword"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BlockProvider>().removeBlockedKeyword(keyword);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
