// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/overlay_machine.dart';

/// @nodoc
enum ZegoLiveAudioRoomPluginNetworkState {
  unknown,
  offline,
  online,
}

/// @nodoc
class ZegoLiveAudioRoomPlugins {
  ZegoLiveAudioRoomPlugins({
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.roomID,
    required this.plugins,
    this.onPluginReLogin,
    this.onError,
  }) {
    _install();
  }

  final int appID;
  final String appSign;

  final String userID;
  final String userName;

  final String roomID;

  final List<IZegoUIKitPlugin> plugins;

  final VoidCallback? onPluginReLogin;
  Function(ZegoUIKitError)? onError;

  ZegoLiveAudioRoomPluginNetworkState networkState =
      ZegoLiveAudioRoomPluginNetworkState.unknown;
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
          'plugin-$pluginType version: $version',
          tag: 'audio room',
          subTag: 'plugin',
        );
      });
    }

    if (ZegoPluginAdapter().getPlugin(ZegoUIKitPluginType.signaling) != null) {
      subscriptions.add(ZegoUIKit()
          .getSignalingPlugin()
          .getErrorStream()
          .listen(onSignalingError));
    }

    if (ZegoPluginAdapter().getPlugin(ZegoUIKitPluginType.beauty) != null) {
      subscriptions.add(
          ZegoUIKit().getBeautyPlugin().getErrorStream().listen(onBeautyError));
    }
  }

  Future<void> init() async {
    if (initialized) {
      ZegoLoggerService.logInfo(
        'plugins had init',
        tag: 'audio room',
        subTag: 'plugin',
      );

      return;
    }

    initialized = true;

    pluginUserStateNotifier.value =
        ZegoUIKit().getSignalingPlugin().getConnectionState();
    roomStateNotifier.value = ZegoUIKit().getSignalingPlugin().getRoomState();

    ZegoLoggerService.logInfo(
      'plugins init, user state:${pluginUserStateNotifier.value}, room state:${roomStateNotifier.value}',
      tag: 'audio room',
      subTag: 'plugin',
    );

    await ZegoUIKit()
        .getSignalingPlugin()
        .init(appID, appSign: appSign)
        .then((value) {
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
        .then((result) async {
      ZegoLoggerService.logInfo(
        'plugins login done, login result:$result, try to join room...',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return joinRoom().then((result) {
        ZegoLoggerService.logInfo(
          'plugins room joined, join result:$result',
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
      'plugins login room',
      tag: 'audio room',
      subTag: 'plugin',
    );

    return ZegoUIKit().getSignalingPlugin().joinRoom(roomID).then((result) {
      ZegoLoggerService.logInfo(
        'plugins login room result: $result',
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
    if (!initialized) {
      ZegoLoggerService.logInfo(
        'is not init before',
        tag: 'audio room',
        subTag: 'plugin',
      );
    }

    ZegoLoggerService.logInfo(
      'uninit',
      tag: 'audio room',
      subTag: 'plugin',
    );
    initialized = false;

    roomHasInitLogin = false;
    tryReLogging = false;

    final toMinimizing = ZegoLiveAudioRoomMiniOverlayPageState.minimizing ==
        ZegoLiveAudioRoomInternalMiniOverlayMachine().state();
    if (toMinimizing) {
      ZegoLoggerService.logInfo(
        'to minimizing, not need to leave room, logout and uninit',
        tag: 'audio room',
        subTag: 'plugin',
      );
    } else {
      await ZegoUIKit().getSignalingPlugin().leaveRoom();

      /// not need logout
      // await ZegoUIKit().getSignalingPlugin().logout();
      /// not need destroy signaling sdk
      await ZegoUIKit().getSignalingPlugin().uninit(forceDestroy: false);
    }

    for (final streamSubscription in subscriptions) {
      streamSubscription?.cancel();
    }
  }

  Future<void> onUserInfoUpdate(String userID, String userName) async {
    final localUser = ZegoUIKit().getLocalUser();

    ZegoLoggerService.logInfo(
      'on user info update, '
      'target user($userID, $userName), '
      'local user:($localUser) '
      'initialized:$initialized, '
      'user state:${pluginUserStateNotifier.value}'
      'room state:${roomStateNotifier.value}',
      tag: 'live streaming',
      subTag: 'plugin',
    );

    if (!initialized) {
      ZegoLoggerService.logInfo(
        'onUserInfoUpdate, plugin is not init',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return;
    }

    if (pluginUserStateNotifier.value !=
        ZegoSignalingPluginConnectionState.connected) {
      ZegoLoggerService.logInfo(
        'onUserInfoUpdate, user state is not connected',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return;
    }

    if (ZegoSignalingPluginRoomState.connected != roomStateNotifier.value) {
      ZegoLoggerService.logInfo(
        'onUserInfoUpdate, room state is not connected',
        tag: 'audio room',
        subTag: 'plugin',
      );
      return;
    }

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

  void onSignalingError(ZegoSignalingError error) {
    ZegoLoggerService.logError(
      'on signaling error:$error',
      tag: 'audio room',
      subTag: 'plugin',
    );

    onError?.call(ZegoUIKitError(
      code: error.code,
      message: error.message,
      method: error.method,
    ));
  }

  void onBeautyError(ZegoBeautyError error) {
    ZegoLoggerService.logError(
      'on beauty error:$error',
      tag: 'audio room',
      subTag: 'prebuilt',
    );

    onError?.call(ZegoUIKitError(
      code: error.code,
      message: error.message,
      method: error.method,
    ));
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
        networkState = ZegoLiveAudioRoomPluginNetworkState.offline;
        break;
      case ZegoNetworkMode.Ethernet:
      case ZegoNetworkMode.WiFi:
      case ZegoNetworkMode.Mode2G:
      case ZegoNetworkMode.Mode3G:
      case ZegoNetworkMode.Mode4G:
      case ZegoNetworkMode.Mode5G:
        if (ZegoLiveAudioRoomPluginNetworkState.offline == networkState) {
          tryReLogin();
        }

        networkState = ZegoLiveAudioRoomPluginNetworkState.online;
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
    await ZegoUIKit().getSignalingPlugin().logout().then((value) async {
      await ZegoUIKit().getSignalingPlugin().login(id: userID, name: userName);
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

    if (networkState != ZegoLiveAudioRoomPluginNetworkState.online) {
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
    return joinRoom().then((result) {
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
