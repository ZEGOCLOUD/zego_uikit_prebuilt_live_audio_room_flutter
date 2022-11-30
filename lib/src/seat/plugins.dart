// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';

enum PluginNetworkState {
  unknown,
  offline,
  online,
}

class ZegoPrebuiltPlugins {
  final int appID;
  final String appSign;

  final String userID;
  final String userName;

  final String liveID;

  final List<IZegoUIKitPlugin> plugins;

  ZegoPrebuiltPlugins({
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.liveID,
    required this.userName,
    required this.plugins,
  }) {
    _install();
  }

  PluginNetworkState networkState = PluginNetworkState.unknown;
  List<StreamSubscription<dynamic>?> subscriptions = [];
  var pluginConnectionStateNotifier =
      ValueNotifier<PluginConnectionState>(PluginConnectionState.disconnected);
  var roomStateNotifier =
      ValueNotifier<PluginRoomState>(PluginRoomState.disconnected);

  bool get isEnabled => plugins.isNotEmpty;

  void _install() {
    ZegoUIKit().installPlugins(plugins);
    for (var pluginType in ZegoUIKitPluginType.values) {
      ZegoUIKit().getPlugin(pluginType)?.getVersion().then((version) {
        debugPrint("[plugin] plugin-$pluginType:$version");
      });
    }

    subscriptions
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getInvitationConnectionStateStream()
          .listen(onInvitationConnectionState))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getRoomStateStream()
          .listen(onRoomState))
      ..add(ZegoUIKit().getNetworkModeStream().listen(onNetworkModeChanged));
  }

  Future<void> init() async {
    debugPrint("[plugin] plugins init");

    await ZegoUIKit()
        .getSignalingPlugin()
        .init(appID, appSign: appSign)
        .then((value) {
      debugPrint("[plugin] plugins init done");
    });

    debugPrint("[plugin] plugins init, login...");
    await ZegoUIKit()
        .getSignalingPlugin()
        .login(userID, userName)
        .then((value) async {
      debugPrint("[plugin] plugins login done, join room...");
      return joinRoom();
    });

    debugPrint("[plugin] plugins init done");
  }

  Future<bool> joinRoom() async {
    debugPrint("[plugin] plugins joinRoom");

    return await ZegoUIKit()
        .getSignalingPlugin()
        .joinRoom(liveID)
        .then((result) {
      debugPrint(
          "[plugin] plugins login result: ${result.code} ${result.message}");
      if (result.code.isNotEmpty) {
        showToast(
            "join signaling login room failed, ${result.code} ${result.message}");
      }

      return result.code.isEmpty;
    });
  }

  Future<void> uninit() async {
    await ZegoUIKit().getSignalingPlugin().leaveRoom();
    await ZegoUIKit().getSignalingPlugin().logout();
    await ZegoUIKit().getSignalingPlugin().uninit();

    for (var streamSubscription in subscriptions) {
      streamSubscription?.cancel();
    }
  }

  Future<void> onUserInfoUpdate(String userID, String userName) async {
    var localUser = ZegoUIKit().getLocalUser();
    if (localUser.id == userID && localUser.name == userName) {
      debugPrint("[plugin] same user, cancel this re-login");
      return;
    }

    await ZegoUIKit().getSignalingPlugin().logout();
    await ZegoUIKit().getSignalingPlugin().login(userID, userName);
  }

  void onInvitationConnectionState(Map params) {
    debugPrint("[plugin] onInvitationConnectionState, param: $params");

    pluginConnectionStateNotifier.value =
        PluginConnectionState.values[params['state']!];

    debugPrint(
        "[plugin] onInvitationConnectionState, state: ${pluginConnectionStateNotifier.value}");
  }

  void onRoomState(Map params) {
    debugPrint("[plugin] onRoomState, param: $params");

    roomStateNotifier.value = PluginRoomState.values[params['state']!];

    debugPrint("[plugin] onRoomState, state: ${roomStateNotifier.value}");
  }

  void onNetworkModeChanged(ZegoNetworkMode networkMode) {
    debugPrint("[plugin] onNetworkModeChanged $networkMode, "
        "network state: $networkState");

    switch (networkMode) {
      case ZegoNetworkMode.Offline:
      case ZegoNetworkMode.Unknown:
        networkState = PluginNetworkState.offline;
        break;
      case ZegoNetworkMode.Ethernet:
      case ZegoNetworkMode.WiFi:
      case ZegoNetworkMode.Mode2G:
      case ZegoNetworkMode.Mode3G:
      case ZegoNetworkMode.Mode4G:
      case ZegoNetworkMode.Mode5G:
        if (PluginNetworkState.offline == networkState) {
          reconnectIfDisconnected();
        }
        networkState = PluginNetworkState.online;
        break;
    }
  }

  void reconnectIfDisconnected() {
    debugPrint(
        "[plugin] reconnectIfDisconnected, state:${pluginConnectionStateNotifier.value}");
    if (pluginConnectionStateNotifier.value ==
        PluginConnectionState.disconnected) {
      debugPrint("[plugin] reconnect, id:$userID, name:$userName");
      ZegoUIKit().getSignalingPlugin().logout().then((value) {
        ZegoUIKit().getSignalingPlugin().login(userID, userName);
      });
    }
  }
}
