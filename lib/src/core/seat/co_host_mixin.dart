part of 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

/// @nodoc
mixin ZegoLiveSeatCoHost {
  ValueNotifier<List<String>> coHostsNotifier = ValueNotifier<List<String>>([]);

  bool haveCoHost() {
    return -1 != ZegoUIKit().getAllUsers().indexWhere((user) => isCoHost(user));
  }

  bool isCoHost(ZegoUIKitUser? user) {
    if (null == user) {
      return false;
    }

    final inRoomAttributes = user.inRoomAttributes.value;
    return inRoomAttributes[attributeKeyIsCoHost]?.toLowerCase() == 'true';
  }

  Future<bool> setCoHostAttribute({
    required String roomID,
    required String targetUserID,
    required bool isCoHost,
  }) async {
    ZegoLoggerService.logInfo(
      '$targetUserID set co-host in-room attribute: $isCoHost',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    return ZegoUIKit().getSignalingPlugin().setUsersInRoomAttributes(
      roomID: roomID,
      key: attributeKeyIsCoHost,
      value: isCoHost.toString(),
      userIDs: [targetUserID],
    ).then((result) {
      final success = result.error == null;
      if (success) {
        ZegoLoggerService.logInfo(
          'host set co-host in-room attribute result success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      } else {
        ZegoLoggerService.logError(
          'host set co-host in-room attribute result failed, error:${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );

        showDebugToast(
            'host set co-host in-room attribute failed, ${result.error}');
      }
      return success;
    });
  }

  Future<bool> assignCoHost({
    required String roomID,
    required ZegoUIKitUser targetUser,
  }) async {
    ZegoLoggerService.logInfo(
      'invite speaker to be the co-host, ${targetUser.id} ${targetUser.name}',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (targetUser.isEmpty()) {
      ZegoLoggerService.logInfo(
        'target user is empty',
        tag: 'live audio',
        subTag: 'connect manager',
      );
    }

    ZegoUIKit().getAllUsers().forEach((user) async {
      if (isCoHost(user)) {
        ZegoLoggerService.logInfo(
          'target user($user) is co-host before, co-host is unique, so revoke this co-host now',
          tag: 'live audio',
          subTag: 'connect manager',
        );

        await revokeCoHost(roomID: roomID, targetUser: user);
      }
    });

    return setCoHostAttribute(
      roomID: roomID,
      targetUserID: targetUser.id,
      isCoHost: true,
    );
  }

  Future<bool> revokeCoHost({
    required String roomID,
    required ZegoUIKitUser targetUser,
  }) async {
    ZegoLoggerService.logInfo(
      'revoke the co-host, ${targetUser.id} ${targetUser.name}',
      tag: 'live audio',
      subTag: 'connect manager',
    );

    if (targetUser.isEmpty()) {
      ZegoLoggerService.logInfo(
        'target user is empty',
        tag: 'live audio',
        subTag: 'connect manager',
      );
    }

    return setCoHostAttribute(
      roomID: roomID,
      targetUserID: targetUser.id,
      isCoHost: false,
    );
  }
}
