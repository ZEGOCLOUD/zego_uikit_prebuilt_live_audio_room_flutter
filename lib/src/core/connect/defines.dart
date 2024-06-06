// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

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

class ZegoLiveAudioRoomRequestingTakeSeatListItem {
  const ZegoLiveAudioRoomRequestingTakeSeatListItem({
    required this.user,
    required this.data,
  });

  final ZegoUIKitUser user;
  final String data;
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
