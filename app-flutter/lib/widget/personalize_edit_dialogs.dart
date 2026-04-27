import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/view/profile/personalize_edit_state.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class PersonalizeEditDialogs {
  static void showFinalDialog(
    BuildContext context, {
    required PersonalizeEditState state,
    required Future<void> Function() onSave,
  }) {
    final statusOptions = [
      '"I\'m bored, let\'s talk."',
      '"Just want someone to chill with."',
      '"Looking for friends to game with."',
    ];

    String currentStatus = state.status ?? statusOptions.first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Final Step:',
                      style: TextStyle(
                        color: Color(0xFF5A3D4A),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'MiSansVF',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Polish Your Profile Card',
                      style: TextStyle(
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
                    const SizedBox(height: 16),
                    _buildInfoRow('Nickname', state.username ?? ''),
                    _buildInfoRow('Interests',
                        state.interests.join(', ').replaceAll('\n', ' ')),
                    const SizedBox(height: 6),
                    _buildInfoRow('Status', currentStatus),
                    const SizedBox(height: 12),
                    Column(
                      children: statusOptions.map((status) {
                        final isSelected = currentStatus == status;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentStatus = status;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFE8B6AE)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF5A3D4A),
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                fontFamily: 'MiSansVF',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 120,
                      height: 44,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFD5A7BD),
                              Color(0xFFFF9595),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            state.status = currentStatus;
                            Navigator.of(context).pop();
                            await onSave();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'MiSansVF',
                            ),
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
      },
    );
  }

  static void showCongratsDialog(BuildContext context,
      {VoidCallback? onStart}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Congrats on being',
                  style: TextStyle(
                    color: Color(0xFF5A3D4A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'MiSansVF',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'one of our first 100 users! 🎉',
                  style: TextStyle(
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
                const SizedBox(height: 16),
                const Text(
                  'We\'re a brand-new social chat app built for connecting over shared interests. Our community is still small, and we\'d love to have you stick around and grow with us.\n\nYour feedback is always welcome — it helps us get better every day.\n\nAs a special thank-you, you\'ll get a digital anniversary card every year on your sign-up date to celebrate this day.\n\nPlus, enjoy a 3-day free VIP trial — hope you love chatting here!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A3D4A),
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'MiSansVF',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  height: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFD5A7BD),
                          Color(0xFFFF9595),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onStart?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Start Chatting',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'MiSansVF',
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 200,
                //   height: 44,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //       onStart?.call();
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: ThemeHelper.primaryColor,
                //       foregroundColor: Colors.white,
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     child: const Text(
                //       'Start Chatting',
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //         fontFamily: 'MiSansVF',
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: '$label: ',
            style: const TextStyle(
              color: Color(0xFF5A3D4A),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'MiSansVF',
            ),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Color(0xFF5A3D4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'MiSansVF',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
