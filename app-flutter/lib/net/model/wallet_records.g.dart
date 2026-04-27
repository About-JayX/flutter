// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletRecords _$WalletRecordsFromJson(Map<String, dynamic> json) =>
    WalletRecords(
      (json['records'] as List<dynamic>)
          .map((e) => WalletRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletRecordsToJson(WalletRecords instance) =>
    <String, dynamic>{
      'records': instance.records.map((e) => e.toJson()).toList(),
    };
