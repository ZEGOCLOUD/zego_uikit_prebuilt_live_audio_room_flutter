// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/live_duration_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/prebuilt_data.dart';

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

  void initPluginAndManagers({
    required ZegoUIKitPrebuiltLiveAudioRoomData prebuiltData,
  }) {
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
      appID: prebuiltData.appID,
      appSign: prebuiltData.appSign,
      userID: prebuiltData.userID,
      userName: prebuiltData.userName,
      roomID: prebuiltData.roomID,
      plugins: [ZegoUIKitSignalingPlugin()],
      onPluginReLogin: () {
        seatManager?.queryRoomAllAttributes(withToast: false).then((value) {
          seatManager?.initRoleAndSeat();
        });
      },
    );
    seatManager = ZegoLiveSeatManager(
      localUserID: prebuiltData.userID,
      roomID: prebuiltData.roomID,
      plugins: plugins!,
      config: prebuiltData.config,
      prebuiltController: prebuiltData.controller,
      innerText: prebuiltData.config.innerText,
      popUpManager: popUpManager,
      kickOutNotifier: kickOutNotifier,
    );
    connectManager = ZegoLiveConnectManager(
      config: prebuiltData.config,
      seatManager: seatManager!,
      prebuiltController: prebuiltData.controller,
      innerText: prebuiltData.config.innerText,
      popUpManager: popUpManager,
      kickOutNotifier: kickOutNotifier,
    );
    seatManager?.setConnectManager(connectManager!);

    liveDurationManager = ZegoLiveDurationManager(
      seatManager: seatManager!,
    );
  }

  Future<void> unintPluginAndManagers() async {
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
    await seatManager?.uninit();
    await liveDurationManager?.uninit();
    await plugins?.uninit();

    connectManager = null;
    seatManager = null;
    liveDurationManager = null;
    plugins = null;
  }

  bool _initialized = false;
  ZegoPrebuiltPlugins? plugins;
  ZegoLiveSeatManager? seatManager;
  ZegoLiveConnectManager? connectManager;
  ZegoLiveDurationManager? liveDurationManager;

  final popUpManager = ZegoPopUpManager();
  final kickOutNotifier = ValueNotifier<bool>(false);
}
