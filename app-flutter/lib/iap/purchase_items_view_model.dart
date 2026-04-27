import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:mobisen_app/iap/iap_helper.dart';
import 'package:mobisen_app/iap/model/product_item_wrapper.dart';
import 'package:mobisen_app/iap/model/product_sub_item_wrapper.dart';
import 'package:mobisen_app/viewmodel/account_view_model.dart';

class PurchaseItemsViewModel extends AccountViewModel {
  List<ProductItemWrapper> items = [];
  List<ProductSubItemWrapper> itemsSub = [];
  final List<Timer?> _timers = [];
  String? currentIndex;

  PurchaseItemsViewModel({required super.accountProvider});

  @override
  void initModel() {
    refresh();
  }

  void refresh() async {
    setLoading(true);
    setLoading(!await _fetchProducts());
  }

  Future<bool> _fetchProducts() async {
    try {
      final list =
          await IAPHelper.instance.getPurchaseItems(accountProvider.account!);
      items
        ..clear()
        ..addAll(list);

      final listSub = await IAPHelper.instance
          .getPurchaseSubItems(accountProvider.account!);
      itemsSub
        ..clear()
        ..addAll(listSub);

      return true;
      // LogD("itemsSub-item:\n${json.encode(itemsSub[0].item)}");
      // LogD(
      //     "itemsSub-rcStoreProduct:\n${json.encode(itemsSub[0].rcStoreProduct)}");
    } catch (e) {
      // LogE("$e"); // print(e);
      // todo report
    }
    return false;
  }

  void changeIndex({
    required String id,
  }) async {
    currentIndex = id;
    notifyListeners();
  }

  void purchase(
      {required ProductItemWrapper item,
      VoidCallback? onSuccess,
      VoidCallback? onFail}) async {
    setLoading(true);
    try {
      await IAPHelper.instance.purchase(accountProvider.account!, item);
      onSuccess?.call();
      _fetchProducts();
      _updateAccount(1000);
      _updateAccount(2000);
      _updateAccount(3000);
      _updateAccount(5000);
      _updateAccount(10000);
      _updateAccount(20000);
      _updateAccount(30000);
    } catch (e) {
      onFail?.call();
    }
    setLoading(false);
  }

  void purchaseV2(
      {required StoreProduct rcStoreProduct,
      VoidCallback? onSuccess,
      VoidCallback? onFail}) async {
    setLoading(true);
    try {
      await IAPHelper.instance
          .purchaseV2(accountProvider.account!, rcStoreProduct);
      onSuccess?.call();
      _fetchProducts();
      _updateAccount(1000);
      _updateAccount(2000);
      _updateAccount(3000);
      _updateAccount(5000);
      _updateAccount(10000);
      _updateAccount(20000);
      _updateAccount(30000);
    } catch (e) {
      onFail?.call();
    }
    setLoading(false);
  }

  void _updateAccount(int delayMillis) {
    _timers.add(Timer(Duration(milliseconds: delayMillis), () async {
      final coins = accountProvider.account?.user.coins;
      await accountProvider.updateAccountProfile();
      if (accountProvider.account?.user.coins != coins) {
        _cancelTimers();
      }
    }));
  }

  void _cancelTimers() {
    for (var timer in _timers) {
      timer?.cancel();
    }
    _timers.clear();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}
