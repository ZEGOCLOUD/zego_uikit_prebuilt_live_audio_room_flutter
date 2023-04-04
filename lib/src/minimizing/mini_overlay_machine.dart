// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:statemachine/statemachine.dart' as sm;
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/prebuilt_data.dart';

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

        for (final _subscription in _signalSubscriptions) {
          _subscription?.cancel();
        }
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine()
              .audiencesRequestingTakeSeatNotifier
              .value = [];
        });

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

        for (final subscription in _signalSubscriptions) {
          subscription?.cancel();
        }
        _signalSubscriptions
          ..add(ZegoUIKit()
              .getSignalingPlugin()
              .getInvitationReceivedStream()
              .listen(onInvitationReceived))
          ..add(ZegoUIKit()
              .getSignalingPlugin()
              .getInvitationCanceledStream()
              .listen(onInvitationCanceled))
          ..add(ZegoUIKit()
              .getSignalingPlugin()
              .getInvitationTimeoutStream()
              .listen(onInvitationTimeout));

        _stateMinimizing.enter();
        break;
    }
  }

  LiveAudioRoomMiniOverlayPageState state() {
    return _machine.current?.identifier ??
        LiveAudioRoomMiniOverlayPageState.idle;
  }

  void onInvitationReceived(Map<String, dynamic> params) {
    final ZegoUIKitUser inviter = params['inviter']!;
    final int type = params['type']!; // call type
    final String data = params['data']!; // extended field

    final invitationType = ZegoInvitationTypeExtension.mapValue[type]!;

    if (ZegoInvitationType.requestTakeSeat == invitationType) {
      audiencesRequestingTakeSeatNotifier.value =
          List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
            ..add(inviter);
    }
  }

  void onInvitationCanceled(Map<String, dynamic> params) {
    final ZegoUIKitUser inviter = params['inviter']!;
    final String data = params['data']!; // extended field

    audiencesRequestingTakeSeatNotifier.value =
        List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
          ..removeWhere((user) => user.id == inviter.id);
  }

  void onInvitationTimeout(Map<String, dynamic> params) {
    final ZegoUIKitUser inviter = params['inviter']!;
    final String data = params['data']!; // extended field

    audiencesRequestingTakeSeatNotifier.value =
        List<ZegoUIKitUser>.from(audiencesRequestingTakeSeatNotifier.value)
          ..removeWhere((user) => user.id == inviter.id);
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

  /// audiences which requesting to take seat
  final List<StreamSubscription<dynamic>?> _signalSubscriptions = [];
  final audiencesRequestingTakeSeatNotifier =
      ValueNotifier<List<ZegoUIKitUser>>([]);
}
