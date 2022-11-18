// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// size
get zegoLiveButtonSize => Size(72.r, 72.r);

get zegoLiveButtonIconSize => Size(40.r, 40.r);

get zegoLiveButtonPadding => SizedBox.fromSize(size: Size.fromRadius(8.r));

Size getTextSize(String text, TextStyle textStyle) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

enum PopupItemValue {
  takeOnSeat,
  takeOffSeat,
  leaveSeat,
  cancel,
}

class PopupItem {
  final PopupItemValue value;
  final String text;
  final dynamic data;

  const PopupItem(this.value, this.text, {this.data});
}

class PrebuiltLiveAudioRoomImage {
  static Image asset(String name) {
    return Image.asset(name, package: "zego_uikit_prebuilt_live_audio_room");
  }

  static AssetImage assetImage(String name) {
    return AssetImage(name, package: "zego_uikit_prebuilt_live_audio_room");
  }
}

class PrebuiltLiveAudioRoomIconUrls {
  static const String im = 'assets/icons/toolbar_im.png';
  static const String back = 'assets/icons/back.png';
  static const String toolbarSoundEffect = 'assets/icons/toolbar_sound.png';
  static const String toolbarMicNormal = 'assets/icons/toolbar_mic_normal.png';
  static const String toolbarMicOff = 'assets/icons/toolbar_mic_off.png';
  static const String toolbarMember = 'assets/icons/toolbar_member.png';
  static const String toolbarMore = 'assets/icons/toolbar_more.png';

  static const String topQuit = "assets/icons/top_quit.png";

  static const String seatAdd = "assets/icons/seat_add.png";
  static const String seatEmpty = "assets/icons/seat_empty.png";
  static const String seatHost = "assets/icons/seat_host.png";
  static const String seatLock = "assets/icons/seat_lock.png";
  static const String seatMicrophoneOff = "assets/icons/seat_mic_off.png";
}
