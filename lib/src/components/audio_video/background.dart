// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/audio_room_layout.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

/// @nodoc
class ZegoLiveAudioRoomSeatBackground extends StatefulWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final Map<String, dynamic> extraInfo;

  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  const ZegoLiveAudioRoomSeatBackground({
    Key? key,
    this.user,
    this.extraInfo = const {},
    required this.size,
    required this.seatManager,
    required this.config,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomSeatBackground> createState() =>
      _ZegoSeatForegroundState();
}

/// @nodoc
class _ZegoSeatForegroundState extends State<ZegoLiveAudioRoomSeatBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.config.seat.backgroundBuilder?.call(
              context,
              widget.size,
              ZegoUIKit().getUser(widget.user?.id ?? ''),
              widget.extraInfo,
            ) ??
            Container(color: Colors.transparent),
        ...null == widget.user
            ? [
                emptySeat(),
              ]
            : [],
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
          child: ValueListenableBuilder<List<int>>(
            valueListenable: widget.seatManager.lockedSeatNotifier,
            builder: (context, lockedSeat, _) {
              final userSeatIndex = int.tryParse(
                      widget.extraInfo[layoutGridItemIndexKey].toString()) ??
                  -1;

              return lockedSeat.contains(userSeatIndex)
                  ? (widget.config.seat.closeIcon ??
                      ZegoLiveAudioRoomImage.asset(
                        ZegoLiveAudioRoomIconUrls.seatLock,
                      ))
                  : (widget.config.seat.openIcon ??
                      ZegoLiveAudioRoomImage.asset(
                        ZegoLiveAudioRoomIconUrls.seatEmpty,
                      ));
            },
          )),
    );
  }
}
