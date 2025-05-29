part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerMediaPrivate {
  final _impl = ZegoLiveAudioRoomControllerMediaPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerMediaPrivateImpl get private => _impl;
}

/// @nodoc
class ZegoLiveAudioRoomControllerMediaPrivateImpl {
  final defaultPlayer = ZegoLiveAudioRoomControllerMediaDefaultPlayer();

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
      subTag: 'controller.media.p',
    );

    this.config = config;

    defaultPlayer.private.initByPrebuilt(config: config);
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveStreaming.
  /// DO NOT CALL!!!
  /// Call Inside By Prebuilt
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'uninit by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.media.p',
    );

    config = null;
    defaultPlayer.private.uninitByPrebuilt();
  }
}
