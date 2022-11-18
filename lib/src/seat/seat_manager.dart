// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/dialogs.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'defines.dart';

class ZegoLiveSeatManager {
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final BuildContext Function() contextQuery;
  final ZegoTranslationText translationText;

  ZegoLiveSeatManager({
    required this.config,
    required this.translationText,
    required this.contextQuery,
  }) {
    role.value = config.role;

    subscriptions
      ..add(ZegoUIKit().getUserListStream().listen(onUserListUpdated))
      ..add(ZegoUIKitSignalingPluginImp.shared
          .getRoomAttributesStream()
          .listen(onRoomAttributesUpdated))
      ..add(ZegoUIKitSignalingPluginImp.shared
          .getRoomBatchAttributesStream()
          .listen(onRoomBatchAttributesUpdated))
      ..add(ZegoUIKitSignalingPluginImp.shared
          .getUsersInRoomAttributesStream()
          .listen(onUsersInRoomAttributesUpdated));
  }

  int userIndexOfKickSeatDialog = -1;
  bool isLeaveSeatDialogVisible = false;
  Map<String, Map<String, String>> pendingUserRoomAttributes = {};
  List<StreamSubscription<dynamic>?> subscriptions = [];

  var hostsNotifier = ValueNotifier<List<String>>([]);
  var role =
      ValueNotifier<ZegoLiveAudioRoomRole>(ZegoLiveAudioRoomRole.audience);

  String get localUserID => ZegoUIKit().getLocalUser().id;

  int get hostIndex => 0;

  var seatsUserMapNotifier =
      ValueNotifier<Map<String, String>>({}); //  <seat id, user id>

  void init() {
    debugPrint("[seat manager] query init users in-room attributes");
    ZegoUIKitSignalingPluginImp.shared
        .queryUsersInRoomAttributesList()
        .then((result) {
      debugPrint(
          "[seat manager] query result: ${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showToast(
            "query users in-room attributes error, ${result.code} ${result.message}");
        return;
      }

      updateUserRoomAttributes(
          result.result as Map<String, Map<String, String>>);
    });

    role.addListener(onRoleChanged);
  }

  Future<void> uninit() async {
    debugPrint("[seat manager] uninit");

    seatsUserMapNotifier.value.clear();

    role.removeListener(onRoleChanged);
    for (var subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  void onRoleChanged() {
    debugPrint("[seat manager] local user role changed to ${role.value}");

    if (ZegoLiveAudioRoomRole.speaker == role.value) {
      requestPermissions(
        context: contextQuery(),
        translationText: translationText,
        isShowDialog: true,
      ).then((value) {
        debugPrint("[seat manager] local is speaker now, turn on microphone");
        ZegoUIKit().turnMicrophoneOn(true);
      });
    } else {
      debugPrint("[seat manager] local is audience now, turn off microphone");
      ZegoUIKit().turnMicrophoneOn(false);

      if (isLeaveSeatDialogVisible) {
        debugPrint("[seat manager] close leave seat dialog");
        isLeaveSeatDialogVisible = false;
        Navigator.of(contextQuery()).pop(false);
      }
    }
  }

  Future<void> clearLocalAttribute() async {
    if (ZegoLiveAudioRoomRole.host == config.role) {
      debugPrint("[seat manager] local is host, reset host");
      await setHostAttribute(false, ZegoUIKit().getLocalUser().id);
    }

    /// take off seat when leave room
    await leaveSeat(showDialog: false);
  }

  bool isSpeaker(ZegoUIKitUser user) {
    return -1 != getIndexByUserID(user.id);
  }

  bool isHost(ZegoUIKitUser user) {
    var inRoomAttributes =
        ZegoUIKit().getInRoomUserAttributesNotifier(user.id).value;
    if (!inRoomAttributes.containsKey(attributeKeyHost)) {
      return false;
    }

    return inRoomAttributes[attributeKeyHost]!.isNotEmpty;
  }

  Future<void> setHostAttribute(bool isHost, String hostID) async {
    debugPrint("[seat manager] host set in-room attribute: $isHost");

    await ZegoUIKitSignalingPluginImp.shared.setUsersInRoomAttributes(
      {"isHost": isHost ? "true" : ""},
      [hostID],
    ).then((result) {
      if (result.code.isNotEmpty) {
        showToast(
            "host set in-room attribute failed, ${result.code} ${result.message}");
      }
    });

    if (!isHost) {
      debugPrint("[seat manager] host seat is take off, turn off microphone");
      ZegoUIKit().turnMicrophoneOn(false);
    }
  }

  Future<bool> takeOnSeat(int index) async {
    if (!isSeatEmpty(index)) {
      debugPrint("[seat manager] seat $index is not empty");
      return false;
    }

    if (-1 != getIndexByUserID(localUserID)) {
      debugPrint("[seat manager] user is on seat , switch to $index");
      return switchToSeat(index);
    }

    debugPrint(
        "[seat manager] local user take on seat $index, target room attribute:${{
      index.toString(): localUserID
    }}");
    ZegoUIKitSignalingPluginImp.shared.beginRoomAttributesBatchOperation(
      isDeleteAfterOwnerLeft: true,
    );
    ZegoUIKitSignalingPluginImp.shared
        .setRoomAttributes({index.toString(): localUserID}).then((result) {
      debugPrint(
          "[seat manager] local user take on seat $index result:${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showToast(
            "take on $index seat is failed, ${result.code} ${result.message}");
      }
    });
    await ZegoUIKitSignalingPluginImp.shared.endRoomAttributesBatchOperation();

    return true;
  }

  Future<bool> switchToSeat(int index) async {
    var oldSeatIndex = getIndexByUserID(localUserID);

    debugPrint(
        "[seat manager] local user switch on seat from $oldSeatIndex to $index, "
        "target room attributes:${{index.toString(): localUserID}}");
    ZegoUIKitSignalingPluginImp.shared.beginRoomAttributesBatchOperation(
      isDeleteAfterOwnerLeft: true,
    );
    ZegoUIKitSignalingPluginImp.shared
        .setRoomAttributes({index.toString(): localUserID}).then((result) {
      debugPrint(
          "[seat manager] local user switch on seat $index result:${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showToast(
            "switch on $index seat is failed, ${result.code} ${result.message}");
      }
    });
    ZegoUIKitSignalingPluginImp.shared
        .deleteRoomAttributes([oldSeatIndex.toString()]);
    await ZegoUIKitSignalingPluginImp.shared.endRoomAttributesBatchOperation();

    return true;
  }

  Future<void> kickSeat(int index) async {
    var targetUser = getUserByIndex(index);
    if (null == targetUser) {
      debugPrint("[seat manager] seat $index user id is empty");
      return;
    }

    if (-1 != userIndexOfKickSeatDialog) {
      debugPrint("[seat manager] kick seat, dialog is visible");
      return;
    }

    userIndexOfKickSeatDialog = index;
    var dialogInfo = translationText.removeFromSeatDialogInfo;
    await showLiveDialog(
      context: contextQuery(),
      title: dialogInfo.title,
      content: dialogInfo.message.replaceFirst(
        translationText.param_1,
        targetUser.name,
      ),
      leftButtonText: dialogInfo.cancelButtonName,
      leftButtonCallback: () {
        userIndexOfKickSeatDialog = -1;
        Navigator.of(contextQuery()).pop(false);
      },
      rightButtonText: dialogInfo.confirmButtonName,
      rightButtonCallback: () async {
        userIndexOfKickSeatDialog = -1;
        Navigator.of(contextQuery()).pop(true);

        await takeOffSeat(index, fromHost: true);
      },
    );
  }

  Future<void> leaveSeat({bool showDialog = true}) async {
    /// take off seat when leave room
    var localSeatIndex = getIndexByUserID(ZegoUIKit().getLocalUser().id);
    if (-1 == localSeatIndex) {
      debugPrint("[seat manager] local is not on seat, not need to leave");
      return;
    }

    if (showDialog && isLeaveSeatDialogVisible) {
      debugPrint("[seat manager] leave seat, dialog is visible");
      return;
    }

    debugPrint("[seat manager] local is on seat $localSeatIndex, leaving..");

    isLeaveSeatDialogVisible = true;
    var dialogInfo = translationText.leaveSeatDialogInfo;
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
  }

  Future<void> takeOffSeat(int index, {bool fromHost = false}) async {
    var targetUser = getUserByIndex(index);
    if (null == targetUser) {
      debugPrint("[seat manager] seat $index user id is empty");
      return;
    }

    debugPrint(
        "[seat manager] take off ${targetUser.toString()} from seat $index");

    ZegoUIKitSignalingPluginImp.shared.beginRoomAttributesBatchOperation(
      isForce: fromHost,
    );
    ZegoUIKitSignalingPluginImp.shared
        .deleteRoomAttributes([index.toString()]).then((result) {
      debugPrint(
          "[seat manager] take off ${targetUser.toString()} from seat $index result:"
          "${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showToast(translationText.removeSpeakerFailedToast
            .replaceFirst(translationText.param_1, targetUser.name));
        debugPrint(
            "[seat manager] take off ${targetUser.name} from $index seat is failed, ${result.code} ${result.message}");
      }
    });
    await ZegoUIKitSignalingPluginImp.shared.endRoomAttributesBatchOperation();
  }

  ZegoUIKitUser? getUserByIndex(int index) {
    return ZegoUIKit()
        .getUser(seatsUserMapNotifier.value[index.toString()] ?? "");
  }

  int getIndexByUserID(String userID) {
    int queryUserIndex = -1;
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

  void onUsersInRoomAttributesUpdated(Map params) {
    debugPrint("[seat manager] onUsersInRoomAttributesUpdated params: $params");

    var infos = params['infos']! as Map<String, Map<String, String>>;
    var editor = params['editor'] as ZegoUIKitUser?;
    debugPrint(
        "[seat manager] onUsersInRoomAttributesUpdated editor:${editor.toString()}, infos:$infos");

    updateUserRoomAttributes(infos);
  }

  void updateUserRoomAttributes(Map<String, Map<String, String>> infos) {
    debugPrint("[seat manager] updateUserRoomAttributes:$infos");

    infos.forEach((updateUserID, updateUserAttributes) {
      var updateUser = ZegoUIKit().getUser(updateUserID);
      if (null == updateUser) {
        pendingUserRoomAttributes[updateUserID] = updateUserAttributes;
        debugPrint(
            "[seat manager] updateUserRoomAttributes, but user is not exist");
        return;
      }

      updateHost(updateUser, updateUserAttributes);
      ZegoUIKit().getInRoomUserAttributesNotifier(updateUserID).value =
          updateUserAttributes;
    });

    updateRole();
  }

  void updateRole() {
    /// update local is a speaker
    if (ZegoLiveAudioRoomRole.host != role.value) {
      role.value = seatsUserMapNotifier.value.values.contains(localUserID)
          ? ZegoLiveAudioRoomRole.speaker
          : ZegoLiveAudioRoomRole.audience;
    }
  }

  void updateHost(
    ZegoUIKitUser updateUser,
    Map<String, String> updateUserAttributes,
  ) {
    /// update host
    var currentHosts = List<String>.from(hostsNotifier.value);
    if (currentHosts.contains(updateUser.id)) {
      /// is host
      if (
          //  host key is removed
          !updateUserAttributes.containsKey(attributeKeyHost) ||
              // host is kicked or leave
              (updateUserAttributes.containsKey(attributeKeyHost) &&
                  (updateUserAttributes[attributeKeyHost]!.isEmpty ||
                      updateUserAttributes[attributeKeyHost]! == "false"))) {
        currentHosts.removeWhere((userID) => userID == updateUser.id);
      }
    } else if (updateUserAttributes.containsKey(attributeKeyHost) &&
        updateUserAttributes[attributeKeyHost]! == "true") {
      /// new host?
      currentHosts.add(updateUser.id);
    }
    hostsNotifier.value = currentHosts;
  }

  void onUserListUpdated(List<ZegoUIKitUser> users) {
    var doneUserIDs = <String>[];
    pendingUserRoomAttributes.forEach((userID, userAttributes) {
      debugPrint(
          "[seat manager] exist pending user attribute, user id: $userID, attributes: $userAttributes");

      var user = ZegoUIKit().getUser(userID);
      if (user != null && !user.isEmpty()) {
        updateUserRoomAttributes({userID: userAttributes});

        doneUserIDs.add(userID);
      }
    });

    pendingUserRoomAttributes
        .removeWhere((userID, userAttributes) => doneUserIDs.contains(userID));
  }

  void onRoomAttributesUpdated(Map _roomAttributes) {
    debugPrint(
        "[seat manager] onRoomAttributesUpdated room attributes: $_roomAttributes");

    Map<ZIMRoomAttributesUpdateAction, List<Map<String, String>>>
        roomAttributes = {};
    (_roomAttributes as Map<ZIMRoomAttributesUpdateAction, Map<String, String>>)
        .forEach((action, attributes) {
      if (roomAttributes.containsKey(action)) {
        roomAttributes[action]!.add(attributes);
      } else {
        roomAttributes[action] = [attributes];
      }
    });
    updateSeatUsersByRoomAttributes(roomAttributes);
  }

  void onRoomBatchAttributesUpdated(Map batchRoomAttributes) {
    debugPrint(
        "[seat manager] onRoomBatchAttributesUpdated, batch room attributes: $batchRoomAttributes");

    updateSeatUsersByRoomAttributes(batchRoomAttributes
        as Map<ZIMRoomAttributesUpdateAction, List<Map<String, String>>>);
  }

  void updateSeatUsersByRoomAttributes(
      Map<ZIMRoomAttributesUpdateAction, List<Map<String, String>>>
          seatsRoomAttributes) {
    debugPrint(
        "[seat manager] onRoomSeatAttributesUpdated, seats room attributes: $seatsRoomAttributes");

    var seatsUsersMap = Map<String, String>.from(seatsUserMapNotifier.value);
    seatsRoomAttributes.forEach((action, roomAttributes) {
      for (var roomAttribute in roomAttributes) {
        roomAttribute.forEach((key, value) {
          var seatIndex = int.tryParse(key);
          if (seatIndex != null) {
            var userId = value;

            switch (action) {
              case ZIMRoomAttributesUpdateAction.set:
                seatsUsersMap[seatIndex.toString()] = userId;
                break;
              case ZIMRoomAttributesUpdateAction.delete:
                if (userIndexOfKickSeatDialog == seatIndex) {
                  debugPrint("[seat manager] close kick seat dialog");
                  userIndexOfKickSeatDialog = -1;
                  Navigator.of(contextQuery()).pop(false);
                }

                seatsUsersMap.remove(seatIndex.toString());
                break;
            }
          }
        });
      }
    });
    seatsUserMapNotifier.value = seatsUsersMap;

    updateRole();

    debugPrint("[seat manager] seats users is: ${seatsUserMapNotifier.value}");
  }
}
