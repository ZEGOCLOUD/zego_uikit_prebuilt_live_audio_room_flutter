enum ConnectState {
  idle,
  connecting,
  connected,
}

enum ZegoInvitationType {
  ///  audience request host to take seat
  requestTakeSeat,

  ///  host invite audience take seat
  inviteToTakeSeat,
}

extension ZegoInvitationTypeExtension on ZegoInvitationType {
  static const valueMap = {
    ZegoInvitationType.requestTakeSeat: 2,
    ZegoInvitationType.inviteToTakeSeat: 3,
  };

  int get value => valueMap[this] ?? -1;

  static const Map<int, ZegoInvitationType> mapValue = {
    2: ZegoInvitationType.requestTakeSeat,
    3: ZegoInvitationType.inviteToTakeSeat,
  };
}
