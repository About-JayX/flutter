import 'package:json_annotation/json_annotation.dart';

part 'vip_item.g.dart';

@JsonSerializable()
class VIPItem {
  final String id; // 商品ID
  final String type; // 类型: basic/premium/ultimate
  final int level; // 等级: 1/2/3
  final String? name; // 显示名称
  final String? description; // 描述

  const VIPItem({
    required this.id,
    required this.type,
    required this.level,
    this.name,
    this.description,
  });

  factory VIPItem.fromJson(Map<String, dynamic> json) =>
      _$VIPItemFromJson(json);
  Map<String, dynamic> toJson() => _$VIPItemToJson(this);
}

@JsonSerializable()
class VIPItemList {
  List<VIPItem> items;

  VIPItemList({required this.items});

  factory VIPItemList.fromJson(Map<String, dynamic> json) =>
      _$VIPItemListFromJson(json);
  Map<String, dynamic> toJson() => _$VIPItemListToJson(this);
}
