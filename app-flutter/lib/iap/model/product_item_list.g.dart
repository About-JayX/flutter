// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItemList _$ProductItemListFromJson(Map<String, dynamic> json) =>
    ProductItemList(
      (json['items'] as List<dynamic>)
          .map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductItemListToJson(ProductItemList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
