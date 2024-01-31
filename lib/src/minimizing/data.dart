// Dart imports:
import 'dart:core';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';

/// @nodoc
class ZegoUIKitPrebuiltLiveAudioRoomMinimizeData {
  const ZegoUIKitPrebuiltLiveAudioRoomMinimizeData({
    required this.appID,
    required this.appSign,
    required this.roomID,
    required this.userID,
    required this.userName,
    required this.config,
    required this.events,
    required this.isPrebuiltFromMinimizing,
    this.controller,
  });

  /// you need to fill in the appID you obtained from console.zegocloud.com
  final int appID;

  /// for Android/iOS
  /// you need to fill in the appID you obtained from console.zegocloud.com
  final String appSign;

  /// local user info
  final String userID;
  final String userName;

  /// You can customize the liveName arbitrarily,
  /// just need to know: users who use the same liveName can talk with each other.
  final String roomID;

  final ZegoUIKitPrebuiltLiveAudioRoomController? controller;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;

  final bool isPrebuiltFromMinimizing;

  @override
  String toString() {
    return '{app id:$appID, app sign:$appSign, room id:$roomID, '
        'isPrebuiltFromMinimizing: $isPrebuiltFromMinimizing, '
        'user id:$userID, user name:$userName, config:$config}';
  }
}
