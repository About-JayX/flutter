import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:blur/blur.dart';
import 'package:mobisen_app/notification/page_change_notification.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/enums/reward_task.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/local_storage_util.dart';
// import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/event_bus/event_bus.dart';
import 'package:mobisen_app/mixin/mixin.dart';
import 'package:mobisen_app/styles/style_const.dart';
import 'package:mobisen_app/view/home/home_tabs.dart';
import 'package:mobisen_app/widget/keep_alive_wrapper.dart';

class HomeTabsView extends StatefulWidget {
  const HomeTabsView({super.key});

  @override
  State<HomeTabsView> createState() => _HomeTabsViewState();
}

class _HomeTabsViewState extends State<HomeTabsView> with UserMembershipMixin {
  static const List<HomeTabs> tabs = [
    HomeTabs.home,
    HomeTabs.matching,
    HomeTabs.messages,
    // HomeTabs.reward,
    HomeTabs.profile
  ];

  final PageController _pageController = PageController();
  int _currentTabIndex = 0;
  bool _notShowTabRewardIconGift = true;

  late StreamSubscription<SwitchTabEvent> _eventBusSwitchTab;

  @override
  void initState() {
    super.initState();

    _eventBusSwitchTab = eventBus.on<SwitchTabEvent>().listen((event) {
      switchTab(event.index);
    });

    _reportScreenView();

    _getTabRewardIconGiftStorage();
  }

  @override
  void dispose() {
    _eventBusSwitchTab.cancel();
    super.dispose();
  }

  void switchTab(int index) {
    _onPageChangedFun(index);
    // setState(() {
    //   if (_currentTabIndex != index) {
    //     _currentTabIndex = index;
    //     // _pageController.jumpToPage(index);
    //   }
    // });
  }

  void _onPageChangedFun(int index) {
    if (_currentTabIndex != index) {
      setState(() {
        _currentTabIndex = index;
      });
      _reportScreenView();
    }
  }

  void _reportScreenView() {
    TrackHelper.instance
        .trackScreenView(screenName: tabs[_currentTabIndex].getScreenName());
  }

  void _saveUserTapTabBarRewardIconAction() async {
    ///
    eventBus.fire(UpdateRewardEvent(RewardTaskJob.refresh));

    ///
    if (!_notShowTabRewardIconGift) {
      LocalStorageUtil.setData("notShowTabRewardIconGift", true);
      //LogD("saveUserTapTabBarRewardIconAction:\n${await LocalStorageUtil.readData('notShowTabRewardIconGift')}");
      if (mounted) {
        setState(() {
          _notShowTabRewardIconGift = true;
        });
      }
    }
  }

  void _getTabRewardIconGiftStorage() async {
    //LogD("notShowTabRewardIconGift:\n${await LocalStorageUtil.readData('notShowTabRewardIconGift')}");
    if (await LocalStorageUtil.readData('notShowTabRewardIconGift') == null) {
      if (mounted) {
        setState(() {
          _notShowTabRewardIconGift = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final bottomNavHeight =
        // AppSize.bottomNavigationHeight
        AppSize.bottomNavigationConHeight + bottomPadding;
    return Scaffold(
      body: Stack(children: [
        NotificationListener<PageChangeNotification>(
            onNotification: (notification) {
              final item = notification.pageItem;
              if (item is HomeTabs) {
                final index = tabs.indexOf(item);
                if (index >= 0) {
                  _onPageChangedFun(index);
                  // _currentTabIndex = index; // Update
                  // _pageController.jumpToPage(index);
                }
                return true;
              }
              return false;
            },
            child: IndexedStack(
              index: _currentTabIndex, // Set the current index
              children: tabs
                  .map((tab) => KeepAliveWrapper(
                        child: tab.buildBodyWidget(context),
                      ))
                  .toList(),
            )),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              height: bottomNavHeight,
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    _onPageChangedFun(index);
                    // if (index == 3) {
                    //   _saveUserTapTabBarRewardIconAction();
                    // }
                    if (index == 3) {
                      updateUserMembershipAction(accountProvider);
                    }
                  },
                  currentIndex: _currentTabIndex,
                  items: tabs
                      .map((tab) => BottomNavigationBarItem(
                          icon: tab.getIcon(
                              notShowTabRewardIconGift:
                                  _notShowTabRewardIconGift,
                              color: const Color.fromRGBO(143, 143, 151, 1)),
                          label: '',
                          activeIcon: tab.getActiveIcon(
                              color: const Color.fromRGBO(204, 107, 98, 1))))
                      .toList(),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedItemColor: const Color.fromRGBO(204, 107, 98, 1),
                  unselectedItemColor: const Color.fromRGBO(143, 143, 151, 1),
                ),
              ),
            ))
      ]),
      // bottomNavigationBar: Theme(
      //   data: Theme.of(context).copyWith(
      //     splashColor: Colors.transparent,
      //     // highlightColor: Colors.transparent,
      //   ),
      //   child: Stack(
      //     children: [
      //       Positioned.fill(
      //         child: Container(
      //           color: const Color.fromRGBO(255, 255, 0, 0.5),
      //         ),
      //       ),
      //       BottomNavigationBar(
      //         type: BottomNavigationBarType.fixed,
      //         onTap: (index) {
      //           _onPageChangedFun(index);
      //           if (index == 2) _saveUserTapTabBarRewardIconAction();
      //           if (index == 3) {
      //             updateUserMembershipAction(accountProvider);
      //           }
      //         },
      //         currentIndex: _currentTabIndex,
      //         items: tabs
      //             .map((tab) => BottomNavigationBarItem(
      //                 icon: tab.getIcon(
      //                     notShowTabRewardIconGift:
      //                         _notShowTabRewardIconGift),
      //                 label: tab.getTitle(context),
      //                 activeIcon: tab.getActiveIcon()))
      //             .toList(),
      //         backgroundColor: const Color.fromRGBO(255, 0, 0, 0.3),
      //         elevation: 0,
      //       )
      //     ],
      //   ),
      // )
    );
  }
}
