// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'defines.dart';
import 'leave_button.dart';

class ZegoTopBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoLiveSeatManager seatManager;
  final ZegoTranslationText translationText;

  final String roomTitle;
  final String roomID;

  const ZegoTopBar({
    Key? key,
    required this.roomTitle,
    required this.roomID,
    required this.config,
    required this.seatManager,
    required this.translationText,
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
          SizedBox(width: 36.r),
          roomInfo(),
          const Expanded(child: SizedBox()),
          closeButton(),
          SizedBox(width: 34.r),
        ],
      ),
    );
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

  Widget roomInfo() {
    return SizedBox(
      width: 501.r,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.roomTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xff1B1B1B),
              fontSize: 32.r,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "ID: ${widget.roomID}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xff606060),
              fontSize: 20.r,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
