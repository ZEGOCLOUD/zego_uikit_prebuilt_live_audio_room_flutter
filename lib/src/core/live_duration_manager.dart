// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

/// @nodoc
class ZegoLiveDurationManager {
  final ZegoLiveSeatManager seatManager;

  bool _initialized = false;

  bool get isValid => notifier.value.millisecondsSinceEpoch > 0;

  ZegoLiveDurationManager({
    required this.seatManager,
  }) {
    subscription =
        ZegoUIKit().getRoomPropertiesStream().listen(onRoomPropertiesUpdated);
  }

  /// internal variables
  var notifier = ValueNotifier<DateTime>(DateTime(0));
  StreamSubscription<dynamic>? subscription;

  Future<void> init() async {
    if (_initialized) {
      ZegoLoggerService.logInfo(
        'had already init',
        tag: 'live audio room',
        subTag: 'seat manager',
      );

      return;
    }

    _initialized = true;

    ZegoLoggerService.logInfo(
      'init',
      tag: 'live audio room',
      subTag: 'live duration manager',
    );

    setValueByHost();
  }

  Future<void> uninit() async {
    if (!_initialized) {
      ZegoLoggerService.logInfo(
        'not init before',
        tag: 'live audio room',
        subTag: 'seat manager',
      );

      return;
    }

    _initialized = false;

    ZegoLoggerService.logInfo(
      'uninit',
      tag: 'live audio room',
      subTag: 'live duration manager',
    );
    subscription?.cancel();
  }

  void onRoomPropertiesUpdated(Map<String, RoomProperty> updatedProperties) {
    final roomProperties = ZegoUIKit().getRoomProperties();
    ZegoLoggerService.logInfo(
      'onRoomPropertiesUpdated roomProperties:$roomProperties, updatedProperties:$updatedProperties',
      tag: 'live streaming',
      subTag: 'live duration manager',
    );

    if (roomProperties.containsKey(RoomPropertyKey.liveDuration.text)) {
      final timestamp =
          roomProperties[RoomPropertyKey.liveDuration.text]!.value;

      final serverValue =
          DateTime.fromMillisecondsSinceEpoch(int.tryParse(timestamp) ?? 0);
      notifier.value = serverValue;
    }
  }

  void setValueByHost() {
    if (!seatManager.localIsAHost) {
      ZegoLoggerService.logInfo(
        'try set value, but is not a host',
        tag: 'live audio room',
        subTag: 'live duration manager',
      );
      return;
    }

    subscription?.cancel();

    final networkTimestamp = ZegoUIKit().getNetworkTimeStamp();
    notifier.value = DateTime.fromMillisecondsSinceEpoch(networkTimestamp);

    ZegoLoggerService.logInfo(
      'host set value:${notifier.value}',
      tag: 'live audio room',
      subTag: 'live duration manager',
    );

    ZegoUIKit().setRoomProperty(
      RoomPropertyKey.liveDuration.text,
      networkTimestamp.toString(),
    );
  }
}
