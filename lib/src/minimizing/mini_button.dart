// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/mini_overlay_machine.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/prebuilt_data.dart';

/// @nodoc
class ZegoMinimizingButton extends StatefulWidget {
  const ZegoMinimizingButton({
    Key? key,
    required this.prebuiltAudioRoomData,
    this.onWillPressed,
    this.icon,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  final ButtonIcon? icon;

  ///  You can do what you want
  final VoidCallback? onWillPressed;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  final ZegoUIKitPrebuiltLiveAudioRoomData prebuiltAudioRoomData;

  @override
  State<ZegoMinimizingButton> createState() => _ZegoMinimizingButtonState();
}

/// @nodoc
class _ZegoMinimizingButtonState extends State<ZegoMinimizingButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final containerSize = widget.buttonSize ?? Size(96.zR, 96.zR);
    final sizeBoxSize = widget.iconSize ?? Size(56.zR, 56.zR);

    return GestureDetector(
      onTap: () {
        if (LiveAudioRoomMiniOverlayPageState.minimizing ==
            ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state()) {
          ZegoLoggerService.logInfo(
            'is minimizing, ignore',
            tag: 'audio room',
            subTag: 'overlay button',
          );

          return;
        }

        if (widget.onWillPressed != null) {
          widget.onWillPressed!();
        }

        ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().changeState(
          LiveAudioRoomMiniOverlayPageState.minimizing,
          prebuiltAudioRoomData: widget.prebuiltAudioRoomData,
        );

        Navigator.of(
          context,
          rootNavigator: widget.prebuiltAudioRoomData.config.rootNavigator,
        ).pop();
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: BoxDecoration(
          color: widget.icon?.backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: widget.icon?.icon ??
              PrebuiltLiveAudioRoomImage.asset(
                  PrebuiltLiveAudioRoomIconUrls.minimizing),
        ),
      ),
    );
  }
}
