// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/mini_audio.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/overlay_machine.dart';

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
///       home: const ZegoUIKitPrebuiltLiveAudioRoomMiniPopScope(
///         child: HomePage(),
///       ),
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

    ZegoLiveAudioRoomInternalMiniOverlayMachine()
        .removeListenStateChanged(onMiniOverlayMachineStateChanged);
  }

  @override
  Widget build(BuildContext context) {
    final preferSize = calculateItemSize();
    preferItemSizeNotifier.value =
        isZoom ? preferSize * _animation.value : preferSize;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
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
          child: ZegoMinimizingAudioRoomPage(
            size: Size(
              preferItemSizeNotifier.value.width,
              preferItemSizeNotifier.value.height,
            ),
            borderRadius: widget.borderRadius,
            borderColor: widget.borderColor,
            backgroundColor: widget.backgroundColor,
            padding: widget.padding,
            withCircleBorder: true,
            showDevices: widget.showDevices,
            showUserName: widget.showUserName,
            showLeaveButton: widget.showLeaveButton,
            soundWaveColor: widget.soundWaveColor,
            leaveButtonIcon: widget.leaveButtonIcon,
            foreground: widget.foreground,
            builder: widget.builder,
            foregroundBuilder: widget.foregroundBuilder,
            backgroundBuilder: widget.backgroundBuilder,
            avatarBuilder:
                widget.avatarBuilder ?? minimizeData?.config.seat.avatarBuilder,
            durationConfig: minimizeData?.config.duration,
            durationEvents: minimizeData?.events.duration,
          ),
        );
    }
  }

  void syncState() {
    setState(() {
      currentState = ZegoLiveAudioRoomInternalMiniOverlayMachine().state();
      visibility =
          currentState == ZegoLiveAudioRoomMiniOverlayPageState.minimizing;
    });
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
