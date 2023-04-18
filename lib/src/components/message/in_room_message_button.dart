// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil_zego/flutter_screenutil_zego.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/message/in_room_message_input_board.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class ZegoInRoomMessageButton extends StatefulWidget {
  final Size? iconSize;
  final Size? buttonSize;
  final ZegoInnerText innerText;

  const ZegoInRoomMessageButton({
    Key? key,
    required this.innerText,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  @override
  State<ZegoInRoomMessageButton> createState() =>
      _ZegoInRoomMessageButtonState();
}

class _ZegoInRoomMessageButtonState extends State<ZegoInRoomMessageButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: () {
        Navigator.of(context).push(ZegoInRoomMessageInputBoard(
          innerText: widget.innerText,
        ));
      },
      icon: ButtonIcon(
        icon:
            PrebuiltLiveAudioRoomImage.asset(PrebuiltLiveAudioRoomIconUrls.im),
      ),
      iconSize: widget.iconSize ?? Size(72.r, 72.r),
      buttonSize: widget.buttonSize ?? Size(96.r, 96.r),
    );
  }
}
