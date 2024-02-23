// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/duration_time_board.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/overlay_machine.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

/// The page can be minimized within the app
///
/// To support the minimize functionality in the app:
///
/// 1. Add a minimize button.
/// ```dart
/// ZegoUIKitPrebuiltLiveAudioRoomConfig.topMenuBar.buttons.add(ZegoLiveAudioRoomMenuBarButtonName.minimizingButton)
/// ```
/// Alternatively, if you have defined your own button, you can call:
/// ```dart
/// ZegoUIKitPrebuiltLiveAudioRoomController().minimize.minimize().
/// ```
///
/// 2. Nest the `ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage` within your MaterialApp widget. Make sure to return the correct context in the `contextQuery` parameter.
///
/// How to add in MaterialApp, example:
/// ```dart
///
/// void main() {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   final navigatorKey = GlobalKey<NavigatorState>();
///   runApp(MyApp(
///     navigatorKey: navigatorKey,
///   ));
/// }
///
/// class MyApp extends StatefulWidget {
///   final GlobalKey<NavigatorState> navigatorKey;
///
///   const MyApp({
///     required this.navigatorKey,
///     Key? key,
///   }) : super(key: key);
///
///   @override
///   State<StatefulWidget> createState() => MyAppState();
/// }
///
/// class MyAppState extends State<MyApp> {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: 'Flutter Demo',
///       home: HomePage(),
///       navigatorKey: widget.navigatorKey,
///       builder: (BuildContext context, Widget? child) {
///         return Stack(
///           children: [
///             child!,
///
///             /// support minimizing
///             ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage(
///               contextQuery: () {
///                 return widget.navigatorKey.currentState!.context;
///               },
///             ),
///           ],
///         );
///       },
///     );
///   }
/// }
/// ```
class ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage extends StatefulWidget {
  const ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage({
    Key? key,
    required this.contextQuery,
    this.rootNavigator = true,
    this.navigatorWithSafeArea = true,
    this.size,
    this.topLeft = const Offset(100, 100),
    this.borderRadius = 12.0,
    this.borderColor = Colors.black12,
    this.soundWaveColor = const Color(0xff2254f6),
    this.backgroundColor = Colors.white,
    this.padding = 0.0,
    this.showDevices = true,
    this.showUserName = true,
    this.showLeaveButton = true,
    this.leaveButtonIcon,
    this.supportClickZoom = true,
    this.foreground,
    this.builder,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.avatarBuilder,
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

  final bool showLeaveButton;
  final Widget? leaveButtonIcon;

  final bool supportClickZoom;

  final Widget? foreground;
  final Widget Function(ZegoUIKitUser? activeUser)? builder;

  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  /// You need to return the `context` of NavigatorState in this callback
  final BuildContext Function() contextQuery;
  final bool rootNavigator;
  final bool navigatorWithSafeArea;

  @override
  ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPageState createState() =>
      ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPageState();
}

/// @nodoc
class ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPageState
    extends State<ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage>
    with SingleTickerProviderStateMixin {
  ZegoLiveAudioRoomMiniOverlayPageState currentState =
      ZegoLiveAudioRoomMiniOverlayPageState.idle;

  bool visibility = false;
  late Offset topLeft;
  final preferItemSizeNotifier = ValueNotifier<Size>(Size.zero);
  bool isZoom = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  StreamSubscription<dynamic>? audioVideoListSubscription;
  List<StreamSubscription<dynamic>?> soundLevelSubscriptions = [];
  Timer? activeUserTimer;
  final activeUserIDNotifier = ValueNotifier<String?>(null);
  final Map<String, List<double>> rangeSoundLevels = {};

  ZegoUIKitPrebuiltLiveAudioRoomMinimizeData? get minimizeData =>
      ZegoUIKitPrebuiltLiveAudioRoomController().minimize.private.minimizeData;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 1, end: 1.5).animate(_animationController);
    _animation.addListener(() {
      isZoom = _animation.value > 1.01;
      final preferSize = calculateItemSize();
      preferItemSizeNotifier.value = preferSize * _animation.value;
    });

    topLeft = widget.topLeft;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ZegoLiveAudioRoomInternalMiniOverlayMachine()
          .listenStateChanged(onMiniOverlayMachineStateChanged);

      if (null !=
          ZegoLiveAudioRoomInternalMiniOverlayMachine().machine.current) {
        syncState();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();

    activeUserTimer?.cancel();
    activeUserTimer = null;

    audioVideoListSubscription?.cancel();

    ZegoLiveAudioRoomInternalMiniOverlayMachine()
        .removeListenStateChanged(onMiniOverlayMachineStateChanged);
  }

  @override
  Widget build(BuildContext context) {
    final preferSize = calculateItemSize();
    preferItemSizeNotifier.value =
        isZoom ? preferSize * _animation.value : preferSize;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Visibility(
        visible: visibility,
        child: Positioned(
          left: topLeft.dx,
          top: topLeft.dy,
          child: ValueListenableBuilder<Size>(
            valueListenable: preferItemSizeNotifier,
            builder: (context, itemSize, _) {
              return GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    var x = topLeft.dx + details.delta.dx;
                    var y = topLeft.dy + details.delta.dy;
                    x = x.clamp(0.0,
                        MediaQuery.of(context).size.width - itemSize.width);
                    y = y.clamp(0.0,
                        MediaQuery.of(context).size.height - itemSize.height);
                    topLeft = Offset(x, y);
                  });
                },
                onDoubleTap: () {
                  if (!widget.supportClickZoom) {
                    return;
                  }

                  if (_animationController.status ==
                      AnimationStatus.completed) {
                    _animationController.reverse();
                  } else {
                    _animationController.forward();
                  }
                },
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: itemSize.width,
                    height: itemSize.height,
                    child: overlayItem(),
                  );
                }),
              );
            },
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
      case ZegoLiveAudioRoomMiniOverlayPageState.idle:
      case ZegoLiveAudioRoomMiniOverlayPageState.inAudioRoom:
        return Container();
      case ZegoLiveAudioRoomMiniOverlayPageState.minimizing:
        return GestureDetector(
          onTap: () {
            ZegoUIKitPrebuiltLiveAudioRoomController().minimize.restore(
                  widget.contextQuery(),
                  rootNavigator: widget.rootNavigator,
                  withSafeArea: widget.navigatorWithSafeArea,
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
                builder: widget.avatarBuilder ??
                    minimizeData?.config.seat.avatarBuilder,
                soundWaveColor: widget.soundWaveColor,
                size: Size(
                  preferItemSizeNotifier.value.width * 0.6,
                  preferItemSizeNotifier.value.height * 0.6,
                ),
                verticalAlignment: ZegoAvatarAlignment.center,
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
              left: seatItemRowSpacing,
              child: redPoint(),
            ),
            durationTimeBoard(),
            widget.foreground ?? Container(),
            widget.showLeaveButton
                ? Positioned(
                    top: seatItemRowSpacing,
                    right: seatItemRowSpacing,
                    child: leaveButton(),
                  )
                : Container(),
          ],
        );
  }

  Widget leaveButton() {
    return ZegoTextIconButton(
      buttonSize: Size(iconButtonClickWidth, iconButtonClickHeight),
      iconSize: Size(iconButtonWidth, iconButtonWidth),
      icon: ButtonIcon(
        icon: widget.leaveButtonIcon ??
            ZegoLiveAudioRoomImage.asset(
              ZegoLiveAudioRoomIconUrls.topQuit,
            ),
        backgroundColor: Colors.white,
      ),
      onPressed: () async {
        await ZegoUIKitPrebuiltLiveAudioRoomController().leave(
          context,
          showConfirmation: false,
        );
      },
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
        config: minimizeData?.config.duration ??
            ZegoLiveAudioRoomLiveDurationConfig(),
        events:
            minimizeData?.events.duration ?? ZegoLiveAudioRoomDurationEvents(),
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
                        muteMode: true,
                      );
                    }
                  : null,
              child: Container(
                width: iconButtonWidth,
                height: iconButtonWidth,
                decoration: BoxDecoration(
                  color: isMicrophoneEnabled
                      ? controlBarButtonCheckedBackgroundColor
                      : controlBarButtonBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: iconButtonWidth,
                    height: iconButtonWidth,
                    child: ZegoLiveAudioRoomImage.asset(
                      isMicrophoneEnabled
                          ? ZegoLiveAudioRoomIconUrls.toolbarMicNormal
                          : ZegoLiveAudioRoomIconUrls.toolbarMicOff,
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
            width: preferItemSizeNotifier.value.width,
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
      currentState = ZegoLiveAudioRoomInternalMiniOverlayMachine().state();
      visibility =
          currentState == ZegoLiveAudioRoomMiniOverlayPageState.minimizing;

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
      ZegoLiveAudioRoomMiniOverlayPageState state) {
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
