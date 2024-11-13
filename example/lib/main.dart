// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

/// Here is the simplest demo.
///
/// Please follow the link below to see more details.
/// https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_live_audio_room_example_flutter

Widget liveAudioRoomPage({required bool isHost}) {
  return ZegoUIKitPrebuiltLiveAudioRoom(
    appID: -1, // your AppID,
    appSign: 'your AppSign',
    userID: 'local user id',
    userName: 'local user name',
    roomID: 'room id',
    config: isHost
        ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience(),
  );
}
