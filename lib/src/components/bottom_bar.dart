// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/components.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/effects/sound_effect_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/leave_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/message/input_board_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/host_lock_seat_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/mini_button.dart';

/// @nodoc
class ZegoLiveAudioRoomBottomBar extends StatefulWidget {
  final Size buttonSize;
  final double height;

  final bool isPluginEnabled;
  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoLiveAudioRoomPopUpManager popUpManager;
  final ZegoUIKitPrebuiltLiveAudioRoomController? prebuiltController;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;
  final void Function(ZegoLiveAudioRoomEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoAvatarBuilder? avatarBuilder;

  final ZegoUIKitPrebuiltLiveAudioRoomMinimizeData minimizeData;

  const ZegoLiveAudioRoomBottomBar({
    Key? key,
    this.avatarBuilder,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.isPluginEnabled,
    required this.seatManager,
    required this.connectManager,
    required this.popUpManager,
    required this.prebuiltController,
    required this.height,
    required this.buttonSize,
    required this.minimizeData,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomBottomBar> createState() =>
      _ZegoLiveAudioRoomBottomBarState();
}

/// @nodoc
class _ZegoLiveAudioRoomBottomBarState
    extends State<ZegoLiveAudioRoomBottomBar> {
  List<ZegoLiveAudioRoomMenuBarButtonName> buttons = [];
  List<Widget> extendButtons = [];

  @override
  void initState() {
    super.initState();

    updateButtonsByRole();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      height: widget.height,
      child: Stack(
        children: [
          rightToolbar(context),
          if (widget.config.bottomMenuBar.showInRoomMessageButton)
            SizedBox(
              height: 124.zR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  zegoLiveButtonPadding,
                  ZegoLiveAudioRoomInRoomMessageInputBoardButton(
                    innerText: widget.config.innerText,
                    rootNavigator: widget.config.rootNavigator,
                    onSheetPopUp: (int key) {
                      widget.popUpManager.addAPopUpSheet(key);
                    },
                    onSheetPop: (int key) {
                      widget.popUpManager.removeAPopUpSheet(key);
                    },
                  ),
                ],
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }

  Widget rightToolbar(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ValueListenableBuilder<bool>(
              valueListenable: widget.seatManager.isRoomSeatLockedNotifier,
              builder: (context, isRoomSeatLocked, _) {
                return ValueListenableBuilder<List<String>>(
                    valueListenable: widget.seatManager.hostsNotifier,
                    builder: (context, _, __) {
                      return ValueListenableBuilder<ZegoLiveAudioRoomRole>(
                          valueListenable: widget.seatManager.localRole,
                          builder: (context, localRole, _) {
                            updateButtonsByRole();

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...getDisplayButtons(
                                  context,
                                  isRoomSeatLocked,
                                  localRole,
                                ),
                                zegoLiveButtonPadding,
                                zegoLiveButtonPadding,
                              ],
                            );
                          });
                    });
              }),
        ),
      ],
    );
  }

  List<Widget> getDisplayButtons(
    BuildContext context,
    bool isRoomSeatLocked,
    ZegoLiveAudioRoomRole localRole,
  ) {
    final buttonList = <Widget>[
      ...getDefaultButtons(
        context,
        isRoomSeatLocked: isRoomSeatLocked,
        localRole: localRole,
        microphoneDefaultValueFunc: widget.minimizeData.isPrebuiltFromMinimizing
            ? () {
                /// if is minimizing, take the local device state
                return ZegoUIKit()
                    .getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id)
                    .value;
              }
            : null,
      ),
      ...extendButtons
    ];

    var displayButtonList = <Widget>[];
    if (buttonList.length > widget.config.bottomMenuBar.maxCount) {
      /// the list count exceeds the limit, so divided into two parts,
      /// one part display in the Menu bar, the other part display in the menu with more buttons
      displayButtonList = buttonList.sublist(
        0,
        widget.config.bottomMenuBar.maxCount - 1,
      )..add(
          buttonWrapper(
            child: ZegoMoreButton(
              menuButtonListFunc: () {
                final buttonList = <Widget>[
                  ...getDefaultButtons(
                    context,
                    isRoomSeatLocked: isRoomSeatLocked,
                    localRole: localRole,
                    microphoneDefaultValueFunc: () {
                      return ZegoUIKit()
                          .getMicrophoneStateNotifier(
                              ZegoUIKit().getLocalUser().id)
                          .value;
                    },
                  ),
                  ...extendButtons
                ]..removeRange(0, widget.config.bottomMenuBar.maxCount - 1);
                return buttonList;
              },
              icon: ButtonIcon(
                icon: ZegoLiveAudioRoomImage.asset(
                    ZegoLiveAudioRoomIconUrls.toolbarMore),
                backgroundColor: Colors.transparent,
              ),
              onSheetPopUp: (int key) {
                widget.popUpManager.addAPopUpSheet(key);
              },
              onSheetPop: (int key) {
                widget.popUpManager.removeAPopUpSheet(key);
              },
            ),
          ),
        );
    } else {
      displayButtonList = buttonList;
    }

    final displayButtonsWithSpacing = <Widget>[];
    for (final button in displayButtonList) {
      displayButtonsWithSpacing
        ..add(button)
        ..add(zegoLiveButtonPadding);
    }

    return displayButtonsWithSpacing;
  }

  Widget buttonWrapper(
      {required Widget child, ZegoLiveAudioRoomMenuBarButtonName? type}) {
    var buttonSize = widget.buttonSize;
    switch (type) {
      case ZegoLiveAudioRoomMenuBarButtonName.applyToTakeSeatButton:
        switch (widget.connectManager.audienceLocalConnectStateNotifier.value) {
          case ZegoLiveAudioRoomConnectState.idle:
            buttonSize = Size(330.zR, 72.zR);
            break;
          case ZegoLiveAudioRoomConnectState.connecting:
            buttonSize = Size(330.zR, 72.zR);
            break;
          case ZegoLiveAudioRoomConnectState.connected:
            buttonSize = Size(168.zR, 72.zR);
            break;
        }
        break;
      default:
        break;
    }

    return SizedBox(
      width: buttonSize.width,
      height: buttonSize.height,
      child: child,
    );
  }

  List<Widget> getDefaultButtons(
    BuildContext context, {
    required bool isRoomSeatLocked,
    required ZegoLiveAudioRoomRole localRole,
    bool Function()? microphoneDefaultValueFunc,
  }) {
    if (buttons.isEmpty) {
      return [];
    }

    return buttons
        .where((button) {
          if (isRoomSeatLocked) {
            if (localRole != ZegoLiveAudioRoomRole.audience &&
                ZegoLiveAudioRoomMenuBarButtonName.applyToTakeSeatButton ==
                    button) {
              /// if audience is on seat, then hide the applyToTakeSeatButton
              return false;
            }
            return true;
          }

          /// if seat is not locked, then hide the applyToTakeSeatButton
          return ZegoLiveAudioRoomMenuBarButtonName.applyToTakeSeatButton !=
              button;
        })
        .map((type) => buttonWrapper(
              child: generateDefaultButtonsByEnum(
                context,
                type,
                microphoneDefaultValueFunc: microphoneDefaultValueFunc,
              ),
              type: type,
            ))
        .toList();
  }

  Widget generateDefaultButtonsByEnum(
    BuildContext context,
    ZegoLiveAudioRoomMenuBarButtonName type, {
    bool Function()? microphoneDefaultValueFunc,
  }) {
    final buttonSize = zegoLiveButtonSize;
    final iconSize = zegoLiveButtonIconSize;

    switch (type) {
      case ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton:
        return ZegoLiveAudioRoomMemberButton(
          buttonSize: buttonSize,
          iconSize: iconSize,
          icon: ButtonIcon(
            icon: ZegoLiveAudioRoomImage.asset(
                ZegoLiveAudioRoomIconUrls.toolbarMember),
            backgroundColor: Colors.white,
          ),
          avatarBuilder: widget.avatarBuilder,
          itemBuilder: widget.config.memberList.itemBuilder,
          isPluginEnabled: widget.isPluginEnabled,
          seatManager: widget.seatManager,
          connectManager: widget.connectManager,
          popUpManager: widget.popUpManager,
          innerText: widget.config.innerText,
          onMoreButtonPressed: widget.events.memberList.onMoreButtonPressed,
          hiddenUserIDsNotifier: widget
              .prebuiltController?.private.hiddenUsersOfMemberListNotifier,
        );
      case ZegoLiveAudioRoomMenuBarButtonName.toggleMicrophoneButton:
        var microphoneDefaultOn = widget.config.turnOnMicrophoneWhenJoining;
        final localUserID = ZegoUIKit().getLocalUser().id;
        if (widget.seatManager.isAttributeHost(ZegoUIKit().getLocalUser()) ||
            widget.seatManager.seatsUserMapNotifier.value.values
                .contains(localUserID)) {
          microphoneDefaultOn = true;
        }

        microphoneDefaultOn =
            microphoneDefaultValueFunc?.call() ?? microphoneDefaultOn;

        return ZegoToggleMicrophoneButton(
          buttonSize: buttonSize,
          iconSize: iconSize,
          normalIcon: ButtonIcon(
            icon: ZegoLiveAudioRoomImage.asset(
                ZegoLiveAudioRoomIconUrls.toolbarMicNormal),
            backgroundColor: Colors.white,
          ),
          offIcon: ButtonIcon(
            icon: ZegoLiveAudioRoomImage.asset(
                ZegoLiveAudioRoomIconUrls.toolbarMicOff),
            backgroundColor: Colors.white,
          ),
          defaultOn: microphoneDefaultOn,
          muteMode: true,
        );
      case ZegoLiveAudioRoomMenuBarButtonName.leaveButton:
        return ZegoLiveAudioRoomLeaveButton(
          buttonSize: buttonSize,
          iconSize: iconSize,
          icon: ButtonIcon(
            icon:
                ZegoLiveAudioRoomImage.asset(ZegoLiveAudioRoomIconUrls.topQuit),
            backgroundColor: Colors.white,
          ),
          config: widget.config,
          events: widget.events,
          defaultEndAction: widget.defaultEndAction,
          defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
          seatManager: widget.seatManager,
        );
      case ZegoLiveAudioRoomMenuBarButtonName.soundEffectButton:
        return ZegoLiveAudioRoomSoundEffectButton(
          innerText: widget.config.innerText,
          voiceChangeEffect: widget.config.audioEffect.voiceChangeEffect,
          reverbEffect: widget.config.audioEffect.reverbEffect,
          buttonSize: buttonSize,
          iconSize: iconSize,
          icon: ButtonIcon(
            icon: ZegoLiveAudioRoomImage.asset(
                ZegoLiveAudioRoomIconUrls.toolbarSoundEffect),
            backgroundColor: Colors.white,
          ),
          rootNavigator: widget.config.rootNavigator,
          popUpManager: widget.popUpManager,
        );
      case ZegoLiveAudioRoomMenuBarButtonName.applyToTakeSeatButton:
        return ZegoLiveAudioRoomAudienceConnectButton(
          seatManager: widget.seatManager,
          connectManager: widget.connectManager,
          innerText: widget.seatManager.innerText,
        );
      case ZegoLiveAudioRoomMenuBarButtonName.closeSeatButton:
        return ZegoLiveAudioRoomHostLockSeatButton(
          buttonSize: buttonSize,
          iconSize: iconSize,
          seatManager: widget.seatManager,
        );
      case ZegoLiveAudioRoomMenuBarButtonName.minimizingButton:
        return ZegoMinimizingButton(
          rootNavigator: widget.config.rootNavigator,
        );
    }
  }

  void updateButtonsByRole() {
    switch (widget.seatManager.localRole.value) {
      case ZegoLiveAudioRoomRole.host:
        buttons = widget.config.bottomMenuBar.hostButtons;
        extendButtons = widget.config.bottomMenuBar.hostExtendButtons;
        break;
      case ZegoLiveAudioRoomRole.speaker:
        if (widget.seatManager.localHasHostPermissions) {
          /// co-hosts have the same permissions as hosts if host is not exist
          buttons = widget.config.bottomMenuBar.hostButtons;
          extendButtons = widget.config.bottomMenuBar.hostExtendButtons;
        } else {
          buttons = widget.config.bottomMenuBar.speakerButtons;
          extendButtons = widget.config.bottomMenuBar.speakerExtendButtons;
        }
        break;
      case ZegoLiveAudioRoomRole.audience:
        buttons = widget.config.bottomMenuBar.audienceButtons;
        extendButtons = widget.config.bottomMenuBar.audienceExtendButtons;
        break;
    }
  }
}
