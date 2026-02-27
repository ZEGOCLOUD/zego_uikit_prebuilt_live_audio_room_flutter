part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// Mixin for PIP (Picture-in-Picture) functionality.
///
/// This mixin provides access to the PIP controller for managing Picture-in-Picture mode.
mixin ZegoLiveAudioRoomControllerPIP {
  final _pipImpl = ZegoLiveAudioRoomControllerPIPImpl();

  /// Gets the PIP controller instance.
  ZegoLiveAudioRoomControllerPIPImpl get pip => _pipImpl;
}

/// Here are the APIs related to PIP (Picture-in-Picture) functionality.
///
/// PIP allows the audio room to continue playing in a small floating window
/// when the user leaves the app or switches to another app.
/// This feature is currently only supported on Android.
class ZegoLiveAudioRoomControllerPIPImpl
    with ZegoLiveAudioRoomControllerPIPImplPrivate {
  /// Gets the current PIP status.
  ///
  /// Returns a [ZegoPiPStatus] indicating whether PIP is active, inactive, or unavailable.
  Future<ZegoPiPStatus> get status async =>
      (await private.floating.pipStatus).toZego();

  /// Checks if PIP is available on the current device.
  ///
  /// Returns `true` if PIP is available, `false` otherwise.
  Future<bool> get available async => await private.floating.isPipAvailable;

  /// Enables PIP mode with the specified aspect ratio.
  ///
  /// [aspectWidth] - The width aspect ratio for the PIP window. Default is 1.
  /// [aspectHeight] - The height aspect ratio for the PIP window. Default is 1.
  ///
  /// Returns the [ZegoPiPStatus] after attempting to enable PIP.
  /// Note: This API is only supported on Android.
  Future<ZegoPiPStatus> enable({
    int aspectWidth = 1,
    int aspectHeight = 1,
  }) async {
    if (!Platform.isAndroid) {
      ZegoLoggerService.logInfo(
        'enable, only support android',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return ZegoPiPStatus.unavailable;
    }

    final isPipAvailable = await private.floating.isPipAvailable;
    if (!isPipAvailable) {
      ZegoLoggerService.logError(
        'enable, '
        'but pip is not available, ',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return ZegoPiPStatus.unavailable;
    }

    var status = ZegoPiPStatus.unavailable;
    try {
      status = (await private.floating.enable(
        ImmediatePiP(
          aspectRatio: Rational(
            aspectWidth,
            aspectHeight,
          ),
        ),
      ))
          .toZego();
    } catch (e) {
      ZegoLoggerService.logInfo(
        'enable exception:${e.toString()}',
        tag: 'audio room',
        subTag: 'controller.pip',
      );
    }
    return status;
  }

  /// Enables PIP mode when the app goes to background.
  ///
  /// [aspectWidth] - The width aspect ratio for the PIP window. Default is 1.
  /// [aspectHeight] - The height aspect ratio for the PIP window. Default is 1.
  ///
  /// Returns the [ZegoPiPStatus] after attempting to enable PIP.
  /// Note: This API is only supported on Android.
  Future<ZegoPiPStatus> enableWhenBackground({
    int aspectWidth = 1,
    int aspectHeight = 1,
  }) async {
    if (!Platform.isAndroid) {
      ZegoLoggerService.logInfo(
        'enableWhenBackground, only support android',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return ZegoPiPStatus.unavailable;
    }

    var status = ZegoPiPStatus.unavailable;
    try {
      status = await private.enableWhenBackground(
        aspectWidth: aspectWidth,
        aspectHeight: aspectHeight,
      );
    } catch (e) {
      ZegoLoggerService.logInfo(
        'enableWhenBackground exception:${e.toString()}',
        tag: 'audio room',
        subTag: 'controller.pip',
      );
    }
    return status;
  }

  /// Cancels the PIP mode when returning to the app from background.
  ///
  /// This will bring the app back to the foreground and cancel the PIP mode.
  /// Note: This API is only supported on Android.
  Future<void> cancelBackground() async {
    if (!Platform.isAndroid) {
      ZegoLoggerService.logInfo(
        'cancelBackground, only support android',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return;
    }

    /// back to app
    await ZegoUIKit().activeAppToForeground();

    try {
      await private.floating.cancelOnLeavePiP();
    } catch (e) {
      ZegoLoggerService.logInfo(
        'cancelOnLeavePiP exception:${e.toString()}',
        tag: 'audio room',
        subTag: 'controller.pip',
      );
    }
  }
}
