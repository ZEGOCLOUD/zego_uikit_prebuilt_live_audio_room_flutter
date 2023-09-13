// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/leave_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/mini_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/prebuilt_data.dart';

/// @nodoc
class ZegoTopBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoInnerText translationText;

  final ZegoUIKitPrebuiltLiveAudioRoomData prebuiltAudioRoomData;

  const ZegoTopBar({
    Key? key,
    required this.config,
    required this.seatManager,
    required this.connectManager,
    required this.translationText,
    required this.prebuiltAudioRoomData,
  }) : super(key: key);

  @override
  State<ZegoTopBar> createState() => _ZegoTopBarState();
}

/// @nodoc
class _ZegoTopBarState extends State<ZegoTopBar> {
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
    return widget.config.topMenuBarConfig.buttons
            .contains(ZegoMenuBarButtonName.minimizingButton)
        ? ZegoMinimizingButton(
            prebuiltAudioRoomData: widget.prebuiltAudioRoomData,
          )
        : Container();
  }

  Widget closeButton() {
    return ZegoLeaveAudioRoomButton(
      buttonSize: Size(52.zR, 52.zR),
      iconSize: Size(24.zR, 24.zR),
      icon: ButtonIcon(
        icon: PrebuiltLiveAudioRoomImage.asset(
            PrebuiltLiveAudioRoomIconUrls.topQuit),
        backgroundColor: Colors.white,
      ),
      config: widget.config,
      seatManager: widget.seatManager,
    );
  }
}
