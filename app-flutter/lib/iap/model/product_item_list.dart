import 'package:json_annotation/json_annotation.dart';
import 'package:mobisen_app/iap/model/product_item.dart';

part 'product_item_list.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductItemList {
  List<ProductItem> items;

  ProductItemList(this.items);

  factory ProductItemList.fromJson(Map<String, dynamic> json) =>
      _$ProductItemListFromJson(json);
  Map<String, dynamic> toJson() => _$ProductItemListToJson(this);
}
