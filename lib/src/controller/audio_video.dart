part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// Mixin for audio and video control functionality.
///
/// This mixin provides access to the audio/video controller.
mixin ZegoLiveAudioRoomControllerAudioVideo {
  final _audioVideoImpl = ZegoLiveAudioRoomControllerAudioVideoImpl();

  /// Gets the audio/video controller instance.
  ZegoLiveAudioRoomControllerAudioVideoImpl get audioVideo => _audioVideoImpl;
}

/// Controller for audio and video related operations.
///
/// This class provides APIs for managing microphone, camera, and audio output devices.
class ZegoLiveAudioRoomControllerAudioVideoImpl
    with ZegoLiveAudioRoomControllerAudioVideoImplPrivate {
  /// Gets the microphone controller for managing microphone state.
  ZegoLiveStreamingControllerAudioVideoMicrophoneImpl get microphone =>
      private._microphone;

  /// Gets the camera controller for managing camera state.
  // ZegoLiveStreamingControllerAudioVideoCameraImpl get camera => private._camera;

  /// Gets the audio output controller for managing audio output device.
  ZegoLiveStreamingControllerAudioVideoAudioOutputImpl get audioOutput =>
      private._audioOutput;

  /// Stream of SEI (Supplemental Enhancement Information) received.
  ///
  /// Listen to this stream to receive custom SEI data sent by other users.
  Stream<ZegoUIKitReceiveSEIEvent> seiStream() {
    return ZegoUIKit().getReceiveCustomSEIStream(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
    );
  }

  /// Sends SEI (Supplemental Enhancement Information) with custom data.
  ///
  /// SEI is used to synchronize additional information along with the audio/video stream.
  /// Note: You can only send SEI when you are on a seat.
  ///
  /// [seiData] - The custom data to send as SEI.
  /// [streamType] - The type of stream to send SEI on. Default is main stream.
  Future<bool> sendSEI(
    Map<String, dynamic> seiData, {
    ZegoStreamType streamType = ZegoStreamType.main,
  }) async {
    final localSeatIndex =
        private.seatManager?.getIndexByUserID(ZegoUIKit().getLocalUser().id) ??
            -1;
    if (-1 == localSeatIndex) {
      ZegoLoggerService.logInfo(
        'local is not on seat, could not sed SEI',
        tag: 'audio-room',
        subTag: 'controller.audioVideo',
      );
      return false;
    }

    return ZegoUIKit().sendCustomSEI(
      seiData,
      streamType: streamType,
    );
  }
}

/// Controller for microphone operations.
///
/// This class provides APIs for managing microphone state.
class ZegoLiveStreamingControllerAudioVideoMicrophoneImpl
    with ZegoLiveStreamingControllerAudioVideoDeviceImplPrivate {
  /// Gets the microphone state of the local user.
  ///
  /// Returns `true` if the microphone is on, `false` otherwise.
  bool get localState => ZegoUIKit()
      .getMicrophoneStateNotifier(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        ZegoUIKit().getLocalUser().id,
      )
      .value;

  /// Gets the microphone state notifier of the local user.
  ///
  /// Use this to listen to microphone state changes.
  ValueNotifier<bool> get localStateNotifier =>
      ZegoUIKit().getMicrophoneStateNotifier(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        ZegoUIKit().getLocalUser().id,
      );

  /// Gets the microphone state of the specified user.
  ///
  /// [userID] - The ID of the user to get microphone state for.
  /// Returns `true` if the microphone is on, `false` otherwise.
  bool state(String userID) => ZegoUIKit()
      .getMicrophoneStateNotifier(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        userID,
      )
      .value;

  /// Gets the microphone state notifier of the specified user.
  ///
  /// [userID] - The ID of the user to get microphone state notifier for.
  ValueNotifier<bool> stateNotifier(String userID) =>
      ZegoUIKit().getMicrophoneStateNotifier(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        userID,
      );

  /// Turns the microphone on or off.
  ///
  /// [isOn] - Whether to turn the microphone on (`true`) or off (`false`).
  /// [userID] - The ID of the user whose microphone to control. If null, controls the local user.
  /// [muteMode] - If true, the microphone is muted rather than turned off. Default is true.
  Future<void> turnOn(bool isOn, {String? userID, bool muteMode = true}) async {
    ZegoLoggerService.logInfo(
      "turn ${isOn ? "on" : "off"} $userID microphone,"
      "mute mode:$muteMode, ",
      tag: 'audio-room',
      subTag: 'controller.audioVideo.microphone',
    );

    await ZegoUIKit().turnMicrophoneOn(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      isOn,
      userID: userID,
      muteMode: muteMode,
    );
  }

  /// Switches the microphone state of the specified user.
  ///
  /// [userID] - The ID of the user whose microphone to switch. If null, switches the local user's microphone.
  void switchState({String? userID}) {
    ZegoLoggerService.logInfo(
      "switchState,"
      "userID:$userID, ",
      tag: 'audio-room',
      subTag: 'controller.audioVideo.microphone',
    );

    final targetUserID = userID ?? ZegoUIKit().getLocalUser().id;
    final currentMicrophoneState = ZegoUIKit()
        .getMicrophoneStateNotifier(
          targetRoomID:
              ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
          targetUserID,
        )
        .value;

    turnOn(!currentMicrophoneState, userID: targetUserID);
  }
}

/// Controller for camera operations.
///
/// This class provides APIs for managing camera state.
class ZegoLiveStreamingControllerAudioVideoCameraImpl
    with ZegoLiveStreamingControllerAudioVideoDeviceImplPrivate {
  /// Gets the camera state of the local user.
  ///
  /// Returns `true` if the camera is on, `false` otherwise.
  bool get localState => ZegoUIKit()
      .getCameraStateNotifier(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        ZegoUIKit().getLocalUser().id,
      )
      .value;

  /// Gets the camera state notifier of the local user.
  ///
  /// Use this to listen to camera state changes.
  ValueNotifier<bool> get localStateNotifier =>
      ZegoUIKit().getCameraStateNotifier(
          targetRoomID:
              ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
          ZegoUIKit().getLocalUser().id);

  /// Gets the camera state of the specified user.
  ///
  /// [userID] - The ID of the user to get camera state for.
  /// Returns `true` if the camera is on, `false` otherwise.
  bool state(String userID) => ZegoUIKit()
      .getCameraStateNotifier(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        userID,
      )
      .value;

  /// Gets the camera state notifier of the specified user.
  ///
  /// [userID] - The ID of the user to get camera state notifier for.
  ValueNotifier<bool> stateNotifier(String userID) =>
      ZegoUIKit().getCameraStateNotifier(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        userID,
      );

  /// Turns the camera on or off.
  ///
  /// [isOn] - Whether to turn the camera on (`true`) or off (`false`).
  /// [userID] - The ID of the user whose camera to control. If null, controls the local user.
  Future<void> turnOn(bool isOn, {String? userID}) async {
    ZegoLoggerService.logInfo(
      "turn ${isOn ? "on" : "off"} $userID camera",
      tag: 'audio-room',
      subTag: 'controller.audioVideo.camera',
    );

    await ZegoUIKit().turnCameraOn(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      isOn,
      userID: userID,
    );
  }

  /// Switches the camera state of the specified user.
  ///
  /// [userID] - The ID of the user whose camera to switch. If null, switches the local user's camera.
  void switchState({String? userID}) {
    ZegoLoggerService.logInfo(
      "switchState,"
      "userID:$userID, ",
      tag: 'audio-room',
      subTag: 'controller.audioVideo.camera',
    );

    final targetUserID = userID ?? ZegoUIKit().getLocalUser().id;
    final currentCameraState = ZegoUIKit()
        .getCameraStateNotifier(
          targetRoomID:
              ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
          targetUserID,
        )
        .value;

    turnOn(!currentCameraState, userID: targetUserID);
  }
}

/// Controller for audio output device operations.
///
/// This class provides APIs for managing audio output (speaker/earpiece).
class ZegoLiveStreamingControllerAudioVideoAudioOutputImpl
    with ZegoLiveStreamingControllerAudioVideoDeviceImplPrivate {
  /// Gets the audio output device notifier of the local user.
  ValueNotifier<ZegoUIKitAudioRoute> get localNotifier =>
      notifier(ZegoUIKit().getLocalUser().id);

  /// Gets the audio output device notifier of the specified user.
  ///
  /// [userID] - The ID of the user to get audio output notifier for.
  ValueNotifier<ZegoUIKitAudioRoute> notifier(
    String userID,
  ) {
    return ZegoUIKit().getAudioOutputDeviceNotifier(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      userID,
    );
  }

  /// Switches audio output between speaker and earpiece.
  ///
  /// [isSpeaker] - If `true`, switches to speaker. If `false`, switches to earpiece.
  void switchToSpeaker(bool isSpeaker) {
    ZegoUIKit().setAudioOutputToSpeaker(isSpeaker);
  }
}
