import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/net/model/wallet_record.dart';

part 'wallet_records.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletRecords {
  List<WalletRecord> records;

  WalletRecords(this.records);

  factory WalletRecords.fromJson(Map<String, dynamic> json) =>
      _$WalletRecordsFromJson(json);
  Map<String, dynamic> toJson() => _$WalletRecordsToJson(this);
}
