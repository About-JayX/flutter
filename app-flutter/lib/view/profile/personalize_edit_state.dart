class PersonalizeEditState {
  String? birthDate;
  String? gender;
  String? username;
  String? avatarPath;
  List<String> personalityTraits = [];
  List<String> interests = [];
  List<String> lookingFor = [];
  String? communicationPreference;
  String? status;
  bool isStatusPublic = false;
  bool blurProfileCard = false;

  bool get isBirthDateValid =>
      birthDate != null && birthDate!.replaceAll(' / ', '').length == 8;

  bool get isGenderValid => gender != null && gender!.isNotEmpty;

  bool get isUsernameValid =>
      username != null && username!.trim().isNotEmpty && username!.length <= 20;

  bool get isAvatarValid => avatarPath != null && avatarPath!.isNotEmpty;

  bool get isPersonalityValid => personalityTraits.isNotEmpty;

  bool get isInterestsValid => interests.isNotEmpty;

  bool get isLookingForValid => lookingFor.isNotEmpty;

  bool get isCommunicationValid =>
      communicationPreference != null && communicationPreference!.isNotEmpty;

  bool isStepValid(int step) {
    switch (step) {
      case 0:
        return isBirthDateValid;
      case 1:
        return isGenderValid;
      case 2:
        return isUsernameValid;
      case 3:
        return isAvatarValid;
      case 4:
        return isPersonalityValid;
      case 5:
        return isInterestsValid;
      case 6:
        return isLookingForValid;
      case 7:
        return isCommunicationValid;
      default:
        return false;
    }
  }
}
