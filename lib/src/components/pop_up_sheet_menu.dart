// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';

/// @nodoc
class ZegoPopUpSheetMenu extends StatefulWidget {
  const ZegoPopUpSheetMenu({
    Key? key,
    required this.popupItems,
    required this.innerText,
    required this.seatManager,
    required this.connectManager,
    this.onPressed,
  }) : super(key: key);

  final List<PopupItem> popupItems;
  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;

  final void Function(PopupItemValue)? onPressed;
  final ZegoInnerText innerText;

  @override
  State<ZegoPopUpSheetMenu> createState() => _ZegoPopUpSheetMenuState();
}

/// @nodoc
class _ZegoPopUpSheetMenuState extends State<ZegoPopUpSheetMenu> {
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
    return LayoutBuilder(builder: (context, constraints) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.popupItems.length,
          itemBuilder: (context, index) {
            final popupItem = widget.popupItems[index];
            return popUpItemWidget(index, popupItem);
          },
        ),
      );
    });
  }

  Widget popUpItemWidget(int index, PopupItem popupItem) {
    return GestureDetector(
      onTap: () async {
        ZegoLoggerService.logInfo(
          'click ${popupItem.text}',
          tag: 'audio room',
          subTag: 'pop-up sheet',
        );

        Navigator.of(
          context,
          rootNavigator: widget.seatManager.config.rootNavigator,
        ).pop();

        switch (popupItem.value) {
          case PopupItemValue.takeOnSeat:
            if (widget.seatManager.isSeatLockedNotifier.value) {
              ZegoLoggerService.logInfo(
                'take on seat, but seat is locked',
                tag: 'audio room',
                subTag: 'seat manager',
              );
            } else {
              widget.seatManager.takeOnSeat(
                popupItem.data as int,
                isForce: false,
                isDeleteAfterOwnerLeft: true,
              );
            }
            break;
          case PopupItemValue.takeOffSeat:
            // clear popup sheet info
            widget.seatManager
                .setKickSeatDialogInfo(KickSeatDialogInfo.empty());
            await widget.seatManager.kickSeat(popupItem.data as int);
            break;
          case PopupItemValue.leaveSeat:
            await widget.seatManager.leaveSeat(showDialog: true);
            break;
          case PopupItemValue.muteSeat:
            await widget.seatManager.muteSeat(popupItem.data as int);
            break;
          case PopupItemValue.inviteLink:
            await widget.connectManager.inviteAudienceConnect(
              ZegoUIKit().getUser(popupItem.data as String? ?? ''),
            );
            break;
          case PopupItemValue.assignCoHost:
            await widget.seatManager.assignCoHost(
              roomID: widget.seatManager.roomID,
              targetUser: ZegoUIKit().getUser(popupItem.data as String? ?? ''),
            );
            break;
          case PopupItemValue.revokeCoHost:
            await widget.seatManager.revokeCoHost(
              roomID: widget.seatManager.roomID,
              targetUser: ZegoUIKit().getUser(popupItem.data as String? ?? ''),
            );
            break;
            // case PopupItemValue.kickOut:
            //   ZegoUIKit().removeUserFromRoom(
            //       [popupItem.data as String? ?? '']).then((result) {
            //     ZegoLoggerService.logInfo(
            //       'kick out result:$result',
            //       tag: 'live audio room',
            //       subTag: 'pop-up sheet',
            //     );
            //   });
            break;
          case PopupItemValue.cancel:
            break;
        }

        widget.onPressed?.call(popupItem.value);
      },
      child: Container(
        width: double.infinity,
        height: 100.zR,
        decoration: BoxDecoration(
          border: (index == (widget.popupItems.length - 1))
              ? null
              : Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
        ),
        child: Center(
          child: Text(
            popupItem.text,
            style: TextStyle(
              fontSize: 28.zR,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

void showPopUpSheet({
  required String userID,
  required BuildContext context,
  required List<PopupItem> popupItems,
  required ZegoInnerText innerText,
  required ZegoLiveSeatManager seatManager,
  required ZegoLiveConnectManager connectManager,
  required ZegoPopUpManager popUpManager,
}) {
  final key = DateTime.now().millisecondsSinceEpoch;
  popUpManager.addAPopUpSheet(key);

  seatManager.setPopUpSheetVisible(true);

  final takeOffSeatItemIndex = popupItems
      .indexWhere((popupItem) => popupItem.value == PopupItemValue.takeOffSeat);
  if (-1 != takeOffSeatItemIndex) {
    /// seat user leave, will auto pop this sheet
    seatManager.setKickSeatDialogInfo(
      KickSeatDialogInfo(
        userIndex: popupItems[takeOffSeatItemIndex].data as int,
        userID: userID,
      ),
    );
  }

  showModalBottomSheet(
    barrierColor: ZegoUIKitDefaultTheme.viewBarrierColor,
    backgroundColor: const Color(0xff111014),
    //ZegoUIKitDefaultTheme.viewBackgroundColor,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0.zR),
        topRight: Radius.circular(32.0.zR),
      ),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 50),
        child: Container(
          height: (popupItems.length * 101).zR,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: ZegoPopUpSheetMenu(
            popupItems: popupItems,
            innerText: innerText,
            seatManager: seatManager,
            connectManager: connectManager,
          ),
        ),
      );
    },
  ).whenComplete(() {
    final takeOffSeatItemIndex = popupItems.indexWhere(
        (popupItem) => popupItem.value == PopupItemValue.takeOffSeat);
    if (-1 != takeOffSeatItemIndex) {
      /// clear kickSeatDialogInfo
      if (seatManager.kickSeatDialogInfo.isExist(
        userID: seatManager.seatsUserMapNotifier
                .value[seatManager.kickSeatDialogInfo.userIndex.toString()] ??
            '',
        userIndex: seatManager.kickSeatDialogInfo.userIndex,
        allSame: true,
      )) {
        ZegoLoggerService.logInfo(
          'clear seat dialog info when popup sheet complete',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        seatManager.kickSeatDialogInfo.clear();
      }
    }

    popUpManager.removeAPopUpSheet(key);
    seatManager.setPopUpSheetVisible(false);
  });
}
