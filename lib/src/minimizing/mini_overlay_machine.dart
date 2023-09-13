// Dart imports:
import 'dart:async';

// Package imports:
import 'package:statemachine/statemachine.dart' as sm;
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/prebuilt_data.dart';

/// @nodoc
enum LiveAudioRoomMiniOverlayPageState {
  idle,
  inAudioRoom,
  minimizing,
}

/// @nodoc
typedef LiveAudioRoomMiniOverlayMachineStateChanged = void Function(
    LiveAudioRoomMiniOverlayPageState);

/// @nodoc
/// The state machine for the minimized state of the live audio room.
class ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine {
  factory ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine() => _instance;

  ZegoUIKitPrebuiltLiveAudioRoomData? get prebuiltAudioRoomData =>
      _prebuiltAudioRoomData;

  sm.Machine<LiveAudioRoomMiniOverlayPageState> get machine => _machine;

  /// Whether the current live audio room widget is in a minimized state.
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
        kickOutSubscription?.cancel();

        _stateIdle.enter();
        break;
      case LiveAudioRoomMiniOverlayPageState.inAudioRoom:
        _prebuiltAudioRoomData = null;
        kickOutSubscription?.cancel();

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

        kickOutSubscription = ZegoUIKit()
            .getMeRemovedFromRoomStream()
            .listen(onMeRemovedFromRoom);

        _stateMinimizing.enter();
        break;
    }
  }

  LiveAudioRoomMiniOverlayPageState state() {
    return _machine.current?.identifier ??
        LiveAudioRoomMiniOverlayPageState.idle;
  }

  Future<void> onMeRemovedFromRoom(String fromUserID) async {
    ZegoLoggerService.logInfo(
      'local user removed by $fromUserID',
      tag: 'live audio room',
      subTag: 'mini overlay page',
    );

    changeState(LiveAudioRoomMiniOverlayPageState.idle);

    ZegoLiveAudioRoomManagers().unintPluginAndManagers();

    await ZegoUIKit().resetSoundEffect();
    await ZegoUIKit().resetBeautyEffect();
    // await ZegoUIKit().leaveRoom(); //  kick-out will leave in zego_uikit

    _prebuiltAudioRoomData?.controller?.uninitByPrebuilt();
    _prebuiltAudioRoomData?.config.onMeRemovedFromRoom?.call(fromUserID);
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

  StreamSubscription<dynamic>? kickOutSubscription;

  late sm.State<LiveAudioRoomMiniOverlayPageState> _stateIdle;
  late sm.State<LiveAudioRoomMiniOverlayPageState> _stateCalling;
  late sm.State<LiveAudioRoomMiniOverlayPageState> _stateMinimizing;

  ZegoUIKitPrebuiltLiveAudioRoomData? _prebuiltAudioRoomData;
}
