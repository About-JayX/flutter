import 'package:mobisen_app/net/model/homepage_category.dart';
import 'package:mobisen_app/net/model/wallet_record.dart';
import 'package:mobisen_app/widget/mixed_list/homepage_category_mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/wallet_record_mixed_list_item.dart';

class MixedListItemHelper {
  static MixedListItem? convert(Object obj) {
    switch (obj) {
      case HomepageCategory data:
        return HomepageCategoryMixedListItem(data);
      case WalletRecord data:
        return WalletRecordMixedListItem(data);
      default:
        return null;
    }
  }

  static List<MixedListItem> convertList(List<Object> list) {
    return list
        .map((e) => convert(e))
        .where((e) => e != null)
        .cast<MixedListItem>()
        .toList();
  }
}
