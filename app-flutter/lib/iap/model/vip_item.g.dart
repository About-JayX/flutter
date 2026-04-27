// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VIPItem _$VIPItemFromJson(Map<String, dynamic> json) => VIPItem(
      id: json['id'] as String,
      type: json['type'] as String,
      level: (json['level'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$VIPItemToJson(VIPItem instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'level': instance.level,
      'name': instance.name,
      'description': instance.description,
    };

VIPItemList _$VIPItemListFromJson(Map<String, dynamic> json) => VIPItemList(
      items: (json['items'] as List<dynamic>)
          .map((e) => VIPItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VIPItemListToJson(VIPItemList instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
