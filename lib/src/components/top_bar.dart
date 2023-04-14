// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/leave_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/minimizing/mini_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/minimizing/prebuilt_data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

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
      height: 80.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          minimizingButton(),
          const Expanded(child: SizedBox()),
          closeButton(),
          SizedBox(width: 34.r),
        ],
      ),
    );
  }

  Widget minimizingButton() {
    return widget.config.topMenuBarConfig.buttons
            .contains(ZegoTopMenuBarButtonName.minimizingButton)
        ? ZegoUIKitPrebuiltLiveAudioRoomMinimizingButton(
            prebuiltAudioRoomData: widget.prebuiltAudioRoomData,
          )
        : Container();
  }

  Widget closeButton() {
    return ZegoLeaveAudioRoomButton(
      buttonSize: Size(52.r, 52.r),
      iconSize: Size(24.r, 24.r),
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
