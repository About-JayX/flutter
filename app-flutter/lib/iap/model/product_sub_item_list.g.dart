// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sub_item_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSubItemList _$ProductSubItemListFromJson(Map<String, dynamic> json) =>
    ProductSubItemList(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ProductSubItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductSubItemListToJson(ProductSubItemList instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
