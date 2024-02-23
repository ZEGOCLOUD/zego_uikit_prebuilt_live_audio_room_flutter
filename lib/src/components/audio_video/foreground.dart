// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/audio_room_layout.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_sheet_menu.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';

/// @nodoc
class ZegoLiveAudioRoomSeatForeground extends StatefulWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final Map<String, dynamic> extraInfo;

  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoLiveAudioRoomPopUpManager popUpManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;
  final ZegoUIKitPrebuiltLiveAudioRoomController? prebuiltController;

  const ZegoLiveAudioRoomSeatForeground({
    Key? key,
    this.user,
    this.extraInfo = const {},
    this.prebuiltController,
    required this.size,
    required this.seatManager,
    required this.connectManager,
    required this.popUpManager,
    required this.config,
    required this.events,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomSeatForeground> createState() =>
      _ZegoLiveAudioRoomSeatForegroundState();
}

/// @nodoc
class _ZegoLiveAudioRoomSeatForegroundState
    extends State<ZegoLiveAudioRoomSeatForeground> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            widget.config.seat.foregroundBuilder?.call(
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
            Positioned(
              bottom: 0,
              child: userName(context, constraints.maxWidth),
            ),
            if (widget.seatManager.isAttributeHost(user))
              Positioned(
                top: seatItemHeight -
                    seatUserNameFontSize -
                    seatHostFlagHeight -
                    3.zR, //  spacing
                child: hostFlag(context, constraints.maxWidth),
              )
            else
              Container(),
            if (widget.seatManager.isCoHost(user))
              Positioned(
                top: seatItemHeight -
                    seatUserNameFontSize -
                    seatHostFlagHeight -
                    3.zR, //  spacing
                child: coHostFlag(context, constraints.maxWidth),
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

    if (widget.events.seat.onClicked != null) {
      ZegoLoggerService.logInfo(
        'ERROR!!! click seat event is deal outside',
        tag: 'audio room',
        subTag: 'foreground',
      );

      widget.events.seat.onClicked!.call(index, widget.user);
      return;
    }

    final popupItems = <ZegoLiveAudioRoomPopupItem>[];

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
          if (!widget.seatManager.lockedSeatNotifier.value.contains(index)) {
            /// only room seat is not locked and index is not in locked seats
            /// if locked, can't apply by click seat
            popupItems.add(ZegoLiveAudioRoomPopupItem(
              ZegoLiveAudioRoomPopupItemValue.takeOnSeat,
              widget.config.innerText.takeSeatMenuButton,
              data: index,
            ));
          }
        }
      }
    } else {
      /// have a user on seat
      if (widget.seatManager.localHasHostPermissions &&
          widget.user?.id != ZegoUIKit().getLocalUser().id) {
        /// local is host, click others
        popupItems

          /// host can kick others off seat
          ..add(ZegoLiveAudioRoomPopupItem(
            ZegoLiveAudioRoomPopupItemValue.takeOffSeat,
            widget.config.innerText.removeSpeakerMenuDialogButton.replaceFirst(
              widget.config.innerText.param_1,
              widget.user?.name ?? '',
            ),
            data: index,
          ))

          /// host can mute others
          ..add(ZegoLiveAudioRoomPopupItem(
            ZegoLiveAudioRoomPopupItemValue.muteSeat,
            widget.config.innerText.muteSpeakerMenuDialogButton.replaceFirst(
              widget.config.innerText.param_1,
              widget.user?.name ?? '',
            ),
            data: index,
          ));

        if (widget.seatManager.localIsAHost) {
          ///
          // popupItems.add(PopupItem(
          //   PopupItemValue.kickOut,
          //   widget.config.innerText.removeUserMenuDialogButton.replaceFirst(
          //     widget.config.innerText.param_1,
          //     widget.user?.name ?? '',
          //   ),
          //   data: widget.user?.id ?? '',
          // ));

          /// only support by host
          if (widget.seatManager.isCoHost(widget.user)) {
            /// host revoke a co-host
            popupItems.add(ZegoLiveAudioRoomPopupItem(
              ZegoLiveAudioRoomPopupItemValue.revokeCoHost,
              widget.config.innerText.revokeCoHostPrivilegesMenuDialogButton
                  .replaceFirst(
                widget.config.innerText.param_1,
                widget.user?.name ?? '',
              ),
              data: widget.user?.id ?? '',
            ));
          } else if (widget.seatManager.isSpeaker(widget.user)) {
            /// host can specify one speaker be a co-host if no co-host now
            popupItems.add(ZegoLiveAudioRoomPopupItem(
              ZegoLiveAudioRoomPopupItemValue.assignCoHost,
              widget.config.innerText.assignAsCoHostMenuDialogButton
                  .replaceFirst(
                widget.config.innerText.param_1,
                widget.user?.name ?? '',
              ),
              data: widget.user?.id ?? '',
            ));
          }
        }
      } else if (ZegoUIKit().getLocalUser().id ==
              widget.seatManager.getUserByIndex(index)?.id &&
          ZegoLiveAudioRoomRole.host != widget.seatManager.localRole.value) {
        /// local is not a host, kick self

        /// speaker can local leave seat
        popupItems.add(ZegoLiveAudioRoomPopupItem(
          ZegoLiveAudioRoomPopupItemValue.leaveSeat,
          widget.config.innerText.leaveSeatDialogInfo.title,
        ));
      }
    }

    if (popupItems.isEmpty) {
      return;
    }

    popupItems.add(ZegoLiveAudioRoomPopupItem(
      ZegoLiveAudioRoomPopupItemValue.cancel,
      widget.config.innerText.cancelMenuDialogButton,
    ));

    showPopUpSheet(
      context: context,
      userID: widget.user?.id ?? '',
      popupItems: popupItems,
      seatManager: widget.seatManager,
      connectManager: widget.connectManager,
      popUpManager: widget.popUpManager,
      innerText: widget.config.innerText,
    );
  }

  Widget hostFlag(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(maxWidth, seatHostFlagHeight)),
      child: Center(
        child: ZegoLiveAudioRoomImage.asset(
          ZegoLiveAudioRoomIconUrls.seatHost,
        ),
      ),
    );
  }

  Widget coHostFlag(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(maxWidth, seatHostFlagHeight)),
      child: Center(
        child: ZegoLiveAudioRoomImage.asset(
          ZegoLiveAudioRoomIconUrls.seatCoHost,
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
    return widget.user?.microphone.value ?? false
        ? Container()
        : Positioned(
            top: avatarPosTop,
            left: 0,
            right: 0,
            child: Container(
              width: seatIconWidth,
              height: seatIconWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
              ),
              child: ZegoLiveAudioRoomImage.asset(
                ZegoLiveAudioRoomIconUrls.seatMicrophoneOff,
              ),
            ),
          );
  }
}
