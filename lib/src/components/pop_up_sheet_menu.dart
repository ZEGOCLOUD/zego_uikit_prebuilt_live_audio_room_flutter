// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';

class ZegoPopUpSheetMenu extends StatefulWidget {
  const ZegoPopUpSheetMenu({
    Key? key,
    required this.popupItems,
    required this.translationText,
    required this.seatManager,
    this.onPressed,
  }) : super(key: key);

  final List<PopupItem> popupItems;
  final ZegoLiveSeatManager seatManager;
  final void Function(PopupItemValue)? onPressed;
  final ZegoTranslationText translationText;

  @override
  State<ZegoPopUpSheetMenu> createState() => _ZegoPopUpSheetMenuState();
}

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
    return LayoutBuilder(builder: ((context, constraints) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.popupItems.length,
          itemBuilder: (context, index) {
            var popupItem = widget.popupItems[index];
            return popUpItemWidget(index, popupItem);
          },
        ),
      );
    }));
  }

  Widget popUpItemWidget(int index, PopupItem popupItem) {
    return GestureDetector(
      onTap: () async {
        ZegoLoggerService.logInfo(
          "click ${popupItem.text}",
          tag: "audio room",
          subTag: "pop-up sheet",
        );

        Navigator.of(context).pop();

        switch (popupItem.value) {
          case PopupItemValue.takeOnSeat:
            widget.seatManager.takeOnSeat(
              popupItem.data as int,
              isForce: false,
              isDeleteAfterOwnerLeft: true,
            );
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
          default:
            break;
        }

        widget.onPressed?.call(popupItem.value);
      },
      child: Container(
        width: double.infinity,
        height: 100.r,
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
              fontSize: 28.r,
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
  required ZegoTranslationText translationText,
  required ZegoLiveSeatManager seatManager,
}) {
  seatManager.setPopUpSheetVisible(true);

  var takeOffSeatItemIndex = popupItems
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
        topLeft: Radius.circular(32.0.r),
        topRight: Radius.circular(32.0.r),
      ),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 50),
        child: Container(
          height: (101 * popupItems.length).r,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: ZegoPopUpSheetMenu(
            popupItems: popupItems,
            translationText: translationText,
            seatManager: seatManager,
          ),
        ),
      );
    },
  ).whenComplete(() {
    seatManager.setPopUpSheetVisible(false);
  });
}
