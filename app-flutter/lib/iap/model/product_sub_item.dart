import 'package:json_annotation/json_annotation.dart';

part 'product_sub_item.g.dart';

@JsonSerializable()
class ProductSubItem {
  final String? id;
  final String? type;

  const ProductSubItem({
    this.id,
    this.type,
  });

  factory ProductSubItem.fromJson(Map<String, dynamic> json) =>
      _$ProductSubItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSubItemToJson(this);
}
