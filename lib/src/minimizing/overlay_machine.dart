// Dart imports:
import 'dart:async';

// Package imports:
import 'package:statemachine/statemachine.dart' as sm;
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/defines.dart';

/// @nodoc
typedef LiveAudioRoomMiniOverlayMachineStateChanged = void Function(
  ZegoLiveAudioRoomMiniOverlayPageState,
);

class ZegoLiveAudioRoomInternalMiniOverlayMachine {
  factory ZegoLiveAudioRoomInternalMiniOverlayMachine() => _instance;

  sm.Machine<ZegoLiveAudioRoomMiniOverlayPageState> get machine => _machine;

  ZegoLiveAudioRoomMiniOverlayPageState state() {
    return _machine.current?.identifier ??
        ZegoLiveAudioRoomMiniOverlayPageState.idle;
  }

  /// Whether the current live audio room widget is in a minimized state.
  bool get isMinimizing =>
      ZegoLiveAudioRoomMiniOverlayPageState.minimizing == state();

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

    _stateIdle = _machine.newState(
        ZegoLiveAudioRoomMiniOverlayPageState.idle); //  default state;
    _stateCalling =
        _machine.newState(ZegoLiveAudioRoomMiniOverlayPageState.inAudioRoom);
    _stateMinimizing =
        _machine.newState(ZegoLiveAudioRoomMiniOverlayPageState.minimizing);
  }

  void changeState(ZegoLiveAudioRoomMiniOverlayPageState state) {
    ZegoLoggerService.logInfo(
      'change state outside to $state',
      tag: 'audio room',
      subTag: 'overlay machine',
    );

    switch (state) {
      case ZegoLiveAudioRoomMiniOverlayPageState.idle:
        kickOutSubscription?.cancel();

        _stateIdle.enter();
        break;
      case ZegoLiveAudioRoomMiniOverlayPageState.inAudioRoom:
        kickOutSubscription?.cancel();

        _stateCalling.enter();
        break;
      case ZegoLiveAudioRoomMiniOverlayPageState.minimizing:
        kickOutSubscription = ZegoUIKit()
            .getMeRemovedFromRoomStream()
            .listen(onMeRemovedFromRoom);

        _stateMinimizing.enter();
        break;
    }
  }

  Future<void> onMeRemovedFromRoom(String fromUserID) async {
    ZegoLoggerService.logInfo(
      'local user removed by $fromUserID',
      tag: 'live audio room',
      subTag: 'mini overlay page',
    );

    changeState(ZegoLiveAudioRoomMiniOverlayPageState.idle);

    ZegoLiveAudioRoomManagers().uninitPluginAndManagers();

    await ZegoUIKit().resetSoundEffect();
    await ZegoUIKit().resetBeautyEffect();
    // await ZegoUIKit().leaveRoom(); //  kick-out will leave in zego_uikit

    ZegoUIKitPrebuiltLiveAudioRoomController().private.uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveAudioRoomController().seat.private.uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveAudioRoomController().room.private.uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveAudioRoomController()
        .minimize
        .private
        .uninitByPrebuilt();
    ZegoUIKitPrebuiltLiveAudioRoomController()
        .audioVideo
        .private
        .uninitByPrebuilt();

    ZegoUIKitPrebuiltLiveAudioRoomController()
        .minimize
        .private
        .minimizeData
        ?.events
        .onEnded
        ?.call(
            ZegoLiveAudioRoomEndEvent(
              reason: ZegoLiveAudioRoomEndReason.kickOut,
              isFromMinimizing: true,
              kickerUserID: fromUserID,
            ), () {
      /// now is minimizing state, not need to navigate, just switch to idle
      ZegoUIKitPrebuiltLiveAudioRoomController().minimize.hide();
    });
  }

  /// private variables

  ZegoLiveAudioRoomInternalMiniOverlayMachine._internal() {
    init();
  }

  static final ZegoLiveAudioRoomInternalMiniOverlayMachine _instance =
      ZegoLiveAudioRoomInternalMiniOverlayMachine._internal();

  final _machine = sm.Machine<ZegoLiveAudioRoomMiniOverlayPageState>();
  final List<LiveAudioRoomMiniOverlayMachineStateChanged>
      _onStateChangedListeners = [];

  StreamSubscription<dynamic>? kickOutSubscription;

  late sm.State<ZegoLiveAudioRoomMiniOverlayPageState> _stateIdle;
  late sm.State<ZegoLiveAudioRoomMiniOverlayPageState> _stateCalling;
  late sm.State<ZegoLiveAudioRoomMiniOverlayPageState> _stateMinimizing;
}
