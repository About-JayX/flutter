import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/model/matching/match_model.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/matching_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class GreetingsView extends StatefulWidget {
  const GreetingsView({super.key});

  @override
  State<GreetingsView> createState() => _GreetingsViewState();
}

class _GreetingsViewState extends State<GreetingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchingProvider>().loadGreetings();
    });
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
          'Greetings',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<MatchingProvider>(
        builder: (context, provider, child) {
          final greetings = provider.greetings;

          if (greetings.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: greetings.length,
            itemBuilder: (context, index) {
              final greeting = greetings[index];
              return _buildGreetingItem(context, greeting, provider);
            },
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
            Icons.mail_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No greetings yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Say hi to someone and start a conversation!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingItem(
    BuildContext context,
    GreetingRecord greeting,
    MatchingProvider provider,
  ) {
    final isIncoming = greeting.toUserId == 'current_user_id';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isIncoming ? 'Received' : 'Sent',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatTime(greeting.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(greeting.status),
              ],
            ),
            if (greeting.message != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  greeting.message!,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
            if (isIncoming && greeting.status == GreetingStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => provider.respondToGreeting(
                        greetingId: greeting.id,
                        accept: false,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => provider.respondToGreeting(
                        greetingId: greeting.id,
                        accept: true,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeHelper.primaryColor,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(GreetingStatus status) {
    Color color;
    String text;

    switch (status) {
      case GreetingStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case GreetingStatus.accepted:
        color = Colors.green;
        text = 'Accepted';
        break;
      case GreetingStatus.rejected:
        color = Colors.red;
        text = 'Declined';
        break;
      case GreetingStatus.expired:
        color = Colors.grey;
        text = 'Expired';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
