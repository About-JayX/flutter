import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfo {
  bool? hasPurchased;

  UserInfo(this.hasPurchased);

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
