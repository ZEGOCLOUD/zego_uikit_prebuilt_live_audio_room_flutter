// Dart imports:
import 'dart:async';
import 'dart:core';
import 'dart:math';

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
import 'package:zego_uikit_prebuilt_live_audio_room/src/style.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/live_duration_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/data.dart';

/// @nodoc
/// user and sdk should be login and init before page enter
class ZegoLiveAudioRoomPage extends StatefulWidget {
  const ZegoLiveAudioRoomPage({
    Key? key,
    this.prebuiltController,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.liveID,
    required this.config,
    required this.style,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.seatManager,
    required this.connectManager,
    required this.popUpManager,
    required this.liveDurationManager,
    required this.minimizeData,
    this.plugins,
  }) : super(key: key);

  final int appID;
  final String appSign;

  final String userID;
  final String userName;

  final String liveID;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;
  final ZegoUIKitPrebuiltLiveAudioRoomStyle style;
  final void Function(ZegoLiveAudioRoomEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoLiveAudioRoomPopUpManager popUpManager;
  final ZegoLiveAudioRoomDurationManager liveDurationManager;
  final ZegoUIKitPrebuiltLiveAudioRoomController? prebuiltController;
  final ZegoLiveAudioRoomPlugins? plugins;

  final ZegoUIKitPrebuiltLiveAudioRoomMinimizeData minimizeData;

  @override
  State<ZegoLiveAudioRoomPage> createState() => _ZegoLiveAudioRoomPageState();
}

class _ZegoLiveAudioRoomPageState extends State<ZegoLiveAudioRoomPage>
    with SingleTickerProviderStateMixin {
  /// had sort the host be first
  bool audioVideoContainerHostHadSorted = false;

  List<StreamSubscription<dynamic>?> subscriptions = [];

  double get bottomBarHeight =>
      widget.config.bottomMenuBar.visible ? 124.zR : 0;

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
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }

          final endConfirmationEvent = ZegoLiveAudioRoomLeaveConfirmationEvent(
            context: context,
          );
          defaultAction() async {
            return widget.defaultLeaveConfirmationAction(endConfirmationEvent);
          }

          final canLeave = await widget.events.onLeaveConfirmation!(
            endConfirmationEvent,
            defaultAction,
          );
          ZegoLoggerService.logInfo(
            'onPopInvoked, canLeave:$canLeave',
            tag: 'audio-room',
            subTag: 'prebuilt',
          );

          if (canLeave) {
            if (context.mounted) {
              Navigator.of(
                context,
                rootNavigator: widget.config.rootNavigator,
              ).pop(false);
            } else {
              ZegoLoggerService.logInfo(
                'onPopInvoked, context not mounted',
                tag: 'audio-room',
                subTag: 'prebuilt',
              );
            }
          }
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
                    durationTimeBoard(),
                    topBar(),
                    bottomBar(),
                    messageList(),
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
      child: SizedBox(
        width: 750.zW,
        height: height,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00008B).withOpacity(0.5),
                    const Color(0xFF800080).withOpacity(0.3),
                    const Color(0xFF006400).withOpacity(0.5),
                  ],
                  stops: const [0.3, 0.5, 0.9], // color ratio
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            widget.config.background ?? Container(),
          ],
        ),
      ),
    );
  }

  Widget foreground(BuildContext context, double height) {
    return widget.config.foreground ?? Container();
  }

  Widget audioVideoContainer(double maxWidth, double maxHeight) {
    final containerHorizontalSpacing = 35.zW;

    final tempMaxWidth = maxWidth - containerHorizontalSpacing * 2;
    var tempMaxHeight = maxHeight - 169.zR; // top position
    tempMaxHeight -= bottomBarHeight; // bottom bar

    final fixedRow = widget.config.seat.layout.rowConfigs.length;
    var containerHeight = seatItemHeight * fixedRow +
        widget.config.seat.layout.rowSpacing * (fixedRow - 1);

    var maxColumn = 1;
    var maxColumnSpacing = 0;
    for (var rowConfig in widget.config.seat.layout.rowConfigs) {
      maxColumn = (rowConfig.count > maxColumn) ? rowConfig.count : maxColumn;
      maxColumnSpacing = (rowConfig.seatSpacing > maxColumnSpacing)
          ? rowConfig.seatSpacing
          : maxColumnSpacing;
    }
    var containerWidth =
        seatItemWidth * maxColumn + maxColumnSpacing * (maxColumn - 1);

    Axis? scrollDirection;
    if (containerHeight > tempMaxHeight) {
      containerHeight = tempMaxHeight;
      scrollDirection = Axis.vertical;
    } else if (containerWidth > tempMaxWidth) {
      containerWidth = tempMaxWidth;
      scrollDirection = Axis.horizontal;
    }

    final seatContainer = ZegoLiveAudioRoomSeatContainer(
      seatManager: widget.seatManager,
      layoutConfig: widget.config.seat.layout,
      style: widget.style,
      foregroundBuilder: (
        BuildContext context,
        Size size,
        ZegoUIKitUser? user,
        Map<String, dynamic> extraInfo,
      ) {
        return ZegoLiveAudioRoomSeatForeground(
          user: user,
          extraInfo: extraInfo,
          size: size,
          seatManager: widget.seatManager,
          connectManager: widget.connectManager,
          popUpManager: widget.popUpManager,
          config: widget.config,
          events: widget.events,
          prebuiltController: widget.prebuiltController,
        );
      },
      backgroundBuilder: (
        BuildContext context,
        Size size,
        ZegoUIKitUser? user,
        Map<String, dynamic> extraInfo,
      ) {
        return Opacity(
          opacity: widget.style.opacity,
          child: ZegoLiveAudioRoomSeatBackground(
            user: user,
            extraInfo: extraInfo,
            size: size,
            seatManager: widget.seatManager,
            config: widget.config,
          ),
        );
      },
      sortAudioVideo: audioVideoViewSorter,
      avatarBuilder: widget.config.seat.avatarBuilder,
      showSoundWavesInAudioMode: widget.config.seat.showSoundWaveInAudioMode,
      soundWaveColor: widget.config.seat.soundWaveColor,
    );

    final topLeft = widget.config.seat.topLeft ??
        Point(
          35.zW,
          169.zR,
        );
    return Positioned(
      left: topLeft.x,
      top: topLeft.y,
      child: SizedBox(
        width: null != scrollDirection ? containerWidth : tempMaxWidth,
        height: containerHeight,
        child: null != scrollDirection
            ? SingleChildScrollView(
                scrollDirection: scrollDirection,
                child: seatContainer,
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
          return ZegoLiveAudioRoomTopBar(
            config: widget.config,
            style: widget.style,
            events: widget.events,
            defaultEndAction: widget.defaultEndAction,
            defaultLeaveConfirmationAction:
                widget.defaultLeaveConfirmationAction,
            seatManager: widget.seatManager,
            connectManager: widget.connectManager,
            popUpManager: widget.popUpManager,
            prebuiltController: widget.prebuiltController,
            isPluginEnabled: widget.plugins?.isEnabled ?? false,
            avatarBuilder: widget.config.seat.avatarBuilder,
            translationText: widget.config.innerText,
          );
        },
      ),
    );
  }

  Widget bottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ZegoLiveAudioRoomBottomBar(
        height: bottomBarHeight,
        buttonSize: zegoLiveButtonSize,
        config: widget.config,
        style: widget.style,
        events: widget.events,
        defaultEndAction: widget.defaultEndAction,
        defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
        seatManager: widget.seatManager,
        connectManager: widget.connectManager,
        popUpManager: widget.popUpManager,
        prebuiltController: widget.prebuiltController,
        isPluginEnabled: widget.plugins?.isEnabled ?? false,
        avatarBuilder: widget.config.seat.avatarBuilder,
        minimizeData: widget.minimizeData,
      ),
    );
  }

  Widget emptyArea(double maxHeight) {
    if (widget.config.emptyAreaBuilder == null) {
      return const SizedBox.shrink();
    }

    var tempMaxHeight = maxHeight - 169.zR; // top position
    tempMaxHeight -= bottomBarHeight; // bottom bar
    final fixedRow = widget.config.seat.layout.rowConfigs.length;
    var containerHeight = seatItemHeight * fixedRow +
        widget.config.seat.layout.rowSpacing * (fixedRow - 1);
    if (containerHeight > tempMaxHeight) {
      containerHeight = tempMaxHeight;
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 169.zR + containerHeight,
      bottom: bottomBarHeight,
      child: widget.config.emptyAreaBuilder!.call(context),
    );
  }

  Widget messageList() {
    if (!widget.config.inRoomMessage.visible) {
      return Container();
    }

    var listSize = Size(
      widget.config.inRoomMessage.width ?? 540.zR,
      widget.config.inRoomMessage.height ?? 400.zR,
    );
    if (listSize.width < 54.zR) {
      listSize = Size(54.zR, listSize.height);
    }
    if (listSize.height < 40.zR) {
      listSize = Size(listSize.width, 40.zR);
    }
    return Positioned(
      left: widget.config.inRoomMessage.bottomLeft?.dx ?? 0,
      bottom:
          bottomBarHeight + (widget.config.inRoomMessage.bottomLeft?.dy ?? 0),
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(listSize),
        child: ZegoLiveAudioRoomInRoomLiveMessageView(
          config: widget.config.inRoomMessage,
          avatarBuilder: widget.config.seat.avatarBuilder,
        ),
      ),
    );
  }

  Widget durationTimeBoard() {
    if (!widget.config.duration.isVisible) {
      return Container();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 10,
      child: LiveDurationTimeBoard(
        config: widget.config.duration,
        events: widget.events.duration,
        manager: widget.liveDurationManager,
      ),
    );
  }

  Future<void> onTurnOnYourMicrophoneRequest(
      ZegoUIKitReceiveTurnOnLocalMicrophoneEvent event) async {
    ZegoLoggerService.logInfo(
      'onTurnOnYourMicrophoneRequest, event:$event',
      tag: 'audio-room',
      subTag: 'live page',
    );

    if (ZegoUIKit().getLocalUser().microphone.value) {
      ZegoLoggerService.logInfo(
        'microphone is open now, not need request',
        tag: 'audio-room',
        subTag: 'live page',
      );

      return;
    }

    final canMicrophoneTurnOnByOthers = await widget
            .events.audioVideo.onMicrophoneTurnOnByOthersConfirmation
            ?.call(context) ??
        false;
    ZegoLoggerService.logInfo(
      'canMicrophoneTurnOnByOthers:$canMicrophoneTurnOnByOthers',
      tag: 'audio-room',
      subTag: 'live page',
    );
    if (canMicrophoneTurnOnByOthers) {
      ZegoUIKit().turnMicrophoneOn(true);
    }
  }
}
