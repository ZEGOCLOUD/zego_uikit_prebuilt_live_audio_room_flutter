// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_sheet_menu.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'audio_room_layout.dart';
import 'defines.dart';

class ZegoSeatForeground extends StatefulWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final Map extraInfo;

  final ZegoLiveSeatManager seatManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  const ZegoSeatForeground({
    Key? key,
    this.user,
    this.extraInfo = const {},
    required this.size,
    required this.seatManager,
    required this.config,
  }) : super(key: key);

  @override
  State<ZegoSeatForeground> createState() => _ZegoSeatForegroundState();
}

class _ZegoSeatForegroundState extends State<ZegoSeatForeground> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: ValueListenableBuilder<Map<String, String>>(
        valueListenable:
            ZegoUIKit().getInRoomUserAttributesNotifier(widget.user?.id ?? ""),
        builder: (context, inRoomAttributes, _) {
          return Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                widget.config.seatConfig.foregroundBuilder?.call(
                      context,
                      widget.size,
                      ZegoUIKit().getUser(widget.user?.id ?? ""),
                      widget.extraInfo,
                    ) ??
                    foreground(
                      context,
                      widget.size,
                      ZegoUIKit().getUser(widget.user?.id ?? ""),
                      widget.extraInfo,
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget foreground(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              child: userName(context, constraints.maxWidth),
            ),
            widget.seatManager.isAttributeHost(user)
                ? Positioned(
                    top: seatItemHeight -
                        seatUserNameFontSize -
                        seatHostFlagHeight -
                        3.r, //  spacing
                    child: hostFlag(context, constraints.maxWidth),
                  )
                : Container(),
          ],
        );
      }),
    );
  }

  void onClicked() {
    var index =
        int.tryParse(widget.extraInfo[layoutGridItemIndexKey].toString()) ?? -1;
    if (-1 == index) {
      ZegoLoggerService.logInfo(
        "ERROR!!! click seat index is invalid",
        tag: "audio room",
        subTag: "foreground",
      );
      return;
    }

    List<PopupItem> popupItems = [];

    if (null == widget.user) {
      /// empty seat
      /// forbid host switch seat and speaker/audience take locked seat
      if (!widget.seatManager.localIsAHost &&
          !widget.seatManager.isAHostSeat(index)) {
        if (-1 !=
            widget.seatManager
                .getIndexByUserID(ZegoUIKit().getLocalUser().id)) {
          /// local user is on seat
          widget.seatManager.switchToSeat(index);
        } else {
          /// local user is not on seat
          popupItems.add(PopupItem(
            PopupItemValue.takeOnSeat,
            widget.config.translationText.takeSeatMenuButton,
            data: index,
          ));
        }
      }
    } else {
      /// have a user on seat
      if (ZegoLiveAudioRoomRole.host == widget.seatManager.localRole.value &&
          widget.user?.id != ZegoUIKit().getLocalUser().id) {
        /// host can kick others off seat
        popupItems.add(PopupItem(
          PopupItemValue.takeOffSeat,
          widget.config.translationText.removeSpeakerMenuDialogButton
              .replaceFirst(
            widget.config.translationText.param_1,
            widget.user?.name ?? "",
          ),
          data: index,
        ));
      } else if (ZegoUIKit().getLocalUser().id ==
              widget.seatManager.getUserByIndex(index)?.id &&
          ZegoLiveAudioRoomRole.host != widget.seatManager.localRole.value) {
        /// speaker can local leave seat
        popupItems.add(PopupItem(
          PopupItemValue.leaveSeat,
          widget.config.translationText.leaveSeatDialogInfo.title,
        ));
      }
    }

    if (popupItems.isEmpty) {
      return;
    }

    popupItems.add(PopupItem(
      PopupItemValue.cancel,
      widget.config.translationText.cancelMenuDialogButton,
    ));

    showPopUpSheet(
      context: context,
      userID: widget.user?.id ?? "",
      popupItems: popupItems,
      seatManager: widget.seatManager,
      translationText: widget.config.translationText,
    );
  }

  Widget hostFlag(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(maxWidth, seatHostFlagHeight)),
      child: Center(
        child: PrebuiltLiveAudioRoomImage.asset(
          PrebuiltLiveAudioRoomIconUrls.seatHost,
        ),
      ),
    );
  }

  Widget userName(BuildContext context, double maxWidth) {
    return SizedBox(
      width: maxWidth,
      child: Text(
        widget.user?.name ?? "",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: seatUserNameFontSize,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
