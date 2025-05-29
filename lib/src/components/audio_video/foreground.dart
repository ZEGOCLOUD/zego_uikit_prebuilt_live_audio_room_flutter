// Dart imports:

// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_sheet_menu.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.defines.dart';
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
        child: foreground(
          context,
          widget.size,
          ZegoUIKit().getUser(widget.user?.id ?? ''),
          widget.extraInfo,
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
    final customForeground = widget.config.seat.foregroundBuilder?.call(
      context,
      widget.size,
      ZegoUIKit().getUser(widget.user?.id ?? ''),
      widget.extraInfo,
    );

    return !widget.config.seat.keepOriginalForeground &&
            null != customForeground
        ? customForeground
        : LayoutBuilder(
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
                  customForeground ?? Container(),
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
        tag: 'audio-room',
        subTag: 'foreground',
      );
      return;
    }

    if (widget.events.seat.onClicked != null) {
      ZegoLoggerService.logInfo(
        'WARN!!! click seat event is deal outside',
        tag: 'audio-room',
        subTag: 'foreground',
      );

      widget.events.seat.onClicked!.call(index, widget.user);
      return;
    }

    final popupItems = <ZegoLiveAudioRoomPopupItem>[];
    void addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem item) {
      if (widget.config.popUpMenu.seatClicked.hiddenMenus.contains(
          ZegoLiveAudioRoomPopupItemValueExtension.fromIndex(item.index))) {
        ZegoLoggerService.logInfo(
          'pop up menu of ${item.text} is hide by \'config.popUpMenu.seatClicked.hiddenMenus\', '
          'which is ${widget.config.popUpMenu.seatClicked.hiddenMenus}',
          tag: 'audio-room',
          subTag: 'foreground',
        );

        return;
      }

      popupItems.add(item);
    }

    final isEmptySeat = null == widget.user;
    if (isEmptySeat) {
      /// forbid host switch seat and speaker/audience take locked seat
      if (!widget.seatManager.localIsAHost &&
          !widget.seatManager.isAHostSeat(index)) {
        final isLocalUserOnSeat = -1 !=
            widget.seatManager.getIndexByUserID(ZegoUIKit().getLocalUser().id);
        if (isLocalUserOnSeat) {
          if (widget.config.seat.canAutoSwitchOnClicked?.call(index) ?? true) {
            /// auto switch
            widget.seatManager.switchToSeat(index);
          } else {
            addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem(
              ZegoLiveAudioRoomPopupItemValue.switchSeat.index,
              widget.config.innerText.switchSeatMenuButton,
              data: index,
            ));
          }
        } else {
          final isSeatIndexLocked =
              widget.seatManager.lockedSeatNotifier.value.contains(index);
          if (!isSeatIndexLocked) {
            /// only room seat is not locked and index is not in locked seats
            /// if locked, can't apply by click seat
            addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem(
              ZegoLiveAudioRoomPopupItemValue.takeOnSeat.index,
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

        /// host can kick others off seat
        addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem(
          ZegoLiveAudioRoomPopupItemValue.takeOffSeat.index,
          widget.config.innerText.removeSpeakerMenuDialogButton.replaceFirst(
            widget.config.innerText.param_1,
            widget.user?.name ?? '',
          ),
          data: index,
        ));

        /// host can mute others

        addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem(
          ZegoLiveAudioRoomPopupItemValue.muteSeat.index,
          widget.config.innerText.muteSpeakerMenuDialogButton.replaceFirst(
            widget.config.innerText.param_1,
            widget.user?.name ?? '',
          ),
          data: index,
        ));

        if (widget.seatManager.localIsAHost) {
          ///
          // addPopUpItemWithFilterConfig(PopupItem(
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
            addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem(
              ZegoLiveAudioRoomPopupItemValue.revokeCoHost.index,
              widget.config.innerText.revokeCoHostPrivilegesMenuDialogButton
                  .replaceFirst(
                widget.config.innerText.param_1,
                widget.user?.name ?? '',
              ),
              data: widget.user?.id ?? '',
            ));
          } else if (widget.seatManager.isSpeaker(widget.user)) {
            /// host can specify one speaker be a co-host if no co-host now
            addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem(
              ZegoLiveAudioRoomPopupItemValue.assignCoHost.index,
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
        addPopUpItemWithFilterConfig(ZegoLiveAudioRoomPopupItem(
          ZegoLiveAudioRoomPopupItemValue.leaveSeat.index,
          widget.config.innerText.leaveSeatDialogInfo.title,
        ));
      }
    }

    addCustomPopMenuItems(
      seatIndex: index,
      currentPopupItems: popupItems,
    );

    if (popupItems.isEmpty) {
      return;
    }

    popupItems.add(ZegoLiveAudioRoomPopupItem(
      ZegoLiveAudioRoomPopupItemValue.cancel.index,
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

  void addCustomPopMenuItems({
    required int seatIndex,
    required List<ZegoLiveAudioRoomPopupItem> currentPopupItems,
  }) {
    int addCustomPopUpMenu({
      required int menuStartIndex,
      required List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo> extendMenus,
    }) {
      for (var emptyExtendMenu in extendMenus) {
        menuStartIndex += 1;
        final event = ZegoLiveAudioRoomPopUpSeatClickedMenuEvent(
          index: seatIndex,
          isAHostSeat: widget.seatManager.isAHostSeat(seatIndex),
          isRoomSeatLocked: widget.seatManager.isRoomSeatLockedNotifier.value,
          data: emptyExtendMenu.data,
          localIsCoHost: widget.seatManager.localIsCoHost,
          localRole: widget.seatManager.localRole.value,
          localUser: ZegoUIKit().getLocalUser(),
          targetIsCoHost: widget.seatManager.isCoHost(widget.user),
          targetRole: widget.seatManager.getRole(widget.user),
          targetUser: widget.user,
        );
        currentPopupItems.add(
          ZegoLiveAudioRoomPopupItem(
            menuStartIndex,
            emptyExtendMenu.title,
            data: emptyExtendMenu.data,
            onPressed: () {
              emptyExtendMenu.onClicked.call(event);
            },
          ),
        );
      }
      return menuStartIndex;
    }

    var customIndex = ZegoLiveAudioRoomPopupItemValue.customStartIndex.index;
    if (null == widget.user) {
      customIndex = addCustomPopUpMenu(
        menuStartIndex: customIndex,
        extendMenus: widget.config.popUpMenu.seatClicked.emptyExtendMenus,
      );
    } else {
      if (widget.seatManager.isCoHost(widget.user)) {
        customIndex = addCustomPopUpMenu(
          menuStartIndex: customIndex,
          extendMenus: widget.config.popUpMenu.seatClicked.coHostExtendMenus,
        );
      } else {
        switch (widget.seatManager.getRole(widget.user)) {
          case ZegoLiveAudioRoomRole.host:
            customIndex = addCustomPopUpMenu(
              menuStartIndex: customIndex,
              extendMenus: widget.config.popUpMenu.seatClicked.hostExtendMenus,
            );
            break;
          case ZegoLiveAudioRoomRole.speaker:
            customIndex = addCustomPopUpMenu(
              menuStartIndex: customIndex,
              extendMenus:
                  widget.config.popUpMenu.seatClicked.speakerExtendMenus,
            );
            break;
          case ZegoLiveAudioRoomRole.audience:
            customIndex = addCustomPopUpMenu(
              menuStartIndex: customIndex,
              extendMenus:
                  widget.config.popUpMenu.seatClicked.audienceExtendMenus,
            );
            break;
        }
      }
    }
  }

  Widget hostFlag(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(maxWidth, seatHostFlagHeight)),
      child: Center(
        child: widget.config.seat.hostRoleIcon ??
            ZegoLiveAudioRoomImage.asset(
              ZegoLiveAudioRoomIconUrls.seatHost,
            ),
      ),
    );
  }

  Widget coHostFlag(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(maxWidth, seatHostFlagHeight)),
      child: Center(
        child: widget.config.seat.coHostRoleIcon ??
            ZegoLiveAudioRoomImage.asset(
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
              child: widget.config.seat.microphoneOffIcon ??
                  ZegoLiveAudioRoomImage.asset(
                    ZegoLiveAudioRoomIconUrls.seatMicrophoneOff,
                  ),
            ),
          );
  }
}
