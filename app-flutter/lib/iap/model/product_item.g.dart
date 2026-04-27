// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItem _$ProductItemFromJson(Map<String, dynamic> json) => ProductItem(
      json['id'] as String,
      (json['coins'] as num?)?.toInt(),
      (json['extraCoins'] as num?)?.toInt(),
      json['type'] as String?,
    );

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coins': instance.coins,
      'extraCoins': instance.extraCoins,
      'type': instance.type,
    };
