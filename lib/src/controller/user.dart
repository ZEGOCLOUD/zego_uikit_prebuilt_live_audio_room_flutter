part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// Mixin for user-related functionality.
///
/// This mixin provides access to the user controller.
mixin ZegoLiveAudioRoomControllerUser {
  final _userImpl = ZegoLiveAudioRoomControllerUserImpl();

  /// Gets the user controller instance.
  ZegoLiveAudioRoomControllerUserImpl get user => _userImpl;
}

/// Controller for user operations.
///
/// This class provides APIs for managing users in the audio room.
class ZegoLiveAudioRoomControllerUserImpl
    with ZegoLiveAudioRoomControllerUserPrivate {
  /// Removes users from the room (kicks them out).
  ///
  /// [userIDs] - A list of user IDs to remove from the room.
  ///
  /// Returns `true` if successful, `false` otherwise.
  /// Error codes can be found at: https://docs.zegocloud.com/en/5548.html
  Future<bool> remove(List<String> userIDs) async {
    ZegoLoggerService.logInfo(
      'remove user:$userIDs',
      tag: 'audio-room',
      subTag: 'controller.user',
    );

    return ZegoUIKit().removeUserFromRoom(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      userIDs,
    );
  }
}
