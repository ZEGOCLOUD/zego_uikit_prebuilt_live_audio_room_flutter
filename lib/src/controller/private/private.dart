part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerPrivate {
  final _private = ZegoLiveAudioRoomControllerPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerPrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerPrivateImpl {
  String _liveID = '';
  String get liveID {
    assert(_liveID.isNotEmpty);
    return _liveID;
  }

  ZegoUIKitPrebuiltLiveAudioRoomConfig? prebuiltConfig;
  ZegoUIKitPrebuiltLiveAudioRoomEvents? prebuiltEvents;
  ZegoLiveAudioRoomConnectManager? connectManager;
  ZegoLiveAudioRoomSeatManager? seatManager;

  final _hiddenUsersOfMemberListNotifier = ValueNotifier<List<String>>([]);

  ValueNotifier<List<String>> get hiddenUsersOfMemberListNotifier =>
      _hiddenUsersOfMemberListNotifier;

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void initByPrebuilt({
    required String roomID,
    required ZegoUIKitPrebuiltLiveAudioRoomConfig config,
    required ZegoUIKitPrebuiltLiveAudioRoomEvents events,
    required ZegoLiveAudioRoomConnectManager? connectManager,
    required ZegoLiveAudioRoomSeatManager? seatManager,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt'
      'room id:$roomID, ',
      tag: 'audio-room',
      subTag: 'controller.p',
    );

    _liveID = roomID;
    prebuiltConfig = config;
    prebuiltEvents = events;
    this.connectManager = connectManager;
    this.seatManager = seatManager;
  }

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.p',
    );

    _liveID = '';
    prebuiltConfig = null;
    prebuiltEvents = null;
    connectManager = null;
    seatManager = null;
  }
}
