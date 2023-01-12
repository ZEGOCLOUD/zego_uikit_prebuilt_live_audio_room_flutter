// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';

class ZegoLeaveAudioRoomButton extends StatelessWidget {
  final ButtonIcon? icon;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  final ZegoLiveSeatManager seatManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  const ZegoLeaveAudioRoomButton({
    Key? key,
    required this.seatManager,
    required this.config,
    this.icon,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZegoLeaveButton(
      buttonSize: buttonSize,
      iconSize: iconSize,
      icon: icon ??
          ButtonIcon(
            icon: const Icon(Icons.close, color: Colors.white),
            backgroundColor: ZegoUIKitDefaultTheme.buttonBackgroundColor,
          ),
      onLeaveConfirmation: (context) async {
        if (seatManager.isRoomAttributesBatching) {
          ZegoLoggerService.logInfo(
            "room attribute is batching, ignore",
            tag: "audio room",
            subTag: "leave button",
          );
          return false;
        }

        var canLeave = await config.onLeaveConfirmation?.call(context) ?? true;
        if (canLeave) {
          /// take off seat when leave room
          await seatManager.leaveSeat(showDialog: false);
        }

        return canLeave;
      },
      onPress: () async {
        if (config.onLeaveLiveAudioRoom != null) {
          config.onLeaveLiveAudioRoom!.call();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
