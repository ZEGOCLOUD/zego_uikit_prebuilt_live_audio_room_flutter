// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:statemachine/statemachine.dart' as sm;
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/minimizing/prebuilt_data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

enum LiveAudioRoomMiniOverlayPageState {
  idle,
  inAudioRoom,
  minimizing,
}

typedef LiveAudioRoomMiniOverlayMachineStateChanged = void Function(
    LiveAudioRoomMiniOverlayPageState);

class ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine {
  factory ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine() => _instance;

  ZegoUIKitPrebuiltLiveAudioRoomData? get prebuiltAudioRoomData =>
      _prebuiltAudioRoomData;

  sm.Machine<LiveAudioRoomMiniOverlayPageState> get machine => _machine;

  bool get isMinimizing =>
      LiveAudioRoomMiniOverlayPageState.minimizing == state();

  void listenStateChanged(
      LiveAudioRoomMiniOverlayMachineStateChanged listener) {
    _onStateChangedListeners.add(listener);
  }

  void removeListenStateChanged(
      LiveAudioRoomMiniOverlayMachineStateChanged listener) {
    _onStateChangedListeners.remove(listener);
  }

  void init() {
    _machine.onAfterTransition.listen((event) {
      ZegoLoggerService.logInfo(
        'mini overlay, from ${event.source} to ${event.target}',
        tag: 'audio room',
        subTag: 'overlay machine',
      );

      for (final listener in _onStateChangedListeners) {
        listener.call(_machine.current!.identifier);
      }
    });

    _stateIdle = _machine
        .newState(LiveAudioRoomMiniOverlayPageState.idle); //  default state;
    _stateCalling =
        _machine.newState(LiveAudioRoomMiniOverlayPageState.inAudioRoom);
    _stateMinimizing =
        _machine.newState(LiveAudioRoomMiniOverlayPageState.minimizing);
  }

  void changeState(
    LiveAudioRoomMiniOverlayPageState state, {
    ZegoUIKitPrebuiltLiveAudioRoomData? prebuiltAudioRoomData,
  }) {
    ZegoLoggerService.logInfo(
      'change state outside to $state',
      tag: 'audio room',
      subTag: 'overlay machine',
    );

    switch (state) {
      case LiveAudioRoomMiniOverlayPageState.idle:
        _prebuiltAudioRoomData = null;

        _stateIdle.enter();
        break;
      case LiveAudioRoomMiniOverlayPageState.inAudioRoom:
        _prebuiltAudioRoomData = null;

        _stateCalling.enter();
        break;
      case LiveAudioRoomMiniOverlayPageState.minimizing:
        ZegoLoggerService.logInfo(
          'data: ${_prebuiltAudioRoomData?.toString()}',
          tag: 'audio room',
          subTag: 'overlay machine',
        );
        assert(null != prebuiltAudioRoomData);
        _prebuiltAudioRoomData = prebuiltAudioRoomData;

        _stateMinimizing.enter();
        break;
    }
  }

  LiveAudioRoomMiniOverlayPageState state() {
    return _machine.current?.identifier ??
        LiveAudioRoomMiniOverlayPageState.idle;
  }

  /// private variables

  ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine._internal() {
    init();
  }

  static final ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine _instance =
      ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine._internal();

  final _machine = sm.Machine<LiveAudioRoomMiniOverlayPageState>();
  final List<LiveAudioRoomMiniOverlayMachineStateChanged>
      _onStateChangedListeners = [];

  late sm.State<LiveAudioRoomMiniOverlayPageState> _stateIdle;
  late sm.State<LiveAudioRoomMiniOverlayPageState> _stateCalling;
  late sm.State<LiveAudioRoomMiniOverlayPageState> _stateMinimizing;

  ZegoUIKitPrebuiltLiveAudioRoomData? _prebuiltAudioRoomData;

}
