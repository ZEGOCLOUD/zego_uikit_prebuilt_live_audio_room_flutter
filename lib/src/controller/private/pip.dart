part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

extension ZegoLiveAudioRoomPipStatus on PiPStatus {
  ZegoPiPStatus toZego() {
    switch (this) {
      case PiPStatus.enabled:
        return ZegoPiPStatus.enabled;
      case PiPStatus.disabled:
        return ZegoPiPStatus.disabled;
      case PiPStatus.automatic:
        return ZegoPiPStatus.automatic;
      case PiPStatus.unavailable:
        return ZegoPiPStatus.unavailable;
    }
  }
}

/// @nodoc
mixin ZegoLiveAudioRoomControllerPIPImplPrivate {
  final _private = ZegoLiveAudioRoomControllerPIPImplPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerPIPImplPrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerPIPImplPrivateImpl {
  final floating = Floating();
  ZegoUIKitPrebuiltLiveAudioRoomConfig? config;

  bool isInPIP = false;
  bool isRestoreFromPIP = false;

  StreamSubscription<dynamic>? subscription;

  Future<ZegoPiPStatus> enableWhenBackground({
    int aspectWidth = 1,
    int aspectHeight = 1,
    Rectangle<int>? sourceRectHint,
  }) async {
    if (!Platform.isAndroid) {
      ZegoLoggerService.logInfo(
        'enableWhenBackground, only support android',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return ZegoPiPStatus.unavailable;
    }

    final isPipAvailable = await floating.isPipAvailable;
    if (!isPipAvailable) {
      ZegoLoggerService.logError(
        'enableWhenBackground, '
        'but pip is not available, ',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return ZegoPiPStatus.unavailable;
    }

    try {
      return (await floating.enable(
        OnLeavePiP(
          aspectRatio: Rational(aspectWidth, aspectHeight),
          sourceRectHint: sourceRectHint,
        ),
      ))
          .toZego();
    } catch (e) {
      ZegoLoggerService.logError(
        'enableWhenBackground, '
        'exception:$e, ',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return ZegoPiPStatus.disabled;
    }
  }

  /// Please do not call this interface. It is the internal logic of Prebuilt.
  Future<void> initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomConfig? config,
  }) async {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.pip.p',
    );

    this.config = config;

    if (!Platform.isAndroid) {
      ZegoLoggerService.logInfo(
        'initByPrebuilt, only support android',
        tag: 'audio room',
        subTag: 'controller.pip',
      );

      return;
    }

    ZegoUIKit()
        .adapterService()
        .registerMessageHandler(_onAppLifecycleStateChanged);

    subscription = floating.pipStatusStream.listen(onPIPStatusUpdated);

    if (config?.pip.enableWhenBackground ?? true) {
      await enableWhenBackground(
        aspectWidth: config?.pip.aspectWidth ?? 1,
        aspectHeight: config?.pip.aspectHeight ?? 1,
      );
    }
  }

  /// Please do not call this interface. It is the internal logic of Prebuilt.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.pip.p',
    );

    config = null;

    subscription?.cancel();

    ZegoUIKit()
        .adapterService()
        .unregisterMessageHandler(_onAppLifecycleStateChanged);
  }

  /// sync app background state
  void _onAppLifecycleStateChanged(AppLifecycleState appLifecycleState) async {
    ZegoLoggerService.logInfo(
      '_onAppLifecycleStateChanged, $appLifecycleState',
      tag: 'audio room',
      subTag: 'controller.pip.p',
    );

    /// app -> desktop  AppLifecycleState.inactive
    /// desktop -> app AppLifecycleState.resumed
    if (AppLifecycleState.paused == appLifecycleState) {}
  }

  void onPIPStatusUpdated(PiPStatus status) {
    ZegoLoggerService.logInfo(
      'onPIPStatusUpdated, $status',
      tag: 'audio room',
      subTag: 'controller.pip.p',
    );

    switch (status) {
      case PiPStatus.enabled:
        isInPIP = true;
        break;
      case PiPStatus.disabled:
        if (isInPIP) {
          isRestoreFromPIP = true;
          isInPIP = false;

          /// can't know when the rendering will end after restoration.
          /// get default value of camera/microphone in bottom bar
          Future.delayed(const Duration(seconds: 1), () {
            isRestoreFromPIP = false;
          });
        }

        if (config?.pip.enableWhenBackground ?? true) {
          enableWhenBackground(
            aspectWidth: config?.pip.aspectWidth ?? 1,
            aspectHeight: config?.pip.aspectHeight ?? 1,
          );
        }
        break;
      case PiPStatus.automatic:
        break;
      case PiPStatus.unavailable:
        break;
    }
  }
}
