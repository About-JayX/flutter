import 'package:flutter/material.dart';

class CheckboxWithLabel extends StatelessWidget {
  const CheckboxWithLabel({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onChanged(!value);
        },
        child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: value,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          onChanged(newValue);
                        }
                      },
                    )),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(label),
                ),
              ],
            )));
  }
}
