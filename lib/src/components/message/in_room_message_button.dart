// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/message/in_room_message_input_board.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';

/// @nodoc
class ZegoInRoomMessageButton extends StatefulWidget {
  final Size? iconSize;
  final Size? buttonSize;
  final ZegoInnerText innerText;
  final bool rootNavigator;

  final Function(int)? onSheetPopUp;
  final Function(int)? onSheetPop;

  const ZegoInRoomMessageButton({
    Key? key,
    required this.innerText,
    this.rootNavigator = false,
    this.iconSize,
    this.buttonSize,
    this.onSheetPopUp,
    this.onSheetPop,
  }) : super(key: key);

  @override
  State<ZegoInRoomMessageButton> createState() =>
      _ZegoInRoomMessageButtonState();
}

/// @nodoc
class _ZegoInRoomMessageButtonState extends State<ZegoInRoomMessageButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: () {
        final key = DateTime.now().millisecondsSinceEpoch;
        widget.onSheetPopUp?.call(key);

        Navigator.of(
          context,
          rootNavigator: widget.rootNavigator,
        )
            .push(
          ZegoInRoomMessageInputBoard(
            innerText: widget.innerText,
            rootNavigator: widget.rootNavigator,
          ),
        )
            .then((value) {
          widget.onSheetPop?.call(key);
        });
      },
      icon: ButtonIcon(
        icon:
            PrebuiltLiveAudioRoomImage.asset(PrebuiltLiveAudioRoomIconUrls.im),
      ),
      iconSize: widget.iconSize ?? Size(72.zR, 72.zR),
      buttonSize: widget.buttonSize ?? Size(96.zR, 96.zR),
    );
  }
}
