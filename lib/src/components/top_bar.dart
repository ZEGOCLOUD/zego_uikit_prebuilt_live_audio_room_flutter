// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/leave_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/mini_button.dart';

/// @nodoc
class ZegoLiveAudioRoomTopBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;
  final void Function(ZegoLiveAudioRoomEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoUIKitPrebuiltLiveAudioRoomInnerText translationText;

  const ZegoLiveAudioRoomTopBar({
    Key? key,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.seatManager,
    required this.connectManager,
    required this.translationText,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomTopBar> createState() =>
      _ZegoLiveAudioRoomTopBarState();
}

/// @nodoc
class _ZegoLiveAudioRoomTopBarState extends State<ZegoLiveAudioRoomTopBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      height: 80.zR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          minimizingButton(),
          const Expanded(child: SizedBox()),
          closeButton(),
          SizedBox(width: 34.zR),
        ],
      ),
    );
  }

  Widget minimizingButton() {
    return widget.config.topMenuBar.buttons
            .contains(ZegoLiveAudioRoomMenuBarButtonName.minimizingButton)
        ? ZegoMinimizingButton(
            rootNavigator: widget.config.rootNavigator,
          )
        : Container();
  }

  Widget closeButton() {
    return ZegoLiveAudioRoomLeaveButton(
      buttonSize: Size(52.zR, 52.zR),
      iconSize: Size(24.zR, 24.zR),
      icon: ButtonIcon(
        icon: ZegoLiveAudioRoomImage.asset(ZegoLiveAudioRoomIconUrls.topQuit),
        backgroundColor: Colors.white,
      ),
      config: widget.config,
      events: widget.events,
      defaultEndAction: widget.defaultEndAction,
      defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
      seatManager: widget.seatManager,
    );
  }
}
