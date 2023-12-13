// Dart imports:
import 'dart:async';
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/background.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/foreground.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/seat_container.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/bottom_bar.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/duration_time_board.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/message/view.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/top_bar.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/live_duration_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/prebuilt_data.dart';

/// @nodoc
/// user and sdk should be login and init before page enter
class ZegoLivePage extends StatefulWidget {
  const ZegoLivePage({
    Key? key,
    this.prebuiltController,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.liveID,
    required this.config,
    required this.seatManager,
    required this.connectManager,
    required this.popUpManager,
    required this.liveDurationManager,
    required this.prebuiltAudioRoomData,
    this.plugins,
  }) : super(key: key);

  final int appID;
  final String appSign;

  final String userID;
  final String userName;

  final String liveID;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoPopUpManager popUpManager;
  final ZegoLiveDurationManager liveDurationManager;
  final ZegoLiveAudioRoomController? prebuiltController;
  final ZegoPrebuiltPlugins? plugins;

  final ZegoUIKitPrebuiltLiveAudioRoomData prebuiltAudioRoomData;

  @override
  State<ZegoLivePage> createState() => ZegoLivePageState();
}

/// @nodoc
class ZegoLivePageState extends State<ZegoLivePage>
    with SingleTickerProviderStateMixin {
  /// had sort the host be first
  bool audioVideoContainerHostHadSorted = false;

  List<StreamSubscription<dynamic>?> subscriptions = [];

  @override
  void initState() {
    super.initState();

    subscriptions.add(ZegoUIKit()
        .getTurnOnYourMicrophoneRequestStream()
        .listen(onTurnOnYourMicrophoneRequest));
  }

  @override
  void dispose() {
    super.dispose();

    for (final subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          return widget.config.onLeaveConfirmation!(context);
        },
        child: ZegoScreenUtilInit(
          designSize: const Size(750, 1334),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return clickListener(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    background(context, constraints.maxHeight),
                    audioVideoContainer(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    topBar(),
                    bottomBar(),
                    messageList(),
                    durationTimeBoard(),
                    emptyArea(constraints.maxHeight),
                    foreground(context, constraints.maxHeight),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget clickListener({required Widget child}) {
    return GestureDetector(
      onTap: () {
        /// listen only click event in empty space
      },
      child: Listener(
        ///  listen for all click events in current view, include the click
        ///  receivers(such as button...), but only listen
        child: AbsorbPointer(
          absorbing: false,
          child: child,
        ),
      ),
    );
  }

  Widget background(BuildContext context, double height) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 750.zW,
        height: height,
        decoration: const BoxDecoration(
          color: Color(0xffF4F4F6),
        ),
        child: widget.config.background,
      ),
    );
  }

  Widget foreground(BuildContext context, double height) {
    return widget.config.foreground ?? Container();
  }

  Widget audioVideoContainer(double maxWidth, double maxHeight) {
    var tempMaxHeight = maxHeight - 169.zR; // top position
    tempMaxHeight -= 124.zR; // bottom bar

    var scrollable = false;
    final fixedRow = widget.config.layoutConfig.rowConfigs.length;
    var containerHeight = seatItemHeight * fixedRow +
        widget.config.layoutConfig.rowSpacing * (fixedRow - 1);
    if (containerHeight > tempMaxHeight) {
      containerHeight = tempMaxHeight;
      scrollable = true;
    }

    final seatContainer = ZegoSeatContainer(
      seatManager: widget.seatManager,
      layoutConfig: widget.config.layoutConfig,
      foregroundBuilder: (
        BuildContext context,
        Size size,
        ZegoUIKitUser? user,
        Map<String, dynamic> extraInfo,
      ) {
        return ZegoSeatForeground(
          user: user,
          extraInfo: extraInfo,
          size: size,
          seatManager: widget.seatManager,
          connectManager: widget.connectManager,
          popUpManager: widget.popUpManager,
          config: widget.config,
          prebuiltController: widget.prebuiltController,
        );
      },
      backgroundBuilder: (
        BuildContext context,
        Size size,
        ZegoUIKitUser? user,
        Map<String, dynamic> extraInfo,
      ) {
        return ZegoSeatBackground(
          user: user,
          extraInfo: extraInfo,
          size: size,
          seatManager: widget.seatManager,
          config: widget.config,
        );
      },
      sortAudioVideo: audioVideoViewSorter,
      avatarBuilder: widget.config.seatConfig.avatarBuilder,
      showSoundWavesInAudioMode:
          widget.config.seatConfig.showSoundWaveInAudioMode,
    );

    return Positioned(
      top: 169.zR,
      left: 35.zW,
      child: SizedBox(
        width: maxWidth - 35.zW * 2,
        height: containerHeight,
        child: scrollable
            ? CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: seatContainer,
                  ),
                ],
              )
            : seatContainer,
      ),
    );
  }

  List<ZegoUIKitUser> audioVideoViewSorter(List<ZegoUIKitUser> users) {
    return users;
  }

  Widget topBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 64.zR,
      child: ValueListenableBuilder<ZegoUIKitRoomState>(
        valueListenable: ZegoUIKit().getRoomStateStream(),
        builder: (context, roomState, _) {
          return ZegoTopBar(
            config: widget.config,
            seatManager: widget.seatManager,
            connectManager: widget.connectManager,
            translationText: widget.config.innerText,
            prebuiltAudioRoomData: widget.prebuiltAudioRoomData,
          );
        },
      ),
    );
  }

  Widget bottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ZegoBottomBar(
        height: 124.zR,
        buttonSize: zegoLiveButtonSize,
        config: widget.config,
        seatManager: widget.seatManager,
        connectManager: widget.connectManager,
        popUpManager: widget.popUpManager,
        prebuiltController: widget.prebuiltController,
        isPluginEnabled: widget.plugins?.isEnabled ?? false,
        avatarBuilder: widget.config.seatConfig.avatarBuilder,
        prebuiltData: widget.prebuiltAudioRoomData,
      ),
    );
  }

  Widget emptyArea(double maxHeight) {
    if (widget.config.emptyAreaBuilder == null) return const SizedBox.shrink();
    var tempMaxHeight = maxHeight - 169.zR; // top position
    tempMaxHeight -= 124.zR; // bottom bar
    final fixedRow = widget.config.layoutConfig.rowConfigs.length;
    var containerHeight = seatItemHeight * fixedRow +
        widget.config.layoutConfig.rowSpacing * (fixedRow - 1);
    if (containerHeight > tempMaxHeight) {
      containerHeight = tempMaxHeight;
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 169.zR + containerHeight,
      bottom: 124.zR,
      child: widget.config.emptyAreaBuilder!.call(context),
    );
  }

  Widget messageList() {
    if (!widget.config.inRoomMessageConfig.visible) {
      return Container();
    }

    var listSize = Size(
      widget.config.inRoomMessageConfig.width ?? 540.zR,
      widget.config.inRoomMessageConfig.height ?? 400.zR,
    );
    if (listSize.width < 54.zR) {
      listSize = Size(54.zR, listSize.height);
    }
    if (listSize.height < 40.zR) {
      listSize = Size(listSize.width, 40.zR);
    }
    return Positioned(
      left: widget.config.inRoomMessageConfig.bottomLeft?.dx ?? 0,
      bottom: 124.zR + (widget.config.inRoomMessageConfig.bottomLeft?.dy ?? 0),
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(listSize),
        child: ZegoInRoomLiveMessageView(
          config: widget.config.inRoomMessageConfig,
          avatarBuilder: widget.config.seatConfig.avatarBuilder,
        ),
      ),
    );
  }

  Widget durationTimeBoard() {
    if (!widget.config.durationConfig.isVisible) {
      return Container();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 10,
      child: LiveDurationTimeBoard(
        config: widget.config.durationConfig,
        manager: widget.liveDurationManager,
      ),
    );
  }

  Future<void> onTurnOnYourMicrophoneRequest(
      ZegoUIKitReceiveTurnOnLocalMicrophoneEvent event) async {
    ZegoLoggerService.logInfo(
      'onTurnOnYourMicrophoneRequest, event:$event',
      tag: 'live audio',
      subTag: 'live page',
    );

    if (ZegoUIKit().getLocalUser().microphone.value) {
      ZegoLoggerService.logInfo(
        'microphone is open now, not need request',
        tag: 'live audio',
        subTag: 'live page',
      );

      return;
    }

    final canMicrophoneTurnOnByOthers = await widget
            .config.onMicrophoneTurnOnByOthersConfirmation
            ?.call(context) ??
        false;
    ZegoLoggerService.logInfo(
      'canMicrophoneTurnOnByOthers:$canMicrophoneTurnOnByOthers',
      tag: 'live audio',
      subTag: 'live page',
    );
    if (canMicrophoneTurnOnByOthers) {
      ZegoUIKit().turnMicrophoneOn(true);
    }
  }
}
