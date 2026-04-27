import 'package:flutter/material.dart';
import 'custom_dialog_base.dart';

/// 筛选弹窗
/// 点击Filter按钮弹出，支持性别筛选和年龄范围选择
class FilterDialog extends StatefulWidget {
  final String? initialGender;
  final RangeValues? initialAgeRange;
  final Function(String? gender, RangeValues ageRange)? onConfirm;
  final VoidCallback? onCancel;

  const FilterDialog({
    super.key,
    this.initialGender,
    this.initialAgeRange,
    this.onConfirm,
    this.onCancel,
  });

  static Future<void> show({
    required BuildContext context,
    String? initialGender,
    RangeValues? initialAgeRange,
    Function(String? gender, RangeValues ageRange)? onConfirm,
  }) {
    return CustomDialogBase.show(
      context: context,
      barrierDismissible: true,
      builder: (context) => FilterDialog(
        initialGender: initialGender,
        initialAgeRange: initialAgeRange,
        onConfirm: onConfirm,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String? _selectedGender;
  late RangeValues _ageRange;

  final List<Map<String, dynamic>> _genderOptions = [
    {'value': null, 'label': 'All', 'icon': Icons.people},
    {'value': 'male', 'label': 'Male', 'icon': Icons.male},
    {'value': 'female', 'label': 'Female', 'icon': Icons.female},
  ];

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
    _ageRange = widget.initialAgeRange ?? const RangeValues(18, 60);
  }

  void _onGenderSelected(String? gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  void _onConfirm() {
    widget.onConfirm?.call(_selectedGender, _ageRange);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialogBase(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onCancel,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 性别筛选
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: _genderOptions.map((option) {
                final isSelected = _selectedGender == option['value'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () =>
                          _onGenderSelected(option['value'] as String?),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFF6B9D)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              option['icon'] as IconData,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF666666),
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              option['label'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // 年龄范围
            const Text(
              'Age Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 16),

            // 年龄显示
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_ageRange.start.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 2,
                  color: const Color(0xFFE0E0E0),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_ageRange.end.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 年龄滑块
            RangeSlider(
              values: _ageRange,
              min: 18,
              max: 80,
              divisions: 62,
              activeColor: const Color(0xFFFF6B9D),
              inactiveColor: const Color(0xFFE0E0E0),
              labels: RangeLabels(
                '${_ageRange.start.toInt()}',
                '${_ageRange.end.toInt()}',
              ),
              onChanged: (values) {
                setState(() {
                  _ageRange = values;
                });
              },
            ),

            const SizedBox(height: 24),

            // 确认按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B9D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filter',
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
}
