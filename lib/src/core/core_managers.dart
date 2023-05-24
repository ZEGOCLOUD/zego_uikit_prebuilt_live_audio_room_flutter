// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/minimizing/prebuilt_data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

class ZegoLiveAudioRoomManagers {
  factory ZegoLiveAudioRoomManagers() => _instance;

  ZegoLiveAudioRoomManagers._internal();

  static final ZegoLiveAudioRoomManagers _instance =
      ZegoLiveAudioRoomManagers._internal();

  void updateContextQuery(BuildContext Function() contextQuery) {
    ZegoLoggerService.logInfo(
      'update context query',
      tag: 'audio room',
      subTag: 'core manager',
    );

    connectManager?.contextQuery = contextQuery;
    seatManager?.contextQuery = contextQuery;
  }

  void initPluginAndManagers(
      ZegoUIKitPrebuiltLiveAudioRoomData prebuiltAudioRoomData) {
    if (_initialized) {
      ZegoLoggerService.logInfo(
        'had init',
        tag: 'audio room',
        subTag: 'core manager',
      );

      return;
    }

    ZegoLoggerService.logInfo(
      'init plugin and managers',
      tag: 'audio room',
      subTag: 'core manager',
    );

    _initialized = true;

    plugins = ZegoPrebuiltPlugins(
      appID: prebuiltAudioRoomData.appID,
      appSign: prebuiltAudioRoomData.appSign,
      userID: prebuiltAudioRoomData.userID,
      userName: prebuiltAudioRoomData.userName,
      roomID: prebuiltAudioRoomData.roomID,
      plugins: [ZegoUIKitSignalingPlugin()],
      onPluginReLogin: () {
        seatManager?.queryRoomAllAttributes(withToast: false).then((value) {
          seatManager?.initRoleAndSeat();
        });
      },
    );
    seatManager = ZegoLiveSeatManager(
      localUserID: prebuiltAudioRoomData.userID,
      roomID: prebuiltAudioRoomData.roomID,
      plugins: plugins!,
      config: prebuiltAudioRoomData.config,
      prebuiltController: prebuiltAudioRoomData.controller,
      innerText: prebuiltAudioRoomData.config.innerText,
    );
    connectManager = ZegoLiveConnectManager(
      config: prebuiltAudioRoomData.config,
      seatManager: seatManager!,
      prebuiltController: prebuiltAudioRoomData.controller,
      innerText: prebuiltAudioRoomData.config.innerText,
    );
    seatManager?.setConnectManager(connectManager!);
  }

  void unintPluginAndManagers() {
    ZegoLoggerService.logInfo(
      'uninit plugin and managers',
      tag: 'audio room',
      subTag: 'core manager',
    );

    if (!_initialized) {
      ZegoLoggerService.logInfo(
        'had not init',
        tag: 'audio room',
        subTag: 'core manager',
      );

      return;
    }

    _initialized = false;

    connectManager?.uninit();
    seatManager?.uninit();
    plugins?.uninit();

    connectManager = null;
    seatManager = null;
    plugins = null;
  }

  bool _initialized = false;
  ZegoPrebuiltPlugins? plugins;
  ZegoLiveSeatManager? seatManager;
  ZegoLiveConnectManager? connectManager;
}
