import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class BirthDatePickerDialog {
  static Future<DateTime?> show(BuildContext context,
      {DateTime? initialDate}) async {
    final now = DateTime.now();
    final defaultDate = initialDate ?? DateTime(2000, 1, 1);

    int selectedMonth = defaultDate.month;
    int selectedDay = defaultDate.day;
    int selectedYear = defaultDate.year;

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final daysInMonth =
                DateTime(selectedYear, selectedMonth + 1, 0).day;
            if (selectedDay > daysInMonth) {
              selectedDay = daysInMonth;
            }

            Widget buildWheel({
              required int itemCount,
              required int selectedIndex,
              required String Function(int index) labelBuilder,
              required ValueChanged<int> onSelectedItemChanged,
            }) {
              return Expanded(
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 44,
                  diameterRatio: 1.45,
                  squeeze: 1.05,
                  perspective: 0.003,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: onSelectedItemChanged,
                  controller:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= itemCount) return null;
                      final isSelected = index == selectedIndex;
                      return Center(
                        child: Text(
                          labelBuilder(index),
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF5A3D4A)
                                : const Color(0xFFA99898),
                            fontSize: isSelected ? 20 : 15,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontFamily: 'MiSansVF',
                            letterSpacing: isSelected ? 0.2 : 0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9C8C3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 300.5,
                    decoration: BoxDecoration(
                      color: const Color(0x1A000000),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 12,
                          right: 12,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 12,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          right: 12,
                          child: SizedBox(
                            height: 32,
                            child: Row(
                              children: const [
                                Expanded(child: SizedBox()),
                                SizedBox(
                                  height: 32,
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Color(0xFFDDDDDD),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                SizedBox(
                                  height: 32,
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Color(0xFFDDDDDD),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            buildWheel(
                              itemCount: 12,
                              selectedIndex: selectedMonth - 1,
                              labelBuilder: (index) =>
                                  (index + 1).toString().padLeft(2, '0'),
                              onSelectedItemChanged: (index) =>
                                  setState(() => selectedMonth = index + 1),
                            ),
                            buildWheel(
                              itemCount: daysInMonth,
                              selectedIndex: selectedDay - 1,
                              labelBuilder: (index) =>
                                  (index + 1).toString().padLeft(2, '0'),
                              onSelectedItemChanged: (index) =>
                                  setState(() => selectedDay = index + 1),
                            ),
                            buildWheel(
                              itemCount: 100,
                              selectedIndex: now.year - selectedYear,
                              labelBuilder: (index) =>
                                  (now.year - index).toString(),
                              onSelectedItemChanged: (index) => setState(
                                  () => selectedYear = now.year - index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          DateTime(selectedYear, selectedMonth, selectedDay),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeHelper.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'MiSansVF',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    return result;
  }
}
