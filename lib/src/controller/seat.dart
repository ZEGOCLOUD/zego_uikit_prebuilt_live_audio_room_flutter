part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerSeat {
  final _seatImpl = ZegoLiveAudioRoomControllerSeatImpl();

  ZegoLiveAudioRoomControllerSeatImpl get seat => _seatImpl;
}

/// Here are the APIs related to seat.
class ZegoLiveAudioRoomControllerSeatImpl
    with ZegoLiveAudioRoomControllerSeatPrivate {
  /// APIs of host
  ZegoLiveAudioRoomControllerSeatHostImpl get host => private.host;

  /// APIs of audience
  ZegoLiveAudioRoomControllerSeatAudienceImpl get audience => private.audience;

  /// APIs of speaker
  ZegoLiveAudioRoomControllerSeatSpeakerImpl get speaker => private.speaker;

  /// the seat user map of the current live audio room.
  ValueNotifier<Map<String, String>>? get userMapNotifier =>
      private.seatManager?.seatsUserMapNotifier;

  /// local user is host or not
  bool get localIsHost => private.seatManager?.localIsAHost ?? false;

  /// local user is audience or not
  bool get localIsAudience => private.seatManager?.localIsAAudience ?? false;

  /// local user is speaker or not
  bool get localIsSpeaker => private.seatManager?.localIsASpeaker ?? false;

  /// local user is co-host or not
  /// co-host have the same permissions as hosts if host is not exist
  bool get localIsCoHost => private.seatManager?.localIsCoHost ?? false;

  /// local user has host permission or not
  /// co-host have the same permissions as hosts if host is not exist
  bool get localHasHostPermissions =>
      private.seatManager?.localHasHostPermissions ?? false;

  /// get user who on the target seat index
  ZegoUIKitUser? getUserByIndex(int targetIndex) =>
      private.seatManager?.getUserByIndex(targetIndex);

  /// Is the current seat muted or not.
  /// Set [isLocally] to true to find out if it is muted locally.
  ///
  /// Related APIs:
  /// [muteLocally]
  /// [muteLocallyByUserID]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.mute]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.muteByUserID]
  ValueNotifier<bool> muteStateNotifier(
    int targetIndex, {
    bool isLocally = false,
  }) {
    final targetUser = ZegoUIKit()
        .getUser(private.seatManager?.getUserByIndex(targetIndex)?.id ?? '');
    return isLocally ? targetUser.microphoneMuteMode : targetUser.microphone;
  }

  /// Mute the user at the [targetIndex] seat **locally**.
  /// After mute, if you want to un-mute, you can set [muted] to false.
  ///
  /// And on side of the user at the [targetIndex] seat, return true/false in
  /// the callback of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  /// to open microphone or not.
  ///
  /// Related APIs:
  /// [muteStateNotifier]
  /// [muteLocallyByUserID]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.mute]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.muteByUserID]
  /// [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  ///
  /// example:
  ///  Mute/UnMute users on the $targetIndex
  /// ```dart
  ///  ZegoUIKitPrebuiltLiveAudioRoomController().seat.muteLocally(
  ///    targetIndex: $targetIndex,
  ///    muted: ! ZegoUIKitPrebuiltLiveAudioRoomController().seat.mutedStateNotifier(
  ///      $targetIndex,
  ///      isLocal: true,
  ///    ).value,
  ///  );
  /// ```
  Future<bool> muteLocally({
    int targetIndex = -1,
    bool muted = true,
  }) async {
    ZegoLoggerService.logInfo(
      'muteLocal, targetIndex:$targetIndex, muted:$muted,',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    final targetUserID =
        private.seatManager?.getUserByIndex(targetIndex)?.id ?? '';
    return await ZegoUIKit().muteUserAudio(targetUserID, muted);
  }

  /// Mute the seat by [targetUserID] **locally**.
  /// After mute, if you want to un-mute, you can set [muted] to false.
  ///
  /// And on side of the user at the [targetIndex] seat, return true/false in
  /// the callback of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  /// to open microphone or not.
  ///
  /// Related APIs:
  /// [muteStateNotifier]
  /// [muteLocally]
  /// [getUserByIndex]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.mute]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.muteByUserID]
  /// [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  ///
  /// example:
  ///  Mute/UnMute users on the $targetIndex
  /// ```dart
  ///  ZegoUIKitPrebuiltLiveAudioRoomController().seat.muteLocallyByUserID(
  ///    $userID,
  ///    muted: ! ZegoUIKitPrebuiltLiveAudioRoomController().seat.mutedStateNotifier(
  ///      $userSeatIndex,
  ///      isLocal: true,
  ///    ).value,
  ///  );
  /// ```
  Future<bool> muteLocallyByUserID(
    String targetUserID, {
    bool muted = true,
  }) async {
    ZegoLoggerService.logInfo(
      'muteLocalByUserID, targetUserID:$targetUserID, muted:$muted',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    return await ZegoUIKit().muteUserAudio(targetUserID, muted);
  }
}

/// APIs of host
class ZegoLiveAudioRoomControllerSeatHostImpl
    with ZegoLiveAudioRoomControllerSeatRolePrivate {
  /// Opens (unlocks) the seat.
  /// allows you to unlock all seats in the room at once, or only unlock specific seat by [targetIndex].
  ///
  /// After opening(locks) the seat, all audience members can freely choose an empty seat to join and start chatting with others.
  Future<bool> open({
    int targetIndex = -1,
  }) async {
    ZegoLoggerService.logInfo(
      'open, targetIndex:$targetIndex',
      tag: 'live audio',
      subTag: 'controller.seat',
    );

    return await private.seatManager?.lockSeat(
          false,
          targetIndex: targetIndex,
        ) ??
        false;
  }

  /// Closes (locks) the seat.
  /// allows you to lock all seats in the room at once, or only lock specific seat by [targetIndex].
  ///
  /// After closing(locks) the seat, audience members need to request permission from the host or be invited by the host to occupy the seat.
  Future<bool> close({
    int targetIndex = -1,
  }) async {
    ZegoLoggerService.logInfo(
      'close, targetIndex:$targetIndex',
      tag: 'live audio',
      subTag: 'controller.seat',
    );

    return await private.seatManager?.lockSeat(
          true,
          targetIndex: targetIndex,
        ) ??
        false;
  }

  /// Removes the speaker with the user ID [userID] from the seat.
  Future<void> removeSpeaker(String userID) async {
    ZegoLoggerService.logInfo(
      'removeSpeaker, userID:$userID',
      tag: 'live audio',
      subTag: 'controller.seat',
    );

    final index = private.seatManager?.getIndexByUserID(userID) ?? -1;
    return private.seatManager?.kickSeat(index);
  }

  /// The host accepts the seat request from the audience with the ID [audienceUserID].
  ///
  /// Related APIs:
  /// [rejectTakingRequest]
  /// [ZegoLiveAudioRoomControllerSeatAudienceImpl.applyToTake]
  /// [ZegoLiveAudioRoomControllerSeatAudienceImpl.cancelTakingRequest]
  Future<bool> acceptTakingRequest(String audienceUserID) async {
    ZegoLoggerService.logInfo(
      'acceptTakingRequest, audienceUserID:$audienceUserID',
      tag: 'live audio',
      subTag: 'controller.seat',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .acceptInvitation(inviterID: audienceUserID, data: '')
        .then((result) {
      ZegoLoggerService.logInfo(
        'accept $audienceUserID seat taking request , result:$result',
        tag: 'live audio',
        subTag: 'controller.seat',
      );
      if (result.error == null) {
        private.connectManager
            ?.removeRequestCoHostUsers(ZegoUIKit().getUser(audienceUserID));
      } else {
        ZegoLoggerService.logInfo(
          'accept seat taking request error:${result.error}',
          tag: 'audio room',
          subTag: 'controller.seat',
        );
      }

      return result.error == null;
    });
  }

  /// The host rejects the seat request from the audience with the ID [audienceUserID].
  ///
  /// Related APIs:
  /// [acceptTakingRequest]
  /// [ZegoLiveAudioRoomControllerSeatAudienceImpl.applyToTake]
  /// [ZegoLiveAudioRoomControllerSeatAudienceImpl.cancelTakingRequest]
  Future<bool> rejectTakingRequest(String audienceUserID) async {
    ZegoLoggerService.logInfo(
      'rejectTakingRequest, audienceUserID:$audienceUserID',
      tag: 'live audio',
      subTag: 'controller.seat',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .refuseInvitation(inviterID: audienceUserID, data: '')
        .then((result) {
      ZegoLoggerService.logInfo(
        'refuse audience $audienceUserID link request, $result',
        tag: 'live audio',
        subTag: 'controller.seat',
      );

      if (result.error == null) {
        private.connectManager
            ?.removeRequestCoHostUsers(ZegoUIKit().getUser(audienceUserID));
      } else {
        ZegoLoggerService.logInfo(
          'reject seat taking request error:${result.error}',
          tag: 'audio room',
          subTag: 'controller.seat',
        );
      }

      return result.error == null;
    });
  }

  /// Host invite the audience with id [userID] to take seat
  ///
  /// Related APIs:
  /// [ZegoLiveAudioRoomControllerSeatAudienceImpl.acceptTakingInvitation]
  Future<bool> inviteToTake(String userID) async {
    ZegoLoggerService.logInfo(
      'inviteToTake, userID:$userID',
      tag: 'live audio',
      subTag: 'controller.seat',
    );

    return await private.connectManager
            ?.inviteAudienceConnect(ZegoUIKit().getUser(userID)) ??
        false;
  }

  /// Mute the user at the [targetIndex] seat.
  /// After mute, if you want to un-mute, you can set [muted] to false.
  ///
  /// And on side of the user at the [targetIndex] seat, return true/false in
  /// the callback of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  /// to open microphone or not.
  ///
  /// Related APIs:
  /// [muteByUserID]
  /// [ZegoLiveAudioRoomControllerSeatImpl.muteStateNotifier]
  /// [ZegoLiveAudioRoomControllerSeatImpl.muteLocally]
  /// [ZegoLiveAudioRoomControllerSeatImpl.muteLocallyByUserID]
  /// [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  Future<bool> mute({
    int targetIndex = -1,
    bool muted = true,
  }) async {
    ZegoLoggerService.logInfo(
      'mute, targetIndex:$targetIndex, muted:$muted',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    return await private.seatManager?.muteSeat(
          targetIndex,
          muted: muted,
        ) ??
        false;
  }

  /// Mute the seat by [targetUserID].
  /// After mute, if you want to un-mute, you can set [muted] to false.
  ///
  /// And on side of the user at the [targetIndex] seat, return true/false in
  /// the callback of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  /// to open microphone or not.
  ///
  /// Related APIs:
  /// [mute]
  /// [ZegoLiveAudioRoomControllerSeatImpl.muteStateNotifier]
  /// [ZegoLiveAudioRoomControllerSeatImpl.muteLocally]
  /// [ZegoLiveAudioRoomControllerSeatImpl.muteLocallyByUserID]
  /// [ZegoLiveAudioRoomControllerSeatImpl.getUserByIndex]
  /// [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation]
  Future<bool> muteByUserID(
    String targetUserID, {
    bool muted = true,
  }) async {
    ZegoLoggerService.logInfo(
      'muteByUserID, targetUserID:$targetUserID, muted:$muted',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    final targetIndex =
        private.seatManager?.getIndexByUserID(targetUserID) ?? -1;
    if (-1 == targetIndex) {
      ZegoLoggerService.logInfo(
        'mute $targetUserID, but user is not on seat',
        tag: 'audio room',
        subTag: 'controller.seat',
      );

      return false;
    }

    return await private.seatManager?.muteSeat(
          targetIndex,
          muted: muted,
        ) ??
        false;
  }
}

/// APIs of audience
class ZegoLiveAudioRoomControllerSeatAudienceImpl
    with ZegoLiveAudioRoomControllerSeatRolePrivate {
  /// Assigns the audience to the seat with the specified [index], where the index represents the seat number starting from 0.
  Future<bool> take(int index) async {
    ZegoLoggerService.logInfo(
      'take, index:$index',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    return await private.seatManager?.takeOnSeat(
          index,
          isForce: true,
          isUpdateOwner: true,
          isDeleteAfterOwnerLeft: true,
        ) ??
        false;
  }

  /// The audience actively requests to occupy a seat.
  ///
  /// Related APIs:
  /// [cancelTakingRequest]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.acceptTakingRequest]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.rejectTakingRequest]
  Future<bool> applyToTake() async {
    ZegoLoggerService.logInfo(
      'applyToTake',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    if (private.seatManager?.hostsNotifier.value.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        'Failed to apply for take seat, host is not exist',
        tag: 'audio room',
        subTag: 'controller.seat',
      );
      return false;
    }

    return ZegoUIKit()
        .getSignalingPlugin()
        .sendInvitation(
          inviterID: ZegoUIKit().getLocalUser().id,
          inviterName: ZegoUIKit().getLocalUser().name,
          invitees: private.seatManager?.hostsNotifier.value ?? [],
          timeout: 60,
          type: ZegoLiveAudioRoomInvitationType.requestTakeSeat.value,
          data: '',
        )
        .then((ZegoSignalingPluginSendInvitationResult result) {
      ZegoLoggerService.logInfo(
        'apply to take seat finished, code:${result.error?.code}, '
        'message:${result.error?.message}, '
        'invitationID:${result.invitationID}, '
        'errorInvitees:${result.errorInvitees.keys.toList()}',
        tag: 'audio room',
        subTag: 'controller.seat',
      );

      if (result.error != null) {
        private.seatManager?.events.seat.audience?.onTakingRequestFailed
            ?.call();
      }

      return result.error == null;
    });
  }

  /// The audience cancels the request to occupy a seat.
  ///
  /// Related APIs:
  /// [applyToTake]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.acceptTakingRequest]
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.rejectTakingRequest]
  Future<bool> cancelTakingRequest() async {
    ZegoLoggerService.logInfo(
      'cancelTakingRequest',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    return await private.connectManager?.audienceCancelTakeSeatRequest() ??
        false;
  }

  /// Accept the seat invitation from the host. The [context] parameter represents the Flutter context object.
  ///
  /// Related APIs:
  /// [ZegoLiveAudioRoomControllerSeatHostImpl.inviteToTake]
  Future<bool> acceptTakingInvitation({
    required BuildContext context,
    bool rootNavigator = false,
  }) async {
    ZegoLoggerService.logInfo(
      'acceptTakingInvitation, context:$context, rootNavigator:$rootNavigator',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .acceptInvitation(
          inviterID: private.seatManager?.hostsNotifier.value.first ?? '',
          data: '',
        )
        .then((result) async {
      ZegoLoggerService.logInfo(
        'accept host take seat invitation, result:$result',
        tag: 'live audio',
        subTag: 'controller.seat',
      );

      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'accept host take seat invitation error: ${result.error}',
          tag: 'live audio',
          subTag: 'controller.seat',
        );
        return false;
      }

      return requestPermissions(
        context: context,
        isShowDialog: true,
        innerText: private.seatManager?.innerText ??
            ZegoUIKitPrebuiltLiveAudioRoomInnerText(),
        rootNavigator: rootNavigator,
        kickOutNotifier: ZegoLiveAudioRoomManagers().kickOutNotifier,
        popUpManager: ZegoLiveAudioRoomManagers().popUpManager,
      ).then((_) async {
        /// agree host's host, take seat, find the nearest seat index
        return await private.seatManager
                ?.takeOnSeat(
              private.seatManager?.getNearestEmptyIndex() ?? -1,
              isForce: true,
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
}

/// APIs of speaker
class ZegoLiveAudioRoomControllerSeatSpeakerImpl
    with ZegoLiveAudioRoomControllerSeatRolePrivate {
  /// The speaker can use this method to leave the seat. If the showDialog parameter is set to true, a confirmation dialog will be displayed before leaving the seat.
  Future<bool> leave({bool showDialog = true}) async {
    ZegoLoggerService.logInfo(
      'leave, showDialog:$showDialog',
      tag: 'audio room',
      subTag: 'controller.seat',
    );

    return await private.seatManager?.leaveSeat(showDialog: showDialog) ??
        false;
  }
}
