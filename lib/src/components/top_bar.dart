// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/components.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/leave_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pip_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/mini_button.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/style.dart';

/// @nodoc
class ZegoLiveAudioRoomTopBar extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomStyle style;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;
  final void Function(ZegoLiveAudioRoomEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoLiveAudioRoomPopUpManager popUpManager;
  final ZegoUIKitPrebuiltLiveAudioRoomController? prebuiltController;

  final ZegoUIKitPrebuiltLiveAudioRoomInnerText translationText;

  final bool isPluginEnabled;
  final ZegoAvatarBuilder? avatarBuilder;

  const ZegoLiveAudioRoomTopBar({
    Key? key,
    required this.config,
    required this.style,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.seatManager,
    required this.connectManager,
    required this.popUpManager,
    required this.translationText,
    required this.prebuiltController,
    required this.isPluginEnabled,
    this.avatarBuilder,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomTopBar> createState() =>
      _ZegoLiveAudioRoomTopBarState();
}

/// @nodoc
class _ZegoLiveAudioRoomTopBarState extends State<ZegoLiveAudioRoomTopBar> {
  Widget get spacing => SizedBox(width: 10.zR);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      height: 80.zR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...pipButton(),
          ...minimizingButton(),
          const Expanded(child: SizedBox()),
          ...memberListButton(),
          closeButton(),
          SizedBox(width: 34.zR),
        ],
      ),
    );
  }

  Widget buttonWrapper(Widget button) {
    return Opacity(
      opacity: widget.style.opacity,
      child: button,
    );
  }

  List<Widget> pipButton() {
    return widget.config.topMenuBar.buttons
            .contains(ZegoLiveAudioRoomMenuBarButtonName.pipButton)
        ? [
            buttonWrapper(
              ZegoAudioRoomPIPButton(
                aspectWidth: widget.config.pip.aspectWidth,
                aspectHeight: widget.config.pip.aspectHeight,
              ),
            ),
            spacing,
          ]
        : [Container()];
  }

  List<Widget> minimizingButton() {
    return widget.config.topMenuBar.buttons
            .contains(ZegoLiveAudioRoomMenuBarButtonName.minimizingButton)
        ? [
            buttonWrapper(
              ZegoMinimizingButton(
                rootNavigator: widget.config.rootNavigator,
              ),
            ),
            spacing,
          ]
        : [Container()];
  }

  List<Widget> memberListButton() {
    return widget.config.topMenuBar.buttons
            .contains(ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton)
        ? [
            buttonWrapper(
              ZegoLiveAudioRoomMemberButton(
                buttonSize: Size(52.zR, 52.zR),
                iconSize: Size(24.zR, 24.zR),
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
                onMoreButtonPressed:
                    widget.events.memberList.onMoreButtonPressed,
                hiddenUserIDsNotifier: widget.prebuiltController?.private
                    .hiddenUsersOfMemberListNotifier,
              ),
            ),
            spacing,
          ]
        : [Container()];
  }

  Widget closeButton() {
    if (!widget.config.topMenuBar.buttons
        .contains(ZegoLiveAudioRoomMenuBarButtonName.leaveButton)) {
      return Container();
    }

    return buttonWrapper(
      ZegoLiveAudioRoomLeaveButton(
        buttonSize: Size(52.zR, 52.zR),
        iconSize: Size(24.zR, 24.zR),
        icon: ButtonIcon(
          icon: ZegoLiveAudioRoomImage.asset(ZegoLiveAudioRoomIconUrls.topQuit),
          backgroundColor: Colors.white,
        ),
        config: widget.config,
        events: widget.events,
        defaultEndAction: widget.defaultEndAction,
        defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
        seatManager: widget.seatManager,
      ),
    );
  }
}
