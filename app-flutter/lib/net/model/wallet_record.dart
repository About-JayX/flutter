import 'package:json_annotation/json_annotation.dart';

part 'wallet_record.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletRecord {
  int timestamp;
  String? title;
  int coins;

  WalletRecord(this.coins, this.timestamp, this.title);

  factory WalletRecord.fromJson(Map<String, dynamic> json) =>
      _$WalletRecordFromJson(json);
  Map<String, dynamic> toJson() => _$WalletRecordToJson(this);
}
