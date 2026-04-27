import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class DurationPickerDialog extends StatelessWidget {
  final String selectedDuration;
  final ValueChanged<String> onSelect;

  const DurationPickerDialog({
    super.key,
    required this.selectedDuration,
    required this.onSelect,
  });

  final List<Map<String, dynamic>> _options = const [
    {'id': '4h', 'label': '4 Hours'},
    {'id': 'permanent', 'label': 'Permanent'},
    {'id': '24h', 'label': '24 Hours'},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Color(0xFF999999)),
              ),
            ),
            // Options
            ..._options.map((option) {
              final isSelected = selectedDuration == option['id'];
              return GestureDetector(
                onTap: () {
                  onSelect(option['id'] as String);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ThemeHelper.primaryColor.withOpacity(0.1)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: ThemeHelper.primaryColor)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    option['label'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected
                          ? ThemeHelper.primaryColor
                          : const Color(0xFF333333),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeHelper.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
