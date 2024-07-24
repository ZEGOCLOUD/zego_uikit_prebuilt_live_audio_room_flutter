part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerMinimizingPrivate {
  final _private = ZegoLiveAudioRoomControllerMinimizingPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerMinimizingPrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerMinimizingPrivateImpl {
  ZegoUIKitPrebuiltLiveAudioRoomMinimizeData? get minimizeData => _minimizeData;

  ZegoUIKitPrebuiltLiveAudioRoomMinimizeData? _minimizeData;

  final isMinimizingNotifier = ValueNotifier<bool>(false);

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomMinimizeData minimizeData,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.minimize.p',
    );

    _minimizeData = minimizeData;

    isMinimizingNotifier.value =
        ZegoLiveAudioRoomInternalMiniOverlayMachine().isMinimizing;
    ZegoLiveAudioRoomInternalMiniOverlayMachine()
        .listenStateChanged(onMiniOverlayMachineStateChanged);
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.minimize.p',
    );

    _minimizeData = null;

    ZegoLiveAudioRoomInternalMiniOverlayMachine()
        .removeListenStateChanged(onMiniOverlayMachineStateChanged);
  }

  void onMiniOverlayMachineStateChanged(
    ZegoLiveAudioRoomMiniOverlayPageState state,
  ) {
    isMinimizingNotifier.value =
        ZegoLiveAudioRoomMiniOverlayPageState.minimizing == state;
  }
}
