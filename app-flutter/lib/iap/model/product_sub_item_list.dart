import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/iap/model/product_sub_item.dart';

part 'product_sub_item_list.g.dart';

@JsonSerializable()
class ProductSubItemList {
  List<ProductSubItem>? items;

  ProductSubItemList({
    this.items,
  });

  factory ProductSubItemList.fromJson(Map<String, dynamic> json) =>
      _$ProductSubItemListFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSubItemListToJson(this);
}
