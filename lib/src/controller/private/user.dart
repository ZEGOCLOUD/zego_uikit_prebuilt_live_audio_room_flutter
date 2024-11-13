part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerUserPrivate {
  final _impl = ZegoLiveAudioRoomControllerUserPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerUserPrivateImpl get private => _impl;
}

/// @nodoc
class ZegoLiveAudioRoomControllerUserPrivateImpl {
  ZegoUIKitPrebuiltLiveAudioRoomConfig? config;

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveStreaming.
  /// DO NOT CALL!!!
  /// Call Inside By Prebuilt
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomConfig config,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.user.p',
    );

    this.config = config;
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveStreaming.
  /// DO NOT CALL!!!
  /// Call Inside By Prebuilt
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'uninit by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.user.p',
    );

    config = null;
  }
}
