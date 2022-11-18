// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'member_list_sheet.dart';

class ZegoMemberButton extends StatefulWidget {
  const ZegoMemberButton({
    Key? key,
    this.avatarBuilder,
    required this.seatManager,
    required this.translationText,
    this.iconSize,
    this.buttonSize,
    this.icon,
  }) : super(key: key);

  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoLiveSeatManager seatManager;
  final ZegoTranslationText translationText;

  final Size? iconSize;
  final Size? buttonSize;
  final ButtonIcon? icon;

  @override
  State<ZegoMemberButton> createState() => _ZegoMemberButtonState();
}

class _ZegoMemberButtonState extends State<ZegoMemberButton> {
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
    Size containerSize = widget.buttonSize ?? Size(96.r, 96.r);
    Size sizeBoxSize = widget.iconSize ?? Size(56.r, 56.r);

    return GestureDetector(
      onTap: () {
        showMemberListSheet(
          context: context,
          avatarBuilder: widget.avatarBuilder,
          seatManager: widget.seatManager,
          translationText: widget.translationText,
        );
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: BoxDecoration(
          color: widget.icon?.backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: widget.icon?.icon ??
              PrebuiltLiveAudioRoomImage.asset(
                  PrebuiltLiveAudioRoomIconUrls.toolbarMember),
        ),
      ),
    );
  }
}
