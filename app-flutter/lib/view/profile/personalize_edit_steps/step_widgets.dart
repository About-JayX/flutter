import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:mobisen_app/view/profile/avatar_crop_page.dart';
import 'package:mobisen_app/widget/birth_date_picker_dialog.dart';
import 'package:mobisen_app/widget/custom_dialog.dart';
import 'package:mobisen_app/widget/custom_icons.dart';
import 'package:mobisen_app/widget/looking_for_dialog.dart';

class StepBirthDate extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const StepBirthDate(
      {super.key, required this.value, required this.onChanged});

  bool _isUnderAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age < 18;
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$month / $day / $year';
  }

  void _onTapBox(BuildContext context) async {
    DateTime? initial;
    if (value != null && value!.length >= 10) {
      final parts = value!.split(' / ');
      if (parts.length == 3) {
        initial = DateTime(
          int.parse(parts[2]),
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }
    }

    final picked =
        await BirthDatePickerDialog.show(context, initialDate: initial);
    if (picked == null) return;

    if (_isUnderAge(picked)) {
      if (context.mounted) {
        CustomDialog.show(
          context,
          title: 'Welcome to Ume',
          description:
              'This app is for adults aged 18 and over only. Minors are prohibited from registering and using.',
          cancelText: 'Cancel',
          confirmText: 'Confirm',
        );
      }
    } else {
      onChanged(_formatDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = value ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Text(
          'Please enter your date of birth. Once submitted, it cannot be changed.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => _onTapBox(context),
          child: Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD4A5A5),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                displayValue.isEmpty ? 'XX / XX / XXXX' : displayValue,
                style: TextStyle(
                  color: displayValue.isEmpty
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'MiSansVF',
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StepGender extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const StepGender(
      {super.key, required this.selected, required this.onChanged});

  final List<String> _options = const [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Please select your gender identity. Only users who select "Prefer not to say" may edit their gender once after registration. All other selections cannot be changed.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.6,
          ),
          itemCount: _options.length,
          itemBuilder: (context, index) {
            final option = _options[index];
            final isSelected = selected == option;
            return _SelectableCard(
              label: option,
              isSelected: isSelected,
              onTap: () => onChanged(option),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          '"Select your gender identity (optional, for a better chat experience. You can choose \'Prefer not to say\' if you don\'t want to share.)"',
          style: TextStyle(
            color: Color(0xFF8B7B7B),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class StepUsername extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const StepUsername({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value ?? '');
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Text(
          'Please enter a username for your profile.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD4A5A5),
              width: 1,
            ),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'MiSansVF',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${value?.length ?? 0}/20',
            style: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 12,
              fontFamily: 'MiSansVF',
            ),
          ),
        ),
      ],
    );
  }
}

class StepAvatar extends StatelessWidget {
  final String? avatarPath;
  final ValueChanged<String> onChanged;

  const StepAvatar(
      {super.key, required this.avatarPath, required this.onChanged});

  Future<void> _pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (picked == null) return;

      if (context.mounted) {
        final croppedPath = await Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder: (_) => AvatarCropPage(imagePath: picked.path),
          ),
        );
        if (croppedPath != null && context.mounted) {
          onChanged(croppedPath);
        }
      }
    } catch (e) {
      LogE('StepAvatar: pickImage error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to select image, please try again'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarPath != null && avatarPath!.isNotEmpty;
    final isAsset = avatarPath != null && avatarPath!.startsWith('assets/');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Upload a clear photo to help others recognize you.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(context),
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD4A5A5),
                  width: 1,
                ),
              ),
              child: !hasImage
                  ? const Center(
                      child: Icon(
                        Icons.add,
                        size: 48,
                        color: Color(0xFFCCCCCC),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: isAsset
                          ? Image.asset(
                              avatarPath!,
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            )
                          : Image.file(
                              File(avatarPath!),
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class StepPersonality extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const StepPersonality(
      {super.key, required this.selected, required this.onChanged});

  final List<String> _options = const [
    'Easygoing\n&\nFriendly',
    'Honest\n&\nStraightforward',
    'Calm\n&\nPatient',
    'Open-minded\n&\nNon-judgmental',
    'Outgoing\n&\nSocial',
    'Humorous\n&\nFun',
    'Introverted\n&\nQuiet',
    'Empathetic\n&\nListener',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Your answers are only used for matching, and are not shown to others.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Select up to 3 traits that best describe you.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 459,
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.55,
            ),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final option = _options[index];
              final isSelected = selected.contains(option);
              return _SelectableCard(
                label: option,
                isSelected: isSelected,
                onTap: () {
                  final list = List<String>.from(selected);
                  if (list.contains(option)) {
                    list.remove(option);
                  } else if (list.length < 3) {
                    list.add(option);
                  }
                  onChanged(list);
                },
                align: TextAlign.left,
                selectedBorderColor: const Color(0xFFE8B6AE),
              );
            },
          ),
        ),
      ],
    );
  }
}

class StepInterests extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const StepInterests(
      {super.key, required this.selected, required this.onChanged});

  final List<String> _options = const [
    'Travel\n&\nOutdoor',
    'Movies\n&\nTV Shows',
    'Food\n&\nCoffee',
    'Music\n&\nConcerts',
    'Fitness\n&\nSports',
    'Gaming',
    'Art\n&\nCreativity',
    'Pets\n&\nAnimals',
    'Reading\n&\nLearning',
    'Lifestyle\n&\nDaily Chat',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'These topics help others start conversations with you.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 500,
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.55,
            ),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final option = _options[index];
              final isSelected = selected.contains(option);
              return _SelectableCard(
                label: option,
                isSelected: isSelected,
                onTap: () {
                  final list = List<String>.from(selected);
                  if (list.contains(option)) {
                    list.remove(option);
                  } else {
                    list.add(option);
                  }
                  onChanged(list);
                },
                align: TextAlign.left,
                selectedBorderColor: const Color(0xFFE8B6AE),
              );
            },
          ),
        ),
      ],
    );
  }
}

class StepLookingFor extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const StepLookingFor(
      {super.key, required this.selected, required this.onChanged});

  final List<Map<String, dynamic>> _options = const [
    {'label': 'Daily Life Sharing', 'icon': DailyLifeIcon},
    {'label': 'Hobby & Interest Chat', 'icon': GuitarIcon},
    {'label': 'Casual Chat', 'icon': CasualChatIcon},
    {'label': 'Make New Friends', 'icon': TwoPeopleIcon},
    {'label': 'Emotional Support', 'icon': HandshakeIcon},
    {'label': 'Work Stress', 'icon': WorkStressIcon},
    {'label': 'Loneliness', 'icon': LonelinessIcon},
  ];

  static const Map<String, List<String>> _subOptionsMap = {
    'Daily Life Sharing': [
      'Daily Life Sharing',
      'Work Stress',
      'Loneliness',
      'Relationship Issues',
      'Family Matters',
      'Self-growth',
      'Health & Wellness',
    ],
    'Hobby & Interest Chat': [
      'Hobby & Interest Chat',
      'Work Stress',
      'Loneliness',
      'Relationship Issues',
      'Family Matters',
      'Self-growth',
      'Health & Wellness',
    ],
    'Casual Chat': [
      'Casual Chat',
      'Work Stress',
      'Loneliness',
      'Relationship Issues',
      'Family Matters',
      'Self-growth',
      'Health & Wellness',
    ],
    'Make New Friends': [
      'Make New Friends',
      'Work Stress',
      'Loneliness',
      'Relationship Issues',
      'Family Matters',
      'Self-growth',
      'Health & Wellness',
    ],
    'Emotional Support': [
      'Emotional Support',
      'Work Stress',
      'Loneliness',
      'Relationship Issues',
      'Family Matters',
      'Self-growth',
      'Health & Wellness',
    ],
    'Work Stress': [
      'Work Stress',
      'Loneliness',
      'Relationship Issues',
      'Family Matters',
      'Self-growth',
      'Health & Wellness',
    ],
    'Loneliness': [
      'Loneliness',
      'Work Stress',
      'Relationship Issues',
      'Family Matters',
      'Self-growth',
      'Health & Wellness',
    ],
  };

  Future<void> _onTap(BuildContext context, String label) async {
    final list = List<String>.from(selected);
    if (list.contains(label)) {
      list.remove(label);
      onChanged(list);
      return;
    }

    if (list.length >= 3) return;

    final subOptions = _subOptionsMap[label] ?? [];
    await LookingForDialog.show(
      context,
      title: "What's on your mind",
      subOptions: subOptions,
    );

    if (context.mounted) {
      list.add(label);
      onChanged(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Your choices will be visible on your profile to help others understand your intentions.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Select up to 3 reasons you\'re here.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 459,
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final option = _options[index];
              final label = option['label'] as String;
              final isSelected = selected.contains(label);
              return _IconSelectableCard(
                label: label,
                icon: (option['icon'] as Type).toString() == 'DailyLifeIcon'
                    ? const DailyLifeIcon(
                        size: 28, color: ThemeHelper.primaryColor)
                    : (option['icon'] as Type).toString() == 'GuitarIcon'
                        ? const GuitarIcon(
                            size: 28, color: ThemeHelper.primaryColor)
                        : (option['icon'] as Type).toString() ==
                                'CasualChatIcon'
                            ? const CasualChatIcon(
                                size: 28, color: ThemeHelper.primaryColor)
                            : (option['icon'] as Type).toString() ==
                                    'TwoPeopleIcon'
                                ? const TwoPeopleIcon(
                                    size: 28, color: ThemeHelper.primaryColor)
                                : (option['icon'] as Type).toString() ==
                                        'HandshakeIcon'
                                    ? const HandshakeIcon(
                                        size: 28,
                                        color: ThemeHelper.primaryColor)
                                    : (option['icon'] as Type).toString() ==
                                            'WorkStressIcon'
                                        ? const WorkStressIcon(
                                            size: 28,
                                            color: ThemeHelper.primaryColor)
                                        : const LonelinessIcon(
                                            size: 28,
                                            color: ThemeHelper.primaryColor),
                isSelected: isSelected,
                selectedBorderColor: const Color(0xFFE8B6AE),
                onTap: () => _onTap(context, label),
              );
            },
          ),
        ),
      ],
    );
  }
}

class StepCommunication extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const StepCommunication(
      {super.key, required this.selected, required this.onChanged});

  final List<Map<String, dynamic>> _options = const [
    {'label': 'Prefer text messages', 'icon': Icons.chat_bubble_outline},
    {'label': 'Prefer voice calls', 'icon': Icons.volume_up},
    {'label': 'Prefer video calls', 'icon': Icons.videocam},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Your answers are only used for matching, never shown to others.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'How do you prefer to chat?',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'MiSansVF',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _options.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final option = _options[index];
            final label = option['label'] as String;
            final isSelected = selected == label;
            return _IconSelectableCard(
              label: label,
              icon: Icon(option['icon'] as IconData,
                  size: 28, color: ThemeHelper.primaryColor),
              isSelected: isSelected,
              onTap: () => onChanged(label),
            );
          },
        ),
      ],
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final TextAlign align;
  final Color selectedBorderColor;

  const _SelectableCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.align = TextAlign.center,
    this.selectedBorderColor = const Color(0xFFE8B6AE),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: selectedBorderColor, width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Center(
          child: Text(
            label,
            textAlign: align,
            style: const TextStyle(
              color: Color(0xFF5A3D4A),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'MiSansVF',
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconSelectableCard extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedBorderColor;

  const _IconSelectableCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedBorderColor = const Color(0xFFE8B6AE),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: selectedBorderColor, width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF5A3D4A),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'MiSansVF',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
