import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/model/block_model.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/provider/block_provider.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class ReportUserView extends StatefulWidget {
  final String userId;
  final String username;

  const ReportUserView({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<ReportUserView> createState() => _ReportUserViewState();
}

class _ReportUserViewState extends State<ReportUserView> {
  ReportType? _selectedType;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  bool _blockUser = false;

  final Map<ReportType, String> _reportTypes = {
    ReportType.harassment: 'Harassment',
    ReportType.spam: 'Spam',
    ReportType.inappropriate: 'Inappropriate Content',
    ReportType.fake: 'Fake Information',
    ReportType.scam: 'Scam',
    ReportType.other: 'Other',
  };

  @override
  void dispose() {
    _descriptionController.dispose();
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
          'Report User',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 被举报用户信息
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white),
                  backgroundColor: ThemeHelper.primaryColor,
                ),
                title: Text(
                  widget.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text('ID: ${widget.userId}'),
              ),
            ),

            const SizedBox(height: 24),

            // 举报类型
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Report Reason',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ..._reportTypes.entries
                      .map((entry) => RadioListTile<ReportType>(
                            title: Text(entry.value),
                            value: entry.key,
                            groupValue: _selectedType,
                            onChanged: (value) =>
                                setState(() => _selectedType = value),
                            activeColor: ThemeHelper.primaryColor,
                          )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 详细描述
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Please describe the situation...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 同时拉黑选项
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Text('Block this user'),
                subtitle: const Text(
                    'You will no longer receive messages from this user'),
                value: _blockUser,
                onChanged: (value) =>
                    setState(() => _blockUser = value ?? false),
                activeColor: ThemeHelper.primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a report reason')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = context.read<BlockProvider>();
    final success = await provider.submitReport(
      reportedUserId: widget.userId,
      type: _selectedType!,
      reason: _reportTypes[_selectedType]!,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
    );

    if (_blockUser) {
      await provider.blockUser(
        userId: widget.userId,
        username: widget.username,
        reason: 'Reported: ${_reportTypes[_selectedType]}',
      );
    }

    setState(() => _isSubmitting = false);

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Report Submitted'),
          content: const Text(
              'Thank you for your report. We will review it as soon as possible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to submit report, please try again')),
      );
    }
  }
}
