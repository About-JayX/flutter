import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/provider/message_provider.dart';
import 'package:mobisen_app/view/messages/widgets/message_list_item.dart';
import 'package:mobisen_app/view/messages/widgets/message_long_press_menu.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessageProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Messages',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Color(0xFF333333)),
              onPressed: () {
                // 显示更多选项
              },
            ),
          ],
        ),
        body: Consumer<MessageProvider>(
          builder: (context, provider, child) {
            if (provider.loading && provider.conversations.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.conversations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.message, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No Messages',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.refresh,
              child: ListView.builder(
                itemCount: provider.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = provider.conversations[index];
                  return Dismissible(
                    key: Key(conversation.id),
                    background: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(Icons.push_pin, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        // 删除
                        return await _showDeleteConfirmDialog(context);
                      } else {
                        // 置顶
                        provider.pinConversation(conversation.id);
                        return false;
                      }
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        provider.deleteConversation(conversation.id);
                      }
                    },
                    child: MessageListItem(
                      conversation: conversation,
                      onTap: () => _onConversationTap(context, conversation),
                      onLongPress: () =>
                          _onLongPress(context, conversation, provider),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _onConversationTap(BuildContext context, Conversation conversation) {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'conversationId': conversation.id,
        'peerName': conversation.name,
      },
    );
  }

  void _onLongPress(BuildContext context, Conversation conversation,
      MessageProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageLongPressMenu(
        onDelete: () {
          provider.deleteConversation(conversation.id);
          Navigator.pop(context);
        },
        onPin: () {
          provider.pinConversation(conversation.id);
          Navigator.pop(context);
        },
        onLock: () {
          provider.lockConversation(conversation.id);
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: const Text(
            'Are you sure you want to delete this conversation? All messages will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
