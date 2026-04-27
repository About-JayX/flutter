import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/iap/iap_helper.dart';
import 'package:mobisen_app/net/model/account.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/util/text_utils.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/util/time_utils.dart';
// import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/widget/image_loader.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';
import 'package:mobisen_app/widget/card/card_for_member_pro.dart';

class AccountMixedListItem extends MixedListItem {
  @override
  List<Widget> buildWidgets(BuildContext context) {
    final account = context.watch<AccountProvider>().account;
    return [
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: account == null
              ? _buildGuestWidget(context)
              : _buildAccountWidget(context, account),
        ),
      )
    ];
  }

  Widget _toMemberPro(BuildContext context, Account account) {
    return
        // const SizedBox()
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GestureDetector(
              onTap: () {
                _toTopUp(context, account);
              },
              child: CardForMemberPro(
                gradientColor: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(255, 203, 221, 1),
                      Color.fromRGBO(255, 169, 228, 1.0),
                    ],
                    stops: [
                      0,
                      1
                    ]),
                imageChild: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.blue.withOpacity(0),
                      height: 32.87,
                      width: 37.02,
                    ),
                    Positioned(
                      top: -7.5,
                      left: -7.5,
                      child: Container(
                        width: 63,
                        height: 59,
                        color: Colors.pink.withOpacity(0),
                        child: Assets.images.diamondPro
                            .image(fit: BoxFit.contain, width: 63, height: 59),
                      ),
                    ),
                  ],
                ),
                left: 18.37,
                right: 9.23,
                title: S.current.mobisen_pro,
                des: account.user.membership != null &&
                        (account.user.membership?.level != null &&
                            account.user.membership?.level.toString() != '0')
                    ? "${S.current.expires_in}: ${account.user.membership?.expirationTime == null ? '--' : TimeUtils.formatTimestamp(account.user.membership?.expirationTime ?? 0, format: 'yyyy/MM/dd HH:mm')}"
                    : S.current.enjoy_all_dramas_for_free,
                goChild: Container(
                  width: 25.21,
                  height: 25.17,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 91, 203, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Assets.images.arrowForward
                      .image(fit: BoxFit.contain, width: 6.17)
                  // const Icon(
                  //   Icons.arrow_forward_ios_rounded,
                  //   size: 15,
                  // )
                  ,
                ),
              ),
            ));
  }

  Widget _buildAccountWidget(BuildContext context, Account account) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: ImageLoader.avatar(url: account.user.ensureAvatarUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    TextUtils.isNullOrEmpty(account.user.displayName)
                        ? account.user.username
                        : account.user.displayName!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              )
            ],
          ),
        ),
        Card(
          elevation: 4,
          child: InkWell(
            onTap: () {
              _toWalletDetails(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        S.current.my_wallet,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Expanded(child: SizedBox()),
                      Icon(
                        color: Theme.of(context).textTheme.titleSmall?.color,
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                  const Divider(
                    height: 32,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${account.user.coins}",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const TextSpan(text: "  "),
                              TextSpan(
                                text: S.current.coins,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          _toTopUp(context, account);
                        },
                        style: Theme.of(context).elevatedButtonTheme.style,
                        child: Text(
                          S.current.top_up,
                          textScaler: const TextScaler.linear(1.2),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        _toMemberPro(context, account)
      ],
    );
  }

  void _toTopUp(BuildContext context, Account account) {
    IAPHelper.instance.showPaywall(context, account: account);
  }

  void _toWalletDetails(BuildContext context) {
    Navigator.pushNamed(context, RoutePaths.walletDetails);
  }

  Widget _buildGuestWidget(BuildContext context) {
    return Card(
      elevation: 4,
      child: GestureDetector(
        onTap: () {
          ViewUtils.jumpToLogin(context, null);
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: ImageLoader.avatar(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                    onPressed: () {
                      ViewUtils.jumpToLogin(context, null);
                    },
                    child: Text(
                      S.current.sign_in,
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
