import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = ThemeHelper.primaryColor,
    this.inactiveThumbColor = const Color(0xFFBDBDBD),
    this.inactiveTrackColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? activeColor : inactiveTrackColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? Colors.white : inactiveThumbColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
