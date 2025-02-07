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
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/live_duration_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/style.dart';

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

  double containerHeight(double maxHeight) {
    var tempMaxHeight = maxHeight - 169.zR; // top position
    tempMaxHeight -= bottomBarHeight; // bottom bar
    final fixedRow = widget.config.seat.layout.rowConfigs.length;
    var containerHeight = seatItemHeight * fixedRow +
        widget.config.seat.layout.rowSpacing * (fixedRow - 1);
    if (containerHeight > tempMaxHeight) {
      containerHeight = tempMaxHeight;
    }

    return containerHeight;
  }

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
                    messageList(),
                    sharingMedia(constraints),
                    durationTimeBoard(),
                    topBar(),
                    bottomBar(),
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
    final topLeft = widget.config.seat.topLeft ??
        Point(
          35.zW,
          169.zR,
        );

    var tempMaxWidth = maxWidth;
    var tempMaxHeight = maxHeight;

    final containerHorizontalSpacing = topLeft.x;
    tempMaxWidth -= containerHorizontalSpacing * 2;

    tempMaxHeight -= topLeft.y; // top position
    tempMaxHeight -= bottomBarHeight; // bottom bar

    final fixedRowCount = widget.config.seat.layout.rowConfigs.length;
    var preferredHeight = seatItemHeight * fixedRowCount +
        widget.config.seat.layout.rowSpacing * (fixedRowCount - 1);

    var maxColumnCount = 1;
    var maxColumnSpacing = 0;
    for (var rowConfig in widget.config.seat.layout.rowConfigs) {
      maxColumnCount =
          (rowConfig.count > maxColumnCount) ? rowConfig.count : maxColumnCount;
      maxColumnSpacing = (rowConfig.seatSpacing > maxColumnSpacing)
          ? rowConfig.seatSpacing
          : maxColumnSpacing;
    }
    var preferredWidth = seatItemWidth * maxColumnCount +
        maxColumnSpacing * (maxColumnCount - 1);

    Size preferredSize = Size(preferredWidth, preferredHeight);

    Size containerSize = preferredSize;
    Axis? scrollDirection;
    if (null == widget.config.seat.containerSize) {
      if (preferredSize.height > tempMaxHeight) {
        containerSize = Size(preferredSize.width, tempMaxHeight);
        scrollDirection = Axis.vertical;
      } else if (preferredSize.width > tempMaxWidth) {
        containerSize = Size(tempMaxWidth, preferredSize.height);
        scrollDirection = Axis.horizontal;
      }
    } else {
      containerSize = widget.config.seat.containerSize!;

      if (containerSize.height < preferredSize.height) {
        scrollDirection = Axis.vertical;
      } else if (containerSize.width < preferredSize.width) {
        scrollDirection = Axis.horizontal;
      }
    }

    seatWidgetCreator(ZegoUIKitUser user, int seatIndex) {
      return ValueListenableBuilder<bool>(
        valueListenable: ZegoUIKit().getMicrophoneStateNotifier(user.id),
        builder: (context, isMicrophoneEnabled, _) {
          return ZegoAudioVideoView(
            user: user,
            borderColor: Colors.transparent,
            extraInfo: {layoutGridItemIndexKey: seatIndex},
            foregroundBuilder: audioVideoForegroundBuilder,
            backgroundBuilder: audioVideoBackgroundBuilder,
            avatarConfig: ZegoAvatarConfig(
              showInAudioMode: true,
              showSoundWavesInAudioMode:
                  widget.config.seat.showSoundWaveInAudioMode,
              builder: widget.config.seat.avatarBuilder,
              soundWaveColor:
                  widget.config.seat.soundWaveColor ?? zegoLiveSoundWaveColor,
              size: Size(seatIconWidth, seatIconHeight),
              verticalAlignment: ZegoAvatarAlignment.start,
            ),
          );
        },
      );
    }

    final audioVideoContainer = SizedBox(
      width: containerSize.width,
      height: containerSize.height,
      child: null != widget.config.seat.containerBuilder
          ? StreamBuilder<List<ZegoUIKitUser>>(
              stream: ZegoUIKit().getUserListStream(),
              builder: (context, snapshot) {
                final allUsers = ZegoUIKit().getAllUsers();
                return StreamBuilder<List<ZegoUIKitUser>>(
                  stream: ZegoUIKit().getAudioVideoListStream(),
                  builder: (context, snapshot) {
                    return widget.config.seat.containerBuilder?.call(
                          context,
                          allUsers,
                          ZegoUIKit().getAudioVideoList(),
                          seatWidgetCreator,
                        ) ??
                        defaultAudioVideoContainer();
                  },
                );
              },
            )
          : defaultAudioVideoContainer(),
    );

    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.only(
          left: topLeft.x,
          top: topLeft.y,
        ),
        child: null != scrollDirection
            ? SingleChildScrollView(
                scrollDirection: scrollDirection,
                child: audioVideoContainer,
              )
            : audioVideoContainer,
      ),
    );
  }

  Widget defaultAudioVideoContainer() {
    return ZegoLiveAudioRoomSeatContainer(
      seatManager: widget.seatManager,
      layoutConfig: widget.config.seat.layout,
      style: widget.style,
      foregroundBuilder: audioVideoForegroundBuilder,
      backgroundBuilder: audioVideoBackgroundBuilder,
      sortAudioVideo: audioVideoViewSorter,
      avatarBuilder: widget.config.seat.avatarBuilder,
      showSoundWavesInAudioMode: widget.config.seat.showSoundWaveInAudioMode,
      soundWaveColor: widget.config.seat.soundWaveColor,
    );
  }

  Widget audioVideoForegroundBuilder(
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
  }

  Widget audioVideoBackgroundBuilder(
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

  Widget sharingMedia(BoxConstraints constraints) {
    if (!widget.config.mediaPlayer.defaultPlayer.support) {
      return Container();
    }

    ZegoUIKitPrebuiltLiveAudioRoomController()
        .media
        .defaultPlayer
        .visibleNotifier
        .value = true;
    return ValueListenableBuilder<bool>(
      valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController()
          .media
          .defaultPlayer
          .visibleNotifier,
      builder: (context, viewVisibility, _) {
        return viewVisibility
            ? ValueListenableBuilder(
                valueListenable: widget.seatManager.localRole,
                builder: (context, localRole, _) {
                  final spacing = 20.zW;

                  final queryParameter =
                      ZegoLiveAudioRoomMediaPlayerQueryParameter(
                    localRole: widget.seatManager.localRole.value,
                  );

                  final rect = widget.config.mediaPlayer.defaultPlayer.rectQuery
                      ?.call(queryParameter);
                  final playerSize = rect?.size ??
                      Size(
                        constraints.maxWidth - spacing * 2,
                        constraints.maxWidth * 9 / 16,
                      );
                  final topLeft = widget
                          .config.mediaPlayer.defaultPlayer.topLeftQuery
                          ?.call(queryParameter) ??
                      Point<double>(
                        spacing,
                        169.zR + containerHeight(constraints.maxHeight),
                      );

                  var config = widget
                          .config.mediaPlayer.defaultPlayer.configQuery
                          ?.call(queryParameter) ??
                      ZegoUIKitMediaPlayerConfig(
                        canControl: ZegoLiveAudioRoomRole.host ==
                            widget.seatManager.localRole.value,
                      );

                  final mediaPlayer = Positioned.fromRect(
                    rect: rect ??
                        Rect.fromLTWH(
                          spacing,
                          spacing,
                          constraints.maxWidth - 2 * spacing,
                          constraints.maxHeight - 2 * spacing,
                        ),
                    child: ValueListenableBuilder<String?>(
                      valueListenable:
                          ZegoUIKitPrebuiltLiveAudioRoomController()
                              .media
                              .defaultPlayer
                              .private
                              .sharingPathNotifier,
                      builder: (context, sharingPath, _) {
                        return ZegoUIKitMediaPlayer(
                          size: playerSize,
                          initPosition: Offset(topLeft.x, topLeft.y),
                          config: config,
                          filePathOrURL: sharingPath,
                          event: widget.events.media,
                          style: widget
                              .config.mediaPlayer.defaultPlayer.styleQuery
                              ?.call(queryParameter),
                        );
                      },
                    ),
                  );

                  if (widget.config.mediaPlayer.defaultPlayer.rolesCanControl
                      .contains(localRole)) {
                    return mediaPlayer;
                  } else {
                    return StreamBuilder<List<ZegoUIKitUser>>(
                      stream: ZegoUIKit().getMediaListStream(),
                      builder: (context, snapshot) {
                        final mediaUsers = ZegoUIKit().getMediaList();
                        if (mediaUsers.isEmpty) {
                          return Container();
                        }

                        return mediaPlayer;
                      },
                    );
                  }
                },
              )
            : Container();
      },
    );
  }

  Widget emptyArea(double maxHeight) {
    if (widget.config.emptyAreaBuilder == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 169.zR + containerHeight(maxHeight),
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
