import 'package:flutter/material.dart';
import 'package:mobisen_app/net/model/wallet_record.dart';
import 'package:mobisen_app/util/text_utils.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';

class WalletRecordMixedListItem extends MixedListItem {
  final WalletRecord _record;
  WalletRecordMixedListItem(this._record);

  @override
  List<Widget> buildWidgets(BuildContext context) {
    final timeFormatted = TextUtils.formatTimestamp(_record.timestamp);
    return [
      SliverToBoxAdapter(
        child: ListTile(
          onTap: () {},
          title: Text(_record.title ?? timeFormatted),
          subtitle: _record.title == null ? null : Text(timeFormatted),
          trailing: Text(
            "${_record.coins}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    ];
  }
}
