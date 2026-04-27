import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:mobisen_app/iap/model/vip_item.dart';

class VIPProductWrapper {
  final VIPItem item;
  final StoreProduct storeProduct;

  const VIPProductWrapper({
    required this.item,
    required this.storeProduct,
  });

  String get id => item.id;
  String get type => item.type;
  int get level => item.level;
  String get name => item.name ?? storeProduct.title;
  String get description => item.description ?? storeProduct.description;
  String get priceString => storeProduct.priceString;
  double get price => storeProduct.price;
}
