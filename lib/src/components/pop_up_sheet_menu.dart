// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';

/// @nodoc
class ZegoLiveAudioRoomPopUpSheetMenu extends StatefulWidget {
  const ZegoLiveAudioRoomPopUpSheetMenu({
    Key? key,
    required this.popupItems,
    required this.innerText,
    required this.seatManager,
    required this.connectManager,
    this.onPressed,
  }) : super(key: key);

  final List<ZegoLiveAudioRoomPopupItem> popupItems;
  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;

  final void Function(ZegoLiveAudioRoomPopupItemValue)? onPressed;
  final ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText;

  @override
  State<ZegoLiveAudioRoomPopUpSheetMenu> createState() =>
      _ZegoLiveAudioRoomPopUpSheetMenuState();
}

/// @nodoc
class _ZegoLiveAudioRoomPopUpSheetMenuState
    extends State<ZegoLiveAudioRoomPopUpSheetMenu> {
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

  Widget popUpItemWidget(int index, ZegoLiveAudioRoomPopupItem popupItem) {
    return GestureDetector(
      onTap: () async {
        ZegoLoggerService.logInfo(
          'click ${popupItem.text} with ${popupItem.data}',
          tag: 'audio-room',
          subTag: 'pop-up sheet',
        );

        Navigator.of(
          context,
          rootNavigator: widget.seatManager.config.rootNavigator,
        ).pop();

        if (ZegoLiveAudioRoomPopupItemValue.takeOnSeat.index ==
            popupItem.index) {
          widget.seatManager.takeOnSeat(
            popupItem.data as int,
            ignoreLocked: false,
            isForce: false,
            isDeleteAfterOwnerLeft: true,
          );
        } else if (ZegoLiveAudioRoomPopupItemValue.takeOffSeat.index ==
            popupItem.index) {
          // clear popup sheet info
          widget.seatManager.setKickSeatDialogInfo(KickSeatDialogInfo.empty());
          await widget.seatManager.kickSeat(popupItem.data as int);
        } else if (ZegoLiveAudioRoomPopupItemValue.switchSeat.index ==
            popupItem.index) {
          await widget.seatManager.switchToSeat(popupItem.data as int);
        } else if (ZegoLiveAudioRoomPopupItemValue.leaveSeat.index ==
            popupItem.index) {
          await widget.seatManager.leaveSeat(showDialog: true);
        } else if (ZegoLiveAudioRoomPopupItemValue.muteSeat.index ==
            popupItem.index) {
          await widget.seatManager.muteSeat(
            popupItem.data as int,
            muted: true,
          );
        } else if (ZegoLiveAudioRoomPopupItemValue.unMuteSeat.index ==
            popupItem.index) {
          await widget.seatManager.muteSeat(
            popupItem.data as int,
            muted: false,
          );
        } else if (ZegoLiveAudioRoomPopupItemValue.inviteLink.index ==
            popupItem.index) {
          await widget.connectManager.inviteAudienceConnect(
            ZegoUIKit().getUser(popupItem.data as String? ?? ''),
          );
        } else if (ZegoLiveAudioRoomPopupItemValue.assignCoHost.index ==
            popupItem.index) {
          await widget.seatManager.assignCoHost(
            roomID: widget.seatManager.roomID,
            targetUser: ZegoUIKit().getUser(popupItem.data as String? ?? ''),
          );
        } else if (ZegoLiveAudioRoomPopupItemValue.revokeCoHost.index ==
            popupItem.index) {
          await widget.seatManager.revokeCoHost(
            roomID: widget.seatManager.roomID,
            targetUser: ZegoUIKit().getUser(popupItem.data as String? ?? ''),
          );
        } else if (ZegoLiveAudioRoomPopupItemValue.cancel.index ==
            popupItem.index) {
          /// do nothing
        } else if (popupItem.index >=
            ZegoLiveAudioRoomPopupItemValue.customStartIndex.index) {
          /// custom menu
          popupItem.onPressed?.call();
        }

        widget.onPressed?.call(
          ZegoLiveAudioRoomPopupItemValueExtension.fromIndex(popupItem.index),
        );
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
  required List<ZegoLiveAudioRoomPopupItem> popupItems,
  required ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText,
  required ZegoLiveAudioRoomSeatManager seatManager,
  required ZegoLiveAudioRoomConnectManager connectManager,
  required ZegoLiveAudioRoomPopUpManager popUpManager,
}) {
  final key = DateTime.now().millisecondsSinceEpoch;
  popUpManager.addAPopUpSheet(key);

  seatManager.setPopUpSheetVisible(true);

  final takeOffSeatItemIndex = popupItems.indexWhere(
    (popupItem) =>
        popupItem.index == ZegoLiveAudioRoomPopupItemValue.takeOffSeat.index,
  );
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
        child: SafeArea(
          child: Container(
            height: (popupItems.length * 101).zR,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: ZegoLiveAudioRoomPopUpSheetMenu(
              popupItems: popupItems,
              innerText: innerText,
              seatManager: seatManager,
              connectManager: connectManager,
            ),
          ),
        ),
      );
    },
  ).whenComplete(() {
    final takeOffSeatItemIndex = popupItems.indexWhere(
      (popupItem) =>
          popupItem.index == ZegoLiveAudioRoomPopupItemValue.takeOffSeat.index,
    );
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
          tag: 'audio-room',
          subTag: 'seat manager',
        );
        seatManager.kickSeatDialogInfo.clear();
      }
    }

    popUpManager.removeAPopUpSheet(key);
    seatManager.setPopUpSheetVisible(false);
  });
}
