part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerAudioVideoImplPrivate {
  final _private = ZegoLiveAudioRoomControllerAudioVideoImplPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerAudioVideoImplPrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerAudioVideoImplPrivateImpl {
  final _microphone = ZegoLiveStreamingControllerAudioVideoMicrophoneImpl();
  final _camera = ZegoLiveStreamingControllerAudioVideoCameraImpl();

  ZegoLiveAudioRoomSeatManager? seatManager;
  ZegoUIKitPrebuiltLiveAudioRoomConfig? config;

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void initByPrebuilt({
    required ZegoLiveAudioRoomSeatManager? seatManager,
    required ZegoUIKitPrebuiltLiveAudioRoomConfig? config,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.audioVideo.p',
    );

    this.seatManager = seatManager;

    _microphone.private.initByPrebuilt(config: config);
    _camera.private.initByPrebuilt(config: config);
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.audioVideo.p',
    );

    seatManager = null;

    _microphone.private.uninitByPrebuilt();
    _camera.private.uninitByPrebuilt();
  }
}

/// @nodoc
mixin ZegoLiveStreamingControllerAudioVideoDeviceImplPrivate {
  final _private = ZegoLiveStreamingControllerAudioVideoImplDevicePrivateImpl();

  /// Don't call that
  ZegoLiveStreamingControllerAudioVideoImplDevicePrivateImpl get private =>
      _private;
}

/// @nodoc
class ZegoLiveStreamingControllerAudioVideoImplDevicePrivateImpl {
  ZegoUIKitPrebuiltLiveAudioRoomConfig? config;

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomConfig? config,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.audioVideo.p',
    );

    this.config = config;
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.audioVideo.p',
    );

    config = null;
  }
}
