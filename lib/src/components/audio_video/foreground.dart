// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/audio_room_layout.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_sheet_menu.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class ZegoSeatForeground extends StatefulWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final Map<String, dynamic> extraInfo;

  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoLiveAudioRoomController? prebuiltController;

  const ZegoSeatForeground({
    Key? key,
    this.user,
    this.extraInfo = const {},
    this.prebuiltController,
    required this.size,
    required this.seatManager,
    required this.connectManager,
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
            ZegoUIKit().getInRoomUserAttributesNotifier(widget.user?.id ?? ''),
        builder: (context, inRoomAttributes, _) {
          return Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                widget.config.seatConfig.foregroundBuilder?.call(
                      context,
                      widget.size,
                      ZegoUIKit().getUser(widget.user?.id ?? ''),
                      widget.extraInfo,
                    ) ??
                    foreground(
                      context,
                      widget.size,
                      ZegoUIKit().getUser(widget.user?.id ?? ''),
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
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              color: widget.config.seatConfig.foregroundColor ??
                  Colors.transparent,
            ),
            Positioned(
              bottom: 0,
              child: userName(context, constraints.maxWidth),
            ),
            if (widget.seatManager.isAttributeHost(user))
              Positioned(
                top: seatItemHeight -
                    seatUserNameFontSize -
                    seatHostFlagHeight -
                    3.r, //  spacing
                child: hostFlag(context, constraints.maxWidth),
              )
            else
              Container(),
            ...null == widget.user ? [] : [microphoneOffFlag()],
          ],
        );
      },
    );
  }

  void onClicked() {
    final index =
        int.tryParse(widget.extraInfo[layoutGridItemIndexKey].toString()) ?? -1;
    if (-1 == index) {
      ZegoLoggerService.logInfo(
        'ERROR!!! click seat index is invalid',
        tag: 'audio room',
        subTag: 'foreground',
      );
      return;
    }

    if (widget.config.onSeatClicked != null) {
      ZegoLoggerService.logInfo(
        'ERROR!!! click seat event is deal outside',
        tag: 'audio room',
        subTag: 'foreground',
      );

      widget.config.onSeatClicked!.call(index, widget.user);
      return;
    }

    final popupItems = <PopupItem>[];

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
          if (!widget.seatManager.isSeatLockedNotifier.value) {
            /// only seat is not locked
            /// if locked, can't apply by click seat
            popupItems.add(PopupItem(
              PopupItemValue.takeOnSeat,
              widget.config.innerText.takeSeatMenuButton,
              data: index,
            ));
          }
        }
      }
    } else {
      /// have a user on seat
      if (ZegoLiveAudioRoomRole.host == widget.seatManager.localRole.value &&
          widget.user?.id != ZegoUIKit().getLocalUser().id) {
        popupItems

          /// host can kick others off seat
          ..add(PopupItem(
            PopupItemValue.takeOffSeat,
            widget.config.innerText.removeSpeakerMenuDialogButton.replaceFirst(
              widget.config.innerText.param_1,
              widget.user?.name ?? '',
            ),
            data: index,
          ))

          /// host can mute others
          ..add(PopupItem(
            PopupItemValue.muteSeat,
            widget.config.innerText.muteSpeakerMenuDialogButton.replaceFirst(
              widget.config.innerText.param_1,
              widget.user?.name ?? '',
            ),
            data: index,
          ));
      } else if (ZegoUIKit().getLocalUser().id ==
              widget.seatManager.getUserByIndex(index)?.id &&
          ZegoLiveAudioRoomRole.host != widget.seatManager.localRole.value) {
        /// speaker can local leave seat
        popupItems.add(PopupItem(
          PopupItemValue.leaveSeat,
          widget.config.innerText.leaveSeatDialogInfo.title,
        ));
      }
    }

    if (popupItems.isEmpty) {
      return;
    }

    popupItems.add(PopupItem(
      PopupItemValue.cancel,
      widget.config.innerText.cancelMenuDialogButton,
    ));

    showPopUpSheet(
      context: context,
      userID: widget.user?.id ?? '',
      popupItems: popupItems,
      seatManager: widget.seatManager,
      connectManager: widget.connectManager,
      innerText: widget.config.innerText,
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
        widget.user?.name ?? '',
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

  Widget microphoneOffFlag() {
    return ValueListenableBuilder<bool>(
      valueListenable:
          ZegoUIKit().getMicrophoneStateNotifier(widget.user?.id ?? ''),
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
