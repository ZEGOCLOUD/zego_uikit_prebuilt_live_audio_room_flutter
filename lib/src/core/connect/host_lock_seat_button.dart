// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

/// @nodoc
class ZegoLiveAudioRoomHostLockSeatButton extends StatefulWidget {
  final Size? iconSize;
  final Size? buttonSize;
  final ZegoLiveAudioRoomSeatManager seatManager;

  const ZegoLiveAudioRoomHostLockSeatButton({
    Key? key,
    required this.seatManager,
    this.iconSize,
    this.buttonSize,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomHostLockSeatButton> createState() =>
      _ZegoLiveAudioRoomHostLockSeatButtonState();
}

/// @nodoc
class _ZegoLiveAudioRoomHostLockSeatButtonState
    extends State<ZegoLiveAudioRoomHostLockSeatButton> {
  var voiceChangerSelectedIDNotifier = ValueNotifier<String>('');
  var reverbSelectedIDNotifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    final containerSize = widget.buttonSize ?? Size(96.zR, 96.zR);
    final sizeBoxSize = widget.iconSize ?? Size(56.zR, 56.zR);
    return GestureDetector(
      onTap: () async {
        widget.seatManager.lockSeat(
          !widget.seatManager.isRoomSeatLockedNotifier.value,
        );
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: ValueListenableBuilder<bool>(
              valueListenable: widget.seatManager.isRoomSeatLockedNotifier,
              builder: (context, isRoomSeatLocked, _) {
                return ZegoLiveAudioRoomImage.asset(
                  isRoomSeatLocked
                      ? ZegoLiveAudioRoomIconUrls.toolbarHostUnLockSeat
                      : ZegoLiveAudioRoomIconUrls.toolbarHostLockSeat,
                );
              }),
        ),
      ),
    );
  }
}
