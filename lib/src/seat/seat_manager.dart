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
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'defines.dart';
import 'plugins.dart';

class ZegoLiveSeatManager {
  final String userID;
  final ZegoPrebuiltPlugins plugins;
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final BuildContext Function() contextQuery;
  final ZegoTranslationText translationText;

  ZegoLiveSeatManager({
    required this.userID,
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
          .getRoomAttributesStream()
          .listen(onRoomAttributesUpdated))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getRoomBatchAttributesStream()
          .listen(onRoomBatchAttributesUpdated))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getUsersInRoomAttributesStream()
          .listen(onUsersAttributesUpdated))
      ..add(ZegoUIKit().getNetworkModeStream().listen(onNetworkModeChanged));
  }

  KickSeatDialogInfo kickSeatDialogInfo = KickSeatDialogInfo.empty();

  bool isLeaveSeatDialogVisible = false;
  bool isPopUpSheetVisible = false;
  bool isRoomAttributesBatching = false;
  bool hostSeatAttributeInitialed = false;
  bool isNetworkOnline = true;

  Map<String, Map<String, String>> pendingUserRoomAttributes = {};
  List<StreamSubscription<dynamic>?> subscriptions = [];

  var hostsNotifier = ValueNotifier<List<String>>([]);
  var localRole =
      ValueNotifier<ZegoLiveAudioRoomRole>(ZegoLiveAudioRoomRole.audience);

  bool get localIsAHost => ZegoLiveAudioRoomRole.host == localRole.value;

  bool isAHostSeat(int index) => config.hostSeatIndexes.contains(index);

  var seatsUserMapNotifier =
      ValueNotifier<Map<String, String>>({}); //  <seat id, user id>

  Future<void> init() async {
    debugPrint("[seat manager] init");

    await queryUsersInRoomAttributesList();

    localRole.addListener(onRoleChanged);
    seatsUserMapNotifier.addListener(onSeatUsersChanged);
  }

  Future<void> uninit() async {
    debugPrint("[seat manager] uninit");

    ZegoUIKit().turnMicrophoneOn(false);

    seatsUserMapNotifier.value.clear();
    hostSeatAttributeInitialed = false;

    plugins.pluginConnectionStateNotifier
        .removeListener(waitPluginsConnectedQueryRoomAttribute);
    seatsUserMapNotifier.removeListener(onSeatUsersChanged);
    localRole.removeListener(onRoleChanged);
    for (var subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  Future<bool> queryUsersInRoomAttributesList({bool withToast = true}) async {
    debugPrint("[seat manager] query init users in-room attributes");
    return await ZegoUIKit()
        .getSignalingPlugin()
        .queryUsersInRoomAttributesList()
        .then((result) {
      debugPrint(
          "[seat manager] query finish, code:${result.code}, message: ${result.message} , result:${result.result as Map<String, Map<String, String>>}");
      if (withToast && result.code.isNotEmpty) {
        showToast(
            "query users in-room attributes error, ${result.code} ${result.message}");
        return false;
      }

      updateRoleFromUserAttributes(
          result.result as Map<String, Map<String, String>>);

      return result.code.isEmpty;
    });
  }

  Future<void> initRoleAndSeat() async {
    if (localRole.value == ZegoLiveAudioRoomRole.host) {
      hostSeatAttributeInitialed = false;
    }

    if (localRole.value == ZegoLiveAudioRoomRole.host ||
        localRole.value == ZegoLiveAudioRoomRole.speaker) {
      debugPrint(
          "[seat manager] try init seat ${config.takeSeatIndexWhenJoining}");
      await takeOnSeat(
        config.takeSeatIndexWhenJoining,
        isForce: true,
        isUpdateOwner: true,
        isDeleteAfterOwnerLeft: true,
      ).then((success) async {
        hostSeatAttributeInitialed = true;

        debugPrint(
            "[live audio room] init seat index ${success ? "success" : "failed"}");
        if (success) {
          if (localRole.value == ZegoLiveAudioRoomRole.host) {
            debugPrint("[live audio room] try init role ${localRole.value}");
            await setRoleAttribute(localRole.value, userID)
                .then((success) async {
              debugPrint(
                  "[live audio room] init role ${success ? "success" : "failed"}");
              if (!success) {
                debugPrint(
                    "[live audio room] reset to audience and take off seat ${config.takeSeatIndexWhenJoining}");

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
    debugPrint("[seat manager] local user role changed to ${localRole.value}");

    if (ZegoLiveAudioRoomRole.host == localRole.value ||
        ZegoLiveAudioRoomRole.speaker == localRole.value) {
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
      if (isPopUpSheetVisible) {
        debugPrint("[seat manager] close pop up sheet");
        isPopUpSheetVisible = false;
        Navigator.of(contextQuery()).pop(false);
      }
    }
  }

  void onSeatUsersChanged() {
    debugPrint(
        "[seat manager] seat users changed to ${seatsUserMapNotifier.value}");

    if (!seatsUserMapNotifier.value.values.contains(userID)) {
      debugPrint(
          "[seat manager] local is not on seat now, turn off microphone");
      ZegoUIKit().turnMicrophoneOn(false);
    }

    if (kickSeatDialogInfo.isExist(
      userID:
          seatsUserMapNotifier.value[kickSeatDialogInfo.userIndex.toString()] ??
              "",
      userIndex: kickSeatDialogInfo.userIndex,
      allSame: true,
    )) {
      debugPrint("[seat manager] close kick seat dialog");
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

    var inRoomAttributes =
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
    debugPrint(
        "[seat manager] $targetUserID set role in-room attribute: $role");

    var success =
        await ZegoUIKit().getSignalingPlugin().setUsersInRoomAttributes(
      {"role": role.index.toString()},
      [targetUserID],
    ).then((result) {
      if (result.code.isNotEmpty) {
        showToast(
            "host set in-room attribute failed, ${result.code} ${result.message}");
      }

      return result.code.isEmpty;
    });

    return success;
  }

  Future<bool> takeOnSeat(
    int index, {
    bool isForce = false,
    bool isUpdateOwner = false,
    bool isDeleteAfterOwnerLeft = false,
  }) async {
    if (!isForce && !isSeatEmpty(index)) {
      debugPrint("[seat manager] take on seat, seat $index is not empty");
      return false;
    }

    if (-1 != getIndexByUserID(userID)) {
      debugPrint(
          "[seat manager] take on seat, user is on seat , switch to $index");
      return switchToSeat(index);
    }

    if (isRoomAttributesBatching) {
      debugPrint(
          "[seat manager] take on seat, room attribute is batching, ignore");
      return false;
    }

    debugPrint(
        "[seat manager] local user take on seat $index, target room attribute:${{
      index.toString(): userID
    }}");

    isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomAttributesBatchOperation(
          isForce: isForce,
          isUpdateOwner: isUpdateOwner,
          isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
        );
    ZegoUIKit()
        .getSignalingPlugin()
        .setRoomAttributes({index.toString(): userID}).then((result) {
      debugPrint(
          "[seat manager] local user take on seat $index result:${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showToast(
            "take on $index seat is failed, ${result.code} ${result.message}");
      }
    });
    await ZegoUIKit()
        .getSignalingPlugin()
        .endRoomAttributesBatchOperation()
        .then((result) {
      if (result.code.isNotEmpty) {
        showToast("take on seat error, ${result.code} ${result.message}");
        return;
      }

      isRoomAttributesBatching = false;
      debugPrint(
          "[seat manager] take on seat, room attribute batch is finished");
    });

    return true;
  }

  Future<bool> switchToSeat(int index) async {
    if (isRoomAttributesBatching) {
      debugPrint(
          "[seat manager] switch seat, room attribute is batching, ignore");
      return false;
    }

    var oldSeatIndex = getIndexByUserID(userID);

    debugPrint(
        "[seat manager] local user switch on seat from $oldSeatIndex to $index, "
        "target room attributes:${{index.toString(): userID}}");

    isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomAttributesBatchOperation(
          isDeleteAfterOwnerLeft: true,
        );
    ZegoUIKit()
        .getSignalingPlugin()
        .setRoomAttributes({index.toString(): userID}).then((result) {
      debugPrint(
          "[seat manager] local user switch on seat $index result:${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showToast(
            "switch on $index seat is failed, ${result.code} ${result.message}");
      }
    });
    ZegoUIKit()
        .getSignalingPlugin()
        .deleteRoomAttributes([oldSeatIndex.toString()]);
    await ZegoUIKit()
        .getSignalingPlugin()
        .endRoomAttributesBatchOperation()
        .then((result) {
      if (result.code.isNotEmpty) {
        showToast("switch seat error, ${result.code} ${result.message}");
        return;
      }

      isRoomAttributesBatching = false;
      debugPrint(
          "[seat manager] switch seat, room attribute batch is finished");
    });

    return true;
  }

  Future<void> kickSeat(int index) async {
    var targetUser = getUserByIndex(index);
    if (null == targetUser) {
      debugPrint("[seat manager] seat $index user id is empty");
      return;
    }

    if (kickSeatDialogInfo.isNotEmpty) {
      debugPrint("[seat manager] kick seat, dialog is visible");
      return;
    }

    kickSeatDialogInfo =
        KickSeatDialogInfo(userID: targetUser.id, userIndex: index);
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

    if (showDialog) {
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
    } else {
      await takeOffSeat(localSeatIndex);
    }
  }

  Future<bool> takeOffSeat(int index, {bool isForce = false}) async {
    var targetUser = getUserByIndex(index);
    if (null == targetUser) {
      debugPrint("[seat manager] seat $index user id is empty");
      return false;
    }

    if (isRoomAttributesBatching) {
      debugPrint(
          "[seat manager] take off seat, room attribute is batching, ignore");
      return false;
    }

    debugPrint(
        "[seat manager] take off ${targetUser.toString()} from seat $index");

    isRoomAttributesBatching = true;
    ZegoUIKit().getSignalingPlugin().beginRoomAttributesBatchOperation(
          isForce: isForce,
        );
    ZegoUIKit()
        .getSignalingPlugin()
        .deleteRoomAttributes([index.toString()]).then((result) {
      debugPrint(
          "[seat manager] take off ${targetUser.toString()} from seat $index result:"
          "${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showError(translationText.removeSpeakerFailedToast
            .replaceFirst(translationText.param_1, targetUser.name));
        debugPrint(
            "[seat manager] take off ${targetUser.name} from $index seat is failed, ${result.code} ${result.message}");
      }
    });
    await ZegoUIKit()
        .getSignalingPlugin()
        .endRoomAttributesBatchOperation()
        .then((result) {
      if (result.code.isNotEmpty) {
        showToast("take off seat error, ${result.code} ${result.message}");
        return;
      }

      isRoomAttributesBatching = false;
      debugPrint(
          "[seat manager] take off seat, room attribute batch is finished");
    });

    return true;
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

  void onUsersAttributesUpdated(Map params) {
    debugPrint("[seat manager] onUsersAttributesUpdated params: $params");

    var infos = params['infos']! as Map<String, Map<String, String>>;
    var editor = params['editor'] as ZegoUIKitUser?;
    debugPrint(
        "[seat manager] onUsersAttributesUpdated editor:${editor.toString()}, infos:$infos");

    updateRoleFromUserAttributes(infos);
  }

  /// users attributes only contain 'host' now
  void updateRoleFromUserAttributes(Map<String, Map<String, String>> infos) {
    debugPrint("[seat manager] updateUserAttributes:$infos");

    infos.forEach((updateUserID, updateUserAttributes) {
      var updateUser = ZegoUIKit().getUser(updateUserID);
      if (null == updateUser) {
        pendingUserRoomAttributes[updateUserID] = updateUserAttributes;
        debugPrint(
            "[seat manager] updateUserAttributes, but user($updateUserID) is not exist, deal when user enter");
        return;
      }

      /// update hosts
      cacheHosts(updateUser, updateUserAttributes);

      /// update all user's role
      ZegoUIKit().getInRoomUserAttributesNotifier(updateUserID).value =
          updateUserAttributes;
      debugPrint(
          "[seat manager] update $updateUserID's attributes:$updateUserAttributes");

      /// update local role
      if (userID == updateUserID) {
        if (!updateUserAttributes.containsKey(attributeKeyRole) ||
            updateUserAttributes[attributeKeyRole]!.isEmpty) {
          localRole.value = ZegoLiveAudioRoomRole.audience;
        } else {
          localRole.value = ZegoLiveAudioRoomRole.values[
              int.parse(updateUserAttributes[attributeKeyRole]!.toString())];
        }
        debugPrint("[seat manager] update local role:${localRole.value}");
      }
    });
  }

  void cacheHosts(
    ZegoUIKitUser updateUser,
    Map<String, String> updateUserAttributes,
  ) {
    /// update host
    var currentHosts = List<String>.from(hostsNotifier.value);
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
    debugPrint("[seat manager] hosts is :${hostsNotifier.value}");
  }

  void onUserListUpdated(List<ZegoUIKitUser> users) {
    var doneUserIDs = <String>[];
    pendingUserRoomAttributes.forEach((userID, userAttributes) {
      debugPrint(
          "[seat manager] exist pending user attribute, user id: $userID, attributes: $userAttributes");

      var user = ZegoUIKit().getUser(userID);
      if (user != null && !user.isEmpty()) {
        updateRoleFromUserAttributes({userID: userAttributes});

        doneUserIDs.add(userID);
      }
    });

    pendingUserRoomAttributes
        .removeWhere((userID, userAttributes) => doneUserIDs.contains(userID));

    if (doneUserIDs.isNotEmpty) {
      /// force update layout
      var seatsUsersMap = Map<String, String>.from(seatsUserMapNotifier.value);
      seatsUserMapNotifier.value = seatsUsersMap;
    }
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
                if (kickSeatDialogInfo.isExist(userIndex: seatIndex)) {
                  debugPrint("[seat manager] close kick seat dialog");
                  kickSeatDialogInfo.clear();
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

    if (localRole.value == ZegoLiveAudioRoomRole.host &&
        !seatsUserMapNotifier.value.values.contains(userID)) {
      if (hostSeatAttributeInitialed) {
        debugPrint("host's seat is been take off, set host to an audience");

        setRoleAttribute(ZegoLiveAudioRoomRole.audience, userID)
            .then((success) {
          if (success) {
            localRole.value = seatsUserMapNotifier.value.values.contains(userID)
                ? ZegoLiveAudioRoomRole.speaker
                : ZegoLiveAudioRoomRole.audience;
            debugPrint(
                "[seat manager] local host's role change by room attribute: ${localRole.value}");
          }
        });
      }
    } else {
      if (localRole.value != ZegoLiveAudioRoomRole.host) {
        localRole.value = seatsUserMapNotifier.value.values.contains(userID)
            ? ZegoLiveAudioRoomRole.speaker
            : ZegoLiveAudioRoomRole.audience;
        debugPrint(
            "[seat manager] local user role change by room attribute: ${localRole.value}");
      }
    }

    debugPrint("[seat manager] seats users is: ${seatsUserMapNotifier.value}");
  }

  void setPopUpSheetVisible(bool isShow) {
    isPopUpSheetVisible = isShow;
  }

  void setKickSeatDialogInfo(KickSeatDialogInfo kickSeatDialogInfo) {
    this.kickSeatDialogInfo = kickSeatDialogInfo;
  }

  void onNetworkModeChanged(ZegoNetworkMode networkMode) async {
    return;

    debugPrint("[seat manager] onNetworkModeChanged $networkMode, "
        "previous network state: $isNetworkOnline");

    switch (networkMode) {
      case ZegoNetworkMode.Offline:
      case ZegoNetworkMode.Unknown:
        isNetworkOnline = false;
        break;
      case ZegoNetworkMode.Ethernet:
      case ZegoNetworkMode.WiFi:
      case ZegoNetworkMode.Mode2G:
      case ZegoNetworkMode.Mode3G:
      case ZegoNetworkMode.Mode4G:
      case ZegoNetworkMode.Mode5G:
        if (!isNetworkOnline) {
          debugPrint(
              "[seat manager] plugin connection state: ${plugins.pluginConnectionStateNotifier.value}");
          if (PluginConnectionState.connected ==
                  plugins.pluginConnectionStateNotifier.value &&
              PluginRoomState.connected == plugins.roomStateNotifier.value) {
            debugPrint(
                "[seat manager] plugin is connected and room is connected, try query room all attributes");
            queryRoomAllAttributes(withToast: false);
          } else if (PluginConnectionState.connected !=
              plugins.pluginConnectionStateNotifier.value) {
            debugPrint(
                "[seat manager] plugin is not connected, waiting connected..");
            plugins.pluginConnectionStateNotifier
                .addListener(waitPluginsConnectedQueryRoomAttribute);
          }
        }
        isNetworkOnline = true;
        break;
    }
  }

  void waitPluginsConnectedQueryRoomAttribute() async {
    debugPrint(
        "[seat manager] waitPluginsConnectedQueryRoomAttribute, ${plugins.pluginConnectionStateNotifier.value}");

    if (PluginConnectionState.connected ==
        plugins.pluginConnectionStateNotifier.value) {
      debugPrint(
          "[seat manager] waitPluginsConnectedQueryRoomAttribute, connected");

      plugins.pluginConnectionStateNotifier
          .removeListener(waitPluginsConnectedQueryRoomAttribute);

      if (PluginRoomState.connected != plugins.roomStateNotifier.value) {
        debugPrint(
            "[seat manager] waitPluginsConnectedQueryRoomAttribute,room is not connected, try re-enter room..");
        await plugins.joinRoom().then((result) async {
          if (!result) {
            showToast("failed to re-enter room");
            return;
          }

          debugPrint(
              "[seat manager] waitPluginsConnectedQueryRoomAttribute, room re-entered, query room all attributes...");
          await queryRoomAllAttributes(withToast: false);
        });
      } else {
        debugPrint(
            "[seat manager] waitPluginsConnectedQueryRoomAttribute, query room all attributes...");
        await queryRoomAllAttributes(withToast: false);
      }
    }
  }

  Future<bool> queryRoomAllAttributes({bool withToast = true}) async {
    debugPrint("[seat manager]  query room all attributes");
    return await ZegoUIKit()
        .getSignalingPlugin()
        .queryRoomAllAttributes()
        .then((result) {
      if (withToast && result.code.isNotEmpty) {
        showToast(
            "query users in-room attributes error, ${result.code} ${result.message}");
        return false;
      }

      debugPrint(
          "[seat manager] query room all attributes finish, code:${result.code}, message: ${result.message} , result:${result.result as Map<String, String>}");

      updateSeatUsersByRoomAttributes({
        ZIMRoomAttributesUpdateAction.set: [
          result.result as Map<String, String>
        ]
      });

      return result.code.isEmpty;
    });
  }
}

class KickSeatDialogInfo {
  int userIndex = -1;
  String userID = "";

  KickSeatDialogInfo({
    this.userID = "",
    this.userIndex = -1,
  });

  KickSeatDialogInfo.empty();

  bool get isEmpty => -1 == userIndex || userID.isEmpty;

  bool get isNotEmpty => -1 != userIndex && userID.isNotEmpty;

  bool isExist({
    userID,
    userIndex,
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
    userID = "";
    userIndex = -1;
  }
}
