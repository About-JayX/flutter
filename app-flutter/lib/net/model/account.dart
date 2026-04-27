import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/net/model/user.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account {
  User user;
  String jwt;

  Account(this.user, this.jwt);

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
