// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/duration_time_board.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

/// @nodoc
class ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage extends StatefulWidget {
  const ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage({
    Key? key,
    required this.contextQuery,
    this.size,
    this.topLeft = const Offset(100, 100),
    this.borderRadius = 12.0,
    this.borderColor = Colors.black12,
    this.soundWaveColor = const Color(0xff2254f6),
    this.backgroundColor = Colors.white,
    this.padding = 0.0,
    this.showDevices = true,
    this.showUserName = true,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.foreground,
    this.builder,
  }) : super(key: key);

  final Size? size;

  final double padding;

  final double borderRadius;

  final Color borderColor;

  final Color backgroundColor;

  final Color soundWaveColor;

  final Offset topLeft;

  final bool showDevices;

  final bool showUserName;

  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;
  final Widget? foreground;
  final Widget Function(ZegoUIKitUser? activeUser)? builder;

  /// You need to return the `context` of NavigatorState in this callback
  final BuildContext Function() contextQuery;

  @override
  ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPageState createState() =>
      ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPageState();
}

/// @nodoc
class ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPageState
    extends State<ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage> {
  LiveAudioRoomMiniOverlayPageState currentState =
      LiveAudioRoomMiniOverlayPageState.idle;

  bool visibility = false;
  late Offset topLeft;
  late Size itemSize;

  StreamSubscription<dynamic>? audioVideoListSubscription;
  List<StreamSubscription<dynamic>?> soundLevelSubscriptions = [];
  Timer? activeUserTimer;
  final activeUserIDNotifier = ValueNotifier<String?>(null);
  final Map<String, List<double>> rangeSoundLevels = {};

  @override
  void initState() {
    super.initState();

    topLeft = widget.topLeft;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
          .listenStateChanged(onMiniOverlayMachineStateChanged);

      if (null !=
          ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().machine.current) {
        syncState();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    activeUserTimer?.cancel();
    activeUserTimer = null;

    audioVideoListSubscription?.cancel();

    ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
        .removeListenStateChanged(onMiniOverlayMachineStateChanged);
  }

  @override
  Widget build(BuildContext context) {
    itemSize = calculateItemSize();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Visibility(
        visible: visibility,
        child: Positioned(
          left: topLeft.dx,
          top: topLeft.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                var x = topLeft.dx + details.delta.dx;
                var y = topLeft.dy + details.delta.dy;
                x = x.clamp(
                    0.0, MediaQuery.of(context).size.width - itemSize.width);
                y = y.clamp(
                    0.0, MediaQuery.of(context).size.height - itemSize.height);
                topLeft = Offset(x, y);
              });
            },
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: itemSize.width,
                height: itemSize.height,
                child: overlayItem(),
              );
            }),
          ),
        ),
      ),
    );
  }

  Size calculateItemSize() {
    if (null != widget.size) {
      return widget.size!;
    }

    if (!visibility) {
      return Size.zero;
    }

    return Size(seatItemWidth, seatItemHeight);
  }

  Widget overlayItem() {
    switch (currentState) {
      case LiveAudioRoomMiniOverlayPageState.idle:
      case LiveAudioRoomMiniOverlayPageState.inAudioRoom:
        return Container();
      case LiveAudioRoomMiniOverlayPageState.minimizing:
        return GestureDetector(
          onTap: () {
            final prebuiltAudioRoomData =
                ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
                    .prebuiltAudioRoomData;
            assert(null != prebuiltAudioRoomData);

            /// re-enter prebuilt call
            ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
                .changeState(LiveAudioRoomMiniOverlayPageState.inAudioRoom);

            Navigator.of(widget.contextQuery(), rootNavigator: true).push(
              MaterialPageRoute(builder: (context) {
                return SafeArea(
                  child: ZegoUIKitPrebuiltLiveAudioRoom(
                    appID: prebuiltAudioRoomData!.appID,
                    appSign: prebuiltAudioRoomData.appSign,
                    userID: prebuiltAudioRoomData.userID,
                    userName: prebuiltAudioRoomData.userName,
                    roomID: prebuiltAudioRoomData.roomID,
                    config: prebuiltAudioRoomData.config,
                    controller: prebuiltAudioRoomData.controller,
                  ),
                );
              }),
            );
          },
          child: ValueListenableBuilder<String?>(
            valueListenable: activeUserIDNotifier,
            builder: (context, activeUserID, _) {
              final activeUser = ZegoUIKit().getUser(activeUserID ?? '');
              return circleBorder(
                child: minimizingUserWidget(activeUser),
              );
            },
          ),
        );
    }
  }

  Widget minimizingUserWidget(ZegoUIKitUser? activeUser) {
    return widget.builder?.call(activeUser) ??
        Stack(
          children: [
            ZegoAudioVideoView(
              user: activeUser,
              avatarConfig: ZegoAvatarConfig(
                showInAudioMode: true,
                showSoundWavesInAudioMode: true,
                builder: ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
                    .prebuiltAudioRoomData
                    ?.config
                    .seatConfig
                    .avatarBuilder,
                soundWaveColor: widget.soundWaveColor,
                size: Size(seatIconWidth, seatIconHeight),
                verticalAlignment: ZegoAvatarAlignment.start,
              ),
              foregroundBuilder: widget.foregroundBuilder,
              backgroundBuilder: widget.backgroundBuilder,
            ),
            Positioned(
              bottom: seatItemRowSpacing,
              child: userName(context, activeUser),
            ),
            Positioned(
              right: seatItemRowSpacing,
              bottom: seatUserNameFontSize + seatItemRowSpacing,
              child: devices(activeUser),
            ),
            Positioned(
              top: seatItemRowSpacing,
              right: seatItemRowSpacing,
              child: redPoint(),
            ),
            durationTimeBoard(),
            widget.foreground ?? Container(),
          ],
        );
  }

  Widget durationTimeBoard() {
    if (null == ZegoLiveAudioRoomManagers().liveDurationManager) {
      return Container();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 2,
      child: LiveDurationTimeBoard(
        config: ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
                .prebuiltAudioRoomData
                ?.config
                .durationConfig ??
            ZegoLiveDurationConfig(),
        manager: ZegoLiveAudioRoomManagers().liveDurationManager!,
        fontSize: 15.zR,
      ),
    );
  }

  Widget devices(ZegoUIKitUser? activeUser) {
    if (null == activeUser) {
      return Container();
    }

    if (!widget.showDevices) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable:
              ZegoUIKit().getMicrophoneStateNotifier(activeUser.id),
          builder: (context, isMicrophoneEnabled, _) {
            return GestureDetector(
              onTap: activeUser.id == ZegoUIKit().getLocalUser().id
                  ? () {
                      ZegoUIKit().turnMicrophoneOn(
                        !isMicrophoneEnabled,
                        userID: activeUser.id,
                      );
                    }
                  : null,
              child: Container(
                width: itemSize.width * 0.3,
                height: itemSize.width * 0.3,
                decoration: BoxDecoration(
                  color: isMicrophoneEnabled
                      ? controlBarButtonCheckedBackgroundColor
                      : controlBarButtonBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: itemSize.width * 0.3,
                    height: itemSize.width * 0.3,
                    child: PrebuiltLiveAudioRoomImage.asset(
                      isMicrophoneEnabled
                          ? PrebuiltLiveAudioRoomIconUrls.toolbarMicNormal
                          : PrebuiltLiveAudioRoomIconUrls.toolbarMicOff,
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget userName(BuildContext context, ZegoUIKitUser? activeUser) {
    return widget.showUserName
        ? SizedBox(
            width: seatItemWidth,
            child: Text(
              activeUser?.name ?? '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: seatUserNameFontSize,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          )
        : Container();
  }

  Widget circleBorder({required Widget child}) {
    final decoration = BoxDecoration(
      border: Border.all(color: widget.borderColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    );

    return Container(
      padding: EdgeInsets.all(widget.padding),
      decoration: decoration,
      child: PhysicalModel(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        clipBehavior: Clip.antiAlias,
        elevation: 6.0,
        shadowColor: Colors.black,
        child: child,
      ),
    );
  }

  Widget redPoint() {
    if (null == ZegoLiveAudioRoomManagers().connectManager) {
      return Container();
    }

    return ValueListenableBuilder<List<ZegoUIKitUser>>(
      valueListenable: ZegoLiveAudioRoomManagers()
          .connectManager!
          .audiencesRequestingTakeSeatNotifier,
      builder: (context, requestTakeSeatUsers, _) {
        if (requestTakeSeatUsers.isEmpty) {
          return Container();
        } else {
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            width: 20.zR,
            height: 20.zR,
          );
        }
      },
    );
  }

  void syncState() {
    setState(() {
      currentState = ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state();
      visibility = currentState == LiveAudioRoomMiniOverlayPageState.minimizing;

      if (visibility) {
        listenAudioVideoList();
        activeUserTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          updateActiveUserByTimer();
        });
      } else {
        audioVideoListSubscription?.cancel();
        activeUserTimer?.cancel();
        activeUserTimer = null;
      }
    });
  }

  void listenAudioVideoList() {
    audioVideoListSubscription =
        ZegoUIKit().getAudioVideoListStream().listen(onAudioVideoListUpdated);

    onAudioVideoListUpdated(ZegoUIKit().getAudioVideoList());
    activeUserIDNotifier.value = ZegoUIKit().getAudioVideoList().isEmpty
        ? ZegoUIKit().getLocalUser().id
        : ZegoUIKit().getAudioVideoList().first.id;
  }

  void onAudioVideoListUpdated(List<ZegoUIKitUser> users) {
    for (final subscription in soundLevelSubscriptions) {
      subscription?.cancel();
    }
    rangeSoundLevels.clear();

    for (final user in users) {
      soundLevelSubscriptions.add(user.soundLevel.listen((soundLevel) {
        if (rangeSoundLevels.containsKey(user.id)) {
          rangeSoundLevels[user.id]!.add(soundLevel);
        } else {
          rangeSoundLevels[user.id] = [soundLevel];
        }
      }));
    }
  }

  void updateActiveUserByTimer() {
    var maxAverageSoundLevel = 0.0;
    var activeUserID = '';
    rangeSoundLevels.forEach((userID, soundLevels) {
      final averageSoundLevel =
          soundLevels.reduce((a, b) => a + b) / soundLevels.length;

      if (averageSoundLevel > maxAverageSoundLevel) {
        activeUserID = userID;
        maxAverageSoundLevel = averageSoundLevel;
      }
    });
    activeUserIDNotifier.value = activeUserID;
    if (activeUserIDNotifier.value?.isEmpty ?? true) {
      activeUserIDNotifier.value = ZegoUIKit().getLocalUser().id;
    }

    rangeSoundLevels.clear();
  }

  void onMiniOverlayMachineStateChanged(
      LiveAudioRoomMiniOverlayPageState state) {
    /// Overlay and setState may be in different contexts, causing the framework to be unable to update.
    ///
    /// The purpose of Future.delayed(Duration.zero, callback) is to execute the callback function in the next frame,
    /// which is equivalent to putting the callback function at the end of the queue,
    /// thus avoiding conflicts with the current frame and preventing the above-mentioned error from occurring.
    Future.delayed(Duration.zero, () {
      syncState();
    });
  }
}
