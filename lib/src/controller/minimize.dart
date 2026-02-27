part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// Mixin for minimizing functionality.
///
/// This mixin provides access to the minimize controller.
mixin ZegoLiveAudioRoomControllerMinimizing {
  final _minimizingImpl = ZegoLiveAudioRoomControllerMinimizingImpl();

  /// Gets the minimize controller instance.
  ZegoLiveAudioRoomControllerMinimizingImpl get minimize => _minimizingImpl;
}

/// Controller for minimizing operations.
///
/// This class provides APIs for minimizing and restoring the audio room.
class ZegoLiveAudioRoomControllerMinimizingImpl
    with ZegoLiveAudioRoomControllerMinimizingPrivate {
  /// Gets the current minimize state.
  ZegoLiveAudioRoomMiniOverlayPageState get state =>
      ZegoLiveAudioRoomInternalMiniOverlayMachine().state();

  /// Checks if the audio room is currently minimized.
  ///
  /// Returns `true` if minimized, `false` otherwise.
  bool get isMinimizing => isMinimizingNotifier.value;

  /// Gets the notifier for the minimizing state.
  ///
  /// Use this to listen to minimize state changes.
  ValueNotifier<bool> get isMinimizingNotifier => _private.isMinimizingNotifier;

  /// Restores the audio room from minimized state to full screen.
  ///
  /// [context] - The build context for navigation.
  /// [rootNavigator] - Whether to use the root navigator. Default is true.
  /// [withSafeArea] - Whether to wrap the page in a SafeArea. Default is false.
  ///
  /// Returns `true` if restoration was successful, `false` otherwise.
  bool restore(
    BuildContext context, {
    bool rootNavigator = true,
    bool withSafeArea = false,
  }) {
    if (ZegoLiveAudioRoomMiniOverlayPageState.minimizing != state) {
      ZegoLoggerService.logInfo(
        'restore, is not minimizing, ignore',
        tag: 'audio-room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    final minimizeData = private.minimizeData;
    if (null == minimizeData) {
      ZegoLoggerService.logError(
        'restore, prebuiltData is null',
        tag: 'audio-room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'restore, '
      'context:$context, '
      'rootNavigator:$rootNavigator, '
      'withSafeArea:$withSafeArea, ',
      tag: 'audio-room',
      subTag: 'controller.minimize',
    );

    /// re-enter prebuilt call
    ZegoLiveAudioRoomInternalMiniOverlayMachine().changeState(
      ZegoLiveAudioRoomMiniOverlayPageState.inAudioRoom,
    );

    try {
      Navigator.of(context, rootNavigator: rootNavigator).push(
        MaterialPageRoute(builder: (context) {
          final prebuiltAudioRoom = ZegoUIKitPrebuiltLiveAudioRoom(
            appID: minimizeData.appID,
            appSign: minimizeData.appSign,
            token: minimizeData.token,
            userID: minimizeData.userID,
            userName: minimizeData.userName,
            roomID: minimizeData.roomID,
            config: minimizeData.config,
            events: minimizeData.events,
          );
          return withSafeArea
              ? SafeArea(
                  child: prebuiltAudioRoom,
                )
              : prebuiltAudioRoom;
        }),
      );
    } catch (e) {
      ZegoLoggerService.logError(
        'restore, navigator push to call page exception:$e',
        tag: 'audio-room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    return true;
  }

  /// Minimizes the audio room to a small floating window.
  ///
  /// [context] - The build context for navigation.
  /// [rootNavigator] - Whether to use the root navigator. Default is true.
  ///
  /// Returns `true` if minimization was successful, `false` otherwise.
  bool minimize(
    BuildContext context, {
    bool rootNavigator = true,
  }) {
    if (ZegoLiveAudioRoomMiniOverlayPageState.minimizing ==
        ZegoLiveAudioRoomInternalMiniOverlayMachine().state()) {
      ZegoLoggerService.logInfo(
        'minimize, is minimizing, ignore',
        tag: 'audio-room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'minimize, '
      'context:$context, '
      'rootNavigator:$rootNavigator, ',
      tag: 'audio-room',
      subTag: 'controller.minimize',
    );

    ZegoLiveAudioRoomInternalMiniOverlayMachine().changeState(
      ZegoLiveAudioRoomMiniOverlayPageState.minimizing,
    );

    try {
      /// pop audio room page
      Navigator.of(
        context,
        rootNavigator: rootNavigator,
      ).pop();
    } catch (e) {
      ZegoLoggerService.logError(
        'minimize, navigator pop exception:$e',
        tag: 'audio-room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    return true;
  }

  /// Hides the minimized widget without navigating.
  ///
  /// Use this when the audio room ends while in minimized state.
  void hide() {
    ZegoLoggerService.logInfo(
      'hide, ',
      tag: 'audio-room',
      subTag: 'controller.minimize',
    );

    ZegoLiveAudioRoomInternalMiniOverlayMachine().changeState(
      ZegoLiveAudioRoomMiniOverlayPageState.idle,
    );
  }
}
