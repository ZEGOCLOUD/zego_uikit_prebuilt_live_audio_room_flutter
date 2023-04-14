// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_controller.dart';

// Project imports:

class ZegoUIKitPrebuiltLiveAudioRoomData {
  const ZegoUIKitPrebuiltLiveAudioRoomData({
    required this.appID,
    required this.appSign,
    required this.roomID,
    required this.userID,
    required this.userName,
    required this.config,
    required this.isPrebuiltFromMinimizing,
    this.controller,
    this.appDesignSize,
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

  final ZegoLiveAudioRoomController? controller;

  final Size? appDesignSize;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  final bool isPrebuiltFromMinimizing;

  @override
  String toString() {
    return 'app id:$appID, app sign:$appSign, room id:$roomID, '
        'isPrebuiltFromMinimizing: $isPrebuiltFromMinimizing, '
        'user id:$userID, user name:$userName, app design size:$appDesignSize, '
        'config:${config.toString()}';
  }
}
