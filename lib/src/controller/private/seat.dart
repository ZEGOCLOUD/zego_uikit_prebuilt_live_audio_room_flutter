part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerSeatPrivate {
  final _private = ZegoLiveAudioRoomControllerSeatPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerSeatPrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerSeatPrivateImpl {
  final host = ZegoLiveAudioRoomControllerSeatHostImpl();
  final audience = ZegoLiveAudioRoomControllerSeatAudienceImpl();
  final speaker = ZegoLiveAudioRoomControllerSeatSpeakerImpl();
  final microphoneMuteNotifier =
      ZegoLiveAudioRoomControllerSeatMicrophoneMuteStateImpl();

  ZegoLiveAudioRoomConnectManager? connectManager;
  ZegoLiveAudioRoomSeatManager? seatManager;

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void initByPrebuilt({
    required ZegoLiveAudioRoomConnectManager? connectManager,
    required ZegoLiveAudioRoomSeatManager? seatManager,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.seat.p',
    );

    this.connectManager = connectManager;
    this.seatManager = seatManager;

    host.private._initByPrebuilt(
      connectManager: connectManager,
      seatManager: seatManager,
    );
    speaker.private._initByPrebuilt(
      connectManager: connectManager,
      seatManager: seatManager,
    );
    audience.private._initByPrebuilt(
      connectManager: connectManager,
      seatManager: seatManager,
    );
    microphoneMuteNotifier._initByPrebuilt(seatManager: seatManager);
  }

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.seat.p',
    );

    connectManager = null;
    seatManager = null;

    host.private._uninitByPrebuilt();
    speaker.private._uninitByPrebuilt();
    audience.private._uninitByPrebuilt();
    microphoneMuteNotifier._uninitByPrebuilt();
  }
}

/// @nodoc
mixin ZegoLiveAudioRoomControllerSeatRolePrivate {
  final _private = ZegoLiveAudioRoomControllerSeatRolePrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerSeatRolePrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveAudioRoomControllerSeatRolePrivateImpl {
  ZegoLiveAudioRoomConnectManager? connectManager;
  ZegoLiveAudioRoomSeatManager? seatManager;

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void _initByPrebuilt({
    required ZegoLiveAudioRoomConnectManager? connectManager,
    required ZegoLiveAudioRoomSeatManager? seatManager,
  }) {
    this.connectManager = connectManager;
    this.seatManager = seatManager;
  }

  void _uninitByPrebuilt() {
    connectManager = null;
    seatManager = null;
  }
}

class ZegoLiveAudioRoomControllerSeatMicrophoneMuteStateImpl {
  Map<String, VoidCallback> microphoneMuteStateNotifierCallbacks = {};

  /// notifiers
  List<ValueNotifier<bool>> microphoneMuteStateNotifiers = [];

  /// <user id, notifier>
  Map<String, ValueNotifier<bool>> microphoneMuteStateNotifierMap = {};

  ZegoLiveAudioRoomSeatManager? seatManager;

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void _initByPrebuilt({
    required ZegoLiveAudioRoomSeatManager? seatManager,
  }) {
    this.seatManager = seatManager;

    seatManager?.seatsUserMapNotifier.addListener(onSeatsUserChanged);
  }

  void _uninitByPrebuilt() {
    seatManager = null;

    seatManager?.seatsUserMapNotifier.removeListener(onSeatsUserChanged);

    final listeningUserIDs = <String>[];
    microphoneMuteStateNotifierMap.forEach((userID, notifier) {
      listeningUserIDs.add(userID);
    });
    for (var userID in listeningUserIDs) {
      removeMicrophoneMuteStateNotifier(ZegoUIKit().getUser(userID));
    }
    microphoneMuteStateNotifierMap.clear();
    microphoneMuteStateNotifierCallbacks.clear();
    microphoneMuteStateNotifiers.clear();
  }

  ValueNotifier<bool> getMicrophoneMuteStateNotifier(ZegoUIKitUser user) {
    if (microphoneMuteStateNotifierMap.containsKey(user.id)) {
      return microphoneMuteStateNotifierMap[user.id]!;
    }

    listener() => onUserMicrophoneStateChanged(user);
    microphoneMuteStateNotifierCallbacks[user.id] = listener;
    user.microphone.addListener(listener);

    final notifier = ValueNotifier<bool>(false);
    microphoneMuteStateNotifiers.add(notifier);
    microphoneMuteStateNotifierMap[user.id] = notifier;
    return notifier;
  }

  void removeMicrophoneMuteStateNotifier(ZegoUIKitUser user) {
    final listener = microphoneMuteStateNotifierCallbacks.remove(user.id);
    if (null != listener) {
      user.microphone.removeListener(listener);
    }

    final notifier = microphoneMuteStateNotifierMap.remove(user.id);
    microphoneMuteStateNotifiers.remove(notifier);
  }

  void onUserMicrophoneStateChanged(ZegoUIKitUser user) {
    final notifier = microphoneMuteStateNotifierMap[user.id];
    if (null != notifier) {
      notifier.value = !user.microphone.value;
    }
  }

  void onSeatsUserChanged() {
    final seatUserIDs = <String>[];
    seatManager?.seatsUserMapNotifier.value.forEach((seatIndex, seatUserID) {
      seatUserIDs.add(seatUserID);
    });

    final listeningUserIDs = <String>[];
    microphoneMuteStateNotifierMap.forEach((userID, notifier) {
      listeningUserIDs.add(userID);
    });

    for (var userID in listeningUserIDs) {
      if (!seatUserIDs.contains(userID)) {
        removeMicrophoneMuteStateNotifier(ZegoUIKit().getUser(userID));
      }
    }
  }
}
