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
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';

/// @nodoc
class ZegoAudienceConnectButton extends StatefulWidget {
  const ZegoAudienceConnectButton({
    Key? key,
    required this.seatManager,
    required this.connectManager,
    required this.innerText,
  }) : super(key: key);
  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoInnerText innerText;

  @override
  State<ZegoAudienceConnectButton> createState() =>
      _ZegoAudienceConnectButtonState();
}

/// @nodoc
class _ZegoAudienceConnectButtonState extends State<ZegoAudienceConnectButton> {
  ButtonIcon get buttonIcon => ButtonIcon(
        icon: PrebuiltLiveAudioRoomImage.asset(
            PrebuiltLiveAudioRoomIconUrls.toolbarAudienceConnect),
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
        valueListenable: widget.seatManager.isSeatLockedNotifier,
        builder: (context, isSeatLocked, _) {
          if (!isSeatLocked) {
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
                            return ValueListenableBuilder<ConnectState>(
                                valueListenable: widget.connectManager
                                    .audienceLocalConnectStateNotifier,
                                builder: (context, connectState, _) {
                                  switch (connectState) {
                                    case ConnectState.idle:
                                      return requestConnectButton();
                                    case ConnectState.connecting:
                                      return cancelRequestConnectButton();
                                    case ConnectState.connected:
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
      invitationType: ZegoInvitationType.requestTakeSeat.value,
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
          widget.connectManager.config.onSeatTakingRequestFailed?.call();

          showDebugToast('Failed to apply for take seat, $code $message');
        } else {
          showDebugToast(
              'You are applying to take seat, please wait for confirmation.');

          widget.connectManager
              .updateAudienceConnectState(ConnectState.connecting);
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
        widget.connectManager.updateAudienceConnectState(ConnectState.idle);
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
