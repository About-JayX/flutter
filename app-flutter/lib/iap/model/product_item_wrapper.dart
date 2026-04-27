import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:mobisen_app/iap/model/product_item.dart';

class ProductItemWrapper {
  ProductItem item;
  StoreProduct rcStoreProduct;

  ProductItemWrapper(this.item, this.rcStoreProduct);
}
