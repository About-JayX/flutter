import 'package:json_annotation/json_annotation.dart';

part 'product_item.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductItem {
  String id;
  int? coins;
  int? extraCoins;
  String? type;

  ProductItem(this.id, this.coins, this.extraCoins, this.type);

  factory ProductItem.fromJson(Map<String, dynamic> json) =>
      _$ProductItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProductItemToJson(this);

  bool isTypeNewUser() {
    return type == "new_user";
  }

  bool isTypeNormal() {
    return type == "normal";
  }
}
