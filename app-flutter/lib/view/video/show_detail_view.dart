import 'dart:math';
import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/app_router.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/iap/iap_helper.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/net/model/watch_history.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/provider/configs_provider.dart';
import 'package:mobisen_app/event_bus/event_bus.dart';
import 'package:mobisen_app/mixin/mixin.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/track_utils.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/util/wakelock_helper.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/view/video/episode_picker_view.dart';
import 'package:mobisen_app/view/video/quicker_scroll_physics.dart';
import 'package:mobisen_app/view/video/show_video_list_controller.dart';
import 'package:mobisen_app/view/video/show_buttons_view.dart';
import 'package:mobisen_app/widget/checkbox_with_label.dart';
import 'package:video_player/video_player.dart';

class ShowDetailsView extends StatefulWidget {
  final Show show;
  final Function()? onShowRefresh;
  const ShowDetailsView({super.key, required this.show, this.onShowRefresh});

  @override
  State<ShowDetailsView> createState() => _ShowDetailsViewState();
}

class _ShowDetailsViewState extends State<ShowDetailsView>
    with WidgetsBindingObserver, UserMembershipMixin {
  late final PageController _pageController;
  int _currentPageIndex = 0;
  final ShowVideoListController _videoListController =
      ShowVideoListController();
  late StreamSubscription<UpdatePurchaseEvent> _updatePurchaseEvent;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WakelockHelper.disable();
    WidgetsBinding.instance.removeObserver(this);
    _videoListController.currentPlayer.pause();
    _videoListController.dispose();
    _pageController.dispose();
    _updatePurchaseEvent.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WakelockHelper.enable();
    WidgetsBinding.instance.addObserver(this);
    var initialPage =
        max(0, _findEpisodeFromWatchHistory(context, widget.show));

    _pageController = PageController(initialPage: initialPage);

    _videoListController.init(
      pageController: _pageController,
      initialList: _buildControllerList(),
      videoProvider: (int index, List<VPVideoController> list) async {
        return [];
      },
    );
    _videoListController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _onPageIndexChanged(context: context, index: initialPage, reload: true);

    super.initState();
    _updatePurchaseEvent = eventBus.on<UpdatePurchaseEvent>().listen((event) {
      if (event.isSuccess == true) {
        _reloadVideo();
      }
    });

    TrackHelper.instance.track(
        event: TrackEvents.show,
        action: TrackValues.showDetails,
        params: TrackUtils.showEpisode(show: widget.show));

    TrackHelper.instance.facebookAppEvents
        .logEvent(name: FacebookAppEvents.eventNameViewedContent);
  }

  _reloadVideo() {
    LogD("eventBus.on<UpdatePurchaseEvent>().listen-----_reloadVideo()");
    widget.onShowRefresh?.call();
  }

  int _findEpisodeFromWatchHistory(BuildContext context, Show show) {
    final accountProvider = context.read<AccountProvider>();
    for (var history in accountProvider.watchHistoryList) {
      if (history.show.showId == show.showId) {
        final episodes = show.episodes ?? [];
        for (int i = 0; i < episodes.length; ++i) {
          final episode = episodes[i];
          if (episode.episodeId == history.episode.episodeId) {
            return i;
          }
        }
        break;
      }
    }
    return -1;
  }

  List<VPVideoController> _buildControllerList() {
    final show = widget.show;
    final episodes = show.episodes ?? [];
    List<VPVideoController> list = [];
    for (int i = 0; i < episodes.length; ++i) {
      final episode = episodes[i];
      list.add(VPVideoController(
        show: show,
        episode: episode,
        builder: () {
          final controller = VideoPlayerController.networkUrl(
              Uri.parse(episode.videoUrl ?? ""));
          controller.addListener(() {
            if (mounted && controller.value.isCompleted) {
              if (i < episodes.length - 1) {
                _pageController.animateToPage(i + 1,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.linear);
              } else {
                controller.play();
              }
            }
          });
          return controller;
        },
        buttons: _buildButtons(show, episode),
      ));
    }
    return list;
  }

  void _showEpisodePicker(
      Show show, List<Episode> episodes, Episode currentEpisode) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EpisodePickerView(
          show: show,
          currentEpisode: currentEpisode,
          onSelectEpisode: (episode) {
            int page = episodes.indexOf(episode);
            if (page < 0 || page >= episodes.length) {
              return true;
            }
            if (page > _findMaxPageIndex()) {
              ViewUtils.showToast(S.current.miss_out_stories_prompt);
              return false;
            } else {
              _pageController.jumpToPage(page);
              return true;
            }
          },
        );
      },
    );
  }

  Widget _buildButtons(Show show, Episode episode) {
    return ShowButtonsView(
      show: show,
      episode: episode,
      onShowEpisodePicker: () {
        _showEpisodePicker(show, show.episodes ?? [], episode);
      },
    );
  }

  void _onPageIndexChanged(
      {required BuildContext context,
      required int index,
      bool reload = false}) async {
    _videoListController.loadIndex(index, reload: reload);

    _currentPageIndex = index;
    final show = widget.show;
    final episode = _videoListController.playerOfIndex(index)?.episode;
    if (episode != null) {
      context.read<AccountProvider>().addWatchHistory(
          WatchHistory(show, episode, DateTime.now().millisecondsSinceEpoch));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryLoginOrIAP(context, show, episode);
      });
    }

    _tryUnlockNextEpisode(index);
  }

  void _tryUnlockNextEpisode(int currentIndex) {
    final episode = _videoListController.playerOfIndex(currentIndex)?.episode;
    final configsProvider = context.read<ConfigsProvider>();
    if (configsProvider.configs.autoUnlockNext.value &&
        episode?.locked != true) {
      final episode =
          _videoListController.playerOfIndex(currentIndex + 1)?.episode;
      if (episode != null && episode.locked == true) {
        _tryUnlock(
            context.read<AccountProvider>(), widget.show, episode, false);
      }
    }
  }

  void _tryLoginOrIAP(BuildContext context, Show show, Episode episode) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) {
      return;
    }
    final accountProvider = context.read<AccountProvider>();
    if (episode.locked == true) {
      if (accountProvider.account == null) {
        await Navigator.pushNamed(context, RoutePaths.login);
      }

      // todo auto refresh show after login

      final account = accountProvider.account;
      if (account != null &&
          context.mounted &&
          account.user.coins < (episode.price ?? 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          IAPHelper.instance.showPaywall(context,
              account: account,
              show: show,
              episode: episode,
              useDialogStyle: true);
        });
      }
    }

    /// unlock by purchase not free or coins
    if (episode.locked != true && (episode.price ?? 0) > 0) {
      // && episode.useCoinsUnlocked != true
      updateUserMembershipAction(accountProvider, onSubscriptionExpired: (v) {
        if (v == true) {
          _reloadVideo();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final configsProvider = context.watch<ConfigsProvider>();
    return PageView.builder(
      physics: const QuickerScrollPhysics(),
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        _onPageIndexChanged(context: context, index: index);
      },
      itemCount: min(_videoListController.videoCount, _findMaxPageIndex() + 1),
      itemBuilder: (context, i) {
        var player = _videoListController.playerOfIndex(i)!;
        final episode = player.episode;
        Widget currentVideo = Chewie(
          controller: player.chewieController,
          key: Key(
              "${episode.videoUrl}_${player.chewieController.hashCode}_${player.controller.value.isInitialized}"),
        );
        if (episode.locked == true) {
          return Stack(
            children: [
              currentVideo,
              _buildLockedOverlay(
                  accountProvider, configsProvider, widget.show, episode),
            ],
          );
        }
        return currentVideo;
      },
    );
  }

  int _findMaxPageIndex() {
    for (var i = 0; i < _videoListController.videoCount; i++) {
      if (_videoListController.playerOfIndex(i)?.episode.locked == true) {
        return i;
      }
    }
    return _videoListController.videoCount - 1;
  }

  Widget _buildLockedOverlay(AccountProvider accountProvider,
      ConfigsProvider configsProvider, Show show, Episode episode) {
    List<String> descList = [];
    final account = accountProvider.account;
    if (account != null) {
      descList.add(
          "${S.current.balance}: ${S.current.coins_num(account.user.coins)}");
    }
    descList.add(
        "${S.current.this_episode}: ${S.current.coins_num(episode.price ?? 0)}");
    String desc = descList.join("\n");
    final autoUnlockNext = configsProvider.configs.autoUnlockNext;
    return Stack(
      children: [
        Container(
          color: Colors.black54,
        ),
        Column(
          children: [
            ViewUtils.buildVideoAppBar(context),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 8, 32),
              child: Align(
                alignment: const FractionalOffset(1, 0),
                child: _buildButtons(show, episode),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxWithLabel(
                    label: S.current.auto_unlock_next_video,
                    value: autoUnlockNext.value,
                    onChanged: (newValue) {
                      autoUnlockNext.value = newValue;
                      configsProvider.onConfigChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(desc),
                  const SizedBox(height: 16),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 使用 Row 包裹第一个按钮
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                                onPressed: () {
                                  _tryUnlock(
                                      accountProvider, show, episode, true);
                                },
                                icon: const Icon(Icons.lock_open_rounded),
                                label: Text(
                                  S.current.unlock_btn,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.reward,
                                      arguments: CommonArgs(goBack: true));
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50)),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      S.current.free_watch,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _tryUnlock(AccountProvider accountProvider, Show show, Episode episode,
      bool interact) async {
    if (interact) {
      TrackHelper.instance.track(
          event: TrackEvents.show,
          action: TrackValues.unlockClick,
          params: TrackUtils.showEpisode(show: show, episode: episode));
    }

    final account = accountProvider.account;
    if (account == null) {
      if (interact) {
        ViewUtils.jumpToLogin(context, accountProvider);
      }
      return;
    }
    if (account.user.coins < (episode.price ?? 0)) {
      if (interact) {
        await IAPHelper.instance.showPaywall(context,
            account: account,
            show: show,
            episode: episode,
            useDialogStyle: true);
      }
    } else {
      try {
        await accountProvider.unlockEpisode(episode);
        if (interact) {
          _videoListController.loadIndex(_currentPageIndex, reload: true);
          _tryUnlockNextEpisode(_currentPageIndex);

          TrackHelper.instance.track(
              event: TrackEvents.show,
              action: TrackValues.unlockSuccess,
              params: TrackUtils.showEpisode(show: show, episode: episode));
        }
      } catch (e) {
        if (interact) {
          ViewUtils.showToast(S.current.error_toast);
        }
      }
    }
  }
}
