import 'dart:io';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/model/square/report_model.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/widget/custom_dialog.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final List<String> _selectedTypes = [];
  final List<File> _screenshots = [];
  final ImagePicker _picker = ImagePicker();

  bool get _canSubmit => _selectedTypes.isNotEmpty && _screenshots.isNotEmpty;

  void _toggleType(String typeId) {
    setState(() {
      if (_selectedTypes.contains(typeId)) {
        _selectedTypes.remove(typeId);
      } else if (_selectedTypes.length < ReportConfig.maxSelections) {
        _selectedTypes.add(typeId);
      }
    });
  }

  Future<void> _pickImage() async {
    if (_screenshots.length >= ReportConfig.maxScreenshots) {
      CustomDialog.showSingleButton(
        context,
        title: 'Maximum Screenshots',
        description:
            'You can upload up to ${ReportConfig.maxScreenshots} screenshots.',
        confirmText: 'Got it',
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _screenshots.add(File(image.path));
      });
    }
  }

  void _removeScreenshot(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Screenshot'),
        content: const Text('Are you sure you want to delete this screenshot?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _screenshots.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_selectedTypes.isEmpty) {
      CustomDialog.showSingleButton(
        context,
        title: 'Please select a type.',
        description: 'Please select at least one report type.',
        confirmText: 'Confirm',
      );
      return;
    }

    if (_screenshots.isEmpty) {
      CustomDialog.showSingleButton(
        context,
        title: 'Please upload screenshots.',
        description: 'Please upload at least one screenshot.',
        confirmText: 'Confirm',
      );
      return;
    }

    // Show success dialog
    CustomDialog.showSingleButton(
      context,
      title: 'Thank you for reporting!',
      description: 'Your report has been submitted successfully.',
      confirmText: 'Go back to previous page',
      onConfirm: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
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
          'Report',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report type section
            _buildSectionTitle(
              'Please select a report type (select at least 1 item, maximum 3 items):',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReportConfig.types.map((type) {
                final isSelected = _selectedTypes.contains(type.id);
                return GestureDetector(
                  onTap: () => _toggleType(type.id),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ThemeHelper.primaryColor
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? ThemeHelper.primaryColor
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isSelected ? Colors.white : const Color(0xFF333333),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Screenshots section
            _buildSectionTitle(
              'Please upload screenshots, at least 1 and up to 6.',
            ),
            const SizedBox(height: 12),
            // Screenshot grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: _screenshots.length + 1,
              itemBuilder: (context, index) {
                if (index == _screenshots.length) {
                  // Add button
                  return GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  );
                }

                // Screenshot item
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _screenshots[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // Delete button
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeScreenshot(index),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            // Submit button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _canSubmit ? _handleSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeHelper.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFBDBDBD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '* ',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFF44336),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}
