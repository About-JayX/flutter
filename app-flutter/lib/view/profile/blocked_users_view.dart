import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/model/block_model.dart';
import 'package:mobisen_app/provider/block_provider.dart';

class BlockedUsersView extends StatelessWidget {
  const BlockedUsersView({super.key});

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
          'Blocked Users',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<BlockProvider>(
        builder: (context, provider, child) {
          final blockedUsers = provider.blockedUsers;

          if (blockedUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No Blocked Users',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Blocked users will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return _buildBlockedUserTile(context, user, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildBlockedUserTile(
      BuildContext context, BlockedUser user, BlockProvider provider) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: user.avatarUrl == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
          backgroundColor: Colors.grey[300],
        ),
        title: Text(
          user.username,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.reason != null)
              Text(
                'Reason: ${user.reason}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            Text(
              'Blocked: ${_formatDate(user.blockedAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            if (!user.isPermanent && user.expireAt != null)
              Text(
                'Expires: ${_formatDate(user.expireAt!)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
          ],
        ),
        trailing: TextButton(
          onPressed: () => _showUnblockConfirmDialog(context, user, provider),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Unblock'),
        ),
      ),
    );
  }

  void _showUnblockConfirmDialog(
      BuildContext context, BlockedUser user, BlockProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: Text('Are you sure you want to unblock ${user.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.unblockUser(user.userId);
              Navigator.pop(context);
            },
            child: const Text('Unblock', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
