import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/account_helper.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/view/profile/personalize_edit_state.dart';
import 'package:mobisen_app/view/profile/personalize_edit_steps/step_widgets.dart';
import 'package:mobisen_app/widget/loading_overlay.dart';
import 'package:mobisen_app/widget/personalize_edit_dialogs.dart';
import 'package:provider/provider.dart';

class PersonalizeEditView extends StatefulWidget {
  const PersonalizeEditView({super.key});

  @override
  State<PersonalizeEditView> createState() => _PersonalizeEditViewState();
}

class _PersonalizeEditViewState extends State<PersonalizeEditView> {
  int _currentStep = 0;
  final PersonalizeEditState _state = PersonalizeEditState();

  final List<String> _titles = const [
    'Your Date of Birth',
    'Your Gender',
    'Create Your Username',
    'Add a Profile Photo',
    'Tell us about your personality',
    'Choose interests to chat about',
    'What are you looking for',
    'How do you prefer to connect?',
  ];

  void _onNext() {
    if (!_state.isStepValid(_currentStep)) return;

    if (_currentStep < 7) {
      setState(() {
        _currentStep++;
      });
    } else {
      PersonalizeEditDialogs.showFinalDialog(
        context,
        state: _state,
        onSave: () async {
          LoadingOverlay.show(context);

          try {
            final account = AccountHelper.instance.account;
            if (account != null) {
              // 1. 上传头像（如果有本地文件）
              String? avatarUrl;
              if (_state.avatarPath != null &&
                  !_state.avatarPath!.startsWith('assets/')) {
                try {
                  LogD('PersonalizeEditView: uploading avatar...');
                  avatarUrl = await ApiService.instance
                      .uploadAvatar(account, _state.avatarPath!);
                  LogD('PersonalizeEditView: avatar uploaded: $avatarUrl');
                } catch (e) {
                  LogE('PersonalizeEditView: failed to upload avatar:\n$e');
                }
              }

              // 2. 保存完整个性化资料到后端
              try {
                LogD('PersonalizeEditView: saving profile to backend...');

                // 转换 birthDate 格式: "12 / 25 / 1995" -> "1995-12-25"
                String? formattedBirthDate;
                if (_state.birthDate != null && _state.birthDate!.isNotEmpty) {
                  final parts = _state.birthDate!.split(' / ');
                  if (parts.length == 3) {
                    formattedBirthDate = '${parts[2]}-${parts[0]}-${parts[1]}';
                  }
                }

                // 确保 gender 是后端期望的枚举值
                String? formattedGender = _state.gender;
                if (formattedGender != null && formattedGender.isNotEmpty) {
                  // 将前端显示值转换为后端枚举值
                  final genderMap = {
                    'Male': 'male',
                    'Female': 'female',
                    'Non-binary': 'non_binary',
                    'Prefer not to say': 'prefer_not_say',
                  };
                  formattedGender =
                      genderMap[formattedGender] ?? formattedGender;
                }

                final profileData = {
                  'birthDate': formattedBirthDate,
                  'gender': formattedGender,
                  'userNickName': _state.username,
                  if (avatarUrl != null) 'avatar': avatarUrl,
                  'interests': _state.interests,
                  'personality': _state.personalityTraits,
                  'chatPurpose': _state.lookingFor,
                  'communicationStyle': [_state.communicationPreference],
                  'status': _state.status,
                  'isStatusPublic': _state.isStatusPublic,
                  'blurProfileCard': _state.blurProfileCard,
                };

                print(
                    '🔵 [PersonalizeEdit] Sending profile data: $profileData');

                await ApiService.instance.saveProfile(account, profileData);
                LogD('PersonalizeEditView: profile saved successfully');
              } catch (e) {
                LogE('PersonalizeEditView: failed to save profile:\n$e');
                rethrow;
              }

              // 3. 标记个性化完成
              try {
                LogD(
                    'PersonalizeEditView: calling backend to mark personalized...');
                await ApiService.instance.markPersonalized(account);
                LogD(
                    'PersonalizeEditView: backend marked personalized successfully');
              } catch (e) {
                LogE(
                    'PersonalizeEditView: failed to mark personalized on backend:\n$e');
                rethrow;
              }

              // 4. 更新本地状态
              account.user.personalizeEdit = 1;
              if (avatarUrl != null) {
                account.user.avatarUrl = avatarUrl;
              }
              account.user.gender = _state.gender;
              account.user.birthDate = _state.birthDate;
              account.user.interests = _state.interests;
              account.user.personality = _state.personalityTraits;
              account.user.chatPurpose = _state.lookingFor;
              account.user.communicationStyle = [
                _state.communicationPreference ?? ''
              ];
              account.user.status = _state.status;
              account.user.isStatusPublic = _state.isStatusPublic;
              account.user.blurProfileCard = _state.blurProfileCard;
              context.read<AccountProvider>().setAccount(account);
              LogD(
                  'PersonalizeEditView: marked personalizeEdit=1 and saved account');

              // 5. 检查是否是前100名用户
              final isEarlyUser =
                  await ApiService.instance.checkIsEarlyUser(account);

              LoadingOverlay.hide();

              if (isEarlyUser) {
                // 显示祝贺弹窗
                if (mounted) {
                  PersonalizeEditDialogs.showCongratsDialog(
                    context,
                    onStart: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RoutePaths.home,
                        (route) => false,
                      );
                    },
                  );
                }
              } else {
                // 直接跳转到首页
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutePaths.home,
                    (route) => false,
                  );
                }
              }
            }
          } catch (e) {
            LoadingOverlay.hide();
            LogE('PersonalizeEditView: error saving profile:\n$e');
            ViewUtils.showToast('Save failed, please try again');
          }
        },
      );
    }
  }

  void _onSkip() {
    if (_currentStep < 7) {
      setState(() {
        _currentStep++;
      });
    }
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 11.67),
      child: GestureDetector(
        onTap: _onSkip,
        child: Container(
          width: 48.67,
          height: 28.67,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 149, 149, 1),
                Color.fromRGBO(213, 167, 189, 1),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'MiSansVF',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      final account = AccountHelper.instance.account;
      final isPersonalized =
          account != null && account.user.personalizeEdit == 1;
      if (isPersonalized) {
        Navigator.of(context).pop();
      } else {
        SystemNavigator.pop();
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      return false;
    }
    final account = AccountHelper.instance.account;
    final isPersonalized = account != null && account.user.personalizeEdit == 1;
    if (isPersonalized) {
      return true;
    }
    SystemNavigator.pop();
    return false;
  }

  void _markPersonalizedAndGoHome(BuildContext context) async {
    try {
      final account = AccountHelper.instance.account;
      if (account != null) {
        // 1. 上传头像（如果有本地文件）
        String? avatarUrl;
        if (_state.avatarPath != null &&
            !_state.avatarPath!.startsWith('assets/')) {
          try {
            LogD('PersonalizeEditView: uploading avatar...');
            avatarUrl = await ApiService.instance
                .uploadAvatar(account, _state.avatarPath!);
            LogD('PersonalizeEditView: avatar uploaded: $avatarUrl');
          } catch (e) {
            LogE('PersonalizeEditView: failed to upload avatar:\n$e');
          }
        }

        // 2. 保存完整个性化资料到后端
        try {
          LogD('PersonalizeEditView: saving profile to backend...');

          // 转换 birthDate 格式: "12 / 25 / 1995" -> "1995-12-25"
          String? formattedBirthDate;
          if (_state.birthDate != null && _state.birthDate!.isNotEmpty) {
            final parts = _state.birthDate!.split(' / ');
            if (parts.length == 3) {
              formattedBirthDate = '${parts[2]}-${parts[0]}-${parts[1]}';
            }
          }

          // 确保 gender 是后端期望的枚举值
          String? formattedGender = _state.gender;
          if (formattedGender != null && formattedGender.isNotEmpty) {
            // 将前端显示值转换为后端枚举值
            final genderMap = {
              'Male': 'male',
              'Female': 'female',
              'Non-binary': 'non_binary',
              'Prefer not to say': 'prefer_not_say',
            };
            formattedGender = genderMap[formattedGender] ?? formattedGender;
          }

          final profileData = {
            'birthDate': formattedBirthDate,
            'gender': formattedGender,
            'userNickName': _state.username,
            if (avatarUrl != null) 'avatar': avatarUrl,
            'interests': _state.interests,
            'personality': _state.personalityTraits,
            'chatPurpose': _state.lookingFor,
            'communicationStyle': [_state.communicationPreference],
            'status': _state.status,
            'isStatusPublic': _state.isStatusPublic,
            'blurProfileCard': _state.blurProfileCard,
          };

          print('🔵 [PersonalizeEdit] Sending profile data: $profileData');

          await ApiService.instance.saveProfile(account, profileData);
          LogD('PersonalizeEditView: profile saved successfully');
        } catch (e) {
          LogE('PersonalizeEditView: failed to save profile:\n$e');
        }

        // 3. 标记个性化完成
        try {
          LogD('PersonalizeEditView: calling backend to mark personalized...');
          await ApiService.instance.markPersonalized(account);
          LogD('PersonalizeEditView: backend marked personalized successfully');
        } catch (e) {
          LogE(
              'PersonalizeEditView: failed to mark personalized on backend:\n$e');
        }

        // 4. 更新本地状态
        account.user.personalizeEdit = 1;
        if (avatarUrl != null) {
          account.user.avatarUrl = avatarUrl;
        }
        account.user.gender = _state.gender;
        account.user.birthDate = _state.birthDate;
        account.user.interests = _state.interests;
        account.user.personality = _state.personalityTraits;
        account.user.chatPurpose = _state.lookingFor;
        account.user.communicationStyle = [
          _state.communicationPreference ?? ''
        ];
        account.user.status = _state.status;
        account.user.isStatusPublic = _state.isStatusPublic;
        account.user.blurProfileCard = _state.blurProfileCard;
        context.read<AccountProvider>().setAccount(account);
        LogD('PersonalizeEditView: marked personalizeEdit=1 and saved account');
      }
    } catch (e) {
      LogE('PersonalizeEditView: error marking personalized:\n$e');
    }
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RoutePaths.home,
        (route) => false,
      );
    }
  }

  String _getButtonLabel() {
    if (_currentStep == 6) return 'View Product';
    return 'Next';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF333333),
            ),
            onPressed: _onBack,
          ),
          title: Text(
            _titles[_currentStep],
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'MiSansVF',
            ),
          ),
          actions: [
            if (_currentStep == 3 || _currentStep == 4) _buildSkipButton(),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: Container(
              width: double.infinity,
              height: 3,
              color: const Color(0xFFBCA5A5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: size.width * ((_currentStep + 1) / 8),
                  height: 3,
                  color: const Color(0xFFE0BFB8),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildStepContent(),
                  ),
                ),
                const SizedBox(height: 46),
                Center(
                  child: SizedBox(
                    width: 162.5,
                    height: 51.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: _state.isStepValid(_currentStep)
                            ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFD5A7BD),
                                  Color(0xFFFF9595),
                                ],
                              )
                            : null,
                        color: _state.isStepValid(_currentStep)
                            ? null
                            : const Color(0xFFB0B0B0),
                      ),
                      child: ElevatedButton(
                        onPressed:
                            _state.isStepValid(_currentStep) ? _onNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.transparent,
                          disabledForegroundColor: Colors.white,
                        ),
                        child: Text(
                          _getButtonLabel(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MiSansVF',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return StepBirthDate(
          value: _state.birthDate,
          onChanged: (value) {
            setState(() {
              _state.birthDate = value;
            });
          },
        );
      case 1:
        return StepGender(
          selected: _state.gender,
          onChanged: (value) => setState(() => _state.gender = value),
        );
      case 2:
        return StepUsername(
          value: _state.username,
          onChanged: (value) => setState(() => _state.username = value),
        );
      case 3:
        return StepAvatar(
          avatarPath: _state.avatarPath,
          onChanged: (value) => setState(() => _state.avatarPath = value),
        );
      case 4:
        return StepPersonality(
          selected: _state.personalityTraits,
          onChanged: (value) =>
              setState(() => _state.personalityTraits = value),
        );
      case 5:
        return StepInterests(
          selected: _state.interests,
          onChanged: (value) => setState(() => _state.interests = value),
        );
      case 6:
        return StepLookingFor(
          selected: _state.lookingFor,
          onChanged: (value) => setState(() => _state.lookingFor = value),
        );
      case 7:
        return StepCommunication(
          selected: _state.communicationPreference,
          onChanged: (value) =>
              setState(() => _state.communicationPreference = value),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
