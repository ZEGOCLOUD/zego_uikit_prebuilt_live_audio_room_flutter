part of 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerPrivate {
  ZegoUIKitPrebuiltLiveAudioRoomConfig? _prebuiltConfig;
  ZegoLiveConnectManager? _connectManager;
  ZegoLiveSeatManager? _seatManager;

  final _hiddenUsersOfMemberListNotifier = ValueNotifier<List<String>>([]);

  ValueNotifier<List<String>> get hiddenUsersOfMemberListNotifier =>
      _hiddenUsersOfMemberListNotifier;

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomConfig config,
    required ZegoLiveConnectManager? connectManager,
    required ZegoLiveSeatManager? seatManager,
  }) {
    _prebuiltConfig = config;
    _connectManager = connectManager;
    _seatManager = seatManager;
  }

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void uninitByPrebuilt() {
    _connectManager = null;
    _seatManager = null;
  }
}
