import 'package:flutter/material.dart';
import 'package:mobisen_app/gen/assets.gen.dart';

class EditCardView extends StatefulWidget {
  const EditCardView({super.key});

  @override
  State<EditCardView> createState() => _EditCardViewState();
}

class _EditCardViewState extends State<EditCardView> {
  final _nicknameController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedStatus;
  final List<String> _selectedInterests = [];

  final List<String> _statusOptions = [
    'Online',
    'Busy',
    'Offline',
  ];

  final List<String> _interestOptions = [
    'Travel',
    'Photo',
    'Music',
    'Coffee',
    'Food',
    'Cooking',
    'Movie',
    'Sports',
    'Game',
    'Tech',
    'Reading',
    'Art',
    'Yoga',
    'Beach',
    'Health',
  ];

  bool get _canPublish =>
      _nicknameController.text.trim().isNotEmpty &&
      _selectedInterests.isNotEmpty &&
      _selectedStatus != null;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_onTextChanged);
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onInterestToggled(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _onStatusSelected(String status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  void _onPublish() {
    if (!_canPublish) return;

    // TODO: 调用API保存用户资料

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );

    Navigator.pop(context);
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
          'Edit Profile',
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
            // 头像上传区域
            _buildAvatarSection(),

            const SizedBox(height: 24),

            // 昵称输入
            _buildNicknameSection(),

            const SizedBox(height: 24),

            // 个人简介
            _buildBioSection(),

            const SizedBox(height: 24),

            // 兴趣标签选择
            _buildInterestsSection(),

            const SizedBox(height: 24),

            // 状态选择
            _buildStatusSection(),

            const SizedBox(height: 32),

            // 保存按钮
            _buildPublishButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: const Color(0xFFFF6B9D),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Assets.images.defaultAvatar.image(
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // TODO: 打开图片选择器
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B9D),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to change photo',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nickname',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              hintText: 'Enter your nickname',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bio',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _bioController,
            maxLines: 3,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: 'Tell others about yourself...',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              counterStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Interests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            Text(
              '${_selectedInterests.length} selected',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interestOptions.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () => _onInterestToggled(interest),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF6B9D) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF6B9D)
                        : const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Text(
                  interest,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _statusOptions.map((status) {
            final isSelected = _selectedStatus == status;
            Color statusColor;
            switch (status) {
              case 'Online':
                statusColor = const Color(0xFF4CAF50);
                break;
              case 'Busy':
                statusColor = const Color(0xFFFF9800);
                break;
              case 'Offline':
                statusColor = const Color(0xFF9E9E9E);
                break;
              default:
                statusColor = const Color(0xFF9E9E9E);
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => _onStatusSelected(status),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? statusColor : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color:
                            isSelected ? statusColor : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status,
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
      ],
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _canPublish ? _onPublish : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B9D),
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: const Color(0xFFFFB6C1),
          disabledForegroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _canPublish ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
