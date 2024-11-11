// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
class ZegoAudioRoomPIPButton extends StatefulWidget {
  const ZegoAudioRoomPIPButton({
    Key? key,
    this.afterClicked,
    this.icon,
    this.iconSize,
    this.buttonSize,
    this.aspectWidth = 1,
    this.aspectHeight = 1,
  }) : super(key: key);

  final ButtonIcon? icon;

  ///  You can do what you want after pressed.
  final VoidCallback? afterClicked;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  final int aspectWidth;
  final int aspectHeight;

  @override
  State<ZegoAudioRoomPIPButton> createState() => _ZegoAudioRoomPIPButtonState();
}

/// @nodoc
class _ZegoAudioRoomPIPButtonState extends State<ZegoAudioRoomPIPButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final containerSize = widget.buttonSize ?? Size(96.zR, 96.zR);
    final sizeBoxSize = widget.iconSize ?? Size(56.zR, 56.zR);

    return GestureDetector(
      onTap: () async {
        final pipStatus =
            await ZegoUIKitPrebuiltLiveAudioRoomController().pip.enable(
                  aspectWidth: widget.aspectWidth,
                  aspectHeight: widget.aspectHeight,
                );
        if (ZegoPiPStatus.enabled != pipStatus) {
          return;
        }

        if (widget.afterClicked != null) {
          widget.afterClicked!();
        }
      },
      child: SizedBox(
        width: containerSize.width,
        height: containerSize.height,
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: widget.icon?.icon ??
              ZegoLiveAudioRoomImage.asset(
                ZegoLiveAudioRoomIconUrls.pip,
              ),
        ),
      ),
    );
  }
}
