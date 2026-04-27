import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/view/base_widget.dart';
import 'package:mobisen_app/viewmodel/wallet_records_view_model.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';

class WalletDetailView extends StatelessWidget {
  const WalletDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: ViewUtils.buildCommonAppBar(
          context,
          title: Text(S.current.my_wallet),
          bottom: TabBar(
            tabs: [
              Tab(text: S.current.consumption),
              Tab(text: S.current.income),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _WalletRecordsListView(endPoint: ApiEndPoints.consumptionRecords),
            _WalletRecordsListView(endPoint: ApiEndPoints.incomeRecords),
          ],
        ),
      ),
    );
  }
}

class _WalletRecordsListView extends StatelessWidget {
  final String endPoint;

  const _WalletRecordsListView({required this.endPoint});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    return BaseWidget(
        builder: (context, model, child) => MixedListView(
              loading: model.loading,
              error: model.error,
              onRefresh: () => model.refresh(),
              onLoadMore: () => model.loadMore(),
              dataRaw: model.records,
            ),
        model: WalletRecordsViewModel(
            accountProvider: accountProvider, endPoint: endPoint),
        onModelReady: (model) => model.initModel());
  }
}
