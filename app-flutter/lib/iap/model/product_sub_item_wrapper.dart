import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:mobisen_app/iap/model/product_sub_item.dart';

class ProductSubItemWrapper {
  ProductSubItem item;
  StoreProduct rcStoreProduct;

  ProductSubItemWrapper(
    this.item,
    this.rcStoreProduct,
  );
}
