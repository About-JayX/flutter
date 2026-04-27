import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/app_router.dart';
import 'package:mobisen_app/iap/iap_helper.dart';
import 'package:mobisen_app/configs.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
// import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/styles/style_const.dart';
import 'package:mobisen_app/net/model/homepage.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/view/base_widget.dart';
import 'package:mobisen_app/viewmodel/home_view_model.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';
// import 'package:mobisen_app/widget/filter_view.dart';
// import 'package:mobisen_app/widget/image_loader.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  _scrollTo(
      HomeViewModel model, ScrollController args, double headShadowHeight) {
    double y = args.offset;

    double appBarOpacity = y / headShadowHeight;
    if (appBarOpacity <= 0) {
      appBarOpacity = 0.0;
    } else if (appBarOpacity > 1) {
      appBarOpacity = 1.0;
    }

    if (y <= headShadowHeight && y >= 0) {
      model.changeHeadShadowOpacity(opacity: appBarOpacity);
    }

    if (args.position.userScrollDirection == ScrollDirection.reverse &&
        y > headShadowHeight &&
        model.headShadowOpacity < 1.0) {
      model.changeHeadShadowOpacity(opacity: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const headToStatusBar = 8.79;
    const headHeight = 35.64;
    const conToHead = 12.79;
    final headShadowHeight =
        statusBarHeight + headToStatusBar + headHeight + conToHead
        // AppSize.statusBarHeight + headToStatusBar + headHeight + conToHead
        ;
    return BaseWidget(
        builder: (context, model, child) {
          _autoPlayNewUser(context: context, homepage: model.homepage);
          return Scaffold(
              body: Stack(children: [
            /// container
            // Padding(
            //   padding: const EdgeInsets.only(top: 103.22),
            //   child:
            MixedListView(
              bottomNavPadding: true,
              loading: model.loading,
              error: model.error,
              onRefresh: () async {
                await model.refresh();
              },
              onScroll: (ScrollController args) {
                _scrollTo(model, args, headShadowHeight);
              },
              dataRaw: model.homepage?.categories,
              // data: [BottomMixedListItem()]
            ),
            // )

            /// head
            /// head shadow
            Positioned(
                top: 0,
                left: 0,
                child: Opacity(
                  opacity: model.headShadowOpacity,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: headShadowHeight,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [
                          0.0,
                          0.4,
                          1.0
                        ],
                            colors: [
                          Color.fromRGBO(0, 0, 0, 1),
                          Color.fromRGBO(0, 0, 0, .9),
                          Color.fromRGBO(0, 0, 0, 0),
                        ])),
                  ),
                )),

            /// post head
            Positioned.fill(
              top: 0,
              left: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.statusBarHeight
                    // 46
                    ,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: headToStatusBar,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                              left: 6.51,
                            ),
                            // color: Colors.orange,
                            height: 35.64,
                            child: Assets.images.appbarLogo.image(
                              fit: BoxFit.contain,
                              // width: 194,
                            )),
                        // const Spacer(),
                        // accountProvider.account != null
                        //     ?
                        GestureDetector(
                            onTap: () {
                              if (ViewUtils.jumpToLogin(
                                  context, accountProvider)) {
                                return;
                              }
                              IAPHelper.instance.showPaywall(context,
                                  account: accountProvider.account!);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(
                                  right: 20.4,
                                ),
                                // color: Colors.green,
                                height: 30.13,
                                child: Assets.images.purchaseProButton.image(
                                  fit: BoxFit.contain,
                                  // width: 194,
                                )))
                        // : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     SizedBox(
              //         height: 330.66,
              //         width: double.infinity,
              //         child: Stack(
              //           // alignment: Alignment.topCenter,
              //           children: [
              //             Positioned.fill(
              //                 top: 0,
              //                 left: 0,
              //                 child: model.currentCarouselImageUrl == null
              //                     ? Container(
              //                         decoration: BoxDecoration(
              //                           image: DecorationImage(
              //                             image: Assets.images.homeHeadbg
              //                                 .image()
              //                                 .image,
              //                             fit: BoxFit.cover,
              //                           ),
              //                         ),
              //                       )
              //                     : FilterView(
              //                         back: ImageLoader.cover(
              //                             url: model.currentCarouselImageUrl),
              //                         sigma: 25.0,
              //                       )),
              //             Column(
              //               children: [
              //                 SizedBox(
              //                   height: AppSize.statusBarHeight
              //                   // 46
              //                   ,
              //                 ),
              //                 Container(
              //                   margin: const EdgeInsets.only(
              //                     top: 7.79,
              //                   ),
              //                   child: Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     crossAxisAlignment:
              //                         CrossAxisAlignment.center,
              //                     children: [
              //                       Container(
              //                           margin: const EdgeInsets.only(
              //                             left: 6.51,
              //                           ),
              //                           // color: Colors.orange,
              //                           height: 35.64,
              //                           child: Assets.images.appbarLogo.image(
              //                             fit: BoxFit.contain,
              //                             // width: 194,
              //                           )),
              //                       // const Spacer(),
              //                       // accountProvider.account != null
              //                       //     ?
              //                       GestureDetector(
              //                           onTap: () {
              //                             if (ViewUtils.jumpToLogin(
              //                                 context, accountProvider)) {
              //                               return;
              //                             }
              //                             IAPHelper.instance.showPaywall(
              //                                 context,
              //                                 account:
              //                                     accountProvider.account!);
              //                           },
              //                           child: Container(
              //                               margin: const EdgeInsets.only(
              //                                 right: 20.4,
              //                               ),
              //                               // color: Colors.green,
              //                               height: 30.13,
              //                               child: Assets
              //                                   .images.purchaseProButton
              //                                   .image(
              //                                 fit: BoxFit.contain,
              //                                 // width: 194,
              //                               )))
              //                       // : const SizedBox(),
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ],
              //         )),
              //   ],
              // )
            ),
          ]));
        },
        model: HomeViewModel(accountProvider: accountProvider),
        onModelReady: (model) => model.initModel());
  }

  void _autoPlayNewUser(
      {required BuildContext context, Homepage? homepage}) async {
    if (homepage != null && homepage.categories.isNotEmpty) {
      final shows = homepage.categories[0].shows;
      final show =
          shows.isNotEmpty ? shows[Random().nextInt(shows.length)] : null;
      if (show != null && !Configs.instance.triedAutoPlayNewUser.value) {
        Configs.instance.triedAutoPlayNewUser.value = true;
        await Future.delayed(const Duration(milliseconds: 100));
        if (context.mounted) {
          Navigator.pushNamed(context, RoutePaths.show,
              arguments: CommonArgs(showId: show.showId));
        }
      }
    }
  }
}
