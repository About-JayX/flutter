import 'package:flutter/material.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/view/home/home_square_view.dart';
// import 'package:mobisen_app/view/reward/reward_view.dart';
import 'package:mobisen_app/view/me/me_tab_view.dart';
import 'package:mobisen_app/view/matching/interest_cards_view.dart';
import 'package:mobisen_app/view/messages/messages_view.dart';

enum HomeTabs { home, matching, messages, /*reward,*/ profile }

extension HomeTabsExtension on HomeTabs {
  String getTitle(BuildContext context) {
    switch (this) {
      case HomeTabs.home:
        return S.of(context).home;
      case HomeTabs.matching:
        return 'Discover';
      case HomeTabs.messages:
        return S.of(context).rewards;
      // case HomeTabs.reward:
      //   return S.of(context).rewards;
      case HomeTabs.profile:
        return S.of(context).profile;
    }
  }

  Widget getIcon({bool notShowTabRewardIconGift = true, Color? color}) {
    Widget icon = const SizedBox(width: 29, height: 29);

    switch (this) {
      case HomeTabs.home:
        icon = Assets.images.home.image(fit: BoxFit.contain, color: color);
      case HomeTabs.matching:
        icon = Icon(Icons.favorite_outline, color: color, size: 29);
      case HomeTabs.messages:
        icon = Icon(Icons.message_outlined, color: color, size: 29);
      // case HomeTabs.reward:
      //   icon = notShowTabRewardIconGift
      //       ? Assets.images.reward.image(fit: BoxFit.contain, color: color)
      //       : Transform.translate(
      //           offset: const Offset(0, -6.5),
      //           child: Transform.scale(
      //             scale: 1.5,
      //             child: Assets.images.rewardGif
      //                 .image(fit: BoxFit.contain, color: color),
      //           ));
      case HomeTabs.profile:
        icon = Assets.images.profile.image(fit: BoxFit.contain, color: color);
    }
    return SizedBox(width: 29, height: 29, child: icon);
  }

  Widget getActiveIcon({Color? color}) {
    Widget icon = const SizedBox(width: 29, height: 29);

    switch (this) {
      case HomeTabs.home:
        icon =
            Assets.images.homeActive.image(fit: BoxFit.contain, color: color);
      case HomeTabs.matching:
        icon = Icon(Icons.favorite, color: color, size: 29);
      case HomeTabs.messages:
        icon = Icon(Icons.message, color: color, size: 29);
      // case HomeTabs.reward:
      //   icon = Assets.images.reward.image(fit: BoxFit.contain, color: color);
      case HomeTabs.profile:
        icon = Assets.images.profileActive
            .image(fit: BoxFit.contain, color: color);
    }

    return SizedBox(width: 29, height: 29, child: icon);
  }

  Widget buildBodyWidget(BuildContext context) {
    switch (this) {
      case HomeTabs.home:
        return const HomeSquareView();
      case HomeTabs.matching:
        return const InterestCardsView();
      case HomeTabs.messages:
        return const MessagesView();
      // case HomeTabs.reward:
      //   return const RewardView();
      case HomeTabs.profile:
        return const MeTabView();
    }
  }

  String getScreenName() {
    switch (this) {
      case HomeTabs.home:
        return TrackScreenNames.home;
      case HomeTabs.matching:
        return TrackScreenNames.matching;
      case HomeTabs.messages:
        return TrackScreenNames.messages;
      // case HomeTabs.reward:
      //   return TrackScreenNames.reward;
      case HomeTabs.profile:
        return TrackScreenNames.profile;
    }
  }
}
