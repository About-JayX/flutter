import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:mobisen_app/util/log.dart';
// import 'package:mobisen_app/iap/model/purchase_mock_data.dart';
// import 'package:mobisen_app/iap/model/purchase_revenuecat_item_list.dart';
import 'package:mobisen_app/iap/model/product_sub_item_list.dart';
import 'package:mobisen_app/iap/model/product_item_list.dart';
import 'package:mobisen_app/iap/model/product_item_wrapper.dart';
import 'package:mobisen_app/iap/model/product_sub_item_wrapper.dart';
import 'package:mobisen_app/iap/model/vip_item.dart';
import 'package:mobisen_app/iap/model/vip_product_wrapper.dart';
import 'package:mobisen_app/iap/purchase_items_view.dart';
import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/net/model/account.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/configs.dart';
import 'package:mobisen_app/remote_configs.dart';

class IAPHelper {
  static IAPHelper instance = IAPHelper._();

  bool _hasPurchased = false;

  IAPHelper._();

  Future<void> tryInit(Account? account) async {
    try {
      if (account == null || await Purchases.isConfigured) {
        return;
      }
      PurchasesConfiguration? configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(RevenueCatConfig.androidKey)
          ..appUserID = _getAccountId(account);
      } else if (Platform.isIOS) {
        configuration = PurchasesConfiguration(RevenueCatConfig.iosKey)
          ..appUserID = _getAccountId(account);
      }
      if (configuration != null) {
        await Purchases.configure(configuration);
      } else {
        throw Exception("Unsupported platform");
      }
    } catch (_) {}
  }

  Future<void> setAccount(Account? account) async {
    try {
      if (account != null) {
        _checkUserId(account);
      }
    } catch (e) {
      // todo report
    }
  }

  Future<void> showPaywall(BuildContext context,
      {required Account account,
      Show? show,
      Episode? episode,
      bool useDialogStyle = false}) async {
    try {
      if (context.mounted) {
        if (useDialogStyle) {
          showModalBottomSheet(
            context: context,
            builder: (context) => PurchaseItemsView(
              show: show,
              episode: episode,
              useDialogStyle: useDialogStyle,
            ),
          );
        } else {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PurchaseItemsView(
                  show: show,
                  episode: episode,
                  useDialogStyle: useDialogStyle,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // const beginScale = 0.0;
                  // const endScale = 1.0;
                  const beginOpacity = 0.0;
                  const endOpacity = 1.0;
                  const curve = Curves.easeInOut;

                  // var scaleTween = Tween(begin: beginScale, end: endScale)
                  //     .chain(CurveTween(curve: curve));
                  var opacityTween = Tween(begin: beginOpacity, end: endOpacity)
                      .chain(CurveTween(curve: curve));

                  // var scaleAnimation = animation.drive(scaleTween);
                  var opacityAnimation = animation.drive(opacityTween);

                  return FadeTransition(
                    opacity: opacityAnimation,
                    child: child,
                    // ScaleTransition(
                    //   scale: scaleAnimation,
                    //   child: child,
                    // ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
              ));
        }
      }
    } catch (e) {
      LogE("IAPHelper - showPaywall:\n$e");
      // todo report
    }
  }

  static String _getAccountId(Account account) {
    return "${account.user.id}";
  }

  Future<List<ProductItemWrapper>> getPurchaseItems(Account account) async {
    await _checkUserId(account);

    String itemsConfigStr;
    if (Platform.isAndroid) {
      itemsConfigStr = RemoteConfigs.instance.getPurchaseItemsAndroidString();
    } else if (Platform.isIOS) {
      itemsConfigStr = RemoteConfigs.instance.getPurchaseItemsIOSString();
    } else {
      throw Exception("Unsupported platform");
    }

    final itemList = ProductItemList.fromJson(
        await compute((s) => const JsonDecoder().convert(s), itemsConfigStr));

    final newUser = (!_hasPurchased) &&
        ((await ApiService.instance.getAccountUserInfo(account)).hasPurchased ==
            false);

    itemList.items = itemList.items.where((item) {
      if (item.isTypeNormal()) {
        return true;
      } else if (item.isTypeNewUser() && newUser) {
        return true;
      }
      return false;
    }).toList();

    final products = (await Purchases.getProducts(
        itemList.items.map((e) => e.id).toList(),
        productCategory: ProductCategory.nonSubscription));
    // LogD("🔥products:\n${itemList.items.map((e) => e.id).toList()}");

    final productMap = {
      for (var product in products) product.identifier: product
    };
    return itemList.items
        .where((e) => productMap[e.id] != null)
        .map((e) => ProductItemWrapper(e, productMap[e.id]!))
        .toList();
  }

  Future<List<ProductSubItemWrapper>> getPurchaseSubItems(
      Account account) async {
    await _checkUserId(account);

    String itemsSubConfigStr;
    if (Platform.isAndroid) {
      itemsSubConfigStr =
          RemoteConfigs.instance.getPurchaseSubItemsAndroidString();
    } else if (Platform.isIOS) {
      itemsSubConfigStr = RemoteConfigs.instance.getPurchaseSubItemsIOSString();
    } else {
      throw Exception("Unsupported platform");
    }

    final itemSubList = ProductSubItemList.fromJson(await compute(
        (s) => const JsonDecoder().convert(s), itemsSubConfigStr));
    // LogD("itemSubList:\n${json.encode(itemSubList).toString()}");
    // LogD("itemSubList-items:\n${itemSubList.items}");
    // LogD("itemSubList-items-id:\n${itemSubList.items?[0].id}");

    // PurchaseRevenuecatItemList items = PurchaseRevenuecatItemList.fromJson(
    //     json.decode(JsonString.purchaseSubRevenuecatMockData));
    // final productsSub = items.items;
    List<String> identifiersToKeep =
        itemSubList.items?.map((e) => e.id).whereType<String>().toList() ?? [];
    Purchases.setLogLevel(LogLevel.debug);
    final productsSub = (await Purchases.getProducts(
        Platform.isIOS ? identifiersToKeep : ["android_pro"],
        productCategory: ProductCategory.subscription));
    final filteredProducts = productsSub.where((product) {
      return identifiersToKeep.contains(product.identifier);
    }).toList();

    final productMap = {
      for (var product in filteredProducts) product.identifier: product
    };
    List<ProductSubItemWrapper> itemList = (itemSubList.items ?? [])
        .where((e) => productMap[e.id] != null)
        .map((e) => ProductSubItemWrapper(e, productMap[e.id]!))
        .toList();
    return itemList;
  }

  Future<void> purchase(Account account, ProductItemWrapper item) async {
    await _checkUserId(account);
    await Purchases.purchase(PurchaseParams.storeProduct(item.rcStoreProduct));
    _hasPurchased = true;
  }

  Future<void> purchaseV2(Account account, StoreProduct rcStoreProduct) async {
    await _checkUserId(account);
    await Purchases.purchase(PurchaseParams.storeProduct(rcStoreProduct));
    _hasPurchased = true;
  }

  /// 获取 VIP 商品列表
  Future<List<VIPProductWrapper>> getVIPItems(Account account) async {
    await _checkUserId(account);

    String itemsConfigStr;
    if (Platform.isAndroid) {
      itemsConfigStr = RemoteConfigs.instance.getVIPItemsAndroidString();
    } else if (Platform.isIOS) {
      itemsConfigStr = RemoteConfigs.instance.getVIPItemsIOSString();
    } else {
      throw Exception("Unsupported platform");
    }

    final itemList = VIPItemList.fromJson(
        await compute((s) => const JsonDecoder().convert(s), itemsConfigStr));

    final products = await Purchases.getProducts(
      itemList.items.map((e) => e.id).toList(),
      productCategory: ProductCategory.subscription,
    );

    final productMap = {
      for (var product in products) product.identifier: product
    };

    return itemList.items
        .where((e) => productMap[e.id] != null)
        .map((e) => VIPProductWrapper(item: e, storeProduct: productMap[e.id]!))
        .toList();
  }

  /// 购买 VIP
  Future<void> purchaseVIP(Account account, VIPProductWrapper item) async {
    await _checkUserId(account);
    await Purchases.purchase(PurchaseParams.storeProduct(item.storeProduct));
  }

  /// 检查是否是 VIP
  Future<bool> isVIP() async {
    try {
      if (!await Purchases.isConfigured) return false;
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active
          .containsKey(RevenueCatConfig.entitlementId);
    } catch (e) {
      return false;
    }
  }

  /// 获取 VIP 过期时间
  Future<DateTime?> getVIPExpireDate() async {
    try {
      if (!await Purchases.isConfigured) return null;
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement =
          customerInfo.entitlements.all[RevenueCatConfig.entitlementId];
      final expirationDateStr = entitlement?.expirationDate;
      if (expirationDateStr != null) {
        return DateTime.tryParse(expirationDateStr);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 恢复购买
  Future<CustomerInfo?> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      return null;
    }
  }

  Future<void> _checkUserId(Account account) async {
    await tryInit(account);

    final String userId = _getAccountId(account);
    if ((await Purchases.appUserID) != userId) {
      await Purchases.logIn(userId);
    }
    if ((await Purchases.appUserID) != userId ||
        (await Purchases.isAnonymous)) {
      throw Exception();
    }
    await Future.delayed(const Duration(milliseconds: 1));
  }
}
