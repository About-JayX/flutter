import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/configs_provider.dart';
import 'package:mobisen_app/remote_configs.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/util/time_utils.dart';
import 'package:mobisen_app/util/in_app_review_helper.dart';
import 'package:mobisen_app/view/base_widget.dart';
import 'package:mobisen_app/view/video/show_detail_view.dart';
import 'package:mobisen_app/viewmodel/show_view_model.dart';
import 'package:mobisen_app/widget/empty_view.dart';
import 'package:mobisen_app/widget/loading.dart';

class ShowView extends StatelessWidget {
  final int showId;

  const ShowView({super.key, required this.showId});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final configsProvider = context.watch<ConfigsProvider>();
    final remoteConfig = RemoteConfigs.instance;

    return PopScope<Map<String, dynamic>>(
        canPop: true,
        onPopInvokedWithResult:
            (bool didPop, Map<String, dynamic>? result) async {
          LogI("PopScope-onPopInvokedWithResult:ShowView");
          // if (didPop) {
          //   return;
          // }
          // Navigator.pop(context, result);

          Future.delayed(const Duration(seconds: 1), () async {
            // LogI("PopScope-onPopInvokedWithResult:ShowView-----delayed seconds: 1");
            final isCoinEnough =
                (accountProvider.account?.user.coins ?? 0) >= 30;
            final isPro = accountProvider.account?.user.membership?.level == 1;
            int limitTime =
                // 1 * 60 * 1000
                24 * 60 * 60 * 1000;
            final inAppDayEnough =
                (configsProvider.configs.firstLaunchTimeMillis.value -
                            DateTime.now().millisecondsSinceEpoch)
                        .abs() >=
                    limitTime;
            final inAppReviewFirst =
                configsProvider.configs.inAppReviewFirst.value;
            final canInAppReview = remoteConfig.getInAppReviewBool();
            LogD(
                "PopScope-isCoinEnough($isCoinEnough) + isPro($isPro) + inAppDayEnough($inAppDayEnough) + inAppReviewFirst($inAppReviewFirst) + canInAppReview($canInAppReview)");
            if ((isCoinEnough || isPro) &&
                inAppDayEnough &&
                inAppReviewFirst &&
                canInAppReview) {
              // LogD("PopScope-InAppReviewHelper.toReview():start");
              InAppReviewHelper.toReview();
              configsProvider.configs.inAppReviewFirst.value = false;
              configsProvider.onConfigChanged();
            }
          });
        },
        child: Scaffold(
          body: Container(
            color: Colors.black,
            child: BaseWidget(
                builder: (context, model, child) => model.loading ||
                        model.show == null ||
                        (model.show?.episodes ?? []).isEmpty
                    ? Stack(
                        children: [
                          model.loading
                              ? const Loading()
                              : EmptyErrorView(
                                  onTap: () => model.refresh(),
                                ),
                          ViewUtils.buildVideoAppBar(context),
                        ],
                      )
                    : ShowDetailsView(
                        show: model.show!,
                        onShowRefresh: () {
                          LogD("ShowDetailsView-----model.refresh()");
                          model.refresh();
                        },
                      ),
                model: ShowViewModel(
                    accountProvider: accountProvider, showId: showId),
                onModelReady: (model) => model.initModel()),
          ),
        ));
  }
}
