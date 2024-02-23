// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/defines.dart';

/// @nodoc
class ZegoLiveAudioRoomLeaveButton extends StatefulWidget {
  final ButtonIcon? icon;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;

  final void Function(ZegoLiveAudioRoomEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  const ZegoLiveAudioRoomLeaveButton({
    Key? key,
    required this.seatManager,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    this.icon,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomLeaveButton> createState() =>
      _ZegoLiveAudioRoomLeaveButtonState();
}

class _ZegoLiveAudioRoomLeaveButtonState
    extends State<ZegoLiveAudioRoomLeaveButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoLeaveButton(
      buttonSize: widget.buttonSize,
      iconSize: widget.iconSize,
      icon: widget.icon ??
          ButtonIcon(
            icon: const Icon(Icons.close, color: Colors.white),
            backgroundColor: ZegoUIKitDefaultTheme.buttonBackgroundColor,
          ),
      onLeaveConfirmation: (context) async {
        if (widget.seatManager.isRoomAttributesBatching) {
          ZegoLoggerService.logInfo(
            'room attribute is batching, ignore',
            tag: 'audio room',
            subTag: 'leave button',
          );
          return false;
        }

        final endConfirmationEvent = ZegoLiveAudioRoomLeaveConfirmationEvent(
          context: context,
        );
        defaultAction() async {
          return widget.defaultLeaveConfirmationAction(endConfirmationEvent);
        }

        final canLeave = await widget.events.onLeaveConfirmation?.call(
              endConfirmationEvent,
              defaultAction,
            ) ??
            true;
        if (canLeave) {
          /// take off seat when leave room
          await widget.seatManager.leaveSeat(showDialog: false);
          widget.seatManager.isLeavingRoom = true;
        }

        return canLeave;
      },
      onPress: () async {
        final endEvent = ZegoLiveAudioRoomEndEvent(
          reason: ZegoLiveAudioRoomEndReason.localLeave,
          isFromMinimizing: ZegoLiveAudioRoomMiniOverlayPageState.minimizing ==
              ZegoUIKitPrebuiltLiveAudioRoomController().minimize.state,
        );
        defaultAction() {
          widget.defaultEndAction(endEvent);
        }

        if (widget.events.onEnded != null) {
          widget.events.onEnded!.call(endEvent, defaultAction);
        } else {
          defaultAction.call();
        }
      },
    );
  }
}
