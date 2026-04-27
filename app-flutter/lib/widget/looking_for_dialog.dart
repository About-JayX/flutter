import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class LookingForDialog {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<String> subOptions,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFF2F0F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF5A3D4A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'MiSansVF',
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x00EB47B8),
                        ThemeHelper.primaryColor,
                        Color(0x00EB47B8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your answers are 100% private and only used for matching.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF5A3D4A),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'MiSansVF',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: SingleChildScrollView(
                    child: Column(
                      children: subOptions
                          .map(
                            (option) => Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF5A3D4A),
                                  fontSize: 14,
                                  fontFamily: 'MiSansVF',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
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
          ),
        );
      },
    );
  }
}
