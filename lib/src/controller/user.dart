part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerUser {
  final _userImpl = ZegoLiveAudioRoomControllerUserImpl();

  ZegoLiveAudioRoomControllerUserImpl get user => _userImpl;
}

/// Here are the APIs related to screen sharing.
class ZegoLiveAudioRoomControllerUserImpl
    with ZegoLiveAudioRoomControllerUserPrivate {
  /// remove user from live, kick out
  ///
  /// @return Error code, please refer to the error codes document https://docs.zegocloud.com/en/5548.html for details.
  ///
  /// @return A `Future` that representing whether the request was successful.
  Future<bool> remove(List<String> userIDs) async {
    ZegoLoggerService.logInfo(
      'remove user:$userIDs',
      tag: 'audio room',
      subTag: 'controller.room',
    );

    return ZegoUIKit().removeUserFromRoom(userIDs);
  }
}
