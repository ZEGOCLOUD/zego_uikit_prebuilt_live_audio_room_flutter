part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

mixin ZegoLiveAudioRoomControllerPIP {
  final _pipImpl = ZegoLiveAudioRoomControllerPIPImpl();

  ZegoLiveAudioRoomControllerPIPImpl get pip => _pipImpl;
}

/// Here are the APIs related to audio video.
class ZegoLiveAudioRoomControllerPIPImpl
    with ZegoLiveAudioRoomControllerPIPImplPrivate {
  Future<ZegoPiPStatus> get status async =>
      (await private.floating.pipStatus).toZego();

  Future<bool> get available async => await private.floating.isPipAvailable;

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
