// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class ZegoLiveAudioRoomController {
  ZegoLiveConnectManager? _connectManager;
  ZegoLiveSeatManager? _seatManager;

  /// turn on/off microphone
  /// @param userID, if null or empty, turn on/off local microphone
  void turnMicrophoneOn(bool isOn, {String? userID}) {
    ZegoUIKit().turnMicrophoneOn(isOn, userID: userID);
  }

  Future<bool> leaveSeat({bool showDialog = true}) async {
    return await _seatManager?.leaveSeat(showDialog: showDialog) ?? false;
  }

  Future<bool> takeSeat(int index) async {
    return await _seatManager?.takeOnSeat(
          index,
          isForce: true,
          isUpdateOwner: true,
          isDeleteAfterOwnerLeft: true,
        ) ??
        false;
  }

  Future<void> removeSpeakerFromSeat(String userID) async {
    final index = _seatManager?.getIndexByUserID(userID) ?? -1;
    return _seatManager?.kickSeat(index);
  }

  Future<bool> closeSeats() async {
    return await _seatManager?.lockSeat(true) ?? false;
  }

  Future<bool> openSeats() async {
    return await _seatManager?.lockSeat(false) ?? false;
  }

  ///--------start of audience request take seat's api--------------
  /// audience request take seat from the host
  Future<bool> applyToTakeSeat() async {
    if (_seatManager?.hostsNotifier.value.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        'Failed to apply for take seat, host is not exist',
        tag: 'audio room',
        subTag: 'controller',
      );
      return false;
    }

    return ZegoUIKit()
        .getSignalingPlugin()
        .sendInvitation(
          inviterName: ZegoUIKit().getLocalUser().name,
          invitees: _seatManager?.hostsNotifier.value ?? [],
          timeout: 60,
          type: ZegoInvitationType.requestTakeSeat.value,
          data: '',
        )
        .then((ZegoSignalingPluginSendInvitationResult result) {
      ZegoLoggerService.logInfo(
        'apply to take seat finished, code:${result.error?.code}, '
        'message:${result.error?.message}, '
        'invitationID:${result.invitationID}, '
        'errorInvitees:${result.errorInvitees.keys.toList()}',
        tag: 'audio room',
        subTag: 'controller',
      );

      if (result.error != null) {
        _seatManager?.config.onSeatTakingRequestFailed?.call();
      }

      return result.error == null;
    });
  }

  /// audience cancelled their request for a seat from the host
  Future<bool> cancelSeatTakingRequest() async {
    return await _connectManager?.audienceCancelTakeSeatRequest() ?? false;
  }

  /// host accept the audience's request to be seated
  Future<bool> acceptSeatTakingRequest(String audienceUserID) async {
    return ZegoUIKit()
        .getSignalingPlugin()
        .acceptInvitation(inviterID: audienceUserID, data: '')
        .then((result) {
      ZegoLoggerService.logInfo(
        'accept $audienceUserID seat taking request , result:$result',
        tag: 'live audio',
        subTag: 'controller',
      );
      if (result.error == null) {
        _connectManager?.removeRequestCoHostUsers(
          ZegoUIKit().getUser(audienceUserID) ?? ZegoUIKitUser.empty(),
        );
      } else {
        ZegoLoggerService.logInfo(
          'accept seat taking request error:${result.error}',
          tag: 'audio room',
          subTag: 'controller',
        );
      }

      return result.error == null;
    });
  }

  /// host reject the audience's request to be seated
  Future<bool> rejectSeatTakingRequest(String audienceUserID) async {
    return ZegoUIKit()
        .getSignalingPlugin()
        .refuseInvitation(inviterID: audienceUserID, data: '')
        .then((result) {
      ZegoLoggerService.logInfo(
        'refuse audience $audienceUserID link request, $result',
        tag: 'live audio',
        subTag: 'controller',
      );

      if (result.error == null) {
        _connectManager?.removeRequestCoHostUsers(
          ZegoUIKit().getUser(audienceUserID) ?? ZegoUIKitUser.empty(),
        );
      } else {
        ZegoLoggerService.logInfo(
          'reject seat taking request error:${result.error}',
          tag: 'audio room',
          subTag: 'controller',
        );
      }

      return result.error == null;
    });
  }

  ///--------end of audience request take seat's api--------------

  ///--------start of host invite audience to take seat's api--------------
  /// host invite audience to take seat
  Future<bool> inviteAudienceToTakeSeat(String userID) async {
    return await _connectManager?.inviteAudienceConnect(
          ZegoUIKit().getUser(userID) ?? ZegoUIKitUser.empty(),
        ) ??
        false;
  }

  Future<bool> acceptHostTakeSeatInvitation({
    required BuildContext context,
  }) async {
    return ZegoUIKit()
        .getSignalingPlugin()
        .acceptInvitation(
          inviterID: _seatManager?.hostsNotifier.value.first ?? '',
          data: '',
        )
        .then((result) async {
      ZegoLoggerService.logInfo(
        'accept host take seat invitation, result:$result',
        tag: 'live audio',
        subTag: 'controller',
      );

      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'accept host take seat invitation error: ${result.error}',
          tag: 'live audio',
          subTag: 'controller',
        );
        return false;
      }

      return requestPermissions(
        context: context,
        isShowDialog: true,
        innerText: _seatManager?.innerText ?? ZegoInnerText(),
      ).then((_) async {
        /// agree host's host, take seat, find the nearest seat index
        return await _seatManager
                ?.takeOnSeat(
              _seatManager?.getNearestEmptyIndex() ?? -1,
              isForce: false,
              isDeleteAfterOwnerLeft: true,
            )
                .then((result) async {
              if (result) {
                ZegoUIKit().turnMicrophoneOn(true);
              }

              return result;
            }) ??
            false;
      });
    });
  }

  ///--------end of host invite audience to take seat's api--------------

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void initByPrebuilt({
    ZegoLiveConnectManager? connectManager,
    ZegoLiveSeatManager? seatManager,
  }) {
    _connectManager = connectManager;
    _seatManager = seatManager;
  }

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void uninitByPrebuilt() {
    _connectManager = null;
    _seatManager = null;
  }
}
