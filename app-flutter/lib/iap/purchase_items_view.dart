import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/iap/model/product_item_wrapper.dart';
import 'package:mobisen_app/iap/model/product_sub_item_wrapper.dart';
import 'package:mobisen_app/iap/purchase_items_view_model.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/mixin/mixin.dart';
import 'package:mobisen_app/event_bus/event_bus.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/track_utils.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/util/time_utils.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/view/base_widget.dart';
import 'package:mobisen_app/widget/loading.dart';
import 'package:mobisen_app/widget/card/card_for_member_pro.dart';
import 'package:mobisen_app/widget/card/card_for_coins.dart';

class PurchaseItemsView extends StatefulWidget {
  final Show? show;
  final Episode? episode;
  final bool useDialogStyle;

  const PurchaseItemsView(
      {super.key, this.show, this.episode, this.useDialogStyle = false});

  @override
  State<PurchaseItemsView> createState() => _PurchaseItemsViewState();
}

class _PurchaseItemsViewState extends State<PurchaseItemsView>
    with UserMembershipMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accountProvider = context.read<AccountProvider>();
      updateUserMembershipAction(accountProvider);
    });

    TrackHelper.instance.track(
        event: TrackEvents.iap,
        action: TrackValues.showDetails,
        params:
            TrackUtils.showEpisode(show: widget.show, episode: widget.episode));
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    int? episodePrice = widget.episode?.price;

    // LogD(json.encode(accountProvider.account).toString());

    bool isPro = accountProvider.account?.user.membership != null &&
        (accountProvider.account?.user.membership?.level != null &&
            accountProvider.account?.user.membership?.level.toString() != '0');
    return Scaffold(
        // backgroundColor: const Color.fromRGBO(20, 15, 18, 1),
        body: Stack(
      children: [
        /// bg bottom
        if (!widget.useDialogStyle)
          Positioned.fill(
              child: Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromRGBO(20, 15, 18, 1),
            alignment: Alignment.bottomCenter,
            // child: Container(
            //   height: 482.99,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: Assets.images.membershipBottomBg.image().image,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
          )),

        /// post head
        if (!widget.useDialogStyle)
          Positioned.fill(
              top: 0,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 188,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Assets.images.membershipHeadbg.image().image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        // alignment: Alignment.topCenter,
                        children: [
                          Container(
                              alignment: Alignment.topCenter,
                              margin: const EdgeInsets.only(top: 68.93),
                              // color: Colors.orange,
                              height: 44,
                              child: Assets.images.mobisenPro.image(
                                fit: BoxFit.contain,
                                // width: 194,
                              )),
                          Positioned(
                            top: 68.93,
                            left: 21.48,
                            height: 44,
                            child: Center(
                              child: GestureDetector(
                                  onTap: () => Navigator.maybePop(context),
                                  child: ClipOval(
                                    child: Container(
                                      width: 36.06,
                                      height: 36.06,
                                      alignment: Alignment.center,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.06),
                                      child: Assets.images.arrowBack.image(
                                          fit: BoxFit.contain,
                                          width: 12.6,
                                          height: 12.6),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      )),
                ],
              )),

        /// container
        // SafeArea(
        //   child:
        BaseWidget(
          builder: (context, model, child) {
            ProductItemWrapper? firstNewUserItem;
            List<ProductItemWrapper> otherItems = [];
            for (var i = 0; i < model.items.length; i++) {
              final item = model.items[i];
              if (i == 0 && item.item.isTypeNewUser()) {
                firstNewUserItem = item;
              } else {
                otherItems.add(item);
              }
            }

            return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, dynamic) async {
                  if (didPop) {
                    return;
                  }
                  final shouldPop = await _shouldPopNewUser(firstNewUserItem);
                  if (shouldPop && context.mounted) {
                    Navigator.of(context, rootNavigator: false).pop();
                  }
                },
                child: Container(
                  height: !widget.useDialogStyle ? double.infinity : 482.99,
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(top: !widget.useDialogStyle ? 116.1 : 0),
                  child: model.items.isEmpty
                      ? (Center(
                          child: model.loading
                              ? const Loading()
                              : TextButton(
                                  onPressed: () => model.refresh(),
                                  child: Text(S.current.empty_refresh_prompt),
                                ),
                        ))
                      : CustomScrollView(
                          slivers: [
                            /// account membership info
                            if (widget.useDialogStyle)
                              SliverToBoxAdapter(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.02, 13.19, 9.54, 0),
                                    child: SizedBox(
                                        // height: 37.87,
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                    decoration: const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 203, 0, 0.1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    37.87))),
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 9.62,
                                                        horizontal: 19.64),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: RichText(
                                                        // overflow: TextOverflow
                                                        //     .ellipsis,
                                                        text: TextSpan(
                                                            text:
                                                                "${S.current.balance}: ",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            1)),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "${accountProvider.account?.user.coins ?? 0}"
                                                                // S.current.coins_num(
                                                                //     accountProvider
                                                                //             .account
                                                                //             ?.user
                                                                //             .coins ??
                                                                //         0
                                                                // )
                                                                ,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            224,
                                                                            100,
                                                                            1)),
                                                              )
                                                            ]),
                                                      ),
                                                    )),
                                              ),
                                              // const SizedBox(
                                              //   width: 12,
                                              // ),
                                              if (episodePrice != null &&
                                                  episodePrice > 0)
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 12),
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              61,
                                                              190,
                                                              0.08),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      37.87))),
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 9.62,
                                                          horizontal: 19.64),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: RichText(
                                                          // overflow: TextOverflow
                                                          //     .ellipsis,
                                                          text: TextSpan(
                                                              text:
                                                                  "${S.current.this_episode}: ",
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          1)),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "$episodePrice"
                                                                  // S.current
                                                                  //     .coins_num(
                                                                  //         episodePrice)
                                                                  ,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color.fromRGBO(
                                                                          255,
                                                                          40,
                                                                          184,
                                                                          1)),
                                                                )
                                                              ]),
                                                        ),
                                                      )),
                                                )
                                            ])),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: GestureDetector(
                                              onTap: () =>
                                                  Navigator.maybePop(context),
                                              child: ClipOval(
                                                child: Container(
                                                  width: 37.87,
                                                  height: 37.87,
                                                  alignment: Alignment.center,
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 0.06),
                                                  child: Assets.images.close
                                                      .image(
                                                          fit: BoxFit.contain,
                                                          width: 12.6,
                                                          height: 12.6),
                                                ),
                                              )),
                                        )
                                      ],
                                    ))),
                              ),

                            /// pro
                            if (!(widget.useDialogStyle && !isPro))
                              SliverToBoxAdapter(
                                  child: Container(
                                height: 20,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                    top: 0, left: 11.9, right: 11.9),
                                child: Text(
                                  S.current.unlock_all_series,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                  // Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                                ),
                              )),
                            // const SliverToBoxAdapter(
                            //   child: SizedBox(
                            //     height: 11.5,
                            //   ),
                            // ),
                            /// pro card
                            isPro
                                ? SliverToBoxAdapter(
                                    child: Container(
                                    height: 20,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                        top: 11.5, left: 11.9, right: 11.9),
                                    child: Text(
                                      "${S.current.expires_in}: ${accountProvider.account?.user.membership?.expirationTime == null ? '--' : TimeUtils.formatTimestamp(accountProvider.account?.user.membership?.expirationTime ?? 0, format: 'yyyy/MM/dd HH:mm')}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.49)),
                                    ),
                                  ))
                                : SliverToBoxAdapter(
                                    child: Container(
                                        // color: Colors.blue,
                                        margin: EdgeInsets.only(
                                            // left: 10,
                                            top: widget.useDialogStyle
                                                ? 16.12
                                                : 20.97),
                                        height:
                                            !widget.useDialogStyle ? 93 : 72.21,
                                        // color: Colors.orange,
                                        child: Swiper(
                                          itemBuilder: (context, int index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12,
                                                  bottom: widget.useDialogStyle
                                                      ? 0
                                                      : 13.02),
                                              child: _buildSubItemView(
                                                  context,
                                                  accountProvider,
                                                  model,
                                                  model.itemsSub[index],
                                                  index),
                                            );
                                          },
                                          indicatorLayout:
                                              PageIndicatorLayout.COLOR,
                                          itemCount: model.itemsSub.length,
                                          loop: true,
                                          viewportFraction: .9,
                                          scale: 1,
                                          pagination: !widget.useDialogStyle
                                              ? const SwiperPagination(
                                                  margin: EdgeInsets.all(0),
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  builder:
                                                      DotSwiperPaginationBuilder(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, .12),
                                                    activeColor: Colors.white,
                                                    size: 7.6,
                                                    activeSize: 7.6,
                                                  ))
                                              : null,
                                          control: null,
                                        )),
                                  ),
                            if (!widget.useDialogStyle ||
                                (widget.useDialogStyle &&
                                    firstNewUserItem != null))
                              SliverToBoxAdapter(
                                  child: Column(children: [
                                Container(
                                  // color: Colors.red,
                                  padding: EdgeInsets.only(
                                    top: !widget.useDialogStyle && isPro
                                        ? 30.02
                                        : !widget.useDialogStyle && !isPro
                                            ? 31.12
                                            : 14.55,
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: const Color.fromRGBO(
                                    255,
                                    255,
                                    255,
                                    .08,
                                  ),
                                )
                              ])),

                            /// coins
                            /// coins button
                            if (!widget.useDialogStyle)
                              SliverToBoxAdapter(
                                  child: Center(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: isPro ? 30.03 : 29.64),
                                        width: 209.08,
                                        // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                        height: 48.81,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Assets.images.coin.image(
                                                fit: BoxFit.contain,
                                                width: 22,
                                                height: 22),
                                            const SizedBox(width: 8),
                                            Text("${S.current.my_coins}: ",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                )),
                                            Text(
                                              '${accountProvider.account?.user.coins ?? 0}',
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      235, 71, 184, 1),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              )),
                            // SliverToBoxAdapter(
                            //   child: SizedBox(
                            //     height: !widget.useDialogStyle ? 14.94 : 10,
                            //   ),
                            // ),
                            /// coins firstNewUser
                            if (firstNewUserItem != null)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          widget.useDialogStyle ? 14.94 : 19.5),
                                  child: Column(
                                    children: [
                                      _buildNewUserItemView(
                                          model, firstNewUserItem),
                                      // _buildNewUserItemViewWithScreenUtil(
                                      //     model, firstNewUserItem),
                                    ],
                                  ),
                                ),
                              ),

                            /// coins purchase list
                            SliverPadding(
                                padding: EdgeInsets.only(
                                    top: !widget.useDialogStyle &&
                                            firstNewUserItem == null
                                        ? 21.67
                                        : 11.37,
                                    left: 8,
                                    right: 8),
                                sliver: SliverList.builder(
                                    itemCount: otherItems.length,
                                    itemBuilder: (context, index) =>
                                        _buildItemView(
                                            context,
                                            accountProvider,
                                            model,
                                            otherItems[index],
                                            episodePrice,
                                            index: index))),

                            /// tips
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 13.64, left: 18, right: 18, bottom: 40),
                              child: Text(
                                S.current.purchase_tips(Platform.isAndroid
                                    ? "Google Play"
                                    : "App Store"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Color.fromRGBO(255, 255, 255, 0.24)),
                              ),
                            )),
                          ],
                        ),
                ));
          },
          model: PurchaseItemsViewModel(accountProvider: accountProvider),
          onModelReady: (model) => model.initModel(),
        ),
        // ),
      ],
    ));
  }

  Future<bool> _shouldPopNewUser(ProductItemWrapper? newUserItem) async {
    if (newUserItem == null) {
      return true;
    }
    return true ==
        (await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                icon: Assets.images.coins
                    .image(width: 52, height: 52, fit: BoxFit.contain),
                content: Text(
                  S.current.new_user_product_give_up_msg(
                      S.current.coins_num(newUserItem.item.coins ?? 0),
                      newUserItem.rcStoreProduct.priceString),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    child: Text(S.current.give_up),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    child: Text(S.current.back),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ],
              );
            }));
  }

  void _purchaseItem(PurchaseItemsViewModel model, ProductItemWrapper item) {
    final trackParams =
        TrackUtils.showEpisode(show: widget.show, episode: widget.episode)
          ..[TrackParams.productId] = item.item.id;
    TrackHelper.instance.track(
        event: TrackEvents.iap,
        action: TrackValues.clickItem,
        params: trackParams);

    TrackHelper.instance.facebookAppEvents.logEvent(
        name: FacebookAppEvents.eventNameAddedToCart,
        parameters: {
          FacebookAppEvents.paramNameCurrency: item.rcStoreProduct.currencyCode,
        },
        valueToSum: item.rcStoreProduct.price);

    model.purchase(
        item: item,
        onSuccess: () {
          ViewUtils.showToast(S.current.purchase_successful);

          TrackHelper.instance.track(
              event: TrackEvents.iap,
              action: TrackValues.success,
              params: trackParams);

          TrackHelper.instance.facebookAppEvents.logPurchase(
              amount: item.rcStoreProduct.price,
              currency: item.rcStoreProduct.currencyCode);
        },
        onFail: () {
          TrackHelper.instance.track(
              event: TrackEvents.iap,
              action: TrackValues.fail,
              params: trackParams);
        });
  }

  void _purchaseItemV2(
      BuildContext context,
      AccountProvider accountProvider,
      PurchaseItemsViewModel model,
      String id,
      StoreProduct rcStoreProduct,
      bool isSub) {
    // Navigator.pop(context);
    // eventBus.fire(UpdatePurchaseEvent(true));
    // return;

    final trackParams =
        TrackUtils.showEpisode(show: widget.show, episode: widget.episode)
          ..[TrackParams.productId] = id;
    TrackHelper.instance.track(
        event: TrackEvents.iap,
        action: TrackValues.clickItem,
        params: trackParams);

    TrackHelper.instance.facebookAppEvents.logEvent(
        name: FacebookAppEvents.eventNameAddedToCart,
        parameters: {
          FacebookAppEvents.paramNameCurrency: rcStoreProduct.currencyCode,
        },
        valueToSum: rcStoreProduct.price);

    model.purchaseV2(
        rcStoreProduct: rcStoreProduct,
        onSuccess: () {
          ///
          /// update
          /// update account
          LogD("PURCHASE Success!!!");
          accountProvider.updateAccountProfile();
          if (widget.useDialogStyle) {
            Navigator.pop(context);
            eventBus.fire(UpdatePurchaseEvent(true));
          }

          /// tips
          ViewUtils.showToast(S.current.purchase_successful);

          /// track
          TrackHelper.instance.track(
              event: TrackEvents.iap,
              action: TrackValues.success,
              params: trackParams);

          if (isSub) {
            TrackHelper.instance.facebookAppEvents.logSubscribe(
                price: rcStoreProduct.price,
                currency: rcStoreProduct.currencyCode,
                orderId:
                    "${accountProvider.account?.user.id}_${DateTime.now().millisecondsSinceEpoch}");
          } else {
            TrackHelper.instance.facebookAppEvents.logPurchase(
                amount: rcStoreProduct.price,
                currency: rcStoreProduct.currencyCode);
          }

          // /// exit pro view
          // if (widget.useDialogStyle) {
          //   Navigator.pop(context, true);
          //   // Future.delayed(const Duration(seconds: 1), () {
          //   //   if (context.mounted) {
          //   //     Navigator.pop(context, true);
          //   //   }
          //   // });
          // }
        },
        onFail: () {
          TrackHelper.instance.track(
              event: TrackEvents.iap,
              action: TrackValues.fail,
              params: trackParams);
        });
  }

  Widget _buildNewUserItemView(
      PurchaseItemsViewModel model, ProductItemWrapper item) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: () {
            _purchaseItem(model, item);
            model.changeIndex(id: item.item.id);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                // border: Border.all(
                //     width: 5, color: const Color.fromRGBO(255, 241, 183, 1)),
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(255, 224, 100, 1),
                image: DecorationImage(
                  image: Assets.images.newUserCoinsBg.image().image,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                )),
            padding: const EdgeInsets.fromLTRB(24.37, 11.55, 18.42, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S.current.coins_num(item.item.coins ?? 0),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(168, 59, 0, 1)),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                const SizedBox(height: 3.86),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 126, 15, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      child: Text(
                        item.rcStoreProduct.priceString,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.86),
                SizedBox(
                  width: 192,
                  child: Text(
                    S.current.new_user_product_msg,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color.fromRGBO(168, 59, 0, 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  // Widget _buildNewUserItemViewWithScreenUtil(
  //     PurchaseItemsViewModel model, ProductItemWrapper item) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8),
  //     child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.r),
  //         ),
  //         child: InkWell(
  //           onTap: () {
  //             _purchaseItem(model, item);
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               border: Border.all(
  //                 color: Colors.yellowAccent,
  //                 width: 2.0.w,
  //               ),
  //               borderRadius: BorderRadius.circular(16.r),
  //             ),
  //             padding: EdgeInsets.fromLTRB(32.w, 16.w, 32.w, 16.w),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Assets.images.coins.image(
  //                         width: 52.w, height: 52.w, fit: BoxFit.contain),
  //                     SizedBox(width: 16.w),
  //                     Expanded(
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(S.current.coins_num(item.item.coins ?? 0),
  //                               style: TextStyle(fontSize: 20.sp)
  //                               // Theme.of(context).textTheme.titleLarge),
  //                               ),
  //                           Text(item.rcStoreProduct.priceString,
  //                               style: TextStyle(fontSize: 16.sp)
  //                               // Theme.of(context).textTheme.bodyLarge,
  //                               ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 8.h),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: Text(S.current.new_user_product_msg,
  //                           style: TextStyle(fontSize: 13.sp)
  //                           // Theme.of(context).textTheme.bodyMedium,
  //                           ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         )),
  //   );
  // }

  Widget _buildItemView(BuildContext context, AccountProvider accountProvider,
      PurchaseItemsViewModel model, ProductItemWrapper item, int? episodePrice,
      {int? index}) {
    final int baseCoins = item.item.coins ?? 0;
    final int extraCoins = item.item.extraCoins ?? 0;
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: GestureDetector(
        onTap: () {
          _purchaseItemV2(context, accountProvider, model, item.item.id,
              item.rcStoreProduct, false);
          model.changeIndex(id: item.item.id);
        },
        child: CardForCoins(
            title: "$baseCoins ${S.current.coins}",
            des: extraCoins > 0 ? "+$extraCoins" : null,
            goTips: item.rcStoreProduct.priceString,
            activity:
                item.item.id.toString() == model.currentIndex ? true : false,
            showPopular: index == 2 ? true : false
            // item.item.id.toString() == model.currentIndex ? true : false
            ,
            save: extraCoins > 0
                ? ((extraCoins / baseCoins) * 100).toInt()
                : null,
            index: index),
      ),
    );
  }

  Widget _buildSubItemView(
      BuildContext context,
      AccountProvider accountProvider,
      PurchaseItemsViewModel model,
      ProductSubItemWrapper item,
      int index) {
    return GestureDetector(
        onTap: () {
          _purchaseItemV2(context, accountProvider, model, item.item.id!,
              item.rcStoreProduct, true);
          model.changeIndex(id: item.item.id!);
        },
        child: Transform.translate(
          offset: const Offset(
              -22, 0), //index == (model.itemsSub.length) - 1 ? 30 :
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: CardForMemberPro(
              gradientColor: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: item.item.type == 'week'
                      ? [
                          const Color.fromRGBO(255, 165, 192, 1),
                          const Color.fromRGBO(255, 169, 228, 1),
                        ]
                      : item.item.type == 'month'
                          ? [
                              const Color.fromRGBO(255, 101, 147, 1),
                              const Color.fromRGBO(255, 77, 198, 1),
                            ]
                          : item.item.type == 'year'
                              ? [
                                  const Color.fromRGBO(255, 120, 195, 1),
                                  const Color.fromRGBO(255, 133, 18, 1),
                                ]
                              : [
                                  const Color.fromRGBO(255, 168, 228, 1),
                                  const Color.fromRGBO(255, 157, 218, 1.0),
                                ],
                  stops: const [0, 1]),
              imageChild: item.item.type == 'week'
                  ? Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          color: Colors.blue.withOpacity(0),
                          height: 43.77,
                          width: 29.15,
                        ),
                        Positioned(
                          top: -7,
                          left: -8.5,
                          child: Container(
                            width: 47,
                            height: 63,
                            color: Colors.pink.withOpacity(0),
                            child: Assets.images.diamondWeekly
                                .image(fit: BoxFit.contain),
                          ),
                        ),
                      ],
                    )
                  : item.item.type == 'month'
                      ? Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              color: Colors.blue.withOpacity(0),
                              height: 35.01,
                              width: 38.09,
                            ),
                            Positioned(
                              top: -3,
                              left: -8,
                              child: Container(
                                width: 52,
                                height: 49,
                                color: Colors.pink.withOpacity(0),
                                child: Assets.images.diamondMonthly
                                    .image(fit: BoxFit.contain),
                              ),
                            ),
                          ],
                        )
                      : item.item.type == 'year'
                          ? Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  color: Colors.blue.withOpacity(0),
                                  height: 44.41,
                                  width: 37.32,
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 38,
                                    height: 45,
                                    color: Colors.pink.withOpacity(0),
                                    child: Assets.images.diamondYearly.image(
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Assets.images.diamondWeekly
                              .image(fit: BoxFit.contain),
              left: item.item.type == 'week'
                  ? 20.29
                  : item.item.type == 'month'
                      ? 15.55
                      : item.item.type == 'year'
                          ? 14.79
                          : 15.55,
              right: item.item.type == 'week'
                  ? 16.72
                  : item.item.type == 'month'
                      ? 10.99
                      : item.item.type == 'year'
                          ? 5.87
                          : 10.99,
              title: item.item.type == 'week'
                  ? S.current.weekly_pro
                  : item.item.type == 'month'
                      ? S.current.monthly_pro
                      : item.item.type == 'year'
                          ? S.current.yearly_pro
                          : '--',
              titleColor: item.item.type == 'week'
                  ? const Color.fromRGBO(255, 40, 184, 1)
                  : item.item.type == 'month'
                      ? const Color.fromRGBO(255, 255, 255, 1.0)
                      : item.item.type == 'year'
                          ? const Color.fromRGBO(255, 255, 255, 1.0)
                          : const Color.fromRGBO(255, 157, 218, 1.0),
              des: S.current.enjoy_all_dramas_for_free,
              desColor: item.item.type == 'week'
                  ? const Color.fromRGBO(255, 40, 184, 1)
                  : item.item.type == 'month'
                      ? const Color.fromRGBO(255, 255, 255, 1.0)
                      : item.item.type == 'year'
                          ? const Color.fromRGBO(255, 255, 255, 1.0)
                          : const Color.fromRGBO(255, 157, 218, 1.0),
              desSize: 10,
              goChild: Container(
                // width: 64.68,
                padding: const EdgeInsets.symmetric(horizontal: 12.47),
                height: 27.98,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: item.item.type == 'week'
                        ? const Color.fromRGBO(255, 40, 184, 1)
                        : item.item.type == 'month'
                            ? const Color.fromRGBO(236, 0, 159, 1)
                            : item.item.type == 'year'
                                ? const Color.fromRGBO(200, 95, 0, 1)
                                : const Color.fromRGBO(255, 157, 218, 1.0),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(27.98))),
                child: Text(
                  item.rcStoreProduct.priceString,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
