part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerMinimizing {
  final _minimizingImpl = ZegoLiveAudioRoomControllerMinimizingImpl();

  ZegoLiveAudioRoomControllerMinimizingImpl get minimize => _minimizingImpl;
}

/// Here are the APIs related to minimizing.
class ZegoLiveAudioRoomControllerMinimizingImpl
    with ZegoLiveAudioRoomControllerMinimizingPrivate {
  /// current minimize state
  ZegoLiveAudioRoomMiniOverlayPageState get state =>
      ZegoLiveAudioRoomInternalMiniOverlayMachine().state();

  /// is it currently in the minimized state or not
  bool get isMinimizing =>
      ZegoLiveAudioRoomInternalMiniOverlayMachine().isMinimizing;

  /// restore the [ZegoUIKitPrebuiltLiveAudioRoom] from minimize
  bool restore(
    BuildContext context, {
    bool rootNavigator = true,
    bool withSafeArea = false,
  }) {
    if (ZegoLiveAudioRoomMiniOverlayPageState.minimizing != state) {
      ZegoLoggerService.logInfo(
        'is not minimizing, ignore',
        tag: 'audio room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    final minimizeData = private.minimizeData;
    if (null == minimizeData) {
      ZegoLoggerService.logError(
        'prebuiltData is null',
        tag: 'audio room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'restore, '
      'context:$context, '
      'rootNavigator:$rootNavigator, '
      'withSafeArea:$withSafeArea, ',
      tag: 'audio room',
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
        'navigator push to call page exception:$e',
        tag: 'audio room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    return true;
  }

  /// minimize the [ZegoUIKitPrebuiltLiveAudioRoom]
  bool minimize(
    BuildContext context, {
    bool rootNavigator = true,
  }) {
    if (ZegoLiveAudioRoomMiniOverlayPageState.minimizing ==
        ZegoLiveAudioRoomInternalMiniOverlayMachine().state()) {
      ZegoLoggerService.logInfo(
        'is minimizing, ignore',
        tag: 'audio room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'minimize, '
      'context:$context, '
      'rootNavigator:$rootNavigator, ',
      tag: 'audio room',
      subTag: 'controller.minimize',
    );

    ZegoLiveAudioRoomInternalMiniOverlayMachine().changeState(
      ZegoLiveAudioRoomMiniOverlayPageState.minimizing,
    );

    try {
      /// pop call page
      Navigator.of(
        context,
        rootNavigator: rootNavigator,
      ).pop();
    } catch (e) {
      ZegoLoggerService.logError(
        'navigator pop exception:$e',
        tag: 'audio room',
        subTag: 'controller.minimize',
      );

      return false;
    }

    return true;
  }

  /// if audio room ended in minimizing state, not need to navigate, just hide the minimize widget.
  void hide() {
    ZegoLoggerService.logInfo(
      'hide, ',
      tag: 'audio room',
      subTag: 'controller.minimize',
    );

    ZegoLiveAudioRoomInternalMiniOverlayMachine().changeState(
      ZegoLiveAudioRoomMiniOverlayPageState.idle,
    );
  }
}
