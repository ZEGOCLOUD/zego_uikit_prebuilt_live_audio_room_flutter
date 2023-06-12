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
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';

/// @nodoc
class ZegoSeatForeground extends StatefulWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final Map<String, dynamic> extraInfo;

  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoPopUpManager popUpManager;
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
    required this.popUpManager,
    required this.config,
  }) : super(key: key);

  @override
  State<ZegoSeatForeground> createState() => _ZegoSeatForegroundState();
}

/// @nodoc
class _ZegoSeatForegroundState extends State<ZegoSeatForeground> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
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
      if (widget.seatManager.hasHostPermissions &&
          widget.user?.id != ZegoUIKit().getLocalUser().id) {
        /// local is host, click others
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
            popupItems.add(PopupItem(
              PopupItemValue.revokeCoHost,
              widget.config.innerText.revokeCoHostPrivilegesMenuDialogButton
                  .replaceFirst(
                widget.config.innerText.param_1,
                widget.user?.name ?? '',
              ),
              data: widget.user?.id ?? '',
            ));
          } else if (widget.seatManager.isSpeaker(widget.user)) {
            /// host can specify one speaker be a co-host if no co-host now
            popupItems.add(PopupItem(
              PopupItemValue.assignCoHost,
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
      popUpManager: widget.popUpManager,
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

  Widget coHostFlag(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(maxWidth, seatHostFlagHeight)),
      child: Center(
        child: PrebuiltLiveAudioRoomImage.asset(
          PrebuiltLiveAudioRoomIconUrls.seatCoHost,
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
              child: PrebuiltLiveAudioRoomImage.asset(
                PrebuiltLiveAudioRoomIconUrls.seatMicrophoneOff,
              ),
            ),
          );
  }
}
