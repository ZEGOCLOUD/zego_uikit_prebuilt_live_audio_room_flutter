// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/member/list_sheet.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';

/// @nodoc
class ZegoMemberButton extends StatefulWidget {
  const ZegoMemberButton({
    Key? key,
    this.avatarBuilder,
    this.itemBuilder,
    required this.isPluginEnabled,
    required this.seatManager,
    required this.connectManager,
    required this.popUpManager,
    required this.innerText,
    required this.onMoreButtonPressed,
    this.hiddenUserIDsNotifier,
    this.iconSize,
    this.buttonSize,
    this.icon,
  }) : super(key: key);

  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoMemberListItemBuilder? itemBuilder;

  final bool isPluginEnabled;
  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoPopUpManager popUpManager;
  final ValueNotifier<List<String>>? hiddenUserIDsNotifier;
  final ZegoInnerText innerText;

  final Size? iconSize;
  final Size? buttonSize;
  final ButtonIcon? icon;

  final ZegoMemberListSheetMoreButtonPressed? onMoreButtonPressed;

  @override
  State<ZegoMemberButton> createState() => _ZegoMemberButtonState();
}

/// @nodoc
class _ZegoMemberButtonState extends State<ZegoMemberButton> {
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
    final containerSize = widget.buttonSize ?? Size(96.zR, 96.zR);
    final sizeBoxSize = widget.iconSize ?? Size(56.zR, 56.zR);

    return GestureDetector(
      onTap: () {
        showMemberListSheet(
          context: context,
          avatarBuilder: widget.avatarBuilder,
          itemBuilder: widget.itemBuilder,
          isPluginEnabled: widget.isPluginEnabled,
          seatManager: widget.seatManager,
          connectManager: widget.connectManager,
          popUpManager: widget.popUpManager,
          innerText: widget.innerText,
          onMoreButtonPressed: widget.onMoreButtonPressed,
          hiddenUserIDsNotifier: widget.hiddenUserIDsNotifier,
        );
      },
      child: Stack(
        children: [
          Container(
            width: containerSize.width,
            height: containerSize.height,
            decoration: BoxDecoration(
              color: widget.icon?.backgroundColor ?? Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: SizedBox.fromSize(
              size: sizeBoxSize,
              child: widget.icon?.icon ??
                  PrebuiltLiveAudioRoomImage.asset(
                      PrebuiltLiveAudioRoomIconUrls.toolbarMember),
            ),
          ),
          redPoint(),
        ],
      ),
    );
  }

  Widget redPoint() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.seatManager.isSeatLockedNotifier,
      builder: (context, isSeatLocked, _) {
        if (!isSeatLocked) {
          /// if seat not locked, red point is hidden
          return Container();
        }

        return ValueListenableBuilder<List<ZegoUIKitUser>>(
          valueListenable:
              widget.connectManager.audiencesRequestingTakeSeatNotifier,
          builder: (context, requestTakeSeatUsers, _) {
            if (requestTakeSeatUsers.isEmpty) {
              return Container();
            } else {
              return Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  width: 20.zR,
                  height: 20.zR,
                ),
              );
            }
          },
        );
      },
    );
  }
}
