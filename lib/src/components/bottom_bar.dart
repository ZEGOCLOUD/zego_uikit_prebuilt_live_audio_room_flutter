// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/components.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'effects/sound_effect_button.dart';
import 'leave_button.dart';
import 'message/in_room_message_button.dart';

class ZegoBottomBar extends StatefulWidget {
  final Size buttonSize;
  final double height;

  final ZegoLiveSeatManager seatManager;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  const ZegoBottomBar({
    Key? key,
    required this.height,
    required this.config,
    required this.buttonSize,
    required this.seatManager,
  }) : super(key: key);

  @override
  State<ZegoBottomBar> createState() => _ZegoBottomBarState();
}

class _ZegoBottomBarState extends State<ZegoBottomBar> {
  List<ZegoMenuBarButtonName> buttons = [];
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
          widget.config.bottomMenuBarConfig.showInRoomMessageButton
              ? SizedBox(
                  height: 124.r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      zegoLiveButtonPadding,
                      const ZegoInRoomMessageButton(),
                    ],
                  ),
                )
              : const SizedBox(),
          ValueListenableBuilder<ZegoLiveAudioRoomRole>(
            valueListenable: widget.seatManager.localRole,
            builder: (context, role, _) {
              updateButtonsByRole();

              return rightToolbar(context);
            },
          ),
        ],
      ),
    );
  }

  Widget rightToolbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 120.0.r),
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...getDisplayButtons(context),
                zegoLiveButtonPadding,
                zegoLiveButtonPadding,
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDisplayButtons(BuildContext context) {
    List<Widget> buttonList = [...getDefaultButtons(context), ...extendButtons];

    List<Widget> displayButtonList = [];
    if (buttonList.length > widget.config.bottomMenuBarConfig.maxCount) {
      /// the list count exceeds the limit, so divided into two parts,
      /// one part display in the Menu bar, the other part display in the menu with more buttons
      displayButtonList =
          buttonList.sublist(0, widget.config.bottomMenuBarConfig.maxCount - 1);

      displayButtonList.add(
        buttonWrapper(
          child: ZegoMoreButton(
            menuButtonListFunc: () {
              List<Widget> buttonList = [
                ...getDefaultButtons(context, microphoneDefaultValueFunc: () {
                  return ZegoUIKit()
                      .getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id)
                      .value;
                }),
                ...extendButtons
              ];

              buttonList.removeRange(
                  0, widget.config.bottomMenuBarConfig.maxCount - 1);
              return buttonList;
            },
            icon: ButtonIcon(
              icon: PrebuiltLiveAudioRoomImage.asset(
                  PrebuiltLiveAudioRoomIconUrls.toolbarMore),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      );
    } else {
      displayButtonList = buttonList;
    }

    List<Widget> displayButtonsWithSpacing = [];
    for (var button in displayButtonList) {
      displayButtonsWithSpacing.add(button);
      displayButtonsWithSpacing.add(zegoLiveButtonPadding);
    }

    return displayButtonsWithSpacing;
  }

  Widget buttonWrapper({required Widget child, ZegoMenuBarButtonName? type}) {
    return SizedBox(
      width: widget.buttonSize.width,
      height: widget.buttonSize.height,
      child: child,
    );
  }

  List<Widget> getDefaultButtons(
    BuildContext context, {
    bool Function()? microphoneDefaultValueFunc,
  }) {
    if (buttons.isEmpty) {
      return [];
    }

    return buttons
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
    ZegoMenuBarButtonName type, {
    bool Function()? microphoneDefaultValueFunc,
  }) {
    var buttonSize = zegoLiveButtonSize;
    var iconSize = zegoLiveButtonIconSize;

    switch (type) {
      case ZegoMenuBarButtonName.showMemberListButton:
        return ZegoMemberButton(
          buttonSize: buttonSize,
          iconSize: iconSize,
          icon: ButtonIcon(
            icon: PrebuiltLiveAudioRoomImage.asset(
                PrebuiltLiveAudioRoomIconUrls.toolbarMember),
            backgroundColor: Colors.white,
          ),
          avatarBuilder: widget.config.seatConfig.avatarBuilder,
          seatManager: widget.seatManager,
          translationText: widget.config.translationText,
        );
      case ZegoMenuBarButtonName.toggleMicrophoneButton:
        var microphoneDefaultOn = widget.config.turnOnMicrophoneWhenJoining;
        var localUserID = ZegoUIKit().getLocalUser().id;
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
            icon: PrebuiltLiveAudioRoomImage.asset(
                PrebuiltLiveAudioRoomIconUrls.toolbarMicNormal),
            backgroundColor: Colors.white,
          ),
          offIcon: ButtonIcon(
            icon: PrebuiltLiveAudioRoomImage.asset(
                PrebuiltLiveAudioRoomIconUrls.toolbarMicOff),
            backgroundColor: Colors.white,
          ),
          defaultOn: microphoneDefaultOn,
        );
      case ZegoMenuBarButtonName.leaveButton:
        return ZegoLeaveAudioRoomButton(
          buttonSize: buttonSize,
          iconSize: iconSize,
          icon: ButtonIcon(
            icon: PrebuiltLiveAudioRoomImage.asset(
                PrebuiltLiveAudioRoomIconUrls.topQuit),
            backgroundColor: Colors.white,
          ),
          config: widget.config,
          seatManager: widget.seatManager,
        );
      case ZegoMenuBarButtonName.soundEffectButton:
        return ZegoSoundEffectButton(
          voiceChangeEffect: widget.config.audioEffectConfig.voiceChangeEffect,
          reverbEffect: widget.config.audioEffectConfig.reverbEffect,
          buttonSize: buttonSize,
          iconSize: iconSize,
          icon: ButtonIcon(
            icon: PrebuiltLiveAudioRoomImage.asset(
                PrebuiltLiveAudioRoomIconUrls.toolbarSoundEffect),
            backgroundColor: Colors.white,
          ),
        );
    }
  }

  void updateButtonsByRole() {
    switch (widget.seatManager.localRole.value) {
      case ZegoLiveAudioRoomRole.host:
        buttons = widget.config.bottomMenuBarConfig.hostButtons;
        extendButtons = widget.config.bottomMenuBarConfig.hostExtendButtons;
        break;
      case ZegoLiveAudioRoomRole.speaker:
        buttons = widget.config.bottomMenuBarConfig.speakerButtons;
        extendButtons = widget.config.bottomMenuBarConfig.speakerExtendButtons;
        break;
      case ZegoLiveAudioRoomRole.audience:
        buttons = widget.config.bottomMenuBarConfig.audienceButtons;
        extendButtons = widget.config.bottomMenuBarConfig.audienceExtendButtons;
        break;
    }
  }
}
