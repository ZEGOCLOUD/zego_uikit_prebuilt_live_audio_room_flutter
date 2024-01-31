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

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomMinimizeData minimizeData,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.minimize.p',
    );

    _minimizeData = minimizeData;
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.minimize.p',
    );

    _minimizeData = null;
  }
}
