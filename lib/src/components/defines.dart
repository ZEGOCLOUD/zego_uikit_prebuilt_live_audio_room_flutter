// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.defines.dart';

/// @nodoc
const layoutGridItemIndexKey = 'index';

Color get zegoLiveSoundWaveColor => const Color(0xff2254f6);
// size
Size get zegoLiveButtonSize => Size(72.zR, 72.zR);

Size get zegoLiveButtonIconSize => Size(40.zR, 40.zR);

SizedBox get zegoLiveButtonPadding =>
    SizedBox.fromSize(size: Size.fromRadius(8.zR));

extension ZegoLiveAudioRoomPopupItemValueExtension
    on ZegoLiveAudioRoomPopupItemValue {
  static ZegoLiveAudioRoomPopupItemValue fromIndex(int index) {
    Map<int, ZegoLiveAudioRoomPopupItemValue> values = {
      0: ZegoLiveAudioRoomPopupItemValue.takeOnSeat,
      1: ZegoLiveAudioRoomPopupItemValue.takeOffSeat,
      2: ZegoLiveAudioRoomPopupItemValue.switchSeat,
      3: ZegoLiveAudioRoomPopupItemValue.leaveSeat,
      4: ZegoLiveAudioRoomPopupItemValue.muteSeat,
      5: ZegoLiveAudioRoomPopupItemValue.inviteLink,
      6: ZegoLiveAudioRoomPopupItemValue.assignCoHost,
      7: ZegoLiveAudioRoomPopupItemValue.revokeCoHost,
      8: ZegoLiveAudioRoomPopupItemValue.cancel,
      100: ZegoLiveAudioRoomPopupItemValue.customStartIndex,
    };

    return values[index] ?? ZegoLiveAudioRoomPopupItemValue.customStartIndex;
  }

  static int getIndex(ZegoLiveAudioRoomPopupItemValue value) {
    Map<ZegoLiveAudioRoomPopupItemValue, int> values = {
      ZegoLiveAudioRoomPopupItemValue.takeOnSeat: 0,
      ZegoLiveAudioRoomPopupItemValue.takeOffSeat: 1,
      ZegoLiveAudioRoomPopupItemValue.switchSeat: 2,
      ZegoLiveAudioRoomPopupItemValue.leaveSeat: 3,
      ZegoLiveAudioRoomPopupItemValue.muteSeat: 4,
      ZegoLiveAudioRoomPopupItemValue.inviteLink: 5,
      ZegoLiveAudioRoomPopupItemValue.assignCoHost: 6,
      ZegoLiveAudioRoomPopupItemValue.revokeCoHost: 7,
      ZegoLiveAudioRoomPopupItemValue.cancel: 8,
      ZegoLiveAudioRoomPopupItemValue.customStartIndex: 100,
    };

    return values[value] ?? -1;
  }

  int get index {
    return getIndex(this);
  }
}

class ZegoLiveAudioRoomPopupItem {
  final int index;
  final String text;
  final dynamic data;
  final void Function()? onPressed;

  const ZegoLiveAudioRoomPopupItem(
    this.index,
    this.text, {
    this.data,
    this.onPressed,
  });
}

/// @nodoc
class ZegoLiveAudioRoomImage {
  static Image asset(String name) {
    return Image.asset(name, package: 'zego_uikit_prebuilt_live_audio_room');
  }

  static AssetImage assetImage(String name) {
    return AssetImage(name, package: 'zego_uikit_prebuilt_live_audio_room');
  }
}

/// @nodoc
class ZegoLiveAudioRoomIconUrls {
  static const String im = 'assets/icons/toolbar_im.png';
  static const String back = 'assets/icons/back.png';
  static const String toolbarSoundEffect = 'assets/icons/toolbar_sound.png';
  static const String toolbarMicNormal = 'assets/icons/toolbar_mic_normal.png';
  static const String toolbarMicOff = 'assets/icons/toolbar_mic_off.png';
  static const String toolbarMember = 'assets/icons/toolbar_member.png';
  static const String toolbarMore = 'assets/icons/toolbar_more.png';
  static const String minimizing = 'assets/icons/minimizing.png';
  static const String pip = 'assets/icons/pip.png';

  static const String memberMore = 'assets/icons/member_more.png';
  static const String toolbarAudienceConnect =
      'assets/icons/toolbar_audience_connect.png';
  static const String toolbarHostLockSeat =
      'assets/icons/toolbar_host_unlock_seat.png';
  static const String toolbarHostUnLockSeat =
      'assets/icons/toolbar_host_lock_seat.png';

  static const String topQuit = 'assets/icons/top_quit.png';

  static const String seatAdd = 'assets/icons/seat_add.png';
  static const String seatEmpty = 'assets/icons/seat_empty.png';
  static const String seatHost = 'assets/icons/seat_host.png';
  static const String seatCoHost = 'assets/icons/seat_cohost.png';
  static const String seatLock = 'assets/icons/seat_lock.png';
  static const String seatMicrophoneOff = 'assets/icons/seat_mic_off.png';
}
