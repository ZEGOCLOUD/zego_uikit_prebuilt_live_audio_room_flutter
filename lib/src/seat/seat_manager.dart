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
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/plugins.dart';

class ZegoLiveSeatManager {
  ZegoLiveSeatManager({
    required this.userID,
    required this.roomID,
    required this.plugins,
    required this.config,
    required this.translationText,
    required this.contextQuery,
  }) {
    localRole.value = config.role;

    subscriptions
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
  final String userID;
  final String roomID;
  final ZegoPrebuiltPlugins plugins;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final BuildContext Function() contextQuery;
  final ZegoTranslationText translationText;

  KickSeatDialogInfo kickSeatDialogInfo = KickSeatDialogInfo.empty();

  bool isLeaveSeatDialogVisible = false;
  bool isPopUpSheetVisible = false;
  bool isRoomAttributesBatching = false;
  bool hostSeatAttributeInitialed = false;

  Map<String, Map<String, String>> pendingUserRoomAttributes = {};
  List<StreamSubscription<dynamic>?> subscriptions = [];

  ValueNotifier<List<String>> hostsNotifier = ValueNotifier<List<String>>([]);
  ValueNotifier<ZegoLiveAudioRoomRole> localRole =
      ValueNotifier<ZegoLiveAudioRoomRole>(ZegoLiveAudioRoomRole.audience);

  bool get localIsAHost => ZegoLiveAudioRoomRole.host == localRole.value;

  bool isAHostSeat(int index) => config.hostSeatIndexes.contains(index);

  ValueNotifier<Map<String, String>> seatsUserMapNotifier =
      ValueNotifier<Map<String, String>>({}); //  <seat id, user id>

  Future<void> init() async {
    ZegoLoggerService.logInfo(
      'init',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    await queryUsersInRoomAttributes();

    localRole.addListener(onRoleChanged);
    seatsUserMapNotifier.addListener(onSeatUsersChanged);
  }

  Future<void> uninit() async {
    ZegoLoggerService.logInfo(
      'uninit',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    ZegoUIKit().turnMicrophoneOn(false);

    seatsUserMapNotifier.value.clear();
    hostSeatAttributeInitialed = false;
    isRoomAttributesBatching = false;

    seatsUserMapNotifier.removeListener(onSeatUsersChanged);
    localRole.removeListener(onRoleChanged);
    for (final subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  Future<bool> queryUsersInRoomAttributes({bool withToast = true}) async {
    ZegoLoggerService.logInfo(
      'query init users in-room attributes',
      tag: 'audio room',
      subTag: 'seat manager',
    );
    return await ZegoUIKit()
        .getSignalingPlugin()
        .queryUsersInRoomAttributes(
          roomID: roomID,
        )
        .then((result) {
      final success = result.error == null;
      ZegoLoggerService.logInfo(
        'query finish, result:$result',
        tag: 'audio room',
        subTag: 'seat manager',
      );

      ZegoLoggerService.logInfo(
        'query finish, result:$result',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      if (success) {
        updateRoleFromUserAttributes(result.attributes);
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
      hostSeatAttributeInitialed = false;
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
        hostSeatAttributeInitialed = true;

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
            await setRoleAttribute(localRole.value, userID)
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
        translationText: translationText,
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

      if (isLeaveSeatDialogVisible) {
        ZegoLoggerService.logInfo(
          'close leave seat dialog',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        isLeaveSeatDialogVisible = false;
        Navigator.of(contextQuery()).pop(false);
      }
      if (isPopUpSheetVisible) {
        ZegoLoggerService.logInfo(
          'close pop up sheet',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        isPopUpSheetVisible = false;
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

    if (!seatsUserMapNotifier.value.values.contains(userID)) {
      ZegoLoggerService.logInfo(
        'local is not on seat now, turn off microphone',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      ZegoUIKit().turnMicrophoneOn(false);
    }

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

  bool isSpeaker(ZegoUIKitUser user) {
    return -1 != getIndexByUserID(user.id);
  }

  bool isAttributeHost(ZegoUIKitUser? user) {
    if (null == user) {
      return false;
    }

    final inRoomAttributes =
        ZegoUIKit().getInRoomUserAttributesNotifier(user.id).value;
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
    if (!isForce && !isSeatEmpty(index)) {
      ZegoLoggerService.logInfo(
        'take on seat, seat $index is not empty',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    if (-1 != getIndexByUserID(userID)) {
      ZegoLoggerService.logInfo(
        'take on seat, user is on seat , switch to $index',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return switchToSeat(index);
    }

    if (isRoomAttributesBatching) {
      ZegoLoggerService.logInfo(
        'take on seat, room attribute is batching, ignore',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    ZegoLoggerService.logInfo(
      'local user take on seat $index, target room attribute:${{
        index.toString(): userID
      }}',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomPropertiesBatchOperation(
          roomID: roomID,
          isForce: isForce,
          isUpdateOwner: isUpdateOwner,
          isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
        );
    ZegoUIKit()
        .getSignalingPlugin()
        .updateRoomProperty(
            roomID: roomID, key: index.toString(), value: userID)
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
    await ZegoUIKit()
        .getSignalingPlugin()
        .endRoomPropertiesBatchOperation(roomID: roomID)
        .then((result) {
      isRoomAttributesBatching = false;
      ZegoLoggerService.logInfo('room attribute batch is finished');
      if (result.error != null) {
        ZegoLoggerService.logInfo(
          'take on seat result, error:${result.error}',
          tag: 'audio room',
          subTag: 'seat manager',
        );
        showDebugToast('take on seat error, ${result.error}');
      } else {
        ZegoLoggerService.logInfo(
          'room attribute batch success finished',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });

    return true;
  }

  Future<bool> switchToSeat(int index) async {
    if (isRoomAttributesBatching) {
      ZegoLoggerService.logInfo(
        'switch seat, room attribute is batching, ignore',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    final oldSeatIndex = getIndexByUserID(userID);

    ZegoLoggerService.logInfo(
      'local user switch on seat from $oldSeatIndex to $index, '
      'target room attributes:${{index.toString(): userID}}',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomPropertiesBatchOperation(
          roomID: roomID,
          isDeleteAfterOwnerLeft: true,
        );
    ZegoUIKit()
        .getSignalingPlugin()
        .updateRoomProperty(
            roomID: roomID, key: index.toString(), value: userID)
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
      isRoomAttributesBatching = false;
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
        'seat $index user id is empty',
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
    final dialogInfo = translationText.removeFromSeatDialogInfo;
    await showLiveDialog(
      context: contextQuery(),
      title: dialogInfo.title,
      content: dialogInfo.message.replaceFirst(
        translationText.param_1,
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

  Future<void> leaveSeat({bool showDialog = true}) async {
    /// take off seat when leave room
    final localSeatIndex = getIndexByUserID(ZegoUIKit().getLocalUser().id);
    if (-1 == localSeatIndex) {
      ZegoLoggerService.logInfo(
        'local is not on seat, not need to leave',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return;
    }

    if (showDialog && isLeaveSeatDialogVisible) {
      ZegoLoggerService.logInfo(
        'leave seat, dialog is visible',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return;
    }

    ZegoLoggerService.logInfo(
      'local is on seat $localSeatIndex, leaving..',
      tag: 'audio room',
      subTag: 'seat manager',
    );

    if (showDialog) {
      isLeaveSeatDialogVisible = true;
      final dialogInfo = translationText.leaveSeatDialogInfo;
      await showLiveDialog(
        context: contextQuery(),
        title: dialogInfo.title,
        content: dialogInfo.message,
        leftButtonText: dialogInfo.cancelButtonName,
        leftButtonCallback: () {
          isLeaveSeatDialogVisible = false;
          Navigator.of(contextQuery()).pop(false);
        },
        rightButtonText: dialogInfo.confirmButtonName,
        rightButtonCallback: () async {
          isLeaveSeatDialogVisible = false;
          Navigator.of(contextQuery()).pop(true);

          await takeOffSeat(localSeatIndex);
        },
      );
    } else {
      await takeOffSeat(localSeatIndex);
    }
  }

  Future<bool> takeOffSeat(int index, {bool isForce = false}) async {
    final targetUser = getUserByIndex(index);
    if (null == targetUser) {
      ZegoLoggerService.logInfo(
        'seat $index user id is empty',
        tag: 'audio room',
        subTag: 'seat manager',
      );
      return false;
    }

    if (isRoomAttributesBatching) {
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

    isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomPropertiesBatchOperation(
          roomID: roomID,
          isForce: isForce,
        );
    ZegoUIKit().getSignalingPlugin().deleteRoomProperties(
        roomID: roomID, keys: [index.toString()]).then((result) {
      if (result.error != null) {
        showError(translationText.removeSpeakerFailedToast
            .replaceFirst(translationText.param_1, targetUser.name));
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
      isRoomAttributesBatching = false;
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
        ZegoLoggerService.logInfo(
          'take off seat success',
          tag: 'audio room',
          subTag: 'seat manager',
        );
      }
    });

    return true;
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

  bool isSeatEmpty(int index) {
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
        pendingUserRoomAttributes[updateUserID] = updateUserAttributes;
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
      if (userID == updateUserID) {
        if (!updateUserAttributes.containsKey(attributeKeyRole) ||
            updateUserAttributes[attributeKeyRole]!.isEmpty) {
          localRole.value = ZegoLiveAudioRoomRole.audience;
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
    pendingUserRoomAttributes
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
  }

  void onRoomAttributesUpdated(
      ZegoSignalingPluginRoomPropertiesUpdatedEvent propertiesData) {
    ZegoLoggerService.logInfo(
      'onRoomAttributesUpdated $propertiesData',
      tag: 'audio room',
      subTag: 'seat manager',
    );
    updateSeatUsersByRoomAttributes(
        propertiesData.setProperties, propertiesData.deleteProperties);
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

  void updateSeatUsersByRoomAttributes(
      Map<String, String> setProperties, Map<String, String> deleteProperties) {
    final seatsUsersMap = Map<String, String>.from(seatsUserMapNotifier.value);

    setProperties.forEach((key, value) {
      final seatIndex = int.tryParse(key);
      if (seatIndex != null) {
        final seatUserId = value;
        if (seatsUsersMap.values.contains(seatUserId)) {
          /// old seat user
          ZegoLoggerService.logInfo(
            'user($seatUserId) has '
            'old data$seatsUsersMap, clear it',
            tag: 'audio room',
            subTag: 'seat manager',
          );
          seatsUsersMap.removeWhere((key, value) => value == seatUserId);
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
        !seatsUserMapNotifier.value.values.contains(userID)) {
      if (hostSeatAttributeInitialed) {
        ZegoLoggerService.logInfo(
          "host's seat is been take off, set host to an audience",
          tag: 'audio room',
          subTag: 'seat manager',
        );

        setRoleAttribute(ZegoLiveAudioRoomRole.audience, userID)
            .then((success) {
          if (success) {
            localRole.value = seatsUserMapNotifier.value.values.contains(userID)
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
        localRole.value = seatsUserMapNotifier.value.values.contains(userID)
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
    isPopUpSheetVisible = isShow;
  }

  void setKickSeatDialogInfo(KickSeatDialogInfo kickSeatDialogInfo) {
    this.kickSeatDialogInfo = kickSeatDialogInfo;
  }

  Future<bool> queryRoomAllAttributes({bool withToast = true}) async {
    ZegoLoggerService.logInfo(
      ' query room all attributes',
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
        updateSeatUsersByRoomAttributes(result.properties, {});
      } else {
        if (withToast) {
          showDebugToast(
              'query users in-room attributes error, ${result.error}');
        }
      }

      return success;
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
