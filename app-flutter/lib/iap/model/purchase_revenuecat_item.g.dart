// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_revenuecat_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseRevenuecatItem _$PurchaseRevenuecatItemFromJson(
        Map<String, dynamic> json) =>
    PurchaseRevenuecatItem(
      identifier: json['identifier'] as String?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      priceString: json['priceString'] as String?,
      currencyCode: json['currencyCode'] as String?,
      introPrice: json['introPrice'],
      discounts: json['discounts'],
      productCategory: json['productCategory'] as String?,
      defaultOption: json['defaultOption'],
      subscriptionOptions: json['subscriptionOptions'],
      presentedOfferingContext: json['presentedOfferingContext'],
      subscriptionPeriod: json['subscriptionPeriod'],
    );

Map<String, dynamic> _$PurchaseRevenuecatItemToJson(
        PurchaseRevenuecatItem instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'description': instance.description,
      'title': instance.title,
      'price': instance.price,
      'priceString': instance.priceString,
      'currencyCode': instance.currencyCode,
      'introPrice': instance.introPrice,
      'discounts': instance.discounts,
      'productCategory': instance.productCategory,
      'defaultOption': instance.defaultOption,
      'subscriptionOptions': instance.subscriptionOptions,
      'presentedOfferingContext': instance.presentedOfferingContext,
      'subscriptionPeriod': instance.subscriptionPeriod,
    };
