// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'avatar.dart';

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
        widget.config.audioVideoViewConfig.backgroundBuilder
                ?.call(context, widget.size, widget.user, widget.extraInfo) ??
            Container(color: Colors.transparent),
        ...null == widget.user
            ? [emptySeat()]
            : [avatar(), microphoneOffFlag()],
      ],
    );
  }

  Widget emptySeat() {
    return Positioned(
      top: 22.r,
      left: 22.r,
      child: Container(
        width: 108.r,
        height: 108.r,
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
          top: 22.r,
          left: 22.r,
          child: Container(
            width: 108.r,
            height: 108.r,
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

  Widget avatar() {
    return Positioned(
      top: 22.r,
      left: 22.r,
      child: SizedBox(
        width: 108.r,
        height: 108.r,
        child: ZegoAvatar(
          avatarSize: Size(108.r, 108.r),
          user: widget.user,
          showAvatar: widget.config.audioVideoViewConfig.showAvatarInAudioMode,
          showSoundLevel:
              widget.config.audioVideoViewConfig.showSoundWavesInAudioMode,
          avatarBuilder: widget.config.avatarBuilder,
          soundLevelSize: widget.size,
        ),
      ),
    );
  }
}
