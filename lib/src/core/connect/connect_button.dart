// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/components.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';

/// @nodoc
class ZegoLiveAudioRoomAudienceConnectButton extends StatefulWidget {
  const ZegoLiveAudioRoomAudienceConnectButton({
    Key? key,
    required this.seatManager,
    required this.connectManager,
    required this.innerText,
  }) : super(key: key);
  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText;

  @override
  State<ZegoLiveAudioRoomAudienceConnectButton> createState() =>
      _ZegoLiveAudioRoomAudienceConnectButtonState();
}

/// @nodoc
class _ZegoLiveAudioRoomAudienceConnectButtonState
    extends State<ZegoLiveAudioRoomAudienceConnectButton> {
  ButtonIcon get buttonIcon => ButtonIcon(
        icon: ZegoLiveAudioRoomImage.asset(
            ZegoLiveAudioRoomIconUrls.toolbarAudienceConnect),
        backgroundColor: Colors.transparent,
      );

  TextStyle get buttonTextStyle => TextStyle(
        color: Colors.white,
        fontSize: 26.zR,
        fontWeight: FontWeight.w500,
      );

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
    return ValueListenableBuilder<bool>(
        valueListenable: widget.seatManager.isRoomSeatLockedNotifier,
        builder: (context, isRoomSeatLocked, _) {
          if (!isRoomSeatLocked) {
            return Container();
          }

          return ValueListenableBuilder<ZegoLiveAudioRoomRole>(
              valueListenable: widget.seatManager.localRole,
              builder: (context, localRole, _) {
                if (localRole != ZegoLiveAudioRoomRole.audience) {
                  return Container();
                }

                return ValueListenableBuilder<List<String>>(
                    valueListenable: widget.seatManager.hostsNotifier,
                    builder: (context, hosts, _) {
                      return ValueListenableBuilder<List<String>>(
                          valueListenable: widget.seatManager.coHostsNotifier,
                          builder: (context, coHosts, _) {
                            return ValueListenableBuilder<
                                    ZegoLiveAudioRoomConnectState>(
                                valueListenable: widget.connectManager
                                    .audienceLocalConnectStateNotifier,
                                builder: (context, connectState, _) {
                                  switch (connectState) {
                                    case ZegoLiveAudioRoomConnectState.idle:
                                      return requestConnectButton();
                                    case ZegoLiveAudioRoomConnectState
                                          .connecting:
                                      return cancelRequestConnectButton();
                                    case ZegoLiveAudioRoomConnectState
                                          .connected:
                                      return Container();
                                  }
                                });
                          });
                    });
              });
        });
  }

  Widget requestConnectButton() {
    final invitees = widget.seatManager.hostsNotifier.value.isNotEmpty
        ? widget.seatManager.hostsNotifier.value
        : widget.seatManager.coHostsNotifier.value;

    return ZegoStartInvitationButton(
      invitationType: ZegoLiveAudioRoomInvitationType.requestTakeSeat.value,
      invitees: invitees,
      data: '',
      icon: buttonIcon,
      buttonSize: Size(330.zR, 72.zR),
      iconSize: Size(48.zR, 48.zR),
      iconTextSpacing: 12.zR,
      text: widget.innerText.applyToTakeSeatButton,
      textStyle: buttonTextStyle,
      verticalLayout: false,
      onWillPressed: checkHostAndCoHostExist,
      onPressed: (
        String code,
        String message,
        String invitationID,
        List<String> errorInvitees,
      ) {
        if (code.isNotEmpty) {
          widget.connectManager.events.seat.audience?.onTakingRequestFailed
              ?.call();

          showDebugToast('Failed to apply for take seat, $code $message');
        } else {
          showDebugToast(
              'You are applying to take seat, please wait for confirmation.');

          widget.connectManager.updateAudienceConnectState(
              ZegoLiveAudioRoomConnectState.connecting);
        }
        //
      },
      clickableTextColor: Colors.white,
      clickableBackgroundColor: const Color(0xff1E2740).withOpacity(0.4),
    );
  }

  Widget cancelRequestConnectButton() {
    final invitees = widget.seatManager.hostsNotifier.value.isNotEmpty
        ? widget.seatManager.hostsNotifier.value
        : widget.seatManager.coHostsNotifier.value;

    return ZegoCancelInvitationButton(
      invitees: invitees,
      icon: buttonIcon,
      buttonSize: Size(330.zR, 72.zR),
      iconSize: Size(48.zR, 48.zR),
      iconTextSpacing: 12.zR,
      text: widget.innerText.cancelTheTakeSeatApplicationButton,
      textStyle: buttonTextStyle,
      verticalLayout: false,
      onPressed: (String code, String message, List<String> errorInvitees) {
        widget.connectManager
            .updateAudienceConnectState(ZegoLiveAudioRoomConnectState.idle);
        //
      },
      clickableTextColor: Colors.white,
      clickableBackgroundColor: const Color(0xff1E2740).withOpacity(0.4),
    );
  }

  bool checkHostExist({bool withToast = true}) {
    if (widget.seatManager.hostsNotifier.value.isEmpty) {
      if (withToast) {
        showDebugToast('Failed to apply for take seat, host is not exist');
      }
      return false;
    }

    return true;
  }

  Future<bool> checkHostAndCoHostExist({bool withToast = true}) async {
    if (widget.seatManager.hostsNotifier.value.isEmpty &&
        widget.seatManager.coHostsNotifier.value.isEmpty) {
      if (withToast) {
        showDebugToast('Failed to apply for take seat, host is not exist');
      }
      return false;
    }

    return true;
  }
}
