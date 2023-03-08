// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/dialogs.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/plugins.dart';

class ZegoLiveSeatManager {
  ZegoLiveSeatManager({
    required this.localUserID,
    required this.roomID,
    required this.plugins,
    required this.config,
    required this.innerText,
    required this.contextQuery,
    required this.prebuiltController,
  }) {
    localRole.value = config.role;

    _subscriptions
      ..add(ZegoUIKit().getUserListStream().listen(onUserListUpdated))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getRoomPropertiesStream()
          .listen(onRoomAttributesUpdated))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getRoomBatchPropertiesStream()
          .listen(onRoomBatchAttributesUpdated))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getUsersInRoomAttributesStream()
          .listen(onUsersAttributesUpdated));
  }

  final String localUserID;
  final String roomID;
  final ZegoPrebuiltPlugins plugins;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoLiveAudioRoomController? prebuiltController;
  final BuildContext Function() contextQuery;
  final ZegoInnerText innerText;

  KickSeatDialogInfo kickSeatDialogInfo = KickSeatDialogInfo.empty();

  bool isSeatLockedPropertyAlreadySet = false;
  final isSeatLockedNotifier = ValueNotifier<bool>(false);

  ValueNotifier<List<String>> hostsNotifier = ValueNotifier<List<String>>([]);
  ValueNotifier<ZegoLiveAudioRoomRole> localRole =
      ValueNotifier<ZegoLiveAudioRoomRole>(ZegoLiveAudioRoomRole.audience);

  ZegoLiveConnectManager? _connectManager;

  bool _isLeaveSeatDialogVisible = false;
  bool _isPopUpSheetVisible = false;
  bool _isRoomAttributesBatching = false;
  bool _hostSeatAttributeInitialed = false;

  bool isLeavingRoom = false;

  final Map<String, Map<String, String>> _pendingUserRoomAttributes = {};
  final List<StreamSubscription<dynamic>?> _subscriptions = [];

  bool get localIsAHost => ZegoLiveAudioRoomRole.host == localRole.value;

  bool get isRoomAttributesBatching => _isRoomAttributesBatching;

  bool get localIsAAudience =>
      ZegoLiveAudioRoomRole.audience == localRole.value;

  bool isAHostSeat(int index) => config.hostSeatIndexes.contains(index);

  ValueNotifier<Map<String, String>> seatsUserMapNotifier =
      ValueNotifier<Map<String, String>>({}); //  <seat id, user id>

  Future<void> init() async {
    ZegoLoggerService.logInfo(
      'init',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    localRole.addListener(onRoleChanged);
    seatsUserMapNotifier.addListener(onSeatUsersChanged);
    isSeatLockedNotifier.addListener(onSeatLockedChanged);

    await queryRoomAllAttributes(withToast: false);
    await queryUsersInRoomAttributes();

    await initLocalAvatarAttribute();
    await initLocalInRoomAttributes();
  }

  Future<void> uninit() async {
    ZegoLoggerService.logInfo(
      'uninit',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    ZegoUIKit().turnMicrophoneOn(false);

    isLeavingRoom = false;

    seatsUserMapNotifier.value.clear();
    _hostSeatAttributeInitialed = false;
    _isRoomAttributesBatching = false;

    isSeatLockedPropertyAlreadySet = false;
    isSeatLockedNotifier.value = false;

    seatsUserMapNotifier.removeListener(onSeatUsersChanged);
    localRole.removeListener(onRoleChanged);
    for (final subscription in _subscriptions) {
      subscription?.cancel();
    }
  }

  void setConnectManager(ZegoLiveConnectManager value) {
    _connectManager = value;
  }

  Future<bool> lockSeat(bool isLocked) async {
    if (localRole.value != ZegoLiveAudioRoomRole.host) {
      return false;
    }

    if (isLocked == isSeatLockedNotifier.value) {
      ZegoLoggerService.logInfo(
        '${isLocked ? 'lock' : 'unlock'} status($isLocked) is same',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return true;
    }

    ZegoLoggerService.logInfo(
      'try ${isLocked ? 'lock' : 'unlock'} audio room',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .updateRoomProperty(
          roomID: roomID,
          key: attributeKeyLockSeat,
          value: isLocked ? '1' : '0',
          isForce: true,
          isDeleteAfterOwnerLeft: false,
          isUpdateOwner: true,
        )
        .then((result) {
      if (result.error != null) {
        ZegoLoggerService.logInfo(
          '${isLocked ? 'lock' : 'unlock'} seat is failed, ${result.error} ',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      } else {
        ZegoLoggerService.logInfo(
          '${isLocked ? 'lock' : 'unlock'} seat success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }

      return result.error != null;
    });
  }

  Future<bool> queryUsersInRoomAttributes({
    bool withToast = true,
    String nextFlag = '',
  }) async {
    ZegoLoggerService.logInfo(
      'query init users in-room attributes, next flag:$nextFlag',
      tag: 'audio room',
      subTag: 'seat manager',
    );
    return ZegoUIKit()
        .getSignalingPlugin()
        .queryUsersInRoomAttributes(
          roomID: roomID,
          nextFlag: nextFlag,
        )
        .then((result) async {
      final success = result.error == null;
      ZegoLoggerService.logInfo(
        'query finish, result:$result',
        tag: 'audio room',
        subTag: 'seat manager',
      );

      ZegoLoggerService.logInfo(
        'query finish, result:$result, nextFlag: ${result.nextFlag}',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      if (success) {
        updateRoleFromUserAttributes(result.attributes);

        if (result.nextFlag.isNotEmpty) {
          ZegoLoggerService.logInfo(
            'query has next flag, query next..',
            tag: 'audio room',
            subTag: 'seat manager',
          );

          return queryUsersInRoomAttributes(
            withToast: withToast,
            nextFlag: result.nextFlag,
          );
        }
      } else {
        if (withToast) {
          showDebugToast(
              'query users in-room attributes error, ${result.error}');
        }
      }

      return success;
    });
  }

  Future<void> initRoleAndSeat() async {
    if (localRole.value == ZegoLiveAudioRoomRole.host) {
      _hostSeatAttributeInitialed = false;
    }

    if (localRole.value == ZegoLiveAudioRoomRole.host ||
        localRole.value == ZegoLiveAudioRoomRole.speaker) {
      ZegoLoggerService.logInfo(
        'try init seat ${config.takeSeatIndexWhenJoining}',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      await takeOnSeat(
        config.takeSeatIndexWhenJoining,
        isForce: true,
        isUpdateOwner: true,
        isDeleteAfterOwnerLeft: true,
      ).then((success) async {
        _hostSeatAttributeInitialed = true;

        ZegoLoggerService.logInfo(
          "[live audio room] init seat index ${success ? "success" : "failed"}",
          tag: 'audio room',
          subTag: 'seat manager',
        );
        if (success) {
          if (localRole.value == ZegoLiveAudioRoomRole.host) {
            ZegoLoggerService.logInfo(
              '[live audio room] try init role ${localRole.value}',
              tag: 'audio room',
              subTag: 'seat manager',
            );
            await setRoleAttribute(localRole.value, localUserID)
                .then((success) async {
              ZegoLoggerService.logInfo(
                "[live audio room] init role ${success ? "success" : "failed"}",
                tag: 'audio room',
                subTag: 'seat manager',
              );
              if (!success) {
                ZegoLoggerService.logInfo(
                  '[live audio room] reset to audience and take off seat ${config.takeSeatIndexWhenJoining}',
                  tag: 'audio room',
                  subTag: 'seat manager',
                );

                localRole.value = ZegoLiveAudioRoomRole.audience;
                await takeOffSeat(
                  config.takeSeatIndexWhenJoining,
                  isForce: true,
                );
              }
            });
          }
        }
      });
    }

    if (localRole.value == ZegoLiveAudioRoomRole.host &&
        !isSeatLockedPropertyAlreadySet) {
      lockSeat(config.closeSeatsWhenJoining);
    }
  }

  void onRoleChanged() {
    ZegoLoggerService.logInfo(
      'local user role changed to ${localRole.value}',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    if (ZegoLiveAudioRoomRole.host == localRole.value ||
        ZegoLiveAudioRoomRole.speaker == localRole.value) {
      requestPermissions(
        context: contextQuery(),
        innerText: innerText,
        isShowDialog: true,
      ).then((value) {
        ZegoLoggerService.logInfo(
          'local is speaker now, turn on microphone',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        ZegoUIKit().turnMicrophoneOn(true);
      });
    } else {
      ZegoLoggerService.logInfo(
        'local is audience now, turn off microphone',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      ZegoUIKit().turnMicrophoneOn(false);
      _connectManager?.updateAudienceConnectState(ConnectState.idle);

      if (_isLeaveSeatDialogVisible) {
        ZegoLoggerService.logInfo(
          'close leave seat dialog',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        _isLeaveSeatDialogVisible = false;
        Navigator.of(contextQuery()).pop(false);
      }
      if (_isPopUpSheetVisible) {
        ZegoLoggerService.logInfo(
          'close pop up sheet',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        _isPopUpSheetVisible = false;
        Navigator.of(contextQuery()).pop(false);
      }
    }
  }

  void onSeatUsersChanged() {
    ZegoLoggerService.logInfo(
      'seat users changed to ${seatsUserMapNotifier.value}',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    if (!seatsUserMapNotifier.value.values.contains(localUserID)) {
      ZegoLoggerService.logInfo(
        'local is not on seat now, turn off microphone',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      ZegoUIKit().turnMicrophoneOn(false);
    }

    /// seat change callback
    notifyOnSeatsChanged();

    /// pop up
    if (kickSeatDialogInfo.isExist(
      userID:
          seatsUserMapNotifier.value[kickSeatDialogInfo.userIndex.toString()] ??
              '',
      userIndex: kickSeatDialogInfo.userIndex,
      allSame: true,
    )) {
      ZegoLoggerService.logInfo(
        'close kick seat dialog',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      kickSeatDialogInfo.clear();
      Navigator.of(contextQuery()).pop(false);
    }
  }

  void notifyOnSeatsChanged() {
    final takenSeats = <int, ZegoUIKitUser>{};
    seatsUserMapNotifier.value.forEach((seatIndex, seatUserID) {
      takenSeats[int.tryParse(seatIndex) ?? -1] =
          ZegoUIKit().getUser(seatUserID) ?? ZegoUIKitUser.empty();
    });
    prebuiltController?.onSeatsChanged?.call(
      takenSeats,
      List<int>.generate(
          config.layoutConfig.rowConfigs
              .fold(0, (totalCount, rowConfig) => totalCount + rowConfig.count),
          (index) => index)
        ..removeWhere((seatIndex) => takenSeats.keys.contains(seatIndex)),
    );
  }

  void onSeatLockedChanged() {
    if (!isSeatLockedNotifier.value) {
      /// after seat is unlocked

      if (localIsAHost) {
        /// host cancels the invitation
        _connectManager?.hostCancelTakeSeatInvitation();
      } else if (localIsAAudience) {
        /// audience cancels self requesting
        _connectManager?.audienceCancelTakeSeatRequest();
      }
    }

    _connectManager?.onSeatLockedChanged(isSeatLockedNotifier.value);

    isSeatLockedNotifier.value
        ? prebuiltController?.onSeatClosed?.call()
        : prebuiltController?.onSeatsOpened?.call();
  }

  bool isSpeaker(ZegoUIKitUser user) {
    return -1 != getIndexByUserID(user.id);
  }

  bool isAttributeHost(ZegoUIKitUser? user) {
    if (null == user) {
      return false;
    }

    final inRoomAttributes = user.inRoomAttributes.value;
    if (!inRoomAttributes.containsKey(attributeKeyRole)) {
      return false;
    }

    return inRoomAttributes[attributeKeyRole] ==
        ZegoLiveAudioRoomRole.host.index.toString();
  }

  Future<bool> setRoleAttribute(
    ZegoLiveAudioRoomRole role,
    String targetUserID,
  ) async {
    ZegoLoggerService.logInfo(
      '$targetUserID set role in-room attribute: $role',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    return ZegoUIKit().getSignalingPlugin().setUsersInRoomAttributes(
      roomID: roomID,
      key: attributeKeyRole,
      value: role.index.toString(),
      userIDs: [targetUserID],
    ).then((result) {
      final success = result.error == null;
      if (success) {
        ZegoLoggerService.logInfo(
          'host set in-room attribute result success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      } else {
        ZegoLoggerService.logInfo(
          'host set in-room attribute result '
          'faild, error:${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );

        showDebugToast('host set in-room attribute failed, ${result.error}');
      }
      return success;
    });
  }

  Future<bool> takeOnSeat(
    int index, {
    bool isForce = false,
    bool isUpdateOwner = false,
    bool isDeleteAfterOwnerLeft = false,
  }) async {
    if (index < 0) {
      ZegoLoggerService.logInfo(
        'take on seat, seat $index is not valid',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    if (!isForce && !isTargetSeatEmpty(index)) {
      ZegoLoggerService.logInfo(
        'take on seat, seat $index is not empty',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    if (-1 != getIndexByUserID(localUserID)) {
      ZegoLoggerService.logInfo(
        'take on seat, user is on seat , switch to $index',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return switchToSeat(index);
    }

    if (_isRoomAttributesBatching) {
      ZegoLoggerService.logInfo(
        'take on seat, room attribute is batching, ignore',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    ZegoLoggerService.logInfo(
      'local user take on seat $index, target room attribute:${{
        index.toString(): localUserID
      }}',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    _isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomPropertiesBatchOperation(
          roomID: roomID,
          isForce: isForce,
          isUpdateOwner: isUpdateOwner,
          isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
        );
    ZegoUIKit()
        .getSignalingPlugin()
        .updateRoomProperty(
            roomID: roomID, key: index.toString(), value: localUserID)
        .then((result) {
      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'take on $index seat is failed, ${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      } else {
        ZegoLoggerService.logInfo(
          'local user take on seat $index success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });
    return ZegoUIKit()
        .getSignalingPlugin()
        .endRoomPropertiesBatchOperation(roomID: roomID)
        .then((result) {
      _isRoomAttributesBatching = false;
      ZegoLoggerService.logInfo('room attribute batch is finished');
      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'take on seat result, error:${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        showDebugToast('take on seat error, ${result.error}');

        _connectManager?.updateAudienceConnectState(ConnectState.idle);
      } else {
        _connectManager?.updateAudienceConnectState(ConnectState.connected);

        ZegoLoggerService.logInfo(
          'room attribute batch success finished',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }

      return result.error == null;
    });
  }

  Future<bool> switchToSeat(int index) async {
    if (_isRoomAttributesBatching) {
      ZegoLoggerService.logInfo(
        'switch seat, room attribute is batching, ignore',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    if (isSeatLockedNotifier.value) {
      ZegoLoggerService.logInfo(
        'switch seat, seat is locked, ignore',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    final oldSeatIndex = getIndexByUserID(localUserID);

    ZegoLoggerService.logInfo(
      'local user switch on seat from $oldSeatIndex to $index, '
      'target room attributes:${{index.toString(): localUserID}}',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    _isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomPropertiesBatchOperation(
          roomID: roomID,
          isDeleteAfterOwnerLeft: true,
        );
    ZegoUIKit()
        .getSignalingPlugin()
        .updateRoomProperty(
            roomID: roomID, key: index.toString(), value: localUserID)
        .then((result) {
      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'switch seat $index, '
          'updateRoomProperty faild, error:${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );

        showDebugToast('switch seat $index, '
            'updateRoomProperty faild, error:${result.error}');
      } else {
        ZegoLoggerService.logInfo(
          'switch seat $index '
          'updateRoomProperty success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });
    ZegoUIKit().getSignalingPlugin().deleteRoomProperties(
        roomID: roomID, keys: [oldSeatIndex.toString()]).then((result) {
      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'switch seat $index, '
          'deleteRoomProperties faild, error:${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );

        showDebugToast('switch seat $index, '
            'deleteRoomProperties faild, error:${result.error}');
      } else {
        ZegoLoggerService.logInfo(
          'switch seat $index '
          'deleteRoomProperties success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });
    await ZegoUIKit()
        .getSignalingPlugin()
        .endRoomPropertiesBatchOperation(roomID: roomID)
        .then((result) {
      _isRoomAttributesBatching = false;
      ZegoLoggerService.logInfo(
        'switch seat, room attribute batch is finished',
        tag: 'audio room',
        subTag: 'seat manager',
      );

      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'switch seat $index, '
          'endRoomPropertiesBatchOperation faild, error:${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );

        showDebugToast('switch seat $index, '
            'endRoomPropertiesBatchOperation faild, error:${result.error}');
      } else {
        ZegoLoggerService.logInfo(
          'switch seat $index '
          'endRoomPropertiesBatchOperation success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });

    return true;
  }

  Future<void> kickSeat(int index) async {
    final targetUser = getUserByIndex(index);
    if (null == targetUser) {
      ZegoLoggerService.logInfo(
        'kick seat $index user id is empty',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return;
    }

    if (kickSeatDialogInfo.isNotEmpty) {
      ZegoLoggerService.logInfo(
        'kick seat, dialog is visible',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return;
    }

    kickSeatDialogInfo =
        KickSeatDialogInfo(userID: targetUser.id, userIndex: index);
    final dialogInfo = innerText.removeFromSeatDialogInfo;
    await showLiveDialog(
      context: contextQuery(),
      title: dialogInfo.title,
      content: dialogInfo.message.replaceFirst(
        innerText.param_1,
        targetUser.name,
      ),
      leftButtonText: dialogInfo.cancelButtonName,
      leftButtonCallback: () {
        kickSeatDialogInfo.clear();
        Navigator.of(contextQuery()).pop(false);
      },
      rightButtonText: dialogInfo.confirmButtonName,
      rightButtonCallback: () async {
        kickSeatDialogInfo.clear();
        Navigator.of(contextQuery()).pop(true);

        await takeOffSeat(index, isForce: true);
      },
    );
  }

  Future<bool> leaveSeat({bool showDialog = true}) async {
    /// take off seat when leave room
    final localSeatIndex = getIndexByUserID(ZegoUIKit().getLocalUser().id);
    if (-1 == localSeatIndex) {
      ZegoLoggerService.logInfo(
        'local is not on seat, not need to leave',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    if (showDialog && _isLeaveSeatDialogVisible) {
      ZegoLoggerService.logInfo(
        'leave seat, dialog is visible',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    ZegoLoggerService.logInfo(
      'local is on seat $localSeatIndex, leaving..',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    if (showDialog) {
      _isLeaveSeatDialogVisible = true;
      final dialogInfo = innerText.leaveSeatDialogInfo;
      await showLiveDialog(
        context: contextQuery(),
        title: dialogInfo.title,
        content: dialogInfo.message,
        leftButtonText: dialogInfo.cancelButtonName,
        leftButtonCallback: () {
          _isLeaveSeatDialogVisible = false;
          Navigator.of(contextQuery()).pop(false);
        },
        rightButtonText: dialogInfo.confirmButtonName,
        rightButtonCallback: () async {
          _isLeaveSeatDialogVisible = false;
          Navigator.of(contextQuery()).pop(true);
          await takeOffSeat(localSeatIndex);
        },
      );
    } else {
      await takeOffSeat(localSeatIndex);
    }
    return true;
  }

  Future<bool> takeOffSeat(int index, {bool isForce = false}) async {
    final targetUser = getUserByIndex(index);
    if (null == targetUser) {
      ZegoLoggerService.logInfo(
        'take off seat $index user id is empty',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    if (_isRoomAttributesBatching) {
      ZegoLoggerService.logInfo(
        'take off seat, room attribute is batching, ignore',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    ZegoLoggerService.logInfo(
      'take off ${targetUser.toString()} from seat $index',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    _isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomPropertiesBatchOperation(
          roomID: roomID,
          isForce: isForce,
        );
    ZegoUIKit().getSignalingPlugin().deleteRoomProperties(
        roomID: roomID, keys: [index.toString()]).then((result) {
      if (result.error != null) {
        showError(innerText.removeSpeakerFailedToast
            .replaceFirst(innerText.param_1, targetUser.name));
        ZegoLoggerService.logInfo(
          'take off ${targetUser.name} from $index seat '
          ' failed, ${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      } else {
        ZegoLoggerService.logInfo(
          'take off ${targetUser.toString()} from seat '
          '$index success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });
    await ZegoUIKit()
        .getSignalingPlugin()
        .endRoomPropertiesBatchOperation(roomID: roomID)
        .then((result) {
      _isRoomAttributesBatching = false;
      ZegoLoggerService.logInfo(
        'take off seat, room attribute batch is finished',
        tag: 'audio room',
        subTag: 'seat manager',
      );

      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'take off seat faild, error: ${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        showDebugToast('take off seat faild, error: ${result.error}');
      } else {
        if (targetUser.id == ZegoUIKit().getLocalUser().id) {
          _connectManager?.updateAudienceConnectState(ConnectState.idle);
        }

        ZegoLoggerService.logInfo(
          'take off seat success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });

    return true;
  }

  Future<void> muteSeat(int index) async {
    final targetUser = getUserByIndex(index);
    if (null == targetUser) {
      ZegoLoggerService.logInfo(
        'mute seat $index user id is empty',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return;
    }

    ZegoUIKit().turnMicrophoneOn(false, userID: targetUser.id);
  }

  ZegoUIKitUser? getUserByIndex(int index) {
    return ZegoUIKit()
        .getUser(seatsUserMapNotifier.value[index.toString()] ?? '');
  }

  int getIndexByUserID(String userID) {
    var queryUserIndex = -1;
    seatsUserMapNotifier.value.forEach((seatIndex, seatUserID) {
      if (seatUserID == userID) {
        queryUserIndex = int.parse(seatIndex);
      }
    });

    return queryUserIndex;
  }

  int getNearestEmptyIndex() {
    final emptySeats = getEmptySeats();

    return emptySeats.isEmpty ? -1 : emptySeats.first;
  }

  List<int> getEmptySeats() {
    final takenSeats = <int, ZegoUIKitUser>{};
    seatsUserMapNotifier.value.forEach((seatIndex, seatUserID) {
      takenSeats[int.tryParse(seatIndex) ?? -1] =
          ZegoUIKit().getUser(seatUserID) ?? ZegoUIKitUser.empty();
    });

    final emptyList = List<int>.generate(
        config.layoutConfig.rowConfigs
            .fold(0, (totalCount, rowConfig) => totalCount + rowConfig.count),
        (index) => index)
      ..removeWhere((seatIndex) => takenSeats.keys.contains(seatIndex));

    return emptyList;
  }

  bool isTargetSeatEmpty(int index) {
    return !seatsUserMapNotifier.value.containsKey(index.toString());
  }

  void onUsersAttributesUpdated(
      ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent event) {
    ZegoLoggerService.logInfo(
      'onUsersAttributesUpdated $event',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    updateRoleFromUserAttributes(event.attributes);
  }

  /// users attributes only contain 'host' now
  void updateRoleFromUserAttributes(Map<String, Map<String, String>> infos) {
    ZegoLoggerService.logInfo(
      'updateUserAttributes:$infos',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    infos.forEach((updateUserID, updateUserAttributes) {
      final updateUser = ZegoUIKit().getUser(updateUserID);
      if (null == updateUser) {
        _pendingUserRoomAttributes[updateUserID] = updateUserAttributes;
        ZegoLoggerService.logInfo(
          'updateUserAttributes, but user($updateUserID) '
          'is not exist, deal when user enter',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        return;
      }

      /// update hosts
      cacheHosts(updateUser, updateUserAttributes);

      /// update local role
      if (localUserID == updateUserID) {
        if (updateUserAttributes[attributeKeyRole]?.isEmpty ?? true) {
          if (localRole.value != ZegoLiveAudioRoomRole.host ||
              _hostSeatAttributeInitialed) {
            localRole.value = ZegoLiveAudioRoomRole.audience;
          }
        } else {
          localRole.value = ZegoLiveAudioRoomRole.values[
              int.parse(updateUserAttributes[attributeKeyRole]!.toString())];
        }
        ZegoLoggerService.logInfo(
          'update local role:${localRole.value}',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });
  }

  void cacheHosts(
    ZegoUIKitUser updateUser,
    Map<String, String> updateUserAttributes,
  ) {
    /// update host
    final currentHosts = List<String>.from(hostsNotifier.value);
    if (currentHosts.contains(updateUser.id)) {
      /// local is host
      if (
          //  host key is removed
          !updateUserAttributes.containsKey(attributeKeyRole) ||
              // host is kicked or leave
              (updateUserAttributes.containsKey(attributeKeyRole) &&
                  (updateUserAttributes[attributeKeyRole]!.isEmpty ||
                      updateUserAttributes[attributeKeyRole]! !=
                          ZegoLiveAudioRoomRole.host.index.toString()))) {
        currentHosts.removeWhere((userID) => userID == updateUser.id);
      }
    } else if (updateUserAttributes.containsKey(attributeKeyRole) &&
        updateUserAttributes[attributeKeyRole]! ==
            ZegoLiveAudioRoomRole.host.index.toString()) {
      /// new host?
      currentHosts.add(updateUser.id);
    }
    hostsNotifier.value = currentHosts;
    ZegoLoggerService.logInfo(
      'hosts is :${hostsNotifier.value}',
      tag: 'audio room',
      subTag: 'seat manager',
    );
  }

  void onUserListUpdated(List<ZegoUIKitUser> users) {
    final doneUserIDs = <String>[];
    _pendingUserRoomAttributes
      ..forEach((userID, userAttributes) {
        ZegoLoggerService.logInfo(
          'exist pending user attribute, user '
          'id: $userID, attributes: $userAttributes',
          tag: 'audio room',
          subTag: 'seat manager',
        );

        final user = ZegoUIKit().getUser(userID);
        if (user != null && !user.isEmpty()) {
          updateRoleFromUserAttributes({userID: userAttributes});

          doneUserIDs.add(userID);
        }
      })
      ..removeWhere((userID, userAttributes) => doneUserIDs.contains(userID));

    if (doneUserIDs.isNotEmpty) {
      /// force update layout
      final seatsUsersMap =
          Map<String, String>.from(seatsUserMapNotifier.value);
      seatsUserMapNotifier.value = seatsUsersMap;
    }

    final userIDs = users.map((e) => e.id).toList();
    if (seatsUserMapNotifier.value.values
        .any((userID) => userIDs.contains(userID))) {
      notifyOnSeatsChanged();
    }
  }

  void onRoomAttributesUpdated(
    ZegoSignalingPluginRoomPropertiesUpdatedEvent propertiesData,
  ) {
    ZegoLoggerService.logInfo(
      'onRoomAttributesUpdated $propertiesData',
      tag: 'audio room',
      subTag: 'seat manager',
    );
    updateSeatUsersByRoomAttributes(
      propertiesData.setProperties,
      propertiesData.deleteProperties,
    );
    updateLockStatusByRoomAttributes(
      propertiesData.setProperties,
      propertiesData.deleteProperties,
    );
  }

  void onRoomBatchAttributesUpdated(
      ZegoSignalingPluginRoomPropertiesBatchUpdatedEvent propertiesData) {
    ZegoLoggerService.logInfo(
      'onRoomBatchAttributesUpdated, $propertiesData}',
      tag: 'audio room',
      subTag: 'seat manager',
    );
    updateSeatUsersByRoomAttributes(
        propertiesData.setProperties, propertiesData.deleteProperties);
  }

  void updateLockStatusByRoomAttributes(
    Map<String, String> setProperties,
    Map<String, String> deleteProperties,
  ) {
    if (deleteProperties.containsKey(attributeKeyLockSeat)) {
      isSeatLockedPropertyAlreadySet = true;
      isSeatLockedNotifier.value = false;
    }

    if (setProperties.containsKey(attributeKeyLockSeat)) {
      isSeatLockedPropertyAlreadySet = true;
      isSeatLockedNotifier.value =
          0 != (int.tryParse(setProperties[attributeKeyLockSeat]!) ?? 0);
    }
  }

  void updateSeatUsersByRoomAttributes(
    Map<String, String> setProperties,
    Map<String, String> deleteProperties,
  ) {
    final seatsUsersMap = Map<String, String>.from(seatsUserMapNotifier.value);

    setProperties.forEach((_seatIndex, _seatUserId) {
      final seatIndex = int.tryParse(_seatIndex);
      if (seatIndex != null) {
        final seatUserId = _seatUserId;
        if (seatsUsersMap.values.contains(seatUserId)) {
          /// old seat user
          ZegoLoggerService.logInfo(
            'user($seatUserId) has '
            'old data $seatsUsersMap, clear it',
            tag: 'audio room',
            subTag: 'seat manager',
          );
          seatsUsersMap.removeWhere(
              (mapSeatIndex, mapSeatUserID) => mapSeatUserID == seatUserId);
        }
        seatsUsersMap[seatIndex.toString()] = seatUserId;
      }
    });
    deleteProperties.forEach((key, value) {
      final seatIndex = int.tryParse(key);
      if (seatIndex != null) {
        if (kickSeatDialogInfo.isExist(userIndex: seatIndex)) {
          ZegoLoggerService.logInfo(
            'close kick seat dialog',
            tag: 'audio room',
            subTag: 'seat manager',
          );
          kickSeatDialogInfo.clear();
          Navigator.of(contextQuery()).pop(false);
        }
        seatsUsersMap.remove(seatIndex.toString());
      }
    });

    seatsUserMapNotifier.value = seatsUsersMap;

    if (localRole.value == ZegoLiveAudioRoomRole.host &&
        !seatsUserMapNotifier.value.values.contains(localUserID)) {
      if (_hostSeatAttributeInitialed) {
        ZegoLoggerService.logInfo(
          "host's seat is been take off, set host to an audience",
          tag: 'audio room',
          subTag: 'seat manager',
        );

        setRoleAttribute(ZegoLiveAudioRoomRole.audience, localUserID)
            .then((success) {
          if (success) {
            localRole.value =
                seatsUserMapNotifier.value.values.contains(localUserID)
                    ? ZegoLiveAudioRoomRole.speaker
                    : ZegoLiveAudioRoomRole.audience;
            ZegoLoggerService.logInfo(
              "local host's role change by room attribute: ${localRole.value}",
              tag: 'audio room',
              subTag: 'seat manager',
            );
          }
        });
      }
    } else {
      if (localRole.value != ZegoLiveAudioRoomRole.host) {
        localRole.value =
            seatsUserMapNotifier.value.values.contains(localUserID)
                ? ZegoLiveAudioRoomRole.speaker
                : ZegoLiveAudioRoomRole.audience;
        ZegoLoggerService.logInfo(
          'local user role change by room attribute: ${localRole.value}',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    }

    ZegoLoggerService.logInfo(
      'seats users is: ${seatsUserMapNotifier.value}',
      tag: 'audio room',
      subTag: 'seat manager',
    );
  }

  void setPopUpSheetVisible(bool isShow) {
    _isPopUpSheetVisible = isShow;
  }

  void setKickSeatDialogInfo(KickSeatDialogInfo kickSeatDialogInfo) {
    this.kickSeatDialogInfo = kickSeatDialogInfo;
  }

  Future<bool> queryRoomAllAttributes({bool withToast = true}) async {
    ZegoLoggerService.logInfo(
      'query room all attributes',
      tag: 'audio room',
      subTag: 'seat manager',
    );
    return ZegoUIKit()
        .getSignalingPlugin()
        .queryRoomProperties(roomID: roomID)
        .then((result) {
      final success = result.error == null;
      ZegoLoggerService.logInfo(
        'query room all attributes finish, result: $result',
        tag: 'audio room',
        subTag: 'seat manager',
      );

      if (success) {
        /// remove if not exist anymore
        final propertyKeys = result.properties.keys.toList()
          ..removeWhere((propertyKey) {
            return int.tryParse(propertyKey) == null;
          });
        final propertySeatIndexes =
            propertyKeys.map((e) => int.parse(e)).toList();
        seatsUserMapNotifier.value =
            Map<String, String>.from(seatsUserMapNotifier.value)
              ..removeWhere((seatIndex, userID) {
                return !propertySeatIndexes.contains(int.parse(seatIndex));
              });

        updateSeatUsersByRoomAttributes(result.properties, {});

        updateLockStatusByRoomAttributes(result.properties, {});
      } else {
        if (withToast) {
          showDebugToast(
              'query users in-room attributes error, ${result.error}');
        }
      }

      return success;
    });
  }

  Future<bool> initLocalAvatarAttribute() async {
    ZegoLoggerService.logInfo(
      'set local user avatar attribute: ${config.userAvatarUrl ?? ''}',
      tag: 'audio room',
      subTag: 'prebuilt',
    );

    return ZegoUIKit().getSignalingPlugin().setUsersInRoomAttributes(
      roomID: roomID,
      key: attributeKeyAvatar,
      value: config.userAvatarUrl ?? '',
      userIDs: [localUserID],
    ).then((result) {
      final success = result.error == null;
      if (success) {
        ZegoLoggerService.logInfo(
          'set local user avatar attribute result success',
          tag: 'audio room',
          subTag: 'prebuilt',
        );
      } else {
        ZegoLoggerService.logInfo(
          'set local user avatar attribute result failed, error:${result.error}',
          tag: 'audio room',
          subTag: 'prebuilt',
        );

        showDebugToast(
            'set local user avatar attribute failed, ${result.error}');
      }
      return success;
    });
  }

  Future<void> initLocalInRoomAttributes() async {
    ZegoLoggerService.logInfo(
      'init local user in-room attributes: ${config.userInRoomAttributes}',
      tag: 'audio room',
      subTag: 'prebuilt',
    );

    config.userInRoomAttributes.forEach((key, value) async {
      return ZegoUIKit().getSignalingPlugin().setUsersInRoomAttributes(
        roomID: roomID,
        key: key,
        value: value,
        userIDs: [localUserID],
      ).then((result) async {
        final success = result.error == null;
        if (success) {
          ZegoLoggerService.logInfo(
            'init local user in-room attributes{$key, $value}: result success',
            tag: 'audio room',
            subTag: 'prebuilt',
          );
        } else {
          ZegoLoggerService.logInfo(
            'init local user in-room attributes{$key, $value}: result failed, error:${result.error}',
            tag: 'audio room',
            subTag: 'prebuilt',
          );

          showDebugToast(
              'init local user in-room attributes{$key, $value}: failed, ${result.error}');
        }
      });
    });
  }
}

class KickSeatDialogInfo {
  KickSeatDialogInfo({
    this.userID = '',
    this.userIndex = -1,
  });

  KickSeatDialogInfo.empty();

  int userIndex = -1;
  String userID = '';

  bool get isEmpty => -1 == userIndex || userID.isEmpty;

  bool get isNotEmpty => -1 != userIndex && userID.isNotEmpty;

  bool isExist({
    String? userID,
    int? userIndex,
    bool allSame = false,
  }) {
    if (isEmpty) {
      return false;
    }

    if (allSame) {
      return this.userIndex == userIndex && this.userID == userID;
    }

    return this.userIndex == userIndex || this.userID == userID;
  }

  void clear() {
    userID = '';
    userIndex = -1;
  }
}
