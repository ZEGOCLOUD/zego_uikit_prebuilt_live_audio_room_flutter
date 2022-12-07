// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'defines.dart';

class ZegoSeatBackground extends StatefulWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final Map extraInfo;

  final ZegoLiveSeatManager seatManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  const ZegoSeatBackground({
    Key? key,
    this.user,
    this.extraInfo = const {},
    required this.size,
    required this.seatManager,
    required this.config,
  }) : super(key: key);

  @override
  State<ZegoSeatBackground> createState() => _ZegoSeatForegroundState();
}

class _ZegoSeatForegroundState extends State<ZegoSeatBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<Map<String, String>>(
            valueListenable: ZegoUIKit()
                .getInRoomUserAttributesNotifier(widget.user?.id ?? ""),
            builder: (context, inRoomAttributes, _) {
              return widget.config.seatConfig.backgroundBuilder?.call(
                    context,
                    widget.size,
                    ZegoUIKit().getUser(widget.user?.id ?? ""),
                    widget.extraInfo,
                  ) ??
                  Container(color: Colors.transparent);
            }),
        ...null == widget.user ? [emptySeat()] : [microphoneOffFlag()],
      ],
    );
  }

  Widget emptySeat() {
    return Positioned(
      top: avatarPosTop,
      left: avatarPosLeft,
      child: Container(
        width: seatIconWidth,
        height: seatIconWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xffE6E6E6).withOpacity(0.5),
        ),
        child: PrebuiltLiveAudioRoomImage.asset(
          PrebuiltLiveAudioRoomIconUrls.seatEmpty,
        ),
      ),
    );
  }

  Widget microphoneOffFlag() {
    return ValueListenableBuilder<bool>(
      valueListenable:
          ZegoUIKit().getMicrophoneStateNotifier(widget.user?.id ?? ""),
      builder: (context, isMicrophoneEnabled, _) {
        if (isMicrophoneEnabled) {
          return Container();
        }

        return Positioned(
          top: avatarPosTop,
          left: avatarPosLeft,
          child: Container(
            width: seatIconWidth,
            height: seatIconWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.5),
            ),
            child: PrebuiltLiveAudioRoomImage.asset(
              PrebuiltLiveAudioRoomIconUrls.seatMicrophoneOff,
            ),
          ),
        );
      },
    );
  }
}
