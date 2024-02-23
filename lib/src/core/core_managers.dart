// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/live_duration_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';

/// @nodoc
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
    required int appID,
    required String appSign,
    required String userID,
    required String userName,
    required String roomID,
    required ZegoUIKitPrebuiltLiveAudioRoomConfig config,
    required ZegoUIKitPrebuiltLiveAudioRoomEvents events,
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

    plugins = ZegoLiveAudioRoomPlugins(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      roomID: roomID,
      plugins: [ZegoUIKitSignalingPlugin()],
      onPluginReLogin: () {
        seatManager?.queryRoomAllAttributes(withToast: false).then((value) {
          seatManager?.initRoleAndSeat();
        });
      },
      onError: events.onError,
    );
    seatManager = ZegoLiveAudioRoomSeatManager(
      localUserID: userID,
      roomID: roomID,
      plugins: plugins!,
      config: config,
      events: events,
      innerText: config.innerText,
      popUpManager: popUpManager,
      kickOutNotifier: kickOutNotifier,
    );
    connectManager = ZegoLiveAudioRoomConnectManager(
      config: config,
      events: events,
      seatManager: seatManager!,
      innerText: config.innerText,
      popUpManager: popUpManager,
      kickOutNotifier: kickOutNotifier,
    );
    seatManager?.setConnectManager(connectManager!);

    liveDurationManager = ZegoLiveAudioRoomDurationManager(
      seatManager: seatManager!,
    );
  }

  Future<void> uninitPluginAndManagers() async {
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
  ZegoLiveAudioRoomPlugins? plugins;
  ZegoLiveAudioRoomSeatManager? seatManager;
  ZegoLiveAudioRoomConnectManager? connectManager;
  ZegoLiveAudioRoomDurationManager? liveDurationManager;

  final popUpManager = ZegoLiveAudioRoomPopUpManager();
  final kickOutNotifier = ValueNotifier<bool>(false);
}
