part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerRoomPrivate {
  final _impl = ZegoLiveAudioRoomControllerRoomPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerRoomPrivateImpl get private => _impl;
}

/// @nodoc
class ZegoLiveAudioRoomControllerRoomPrivateImpl {
  ZegoUIKitPrebuiltLiveAudioRoomConfig? config;
  ZegoUIKitPrebuiltLiveAudioRoomEvents? events;
  ZegoLiveAudioRoomConnectManager? connectManager;
  ZegoLiveAudioRoomSeatManager? seatManager;

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveStreaming.
  /// DO NOT CALL!!!
  /// Call Inside By Prebuilt
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomConfig config,
    required ZegoUIKitPrebuiltLiveAudioRoomEvents events,
    required ZegoLiveAudioRoomConnectManager? connectManager,
    required ZegoLiveAudioRoomSeatManager? seatManager,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'live streaming',
      subTag: 'controller.room.p',
    );

    this.config = config;
    this.events = events;
    this.connectManager = connectManager;
    this.seatManager = seatManager;
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveStreaming.
  /// DO NOT CALL!!!
  /// Call Inside By Prebuilt
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'uninit by prebuilt',
      tag: 'live streaming',
      subTag: 'controller.room.p',
    );

    config = null;
    events = null;
    connectManager = null;
    seatManager = null;
  }

  Future<bool> _leave(
    BuildContext context, {
    bool showConfirmation = false,
  }) async {
    if (null == seatManager) {
      ZegoLoggerService.logInfo(
        'leave, param is invalid, seatManager:$seatManager',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return false;
    }

    if (seatManager?.isLeavingRoom ?? false) {
      ZegoLoggerService.logInfo(
        'leave, is leave requesting...',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return false;
    }

    if (seatManager?.isRoomAttributesBatching ?? false) {
      ZegoLoggerService.logInfo(
        'room attribute is batching, ignore',
        tag: 'audio room',
        subTag: 'leave button',
      );
      return false;
    }

    ZegoLoggerService.logInfo(
      'leave, show confirmation:$showConfirmation',
      tag: 'audio room',
      subTag: 'controller.room',
    );

    if (showConfirmation) {
      ///  if there is a user-defined event before the click,
      ///  wait the synchronize execution result
      final endConfirmationEvent = ZegoLiveAudioRoomLeaveConfirmationEvent(
        context: context,
      );
      final canLeave = await _defaultLeaveConfirmationAction(
        endConfirmationEvent,
      );
      if (!canLeave) {
        ZegoLoggerService.logInfo(
          'leave, refuse',
          tag: 'audio room',
          subTag: 'controller.room',
        );

        return false;
      }

      /// take off seat when leave room
      await seatManager?.leaveSeat(showDialog: false);
      seatManager?.isLeavingRoom = true;
    }

    final isFromMinimizing = ZegoLiveAudioRoomMiniOverlayPageState.minimizing ==
        ZegoUIKitPrebuiltLiveAudioRoomController().minimize.state;
    ZegoUIKitPrebuiltLiveAudioRoomController().minimize.hide();

    if (isFromMinimizing) {
      await ZegoLiveAudioRoomManagers().uninitPluginAndManagers();

      await ZegoUIKit().resetSoundEffect();
      await ZegoUIKit().resetBeautyEffect();
    }

    final result = await ZegoUIKit().leaveRoom().then((result) {
      ZegoLoggerService.logInfo(
        'leave, leave room result, ${result.errorCode} ${result.extendedData}',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return 0 == result.errorCode;
    });

    final endEvent = ZegoLiveAudioRoomEndEvent(
      reason: ZegoLiveAudioRoomEndReason.localLeave,
      isFromMinimizing: isFromMinimizing,
    );
    defaultAction() {
      _defaultEndAction(endEvent, context, true);
    }

    if (events?.onEnded != null) {
      events?.onEnded?.call(endEvent, defaultAction);
    } else {
      defaultAction.call();
    }

    ZegoLoggerService.logInfo(
      'leave, finished',
      tag: 'live audio room',
      subTag: 'controller.room',
    );

    return result;
  }

  Future<void> _defaultEndAction(
    ZegoLiveAudioRoomEndEvent event,
    BuildContext context,
    bool rootNavigator,
  ) async {
    ZegoLoggerService.logInfo(
      'default call end event, event:$event',
      tag: 'live audio room',
      subTag: 'controller.room.p',
    );

    if (ZegoLiveAudioRoomMiniOverlayPageState.minimizing ==
        ZegoUIKitPrebuiltLiveAudioRoomController().minimize.state) {
      /// now is minimizing state, not need to navigate, just switch to idle
      ZegoUIKitPrebuiltLiveAudioRoomController().minimize.hide();
    } else {
      try {
        if (context.mounted) {
          Navigator.of(
            context,
            rootNavigator: rootNavigator,
          ).pop(true);
        } else {
          ZegoLoggerService.logInfo(
            'live audio room end, context is not mounted',
            tag: 'live streaming',
            subTag: 'controller.room.p',
          );
        }
      } catch (e) {
        ZegoLoggerService.logError(
          'live audio room end, navigator exception:$e, event:$event',
          tag: 'live streaming',
          subTag: 'controller.room.p',
        );
      }
    }
  }

  Future<bool> _defaultLeaveConfirmationAction(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) async {
    if (ZegoLiveAudioRoomManagers().seatManager?.localRole.value !=
        ZegoLiveAudioRoomRole.host) {
      return true;
    }

    final confirmDialogInfo = config?.confirmDialogInfo ??
        ZegoLiveAudioRoomDialogInfo(
          title: 'Leave the room',
          message: 'Are you sure to leave the room?',
          cancelButtonName: 'Cancel',
          confirmButtonName: 'OK',
        );
    return showLiveDialog(
      context: event.context,
      title: confirmDialogInfo.title,
      content: confirmDialogInfo.message,
      leftButtonText: confirmDialogInfo.cancelButtonName,
      leftButtonCallback: () {
        try {
          //  pop this dialog
          Navigator.of(
            event.context,
            rootNavigator: config?.rootNavigator ?? false,
          ).pop(false);
        } catch (e) {
          ZegoLoggerService.logError(
            'leave confirmation left click, '
            'navigator exception:$e, '
            'event:$event',
            tag: 'live audio room',
            subTag: 'prebuilt',
          );
        }
      },
      rightButtonText: confirmDialogInfo.confirmButtonName,
      rightButtonCallback: () {
        try {
          //  pop this dialog
          Navigator.of(
            event.context,
            rootNavigator: config?.rootNavigator ?? false,
          ).pop(true);
        } catch (e) {
          ZegoLoggerService.logError(
            'leave confirmation left click, '
            'navigator exception:$e, '
            'event:$event',
            tag: 'live audio room',
            subTag: 'prebuilt',
          );
        }
      },
    );
  }
}
