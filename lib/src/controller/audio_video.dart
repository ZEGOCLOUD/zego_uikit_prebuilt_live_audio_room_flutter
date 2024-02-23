part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerAudioVideo {
  final _audioVideoImpl = ZegoLiveAudioRoomControllerAudioVideoImpl();

  ZegoLiveAudioRoomControllerAudioVideoImpl get audioVideo => _audioVideoImpl;
}

/// Here are the APIs related to audio video
class ZegoLiveAudioRoomControllerAudioVideoImpl
    with ZegoLiveAudioRoomControllerAudioVideoImplPrivate {
  /// microphone series APIs
  ZegoLiveStreamingControllerAudioVideoMicrophoneImpl get microphone =>
      private._microphone;

  /// camera series APIs
  // ZegoLiveStreamingControllerAudioVideoCameraImpl get camera => private._camera;

  /// stream of SEI(Supplemental Enhancement Information)
  Stream<ZegoUIKitReceiveSEIEvent> seiStream() {
    return ZegoUIKit().getReceiveCustomSEIStream();
  }

  /// if you want synchronize some other additional information by audio-video,
  /// send SEI(Supplemental Enhancement Information) with it.
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
        tag: 'audio room',
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

class ZegoLiveStreamingControllerAudioVideoMicrophoneImpl
    with ZegoLiveStreamingControllerAudioVideoDeviceImplPrivate {
  /// microphone state of local user
  bool get localState => ZegoUIKit()
      .getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id)
      .value;

  /// microphone state notifier of local user
  ValueNotifier<bool> get localStateNotifier =>
      ZegoUIKit().getMicrophoneStateNotifier(ZegoUIKit().getLocalUser().id);

  /// microphone state of [userID]
  bool state(String userID) =>
      ZegoUIKit().getMicrophoneStateNotifier(userID).value;

  /// microphone state notifier of [userID]
  ValueNotifier<bool> stateNotifier(String userID) =>
      ZegoUIKit().getMicrophoneStateNotifier(userID);

  /// turn on/off [userID] microphone, if [userID] is empty, then it refers to local user
  void turnOn(bool isOn, {String? userID, bool muteMode = true}) {
    ZegoLoggerService.logInfo(
      "turn ${isOn ? "on" : "off"} $userID microphone,"
      "mute mode:$muteMode, ",
      tag: 'audio room',
      subTag: 'controller.audioVideo.microphone',
    );

    return ZegoUIKit().turnMicrophoneOn(
      isOn,
      userID: userID,
      muteMode: muteMode,
    );
  }

  /// switch [userID] microphone state, if [userID] is empty, then it refers to local user
  void switchState({String? userID}) {
    ZegoLoggerService.logInfo(
      "switchState,"
      "userID:$userID, ",
      tag: 'audio room',
      subTag: 'controller.audioVideo.microphone',
    );

    final targetUserID = userID ?? ZegoUIKit().getLocalUser().id;
    final currentMicrophoneState =
        ZegoUIKit().getMicrophoneStateNotifier(targetUserID).value;

    turnOn(!currentMicrophoneState, userID: targetUserID);
  }
}

class ZegoLiveStreamingControllerAudioVideoCameraImpl
    with ZegoLiveStreamingControllerAudioVideoDeviceImplPrivate {
  /// camera state of local user
  bool get localState =>
      ZegoUIKit().getCameraStateNotifier(ZegoUIKit().getLocalUser().id).value;

  /// camera state notifier of local user
  ValueNotifier<bool> get localStateNotifier =>
      ZegoUIKit().getCameraStateNotifier(ZegoUIKit().getLocalUser().id);

  /// camera state of [userID]
  bool state(String userID) => ZegoUIKit().getCameraStateNotifier(userID).value;

  /// camera state notifier of [userID]
  ValueNotifier<bool> stateNotifier(String userID) =>
      ZegoUIKit().getCameraStateNotifier(userID);

  /// turn on/off [userID] camera, if [userID] is empty, then it refers to local user
  void turnOn(bool isOn, {String? userID}) {
    ZegoLoggerService.logInfo(
      "turn ${isOn ? "on" : "off"} $userID camera",
      tag: 'audio room',
      subTag: 'controller.audioVideo.camera',
    );

    return ZegoUIKit().turnCameraOn(
      isOn,
      userID: userID,
    );
  }

  /// switch [userID] camera state, if [userID] is empty, then it refers to local user
  void switchState({String? userID}) {
    ZegoLoggerService.logInfo(
      "switchState,"
      "userID:$userID, ",
      tag: 'audio room',
      subTag: 'controller.audioVideo.camera',
    );

    final targetUserID = userID ?? ZegoUIKit().getLocalUser().id;
    final currentCameraState =
        ZegoUIKit().getCameraStateNotifier(targetUserID).value;

    turnOn(!currentCameraState, userID: targetUserID);
  }
}
