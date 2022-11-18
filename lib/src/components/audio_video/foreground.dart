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
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'layout_grid.dart';

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
      child: Stack(
        children: [
          widget.config.audioVideoViewConfig.foregroundBuilder
                  ?.call(context, widget.size, widget.user, widget.extraInfo) ??
              Container(color: Colors.transparent),
          widget.user == null
              ? Container(color: Colors.transparent)
              : LayoutBuilder(
                  builder: ((context, constraints) {
                    return Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: userName(context, constraints.maxWidth),
                        ),
                        widget.seatManager.hostsNotifier.value
                                .contains(widget.user?.id)
                            ? Positioned(
                                bottom: 28.r + 14.r,
                                child: hostFlag(context, constraints.maxWidth),
                              )
                            : Container(),
                      ],
                    );
                  }),
                ),
        ],
      ),
    );
  }

  void onClicked() {
    var index =
        int.tryParse(widget.extraInfo[layoutGridItemIndexKey].toString()) ?? -1;
    if (-1 == index) {
      debugPrint("ERROR!!! click seat index is invalid");
      return;
    }

    List<PopupItem> popupItems = [];

    if (null == widget.user) {
      if (-1 !=
              widget.seatManager
                  .getIndexByUserID(ZegoUIKit().getLocalUser().id) &&
          // 0 index is for host
          widget.seatManager.hostIndex != index) {
        widget.seatManager.switchToSeat(index);
      } else if (ZegoLiveAudioRoomRole.host != widget.config.role &&
          // 0 index is for host
          widget.seatManager.hostIndex != index) {
        /// local is not a host, because host is fixed and default on
        /// so local user can take on or switch seat if not a host
        popupItems.add(PopupItem(
          PopupItemValue.takeOnSeat,
          widget.config.translationText.takeSeatMenuButton,
          data: index,
        ));
      }
    } else {
      if (ZegoLiveAudioRoomRole.host == widget.config.role &&
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
          widget.seatManager.getUserByIndex(index)?.id) {
        /// local leave seat
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
      popupItems: popupItems,
      seatManager: widget.seatManager,
      translationText: widget.config.translationText,
    );
  }

  Widget hostFlag(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(maxWidth, 23.r)),
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
          fontSize: 22.0.r,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
