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
  ZegoPrebuiltPlugins(
      {required this.appID,
      required this.appSign,
      required this.userID,
      required this.userName,
      required this.roomID,
      required this.plugins,
      this.onPluginReLogin}) {
    _install();
  }
  final int appID;
  final String appSign;

  final String userID;
  final String userName;

  final String roomID;

  final List<IZegoUIKitPlugin> plugins;

  final VoidCallback? onPluginReLogin;

  PluginNetworkState networkState = PluginNetworkState.unknown;
  List<StreamSubscription<dynamic>?> subscriptions = [];
  ValueNotifier<ZegoSignalingPluginConnectionState> pluginUserStateNotifier =
      ValueNotifier<ZegoSignalingPluginConnectionState>(
          ZegoSignalingPluginConnectionState.disconnected);
  ValueNotifier<ZegoSignalingPluginRoomState> roomStateNotifier =
      ValueNotifier<ZegoSignalingPluginRoomState>(
          ZegoSignalingPluginRoomState.disconnected);
  bool tryReLogging = false;
  bool initialized = false;
  bool roomHasInitLogin = false;

  bool get isEnabled => plugins.isNotEmpty;

  void _install() {
    ZegoUIKit().installPlugins(plugins);
    for (final pluginType in ZegoUIKitPluginType.values) {
      ZegoUIKit().getPlugin(pluginType)?.getVersion().then((version) {
        ZegoLoggerService.logInfo(
          'plugin-$pluginType:$version',
          tag: 'audio room',
          subTag: 'plugin',
        );
      });
    }

    subscriptions
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getConnectionStateStream()
          .listen(onUserConnectionState))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getRoomStateStream()
          .listen(onRoomState))
      ..add(ZegoUIKit().getNetworkModeStream().listen(onNetworkModeChanged));
  }

  Future<void> init() async {
    ZegoLoggerService.logInfo(
      'plugins init',
      tag: 'audio room',
      subTag: 'plugin',
    );
    initialized = true;

    await ZegoUIKit()
        .getSignalingPlugin()
        .init(appID, appSign: appSign)
        .then((value) {
      ZegoLoggerService.logInfo(
        'plugins init done',
        tag: 'audio room',
        subTag: 'plugin',
      );
    });

    ZegoLoggerService.logInfo(
      'plugins init, login...',
      tag: 'audio room',
      subTag: 'plugin',
    );
    await ZegoUIKit()
        .getSignalingPlugin()
        .login(id: userID, name: userName)
        .then((value) async {
      ZegoLoggerService.logInfo(
        'plugins login done, join room...',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return joinRoom().then((value) {
        ZegoLoggerService.logInfo(
          'plugins room joined',
          tag: 'audio room',
          subTag: 'plugin',
        );
        roomHasInitLogin = true;
      });
    });

    ZegoLoggerService.logInfo(
      'plugins init done',
      tag: 'audio room',
      subTag: 'plugin',
    );
  }

  Future<bool> joinRoom() async {
    ZegoLoggerService.logInfo(
      'plugins joinRoom',
      tag: 'audio room',
      subTag: 'plugin',
    );

    return ZegoUIKit().getSignalingPlugin().joinRoom(roomID).then((result) {
      ZegoLoggerService.logInfo(
        'plugins login result: $result',
        tag: 'audio room',
        subTag: 'plugin',
      );
      if (result.error != null) {
        showDebugToast('login room failed, ${result.error}');
      }

      return result.error == null;
    });
  }

  Future<void> uninit() async {
    ZegoLoggerService.logInfo(
      'uninit',
      tag: 'audio room',
      subTag: 'plugin',
    );
    initialized = false;

    roomHasInitLogin = false;
    tryReLogging = false;

    await ZegoUIKit().getSignalingPlugin().leaveRoom();
    await ZegoUIKit().getSignalingPlugin().logout();
    await ZegoUIKit().getSignalingPlugin().uninit();

    for (final streamSubscription in subscriptions) {
      streamSubscription?.cancel();
    }
  }

  Future<void> onUserInfoUpdate(String userID, String userName) async {
    final localUser = ZegoUIKit().getLocalUser();
    if (localUser.id == userID && localUser.name == userName) {
      ZegoLoggerService.logInfo(
        'same user, cancel this re-login',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return;
    }

    await ZegoUIKit().getSignalingPlugin().logout();
    await ZegoUIKit().getSignalingPlugin().login(id: userID, name: userName);
  }

  void onUserConnectionState(
      ZegoSignalingPluginConnectionStateChangedEvent event) {
    ZegoLoggerService.logInfo(
      'onUserConnectionState, param: $event',
      tag: 'audio room',
      subTag: 'plugin',
    );

    pluginUserStateNotifier.value = event.state;

    ZegoLoggerService.logInfo(
      'onUserConnectionState, user state: ${pluginUserStateNotifier.value}',
      tag: 'audio room',
      subTag: 'plugin',
    );

    if (tryReLogging &&
        pluginUserStateNotifier.value ==
            ZegoSignalingPluginConnectionState.connected) {
      tryReLogging = false;
      onPluginReLogin?.call();
    }

    tryReEnterRoom();
  }

  void onRoomState(ZegoSignalingPluginRoomStateChangedEvent event) {
    ZegoLoggerService.logInfo(
      'onRoomState, event: $event',
      tag: 'audio room',
      subTag: 'plugin',
    );

    roomStateNotifier.value = event.state;

    ZegoLoggerService.logInfo(
      '[plugin] onRoomState, state: ${event.state}, networkState:$networkState',
      tag: 'audio room',
      subTag: 'plugin',
    );

    tryReEnterRoom();
  }

  void onNetworkModeChanged(ZegoNetworkMode networkMode) {
    ZegoLoggerService.logInfo(
      'onNetworkModeChanged $networkMode, previous network state: $networkState',
      tag: 'audio room',
      subTag: 'plugin',
    );

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
          tryReLogin();
        }

        networkState = PluginNetworkState.online;
        break;
    }
  }

  Future<void> tryReLogin() async {
    ZegoLoggerService.logInfo(
      'tryReLogin, state:${pluginUserStateNotifier.value}',
      tag: 'audio room',
      subTag: 'plugin',
    );

    if (!initialized) {
      ZegoLoggerService.logInfo(
        'tryReLogin, plugin is not init',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return;
    }

    if (pluginUserStateNotifier.value !=
        ZegoSignalingPluginConnectionState.disconnected) {
      ZegoLoggerService.logInfo(
        'tryReLogin, user state is not disconnected',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return;
    }

    ZegoLoggerService.logInfo(
      're-login, id:$userID, name:$userName',
      tag: 'audio room',
      subTag: 'plugin',
    );
    tryReLogging = true;
    return ZegoUIKit().getSignalingPlugin().logout().then((value) async {
      return ZegoUIKit().getSignalingPlugin().login(id: userID, name: userName);
    });
  }

  Future<bool> tryReEnterRoom() async {
    ZegoLoggerService.logInfo(
      'tryReEnterRoom, room state: ${roomStateNotifier.value}, networkState:$networkState',
      tag: 'audio room',
      subTag: 'plugin',
    );

    if (!initialized) {
      ZegoLoggerService.logInfo(
        'tryReEnterRoom, plugin is not init',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return false;
    }
    if (!roomHasInitLogin) {
      ZegoLoggerService.logInfo(
        'tryReEnterRoom, first login room has not finished',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return false;
    }

    if (ZegoSignalingPluginRoomState.disconnected != roomStateNotifier.value) {
      ZegoLoggerService.logInfo(
        'tryReEnterRoom, room state is not disconnected',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return false;
    }

    if (networkState != PluginNetworkState.online) {
      ZegoLoggerService.logInfo(
        'tryReEnterRoom, network is not connected',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return false;
    }

    if (pluginUserStateNotifier.value !=
        ZegoSignalingPluginConnectionState.connected) {
      ZegoLoggerService.logInfo(
        'tryReEnterRoom, user state is not connected',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return false;
    }

    ZegoLoggerService.logInfo(
      'try re-enter room',
      tag: 'audio room',
      subTag: 'plugin',
    );
    return await joinRoom().then((result) {
      ZegoLoggerService.logInfo(
        're-enter room result:$result',
        tag: 'audio room',
        subTag: 'plugin',
      );

      if (!result) {
        return false;
      }

      onPluginReLogin?.call();

      return true;
    });
  }
}
