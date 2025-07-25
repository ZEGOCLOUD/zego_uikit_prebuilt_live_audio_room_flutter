// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';

class ZegoLiveAudioRoomEventListener {
  final ZegoUIKitPrebuiltLiveAudioRoomEvents? events;
  final List<StreamSubscription<dynamic>?> _subscriptions = [];

  ZegoLiveAudioRoomEventListener(this.events);

  void init() {
    _subscriptions
      ..add(ZegoUIKit().getUserJoinStream().listen(_onUserJoin))
      ..add(ZegoUIKit().getUserLeaveStream().listen(_onUserLeave));

    ZegoUIKit()
        .getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id)
        .addListener(_onMicrophoneStateChanged);
    ZegoUIKit()
        .getAudioOutputDeviceNotifier(ZegoUIKit().getLocalUser().id)
        .addListener(_onAudioOutputChanged);

    ZegoUIKit().getRoomStateStream().addListener(_onRoomStateChanged);
  }

  void uninit() {
    ZegoUIKit()
        .getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id)
        .removeListener(_onMicrophoneStateChanged);
    ZegoUIKit()
        .getAudioOutputDeviceNotifier(ZegoUIKit().getLocalUser().id)
        .removeListener(_onAudioOutputChanged);

    ZegoUIKit().getRoomStateStream().removeListener(_onRoomStateChanged);

    for (final subscription in _subscriptions) {
      subscription?.cancel();
    }
  }

  void _onUserJoin(List<ZegoUIKitUser> users) {
    for (var user in users) {
      events?.user.onEnter?.call(user);
    }
  }

  void _onUserLeave(List<ZegoUIKitUser> users) {
    for (var user in users) {
      events?.user.onLeave?.call(user);
    }
  }

  void _onRoomStateChanged() {
    events?.room.onStateChanged?.call(ZegoUIKit().getRoomStateStream().value);
  }

  void _onMicrophoneStateChanged() {
    events?.audioVideo.onMicrophoneStateChanged?.call(
      ZegoUIKit()
          .getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id)
          .value,
    );
  }

  void _onAudioOutputChanged() {
    events?.audioVideo.onAudioOutputChanged?.call(
      ZegoUIKit()
          .getAudioOutputDeviceNotifier(ZegoUIKit().getLocalUser().id)
          .value,
    );
  }
}
