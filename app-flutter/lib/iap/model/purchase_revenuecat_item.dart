import 'package:json_annotation/json_annotation.dart';

part 'purchase_revenuecat_item.g.dart';

@JsonSerializable()
class PurchaseRevenuecatItem {
  final String? identifier;
  final String? description;
  final String? title;
  final double? price;
  final String? priceString;
  final String? currencyCode;
  final dynamic introPrice;
  final dynamic discounts;
  final String? productCategory;
  final dynamic defaultOption;
  final dynamic subscriptionOptions;
  final dynamic presentedOfferingContext;
  final dynamic subscriptionPeriod;

  const PurchaseRevenuecatItem({
    this.identifier,
    this.description,
    this.title,
    this.price,
    this.priceString,
    this.currencyCode,
    this.introPrice,
    this.discounts,
    this.productCategory,
    this.defaultOption,
    this.subscriptionOptions,
    this.presentedOfferingContext,
    this.subscriptionPeriod,
  });

  factory PurchaseRevenuecatItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRevenuecatItemFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseRevenuecatItemToJson(this);
}
