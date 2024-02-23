/// @nodoc
enum ZegoLiveAudioRoomConnectState {
  idle,
  connecting,
  connected,
}

/// @nodoc
enum ZegoLiveAudioRoomInvitationType {
  ///  audience request host to take seat
  requestTakeSeat,

  ///  host invite audience take seat
  inviteToTakeSeat,
}

/// @nodoc
extension ZegoLiveAudioRoomInvitationTypeExtension
    on ZegoLiveAudioRoomInvitationType {
  static const valueMap = {
    ZegoLiveAudioRoomInvitationType.requestTakeSeat: 2,
    ZegoLiveAudioRoomInvitationType.inviteToTakeSeat: 3,
  };

  int get value => valueMap[this] ?? -1;

  static const Map<int, ZegoLiveAudioRoomInvitationType> mapValue = {
    2: ZegoLiveAudioRoomInvitationType.requestTakeSeat,
    3: ZegoLiveAudioRoomInvitationType.inviteToTakeSeat,
  };
}
