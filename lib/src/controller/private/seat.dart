part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerSeatPrivate {
  final _private = ZegoLiveAudioRoomControllerSeatPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerSeatPrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerSeatPrivateImpl {
  final host = ZegoLiveAudioRoomControllerSeatHostImpl();
  final audience = ZegoLiveAudioRoomControllerSeatAudienceImpl();
  final speaker = ZegoLiveAudioRoomControllerSeatSpeakerImpl();

  ZegoLiveAudioRoomConnectManager? connectManager;
  ZegoLiveAudioRoomSeatManager? seatManager;

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void initByPrebuilt({
    required ZegoLiveAudioRoomConnectManager? connectManager,
    required ZegoLiveAudioRoomSeatManager? seatManager,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.seat.p',
    );

    this.connectManager = connectManager;
    this.seatManager = seatManager;

    host.private._initByPrebuilt(
      connectManager: connectManager,
      seatManager: seatManager,
    );
    speaker.private._initByPrebuilt(
      connectManager: connectManager,
      seatManager: seatManager,
    );
    audience.private._initByPrebuilt(
      connectManager: connectManager,
      seatManager: seatManager,
    );
  }

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio room',
      subTag: 'controller.seat.p',
    );

    connectManager = null;
    seatManager = null;

    host.private._uninitByPrebuilt();
    speaker.private._uninitByPrebuilt();
    audience.private._uninitByPrebuilt();
  }
}

/// @nodoc
mixin ZegoLiveAudioRoomControllerSeatRolePrivate {
  final _private = ZegoLiveAudioRoomControllerSeatRolePrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerSeatRolePrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerSeatRolePrivateImpl {
  ZegoLiveAudioRoomConnectManager? connectManager;
  ZegoLiveAudioRoomSeatManager? seatManager;

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void _initByPrebuilt({
    required ZegoLiveAudioRoomConnectManager? connectManager,
    required ZegoLiveAudioRoomSeatManager? seatManager,
  }) {
    this.connectManager = connectManager;
    this.seatManager = seatManager;
  }

  void _uninitByPrebuilt() {
    connectManager = null;
    seatManager = null;
  }
}
