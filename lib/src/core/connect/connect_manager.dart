// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/dialogs.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';

/// @nodoc
class ZegoLiveAudioRoomConnectManager {
  ZegoLiveAudioRoomConnectManager({
    required this.config,
    required this.events,
    required this.seatManager,
    required this.popUpManager,
    required this.innerText,
    required this.kickOutNotifier,
    this.contextQuery,
  }) {
    listenStream();
  }

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;
  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomPopUpManager popUpManager;
  final ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText;
  final ValueNotifier<bool> kickOutNotifier;
  BuildContext Function()? contextQuery;

  /// current audience connection state
  final audienceLocalConnectStateNotifier =
      ValueNotifier<ZegoLiveAudioRoomConnectState>(
          ZegoLiveAudioRoomConnectState.idle);

  /// audiences which requesting to take seat
  final audiencesRequestingTakeSeatNotifier =
      ValueNotifier<List<ZegoUIKitUser>>([]);

  /// audiences which host invite to take seat
  final List<String> _audienceIDsInvitedTakeSeatByHost = [];

  bool _initialized = false;

  ///  invite dialog's visibility of audience
  bool _isInvitedTakeSeatDlgVisible = false;

  final List<StreamSubscription<dynamic>?> _subscriptions = [];

  void init() {
    if (_initialized) {
      ZegoLoggerService.logInfo(
        'had already init',
        tag: 'live audio',
        subTag: 'seat manager',
      );
      return;
    }

    _initialized = true;

    ZegoLoggerService.logInfo(
      'init',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    _subscriptions
        .add(ZegoUIKit().getUserLeaveStream().listen(onUserListLeaveUpdated));
  }

  void uninit() {
    if (!_initialized) {
      ZegoLoggerService.logInfo(
        'not init before',
        tag: 'live audio',
        subTag: 'connect manager',
      );
    }

    _initialized = false;

    ZegoLoggerService.logInfo(
      'uninit',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    audienceLocalConnectStateNotifier.value =
        ZegoLiveAudioRoomConnectState.idle;
    audiencesRequestingTakeSeatNotifier.value = [];
    _isInvitedTakeSeatDlgVisible = false;
    _audienceIDsInvitedTakeSeatByHost.clear();

    for (final subscription in _subscriptions) {
      subscription?.cancel();
    }
  }

  void listenStream() {
    if (seatManager.plugins.plugins.isNotEmpty) {
      _subscriptions
        ..add(ZegoUIKit()
            .getSignalingPlugin()
            .getInvitationReceivedStream()
            .listen(onInvitationReceived))
        ..add(ZegoUIKit()
            .getSignalingPlugin()
            .getInvitationAcceptedStream()
            .listen(onInvitationAccepted))
        ..add(ZegoUIKit()
            .getSignalingPlugin()
            .getInvitationCanceledStream()
            .listen(onInvitationCanceled))
        ..add(ZegoUIKit()
            .getSignalingPlugin()
            .getInvitationRefusedStream()
            .listen(onInvitationRefused))
        ..add(ZegoUIKit()
            .getSignalingPlugin()
            .getInvitationTimeoutStream()
            .listen(onInvitationTimeout))
        ..add(ZegoUIKit()
            .getSignalingPlugin()
            .getInvitationResponseTimeoutStream()
            .listen(onInvitationResponseTimeout));
    }
  }

  Future<bool> inviteAudienceConnect(ZegoUIKitUser invitee) async {
    ZegoLoggerService.logInfo(
      'invite audience take seat, ${invitee.id} ${invitee.name}',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (invitee.isEmpty()) {
      ZegoLoggerService.logInfo(
        'invitee is empty',
        tag: 'live audio',
        subTag: 'connect manager',
      );
    }

    if (_audienceIDsInvitedTakeSeatByHost.contains(invitee.id)) {
      ZegoLoggerService.logInfo(
        'audience is inviting take seat',
        tag: 'live audio',
        subTag: 'connect manager',
      );
      return false;
    }

    _audienceIDsInvitedTakeSeatByHost.add(invitee.id);

    return ZegoUIKit()
        .getSignalingPlugin()
        .sendInvitation(
          inviterID: ZegoUIKit().getLocalUser().id,
          inviterName: ZegoUIKit().getLocalUser().name,
          invitees: [invitee.id],
          timeout: 60,
          type: ZegoLiveAudioRoomInvitationType.inviteToTakeSeat.value,
          data: '',
        )
        .then((result) {
      if (result.error != null) {
        _audienceIDsInvitedTakeSeatByHost.remove(invitee.id);

        events.seat.host?.onTakingInvitationFailed?.call();

        showDebugToast('Failed to invite take seat, please try again.');
      }

      return result.error != null;
    });
  }

  void clearAudienceIDsInvitedTakeSeatByHost() {
    ZegoLoggerService.logInfo(
      'clear audience ids invited take seat by host',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    _audienceIDsInvitedTakeSeatByHost.clear();
  }

  void onInvitationReceived(Map<String, dynamic> params) {
    if (seatManager.isLeavingRoom) {
      ZegoLoggerService.logInfo(
        'on invitation received, but is leaving room...',
        tag: 'live audio',
        subTag: 'connect manager',
      );
      return;
    }

    final ZegoUIKitUser inviter = params['inviter']!;
    final int type = params['type']!; // call type
    final String data = params['data']!; // extended field

    final invitationType =
        ZegoLiveAudioRoomInvitationTypeExtension.mapValue[type]!;

    ZegoLoggerService.logInfo(
      'on invitation received, inviter:$inviter,'
      ' $type($invitationType) $data',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (seatManager.localHasHostPermissions) {
      if (ZegoLiveAudioRoomInvitationType.requestTakeSeat == invitationType) {
        audiencesRequestingTakeSeatNotifier.value =
            List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
              ..add(inviter);

        events.seat.host?.onTakingRequested?.call(inviter);
      }
    } else {
      if (ZegoLiveAudioRoomInvitationType.inviteToTakeSeat == invitationType) {
        onAudienceReceivedTakeSeatInvitation(inviter);
      }
    }
  }

  void onAudienceReceivedTakeSeatInvitation(ZegoUIKitUser host) {
    if (_isInvitedTakeSeatDlgVisible) {
      ZegoLoggerService.logInfo(
        'invite to take seat dialog is visible',
        tag: 'live audio',
        subTag: 'connect manager',
      );
      return;
    }

    if (-1 != seatManager.getIndexByUserID(ZegoUIKit().getLocalUser().id)) {
      ZegoLoggerService.logInfo(
        'audience is take on seat now',
        tag: 'live audio',
        subTag: 'connect manager',
      );
      return;
    }

    events.seat.audience?.onTakingInvitationReceived?.call();

    /// self-cancellation if requesting when host invite you
    ZegoLoggerService.logInfo(
      'audience self-cancel take seat request if requesting',
      tag: 'live audio',
      subTag: 'connect manager',
    );
    audienceCancelTakeSeatRequest().then((value) {
      showAudienceReceivedTakeSeatInvitationDialog(host);
    });
  }

  void showAudienceReceivedTakeSeatInvitationDialog(ZegoUIKitUser host) {
    final translation = innerText.hostInviteTakeSeatDialog;

    final key = DateTime.now().millisecondsSinceEpoch;
    popUpManager.addAPopUpSheet(key);

    _isInvitedTakeSeatDlgVisible = true;
    showLiveDialog(
      context: contextQuery!.call(),
      title: translation.title,
      content: translation.message,
      leftButtonText: translation.cancelButtonName,
      leftButtonCallback: () {
        _isInvitedTakeSeatDlgVisible = false;

        ZegoUIKit()
            .getSignalingPlugin()
            .refuseInvitation(inviterID: host.id, data: '')
            .then((result) {
          ZegoLoggerService.logInfo(
            'refuse take seat invite, result:$result',
            tag: 'live audio',
            subTag: 'connect manager',
          );
        });

        Navigator.of(
          contextQuery!.call(),
          rootNavigator: config.rootNavigator,
        ).pop();
      },
      rightButtonText: translation.confirmButtonName,
      rightButtonCallback: () {
        _isInvitedTakeSeatDlgVisible = false;

        ZegoLoggerService.logInfo(
          'accept take seat invite',
          tag: 'live audio',
          subTag: 'connect manager',
        );

        ZegoUIKit()
            .getSignalingPlugin()
            .acceptInvitation(inviterID: host.id, data: '')
            .then((result) {
          ZegoLoggerService.logInfo(
            'accept take seat invite, result:$result',
            tag: 'live audio',
            subTag: 'connect manager',
          );

          if (result.error != null) {
            showDebugToast('accept take seat error: ${result.error}');
            return;
          }

          requestPermissions(
            context: contextQuery!.call(),
            isShowDialog: true,
            innerText: innerText,
            rootNavigator: config.rootNavigator,
            popUpManager: popUpManager,
            kickOutNotifier: kickOutNotifier,
          ).then((_) {
            /// agree host's host, take seat, find the nearest seat index
            final targetSeatIndex = seatManager.getNearestEmptyIndex();
            ZegoLoggerService.logInfo(
              'accept take seat invite, target seat index is $targetSeatIndex',
              tag: 'live audio',
              subTag: 'connect manager',
            );
            seatManager
                .takeOnSeat(
              targetSeatIndex,
              isForce: true,
              isDeleteAfterOwnerLeft: true,
            )
                .then((result) {
              if (result) {
                ZegoUIKit().turnMicrophoneOn(true);
              }
            });
          });
        });

        Navigator.of(
          contextQuery!.call(),
          rootNavigator: config.rootNavigator,
        ).pop();
      },
    ).whenComplete(() {
      popUpManager.removeAPopUpSheet(key);
    });
  }

  void onInvitationAccepted(Map<String, dynamic> params) {
    final ZegoUIKitUser invitee = params['invitee']!;
    final String data = params['data']!; // extended field

    ZegoLoggerService.logInfo(
      'on invitation accepted, invitee:$invitee, data:$data',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (seatManager.localHasHostPermissions) {
      _audienceIDsInvitedTakeSeatByHost.remove(invitee.id);
    } else {
      requestPermissions(
        context: contextQuery!.call(),
        isShowDialog: true,
        innerText: innerText,
        rootNavigator: config.rootNavigator,
        popUpManager: popUpManager,
        kickOutNotifier: kickOutNotifier,
      ).then((value) {
        /// host agree take seat, find the nearest seat index
        final targetSeatIndex = seatManager.getNearestEmptyIndex();
        if (targetSeatIndex < 0) {
          ZegoLoggerService.logInfo(
            'on invitation accepted, target seat index is $targetSeatIndex invalid',
            tag: 'live audio',
            subTag: 'connect manager',
          );

          updateAudienceConnectState(ZegoLiveAudioRoomConnectState.idle);
          return;
        }

        ZegoLoggerService.logInfo(
          'on invitation accepted, target seat index is $targetSeatIndex',
          tag: 'live audio',
          subTag: 'connect manager',
        );

        seatManager
            .takeOnSeat(
          targetSeatIndex,
          isForce: true,
          isDeleteAfterOwnerLeft: true,
        )
            .then((result) {
          ZegoLoggerService.logInfo(
            'on invitation accepted, take on seat result:$result',
            tag: 'live audio',
            subTag: 'connect manager',
          );

          if (result) {
            ZegoUIKit().turnMicrophoneOn(true);
          }
        });
      });
    }
  }

  void onInvitationCanceled(Map<String, dynamic> params) {
    final ZegoUIKitUser inviter = params['inviter']!;
    final String data = params['data']!; // extended field

    ZegoLoggerService.logInfo(
      'on invitation canceled, inviter:$inviter, data:$data',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (seatManager.localHasHostPermissions) {
      audiencesRequestingTakeSeatNotifier.value =
          List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
            ..removeWhere((user) => user.id == inviter.id);

      events.seat.host?.onTakingRequestCanceled?.call(inviter);
    }

    /// hide invite take seat dialog
    if (_isInvitedTakeSeatDlgVisible) {
      _isInvitedTakeSeatDlgVisible = false;
      Navigator.of(
        contextQuery!.call(),
        rootNavigator: config.rootNavigator,
      ).pop();
    }
  }

  void onInvitationRefused(Map<String, dynamic> params) {
    final ZegoUIKitUser invitee = params['invitee']!;
    final String data = params['data']!; // extended field

    ZegoLoggerService.logInfo(
      'on invitation refused, data: $data, invitee:$invitee',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (seatManager.localHasHostPermissions) {
      _audienceIDsInvitedTakeSeatByHost.remove(invitee.id);

      /// host's invite is rejected by audience
      events.seat.host?.onTakingInvitationRejected?.call(invitee);

      showDebugToast(
          'Your request to take seat has been refused by ${ZegoUIKit().getUser(invitee.id).name}');
    } else {
      /// audience's request is rejected by host
      events.seat.audience?.onTakingRequestRejected?.call();

      showDebugToast('Your request to take seat has been refused.');
      updateAudienceConnectState(ZegoLiveAudioRoomConnectState.idle);
    }
  }

  void onInvitationTimeout(Map<String, dynamic> params) {
    final ZegoUIKitUser inviter = params['inviter']!;
    final String data = params['data']!; // extended field

    ZegoLoggerService.logInfo(
      'on invitation timeout, inviter:$inviter, data:$data',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (seatManager.localHasHostPermissions) {
      audiencesRequestingTakeSeatNotifier.value =
          List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
            ..removeWhere((user) => user.id == inviter.id);
    } else {
      /// hide invite take seat dialog
      if (_isInvitedTakeSeatDlgVisible) {
        _isInvitedTakeSeatDlgVisible = false;
        Navigator.of(
          contextQuery!.call(),
          rootNavigator: config.rootNavigator,
        ).pop();
      }
    }
  }

  void onInvitationResponseTimeout(Map<String, dynamic> params) {
    final List<ZegoUIKitUser> invitees = params['invitees']!;
    final String data = params['data']!; // extended field

    ZegoLoggerService.logInfo(
      'on invitation response timeout, data: $data, '
      'invitees:${invitees.map((e) => e.toString())}',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (seatManager.localHasHostPermissions) {
      for (final invitee in invitees) {
        _audienceIDsInvitedTakeSeatByHost.remove(invitee.id);
      }
    } else {
      events.seat.audience?.onTakingRequestFailed?.call();

      updateAudienceConnectState(ZegoLiveAudioRoomConnectState.idle);
    }
  }

  void removeRequestCoHostUsers(ZegoUIKitUser targetUser) {
    audiencesRequestingTakeSeatNotifier.value =
        List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
          ..removeWhere((user) => user.id == targetUser.id);
  }

  void updateAudienceConnectState(ZegoLiveAudioRoomConnectState state) {
    if (state == audienceLocalConnectStateNotifier.value) {
      ZegoLoggerService.logInfo(
        'audience connect state is same: $state',
        tag: 'live audio',
        subTag: 'connect manager',
      );
      return;
    }

    ZegoLoggerService.logInfo(
      'update audience connect state: $state',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    switch (state) {
      case ZegoLiveAudioRoomConnectState.idle:
        ZegoUIKit().resetSoundEffect();

        ZegoUIKit().turnMicrophoneOn(false);

        /// hide invite join take seat dialog
        if (_isInvitedTakeSeatDlgVisible) {
          _isInvitedTakeSeatDlgVisible = false;
          Navigator.of(
            contextQuery!.call(),
            rootNavigator: config.rootNavigator,
          ).pop();
        }

        break;
      case ZegoLiveAudioRoomConnectState.connecting:
        break;
      case ZegoLiveAudioRoomConnectState.connected:
        ZegoUIKit().turnMicrophoneOn(true);
        break;
    }

    audienceLocalConnectStateNotifier.value = state;
  }

  void onSeatLockedChanged(bool isLocked) {
    ZegoLoggerService.logInfo(
      'on seat locked changed: $isLocked',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    /// cancel if still requesting when room locked/unlocked
    audienceCancelTakeSeatRequest();

    if (!isLocked) {
      /// hide invite take seat dialog
      if (_isInvitedTakeSeatDlgVisible) {
        _isInvitedTakeSeatDlgVisible = false;
        Navigator.of(
          contextQuery!.call(),
          rootNavigator: config.rootNavigator,
        ).pop();
      }
    }
  }

  void hostCancelTakeSeatInvitation() {
    ZegoLoggerService.logInfo(
      'host cancel take seat invitation',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    _audienceIDsInvitedTakeSeatByHost
      ..forEach((audienceID) {
        ZegoUIKit().getSignalingPlugin().cancelInvitation(
          invitees: [audienceID],
          data: '',
        );
      })
      ..clear();
  }

  Future<bool> audienceCancelTakeSeatRequest() async {
    ZegoLoggerService.logInfo(
      'audience cancel take seat request, connect state: ${audienceLocalConnectStateNotifier.value}',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (audienceLocalConnectStateNotifier.value ==
        ZegoLiveAudioRoomConnectState.connecting) {
      return ZegoUIKit()
          .getSignalingPlugin()
          .cancelInvitation(
            invitees: seatManager.hostsNotifier.value,
            data: '',
          )
          .then((ZegoSignalingPluginCancelInvitationResult result) {
        updateAudienceConnectState(ZegoLiveAudioRoomConnectState.idle);

        ZegoLoggerService.logInfo(
          'audience cancel take seat request finished, '
          'code:${result.error?.code}, '
          'message:${result.error?.message}, '
          'errorInvitees:${result.errorInvitees}',
          tag: 'audio room',
          subTag: 'connect manager',
        );

        return result.error?.code.isNotEmpty ?? true;
      });
    }

    return true;
  }

  void onUserListLeaveUpdated(List<ZegoUIKitUser> users) {
    ZegoLoggerService.logInfo(
      'users leave, ${users.map((e) => e.toString()).toList()}',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    final userIDs = users.map((e) => e.id).toList();

    _audienceIDsInvitedTakeSeatByHost
        .removeWhere((userID) => userIDs.contains(userID));

    audiencesRequestingTakeSeatNotifier.value =
        List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
          ..removeWhere((user) => userIDs.contains(user.id));
  }
}
