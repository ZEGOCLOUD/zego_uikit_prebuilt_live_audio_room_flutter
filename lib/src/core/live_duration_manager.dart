// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

/// @nodoc
class ZegoLiveAudioRoomDurationManager {
  final ZegoLiveAudioRoomSeatManager seatManager;

  bool _initialized = false;

  bool get isValid => notifier.value.millisecondsSinceEpoch > 0;

  ZegoLiveAudioRoomDurationManager({
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

    setRoomPropertyByHost();
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
      final propertyTimestamp =
          roomProperties[RoomPropertyKey.liveDuration.text]!.value;

      final serverDateTime = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(propertyTimestamp) ?? 0);

      ZegoLoggerService.logInfo(
        'live duration value is exist:${notifier.value}',
        tag: 'live audio room',
        subTag: 'live duration manager',
      );

      notifier.value = serverDateTime;
    }
  }

  void setRoomPropertyByHost() {
    if (!seatManager.localIsAHost) {
      ZegoLoggerService.logInfo(
        'try set value, but is not a host',
        tag: 'live audio room',
        subTag: 'live duration manager',
      );
      return;
    }

    subscription?.cancel();

    final networkTimeNow = ZegoUIKit().getNetworkTime();
    if (null == networkTimeNow.value) {
      ZegoLoggerService.logInfo(
        'network time is null, wait..',
        tag: 'live audio room',
        subTag: 'live duration manager',
      );

      ZegoUIKit()
          .getNetworkTime()
          .addListener(waitNetworkTimeUpdatedForSetProperty);
    } else {
      setPropertyByNetworkTime(networkTimeNow.value!);
    }
  }

  void waitNetworkTimeUpdatedForSetProperty() {
    ZegoUIKit()
        .getNetworkTime()
        .removeListener(waitNetworkTimeUpdatedForSetProperty);

    final networkTimeNow = ZegoUIKit().getNetworkTime();
    ZegoLoggerService.logInfo(
      'network time update:$networkTimeNow',
      tag: 'live audio room',
      subTag: 'live duration manager',
    );

    setPropertyByNetworkTime(networkTimeNow.value!);
  }

  void setPropertyByNetworkTime(DateTime networkTimeNow) {
    notifier.value = networkTimeNow;

    ZegoLoggerService.logInfo(
      'host set value:${notifier.value}',
      tag: 'live audio room',
      subTag: 'live duration manager',
    );

    ZegoUIKit().setRoomProperty(
      RoomPropertyKey.liveDuration.text,
      networkTimeNow.millisecondsSinceEpoch.toString(),
    );
  }
}
