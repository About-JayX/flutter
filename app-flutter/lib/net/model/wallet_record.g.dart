// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletRecord _$WalletRecordFromJson(Map<String, dynamic> json) => WalletRecord(
      (json['coins'] as num).toInt(),
      (json['timestamp'] as num).toInt(),
      json['title'] as String?,
    );

Map<String, dynamic> _$WalletRecordToJson(WalletRecord instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'title': instance.title,
      'coins': instance.coins,
    };
