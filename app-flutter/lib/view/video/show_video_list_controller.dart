import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/event_bus/event_bus.dart';
import 'package:mobisen_app/enums/reward_task.dart';
import 'package:mobisen_app/db/hive_helper.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/net/model/reward/task_item.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/track_utils.dart';
import 'package:mobisen_app/view/video/custom_video_controls.dart';
import 'package:mobisen_app/widget/loading.dart';
import 'package:video_player/video_player.dart';

typedef LoadMoreVideo = Future<List<VPVideoController>> Function(
  int index,
  List<VPVideoController> list,
);

class ShowVideoListController extends ChangeNotifier {
  ShowVideoListController({
    this.loadMoreCount = 1,
    this.preloadCount = 2,
    this.disposeCount = 1,
  });

  final int loadMoreCount;

  final int preloadCount;

  final int disposeCount;

  LoadMoreVideo? _videoProvider;

  loadIndex(int target, {bool reload = false}) async {
    if (!reload) {
      if (index.value == target) return;
    }

    var oldIndex = index.value;
    var newIndex = target;

    if (!(oldIndex == 0 && newIndex == 0)) {
      playerOfIndex(oldIndex)?.controller.seekTo(Duration.zero);
      playerOfIndex(oldIndex)?.pause();
    }
    playerOfIndex(newIndex)?.controller.addListener(_didUpdateValue);
    playerOfIndex(newIndex)?.paused.addListener(_didUpdateValue);
    if (playerOfIndex(newIndex)?.shouldAutoPlay == true) {
      playerOfIndex(newIndex)?.play();
    } else {
      playerOfIndex(newIndex)?.pause();
      playerOfIndex(newIndex)?.resetTracking();
    }
    for (var i = 0; i < playerList.length; i++) {
      if (i < newIndex - disposeCount || i > newIndex + max(disposeCount, 2)) {
        playerOfIndex(i)?.controller.removeListener(_didUpdateValue);
        playerOfIndex(i)?.paused.removeListener(_didUpdateValue);
        playerOfIndex(i)?.dispose();
        continue;
      }
      if (i > newIndex && i < newIndex + preloadCount) {
        playerOfIndex(i)?.init();
        continue;
      }
    }

    if (playerList.length - newIndex <= loadMoreCount + 1) {
      _videoProvider?.call(newIndex, playerList).then(
        (list) async {
          playerList.addAll(list);
          notifyListeners();
        },
      );
    }

    index.value = target;
  }

  _didUpdateValue() {
    notifyListeners();
  }

  VPVideoController? playerOfIndex(int index) {
    if (index < 0 || index > playerList.length - 1) {
      return null;
    }
    return playerList[index];
  }

  int get videoCount => playerList.length;

  init({
    required PageController pageController,
    required List<VPVideoController> initialList,
    required LoadMoreVideo videoProvider,
  }) async {
    playerList.addAll(initialList);
    _videoProvider = videoProvider;
    notifyListeners();
  }

  ValueNotifier<int> index = ValueNotifier<int>(0);

  List<VPVideoController> playerList = [];

  VPVideoController get currentPlayer => playerList[index.value];

  @override
  void dispose() {
    for (var player in playerList) {
      player.paused.dispose();
      player.dispose();
    }
    playerList = [];
    super.dispose();
  }
}

typedef ControllerSetter<T> = Future<void> Function(T controller);
typedef ControllerBuilder<T> = T Function();

class VPVideoController {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  final ValueNotifier<bool> _paused = ValueNotifier<bool>(false);

  final Show show;
  final Episode episode;

  final Widget _buttons;
  final ControllerBuilder<VideoPlayerController> _builder;
  final ControllerSetter<VideoPlayerController>? _afterInit;

  VPVideoController({
    required this.show,
    required this.episode,
    required ControllerBuilder<VideoPlayerController> builder,
    required Widget buttons,
    ControllerSetter<VideoPlayerController>? afterInit,
  })  : _builder = builder,
        _afterInit = afterInit,
        _buttons = buttons;

  VideoPlayerController get controller {
    if (_controller == null) {
      _controller = _builder.call();
      _controller!.addListener(() {
        if (_controller?.value.isCompleted == true && !_playCompleteReported) {
          _playCompleteReported = true;
          TrackHelper.instance.track(
              event: TrackEvents.playback,
              action: TrackValues.playComplete,
              params: trackParams);
        }
      });
    }
    return _controller!;
  }

  bool get shouldAutoPlay => !(episode.locked == true);

  ChewieController get chewieController {
    _chewieController ??= ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: false,
        allowFullScreen: false,
        showOptions: false,
        showControls: true,
        allowMuting: false,
        showControlsOnInitialize: false,
        placeholder: const Center(
          child: Loading(),
        ),
        customControls: CustomVideoControls(buttons: _buttons));
    return _chewieController!;
  }

  bool _prepared = false;

  Future<void> dispose() async {
    _prepared = false;
    controller.dispose();
    _controller = null;
    _chewieController?.dispose();
    _chewieController = null;
    resetTracking();
  }

  Future<void> init({
    ControllerSetter<VideoPlayerController>? afterInit,
  }) async {
    if (_prepared) return;
    _prepared = true;
    controller.initialize();
    afterInit ??= _afterInit;
    afterInit?.call(controller);
  }

  Future<void> pause({bool showPauseIcon = false}) async {
    init();
    if (!_prepared) return;
    controller.pause();
    _paused.value = true;
  }

  Future<void> play() async {
    init();
    if (!_prepared) return;
    controller.play();
    _paused.value = false;

    if (!_playReported) {
      _playReported = true;
      TrackHelper.instance.track(
          event: TrackEvents.playback,
          action: TrackValues.playStart,
          params: trackParams);
    }
    _report5sTimer = Timer(const Duration(seconds: 5), () {
      if (!_play5sReported) {
        _play5sReported = true;
        TrackHelper.instance.track(
            event: TrackEvents.playback,
            action: TrackValues.play5s,
            params: trackParams);
        _rewardTask();
      }
    });
  }

  void _rewardTask() async {
    List<TaskItem> taskList = HiveHelper.instance.getRewardUserTaskList();
    LogD(
        "_ShowDetailsViewState extends State<ShowDetailsView>-taskList:\n${json.encode(taskList).toString()}");
    if (taskList.isNotEmpty) {
      TaskItem? taskIn = taskList.toList().cast<TaskItem?>().firstWhere(
            (item) =>
                item?.type.toString() ==
                rewardTaskStrings[RewardTask.watchEpisode],
            orElse: () => null as TaskItem?, // Cast null to TaskItem?
          );
      if (taskIn != null) {
        eventBus.fire(UpdateRewardEvent(RewardTaskJob.watchEpisode, args: {
          "type": taskIn?.type.toString(),
          "id": taskIn?.id,
        }));
      }
    }
  }

  ValueNotifier<bool> get paused => _paused;

  bool _playReported = false;
  bool _play5sReported = false;
  bool _playCompleteReported = false;
  Timer? _report5sTimer;

  Map<String, dynamic> get trackParams =>
      TrackUtils.showEpisode(show: show, episode: episode);

  void resetTracking() {
    _report5sTimer?.cancel();
    _playReported = false;
    _play5sReported = false;
    _playCompleteReported = false;
  }
}
