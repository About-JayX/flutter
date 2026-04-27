import 'package:json_annotation/json_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:mobisen_app/iap/model/purchase_revenuecat_item.dart';

part 'purchase_revenuecat_item_list.g.dart';

@JsonSerializable()
class PurchaseRevenuecatItemList {
  List<StoreProduct>? items;

  PurchaseRevenuecatItemList({
    this.items,
  });

  factory PurchaseRevenuecatItemList.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRevenuecatItemListFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseRevenuecatItemListToJson(this);
}
