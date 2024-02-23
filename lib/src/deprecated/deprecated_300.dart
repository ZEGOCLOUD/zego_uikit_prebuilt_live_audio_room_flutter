// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

const deprecatedTips = ', '
    'deprecated since 3.0.0, '
    'will be removed after 3.5.0,'
    'Migrate Guide:https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Migration_3.x-topic.html';

@Deprecated(
    'Use ZegoUIKitPrebuiltLiveAudioRoomController instead$deprecatedTips')
typedef ZegoLiveAudioRoomController = ZegoUIKitPrebuiltLiveAudioRoomController;

@Deprecated('Use ZegoLiveAudioRoomMiniOverlayPageState instead$deprecatedTips')
typedef LiveAudioRoomMiniOverlayPageState
    = ZegoLiveAudioRoomMiniOverlayPageState;

@Deprecated('Use ZegoLiveAudioRoomTopMenuBarConfig instead$deprecatedTips')
typedef ZegoTopMenuBarConfig = ZegoLiveAudioRoomTopMenuBarConfig;

@Deprecated('Use ZegoLiveAudioRoomBottomMenuBarConfig instead$deprecatedTips')
typedef ZegoBottomMenuBarConfig = ZegoLiveAudioRoomBottomMenuBarConfig;

@Deprecated('Use ZegoLiveAudioRoomInRoomMessageConfig instead$deprecatedTips')
typedef ZegoInRoomMessageConfig = ZegoLiveAudioRoomInRoomMessageConfig;

@Deprecated('Use ZegoLiveAudioRoomMemberListConfig instead$deprecatedTips')
typedef ZegoMemberListConfig = ZegoLiveAudioRoomMemberListConfig;

@Deprecated('Use ZegoLiveAudioRoomAudioEffectConfig instead$deprecatedTips')
typedef ZegoAudioEffectConfig = ZegoLiveAudioRoomAudioEffectConfig;

@Deprecated('Use ZegoLiveAudioRoomLiveDurationConfig instead$deprecatedTips')
typedef ZegoLiveDurationConfig = ZegoLiveAudioRoomLiveDurationConfig;

@Deprecated('Use ZegoLiveAudioRoomMediaPlayerConfig instead$deprecatedTips')
typedef ZegoMediaPlayerConfig = ZegoLiveAudioRoomMediaPlayerConfig;

@Deprecated('Use ZegoLiveAudioRoomBackgroundMediaConfig instead$deprecatedTips')
typedef ZegoBackgroundMediaConfig = ZegoLiveAudioRoomBackgroundMediaConfig;

@Deprecated(
    'Use ZegoUIKitPrebuiltLiveAudioRoomInnerText instead$deprecatedTips')
typedef ZegoInnerText = ZegoUIKitPrebuiltLiveAudioRoomInnerText;

@Deprecated('Use ZegoLiveAudioRoomMenuBarButtonName instead$deprecatedTips')
typedef ZegoMenuBarButtonName = ZegoLiveAudioRoomMenuBarButtonName;

@Deprecated('Use ZegoLiveAudioRoomDialogInfo instead$deprecatedTips')
typedef ZegoDialogInfo = ZegoLiveAudioRoomDialogInfo;

extension ZegoUIKitPrebuiltLiveAudioRoomConfigDeprecatedExtension
    on ZegoUIKitPrebuiltLiveAudioRoomConfig {
  @Deprecated('Use topMenuBar instead$deprecatedTips')
  ZegoTopMenuBarConfig get topMenuBarConfig => topMenuBar;

  @Deprecated('Use topMenuBar instead$deprecatedTips')
  set topMenuBarConfig(ZegoTopMenuBarConfig config) => topMenuBar = config;

  @Deprecated('Use bottomMenuBar instead$deprecatedTips')
  ZegoBottomMenuBarConfig get bottomMenuBarConfig => bottomMenuBar;

  @Deprecated('Use bottomMenuBar instead$deprecatedTips')
  set bottomMenuBarConfig(ZegoBottomMenuBarConfig config) =>
      bottomMenuBar = config;

  @Deprecated('Use inRoomMessage instead$deprecatedTips')
  ZegoInRoomMessageConfig get inRoomMessageConfig => inRoomMessage;

  @Deprecated('Use inRoomMessage instead$deprecatedTips')
  set inRoomMessageConfig(ZegoInRoomMessageConfig config) =>
      inRoomMessage = config;

  @Deprecated('Use inRoomMessage instead$deprecatedTips')
  ZegoInRoomMessageConfig get inRoomMessageViewConfig => inRoomMessage;

  @Deprecated('Use inRoomMessage instead$deprecatedTips')
  set inRoomMessageViewConfig(ZegoInRoomMessageConfig config) =>
      inRoomMessage = config;

  @Deprecated('Use memberList instead$deprecatedTips')
  ZegoMemberListConfig get memberListConfig => memberList;

  @Deprecated('Use memberList instead$deprecatedTips')
  set memberListConfig(ZegoMemberListConfig config) => memberList = config;

  @Deprecated('Use audioEffect instead$deprecatedTips')
  ZegoAudioEffectConfig get audioEffectConfig => audioEffect;

  @Deprecated('Use audioEffect instead$deprecatedTips')
  set audioEffectConfig(ZegoAudioEffectConfig config) => audioEffect = config;

  @Deprecated('Use duration instead$deprecatedTips')
  ZegoLiveDurationConfig get durationConfig => duration;

  @Deprecated('Use duration instead$deprecatedTips')
  set durationConfig(ZegoLiveDurationConfig config) => duration = config;

  @Deprecated('Use mediaPlayer instead$deprecatedTips')
  ZegoMediaPlayerConfig get mediaPlayerConfig => mediaPlayer;

  @Deprecated('Use mediaPlayer instead$deprecatedTips')
  set mediaPlayerConfig(ZegoMediaPlayerConfig config) => mediaPlayer = config;

  @Deprecated('Use backgroundMedia instead$deprecatedTips')
  ZegoBackgroundMediaConfig get backgroundMediaConfig => backgroundMedia;

  @Deprecated('Use backgroundMedia instead$deprecatedTips')
  set backgroundMediaConfig(ZegoBackgroundMediaConfig config) =>
      backgroundMedia = config;
}

extension ZegoUIKitPrebuiltLiveAudioRoomConfigSeatDeprecatedExtension
    on ZegoUIKitPrebuiltLiveAudioRoomConfig {
  @Deprecated('Use seat instead$deprecatedTips')
  ZegoLiveAudioRoomSeatConfig get seatConfig => seat;

  @Deprecated('Use seat instead$deprecatedTips')
  set seatConfig(ZegoLiveAudioRoomSeatConfig config) => seat = config;

  @Deprecated('Use seat.layout instead$deprecatedTips')
  ZegoLiveAudioRoomLayoutConfig get layoutConfig => seat.layout;

  @Deprecated('Use seat.layout instead$deprecatedTips')
  set layoutConfig(ZegoLiveAudioRoomLayoutConfig value) => seat.layout = value;

  @Deprecated('Use seat.takeIndexWhenJoining instead$deprecatedTips')
  int get takeSeatIndexWhenJoining => seat.takeIndexWhenJoining;

  @Deprecated('Use seat.takeIndexWhenJoining instead$deprecatedTips')
  set takeSeatIndexWhenJoining(int value) => seat.takeIndexWhenJoining = value;

  @Deprecated('Use seat.closeWhenJoining instead$deprecatedTips')
  bool get closeSeatsWhenJoining => seat.closeWhenJoining;

  @Deprecated('Use seat.closeWhenJoining instead$deprecatedTips')
  set closeSeatsWhenJoining(bool value) => seat.closeWhenJoining = value;

  @Deprecated('Use seat.hostIndexes instead$deprecatedTips')
  List<int> get hostSeatIndexes => seat.hostIndexes;

  @Deprecated('Use seat.hostIndexes instead$deprecatedTips')
  set hostSeatIndexes(List<int> value) => seat.hostIndexes = value;
}

extension ZegoUIKitPrebuiltLiveAudioRoomControllerDeprecatedExtension
    on ZegoUIKitPrebuiltLiveAudioRoomController {
  @Deprecated('use audioVideo.microphone.turnOn instead$deprecatedTips')
  void turnMicrophoneOn(bool isOn, {String? userID}) {
    audioVideo.microphone.turnOn(
      isOn,
      userID: userID,
    );
  }

  @Deprecated('use seat.localIsAHost instead$deprecatedTips')
  bool get localIsAHost => seat.localIsHost;

  @Deprecated('use seat.localIsAAudience instead$deprecatedTips')
  bool get localIsAAudience => seat.localIsAudience;

  @Deprecated('use seat.localIsCoHost instead$deprecatedTips')
  bool get localIsCoHost => seat.localIsCoHost;

  @Deprecated('use seat.localHasHostPermissions instead$deprecatedTips')
  bool get localHasHostPermissions => seat.localHasHostPermissions;

  @Deprecated('use seat.userMapNotifier instead$deprecatedTips')
  ValueNotifier<Map<String, String>>? getSeatsUserMapNotifier() {
    return seat.userMapNotifier;
  }

  @Deprecated('use seat.openSeats instead$deprecatedTips')
  Future<bool> openSeats({
    int targetIndex = -1,
  }) async {
    return seat.host.open(targetIndex: targetIndex);
  }

  @Deprecated('use seat.host.close instead$deprecatedTips')
  Future<bool> closeSeats({
    int targetIndex = -1,
  }) async {
    return seat.host.close(targetIndex: targetIndex);
  }

  @Deprecated('use seat.host.removeSpeaker instead$deprecatedTips')
  Future<void> removeSpeakerFromSeat(String userID) async {
    return seat.host.removeSpeaker(userID);
  }

  @Deprecated('use seat.host.acceptTakingRequest instead$deprecatedTips')
  Future<bool> acceptSeatTakingRequest(String audienceUserID) async {
    return seat.host.acceptTakingRequest(audienceUserID);
  }

  @Deprecated('use seat.host.rejectTakingRequest instead$deprecatedTips')
  Future<bool> rejectSeatTakingRequest(String audienceUserID) async {
    return seat.host.rejectTakingRequest(audienceUserID);
  }

  @Deprecated('use seat.host.inviteToTake instead$deprecatedTips')
  Future<bool> inviteAudienceToTakeSeat(String audienceUserID) async {
    return seat.host.inviteToTake(audienceUserID);
  }

  @Deprecated('use seat.speaker.leave instead$deprecatedTips')
  Future<bool> leaveSeat({bool showDialog = true}) async {
    return seat.speaker.leave(showDialog: showDialog);
  }

  @Deprecated('use seat.audience.take instead$deprecatedTips')
  Future<bool> takeSeat(int index) async {
    return seat.audience.take(index);
  }

  @Deprecated('use seat.audience.applyToTake instead$deprecatedTips')
  Future<bool> applyToTakeSeat() async {
    return seat.audience.applyToTake();
  }

  @Deprecated('use seat.audience.cancelTakingRequest instead$deprecatedTips')
  Future<bool> cancelSeatTakingRequest() async {
    return seat.audience.cancelTakingRequest();
  }

  @Deprecated('use seat.audience.acceptTakingInvitation instead$deprecatedTips')
  Future<bool> acceptHostTakeSeatInvitation({
    required BuildContext context,
    bool rootNavigator = false,
  }) async {
    return seat.audience.acceptTakingInvitation(
      context: context,
      rootNavigator: rootNavigator,
    );
  }
}

extension ZegoLiveAudioRoomMediaControllerDeprecatedExtension
    on ZegoLiveAudioRoomControllerMediaImpl {
  @Deprecated('use volume instead$deprecatedTips')
  int getVolume() {
    return volume;
  }

  @Deprecated('use totalDuration instead$deprecatedTips')
  int getTotalDuration() {
    return totalDuration;
  }

  @Deprecated('use currentProgress instead$deprecatedTips')
  int getCurrentProgress() {
    return currentProgress;
  }

  @Deprecated('use type instead$deprecatedTips')
  ZegoUIKitMediaType getType() {
    return type;
  }

  @Deprecated('use volumeNotifier instead$deprecatedTips')
  ValueNotifier<int> getVolumeNotifier() {
    return volumeNotifier;
  }

  @Deprecated('use currentProgressNotifier instead$deprecatedTips')
  ValueNotifier<int> getCurrentProgressNotifier() {
    return currentProgressNotifier;
  }

  @Deprecated('use playStateNotifier instead$deprecatedTips')
  ValueNotifier<ZegoUIKitMediaPlayState> getPlayStateNotifier() {
    return playStateNotifier;
  }

  @Deprecated('use typeNotifier instead$deprecatedTips')
  ValueNotifier<ZegoUIKitMediaType> getMediaTypeNotifier() {
    return typeNotifier;
  }

  @Deprecated('use info instead$deprecatedTips')
  ZegoUIKitMediaInfo getMediaInfo() {
    return info;
  }
}
