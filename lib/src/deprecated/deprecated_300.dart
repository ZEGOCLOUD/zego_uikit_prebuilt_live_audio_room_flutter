// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

const deprecatedTipsV3_0_0 = ', '
    'deprecated since 3.0.0, '
    'will be removed after 3.10.0,'
    'Migrate Guide:https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Migration_3.x-topic.html';

@Deprecated(
    'Use ZegoUIKitPrebuiltLiveAudioRoomController instead$deprecatedTipsV3_0_0')
typedef ZegoLiveAudioRoomController = ZegoUIKitPrebuiltLiveAudioRoomController;

@Deprecated(
    'Use ZegoLiveAudioRoomMiniOverlayPageState instead$deprecatedTipsV3_0_0')
typedef LiveAudioRoomMiniOverlayPageState
    = ZegoLiveAudioRoomMiniOverlayPageState;

@Deprecated(
    'Use ZegoLiveAudioRoomTopMenuBarConfig instead$deprecatedTipsV3_0_0')
typedef ZegoTopMenuBarConfig = ZegoLiveAudioRoomTopMenuBarConfig;

@Deprecated(
    'Use ZegoLiveAudioRoomBottomMenuBarConfig instead$deprecatedTipsV3_0_0')
typedef ZegoBottomMenuBarConfig = ZegoLiveAudioRoomBottomMenuBarConfig;

@Deprecated(
    'Use ZegoLiveAudioRoomInRoomMessageConfig instead$deprecatedTipsV3_0_0')
typedef ZegoInRoomMessageConfig = ZegoLiveAudioRoomInRoomMessageConfig;

@Deprecated(
    'Use ZegoLiveAudioRoomMemberListConfig instead$deprecatedTipsV3_0_0')
typedef ZegoMemberListConfig = ZegoLiveAudioRoomMemberListConfig;

@Deprecated(
    'Use ZegoLiveAudioRoomAudioEffectConfig instead$deprecatedTipsV3_0_0')
typedef ZegoAudioEffectConfig = ZegoLiveAudioRoomAudioEffectConfig;

@Deprecated(
    'Use ZegoLiveAudioRoomLiveDurationConfig instead$deprecatedTipsV3_0_0')
typedef ZegoLiveDurationConfig = ZegoLiveAudioRoomLiveDurationConfig;

@Deprecated(
    'Use ZegoLiveAudioRoomMediaPlayerConfig instead$deprecatedTipsV3_0_0')
typedef ZegoMediaPlayerConfig = ZegoLiveAudioRoomMediaPlayerConfig;

@Deprecated(
    'Use ZegoLiveAudioRoomBackgroundMediaConfig instead$deprecatedTipsV3_0_0')
typedef ZegoBackgroundMediaConfig = ZegoLiveAudioRoomBackgroundMediaConfig;

@Deprecated(
    'Use ZegoUIKitPrebuiltLiveAudioRoomInnerText instead$deprecatedTipsV3_0_0')
typedef ZegoInnerText = ZegoUIKitPrebuiltLiveAudioRoomInnerText;

@Deprecated(
    'Use ZegoLiveAudioRoomMenuBarButtonName instead$deprecatedTipsV3_0_0')
typedef ZegoMenuBarButtonName = ZegoLiveAudioRoomMenuBarButtonName;

@Deprecated('Use ZegoLiveAudioRoomDialogInfo instead$deprecatedTipsV3_0_0')
typedef ZegoDialogInfo = ZegoLiveAudioRoomDialogInfo;

extension ZegoUIKitPrebuiltLiveAudioRoomConfigDeprecatedExtension
    on ZegoUIKitPrebuiltLiveAudioRoomConfig {
  @Deprecated('Use topMenuBar instead$deprecatedTipsV3_0_0')
  ZegoTopMenuBarConfig get topMenuBarConfig => topMenuBar;

  @Deprecated('Use topMenuBar instead$deprecatedTipsV3_0_0')
  set topMenuBarConfig(ZegoTopMenuBarConfig config) => topMenuBar = config;

  @Deprecated('Use bottomMenuBar instead$deprecatedTipsV3_0_0')
  ZegoBottomMenuBarConfig get bottomMenuBarConfig => bottomMenuBar;

  @Deprecated('Use bottomMenuBar instead$deprecatedTipsV3_0_0')
  set bottomMenuBarConfig(ZegoBottomMenuBarConfig config) =>
      bottomMenuBar = config;

  @Deprecated('Use inRoomMessage instead$deprecatedTipsV3_0_0')
  ZegoInRoomMessageConfig get inRoomMessageConfig => inRoomMessage;

  @Deprecated('Use inRoomMessage instead$deprecatedTipsV3_0_0')
  set inRoomMessageConfig(ZegoInRoomMessageConfig config) =>
      inRoomMessage = config;

  @Deprecated('Use inRoomMessage instead$deprecatedTipsV3_0_0')
  ZegoInRoomMessageConfig get inRoomMessageViewConfig => inRoomMessage;

  @Deprecated('Use inRoomMessage instead$deprecatedTipsV3_0_0')
  set inRoomMessageViewConfig(ZegoInRoomMessageConfig config) =>
      inRoomMessage = config;

  @Deprecated('Use memberList instead$deprecatedTipsV3_0_0')
  ZegoMemberListConfig get memberListConfig => memberList;

  @Deprecated('Use memberList instead$deprecatedTipsV3_0_0')
  set memberListConfig(ZegoMemberListConfig config) => memberList = config;

  @Deprecated('Use audioEffect instead$deprecatedTipsV3_0_0')
  ZegoAudioEffectConfig get audioEffectConfig => audioEffect;

  @Deprecated('Use audioEffect instead$deprecatedTipsV3_0_0')
  set audioEffectConfig(ZegoAudioEffectConfig config) => audioEffect = config;

  @Deprecated('Use duration instead$deprecatedTipsV3_0_0')
  ZegoLiveDurationConfig get durationConfig => duration;

  @Deprecated('Use duration instead$deprecatedTipsV3_0_0')
  set durationConfig(ZegoLiveDurationConfig config) => duration = config;

  @Deprecated('Use mediaPlayer instead$deprecatedTipsV3_0_0')
  ZegoMediaPlayerConfig get mediaPlayerConfig => mediaPlayer;

  @Deprecated('Use mediaPlayer instead$deprecatedTipsV3_0_0')
  set mediaPlayerConfig(ZegoMediaPlayerConfig config) => mediaPlayer = config;

  @Deprecated('Use backgroundMedia instead$deprecatedTipsV3_0_0')
  ZegoBackgroundMediaConfig get backgroundMediaConfig => backgroundMedia;

  @Deprecated('Use backgroundMedia instead$deprecatedTipsV3_0_0')
  set backgroundMediaConfig(ZegoBackgroundMediaConfig config) =>
      backgroundMedia = config;
}

extension ZegoUIKitPrebuiltLiveAudioRoomConfigSeatDeprecatedExtension
    on ZegoUIKitPrebuiltLiveAudioRoomConfig {
  @Deprecated('Use seat instead$deprecatedTipsV3_0_0')
  ZegoLiveAudioRoomSeatConfig get seatConfig => seat;

  @Deprecated('Use seat instead$deprecatedTipsV3_0_0')
  set seatConfig(ZegoLiveAudioRoomSeatConfig config) => seat = config;

  @Deprecated('Use seat.layout instead$deprecatedTipsV3_0_0')
  ZegoLiveAudioRoomLayoutConfig get layoutConfig => seat.layout;

  @Deprecated('Use seat.layout instead$deprecatedTipsV3_0_0')
  set layoutConfig(ZegoLiveAudioRoomLayoutConfig value) => seat.layout = value;

  @Deprecated('Use seat.takeIndexWhenJoining instead$deprecatedTipsV3_0_0')
  int get takeSeatIndexWhenJoining => seat.takeIndexWhenJoining;

  @Deprecated('Use seat.takeIndexWhenJoining instead$deprecatedTipsV3_0_0')
  set takeSeatIndexWhenJoining(int value) => seat.takeIndexWhenJoining = value;

  @Deprecated('Use seat.closeWhenJoining instead$deprecatedTipsV3_0_0')
  bool get closeSeatsWhenJoining => seat.closeWhenJoining;

  @Deprecated('Use seat.closeWhenJoining instead$deprecatedTipsV3_0_0')
  set closeSeatsWhenJoining(bool value) => seat.closeWhenJoining = value;

  @Deprecated('Use seat.hostIndexes instead$deprecatedTipsV3_0_0')
  List<int> get hostSeatIndexes => seat.hostIndexes;

  @Deprecated('Use seat.hostIndexes instead$deprecatedTipsV3_0_0')
  set hostSeatIndexes(List<int> value) => seat.hostIndexes = value;
}

extension ZegoUIKitPrebuiltLiveAudioRoomControllerDeprecatedExtension
    on ZegoUIKitPrebuiltLiveAudioRoomController {
  @Deprecated('use audioVideo.microphone.turnOn instead$deprecatedTipsV3_0_0')
  void turnMicrophoneOn(bool isOn, {String? userID}) {
    audioVideo.microphone.turnOn(
      isOn,
      userID: userID,
    );
  }

  @Deprecated('use seat.localIsAHost instead$deprecatedTipsV3_0_0')
  bool get localIsAHost => seat.localIsHost;

  @Deprecated('use seat.localIsAAudience instead$deprecatedTipsV3_0_0')
  bool get localIsAAudience => seat.localIsAudience;

  @Deprecated('use seat.localIsCoHost instead$deprecatedTipsV3_0_0')
  bool get localIsCoHost => seat.localIsCoHost;

  @Deprecated('use seat.localHasHostPermissions instead$deprecatedTipsV3_0_0')
  bool get localHasHostPermissions => seat.localHasHostPermissions;

  @Deprecated('use seat.userMapNotifier instead$deprecatedTipsV3_0_0')
  ValueNotifier<Map<String, String>>? getSeatsUserMapNotifier() {
    return seat.userMapNotifier;
  }

  @Deprecated('use seat.openSeats instead$deprecatedTipsV3_0_0')
  Future<bool> openSeats({
    int targetIndex = -1,
  }) async {
    return seat.host.open(targetIndex: targetIndex);
  }

  @Deprecated('use seat.host.close instead$deprecatedTipsV3_0_0')
  Future<bool> closeSeats({
    int targetIndex = -1,
  }) async {
    return seat.host.close(targetIndex: targetIndex);
  }

  @Deprecated('use seat.host.removeSpeaker instead$deprecatedTipsV3_0_0')
  Future<void> removeSpeakerFromSeat(String userID) async {
    return seat.host.removeSpeaker(userID);
  }

  @Deprecated('use seat.host.acceptTakingRequest instead$deprecatedTipsV3_0_0')
  Future<bool> acceptSeatTakingRequest(String audienceUserID) async {
    return seat.host.acceptTakingRequest(audienceUserID);
  }

  @Deprecated('use seat.host.rejectTakingRequest instead$deprecatedTipsV3_0_0')
  Future<bool> rejectSeatTakingRequest(String audienceUserID) async {
    return seat.host.rejectTakingRequest(audienceUserID);
  }

  @Deprecated('use seat.host.inviteToTake instead$deprecatedTipsV3_0_0')
  Future<bool> inviteAudienceToTakeSeat(String audienceUserID) async {
    return seat.host.inviteToTake(audienceUserID);
  }

  @Deprecated('use seat.speaker.leave instead$deprecatedTipsV3_0_0')
  Future<bool> leaveSeat({bool showDialog = true}) async {
    return seat.speaker.leave(showDialog: showDialog);
  }

  @Deprecated('use seat.audience.take instead$deprecatedTipsV3_0_0')
  Future<bool> takeSeat(int index) async {
    return seat.audience.take(index);
  }

  @Deprecated('use seat.audience.applyToTake instead$deprecatedTipsV3_0_0')
  Future<bool> applyToTakeSeat() async {
    return seat.audience.applyToTake();
  }

  @Deprecated(
      'use seat.audience.cancelTakingRequest instead$deprecatedTipsV3_0_0')
  Future<bool> cancelSeatTakingRequest() async {
    return seat.audience.cancelTakingRequest();
  }

  @Deprecated(
      'use seat.audience.acceptTakingInvitation instead$deprecatedTipsV3_0_0')
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
  @Deprecated('use volume instead$deprecatedTipsV3_0_0')
  int getVolume() {
    return volume;
  }

  @Deprecated('use totalDuration instead$deprecatedTipsV3_0_0')
  int getTotalDuration() {
    return totalDuration;
  }

  @Deprecated('use currentProgress instead$deprecatedTipsV3_0_0')
  int getCurrentProgress() {
    return currentProgress;
  }

  @Deprecated('use type instead$deprecatedTipsV3_0_0')
  ZegoUIKitMediaType getType() {
    return type;
  }

  @Deprecated('use volumeNotifier instead$deprecatedTipsV3_0_0')
  ValueNotifier<int> getVolumeNotifier() {
    return volumeNotifier;
  }

  @Deprecated('use currentProgressNotifier instead$deprecatedTipsV3_0_0')
  ValueNotifier<int> getCurrentProgressNotifier() {
    return currentProgressNotifier;
  }

  @Deprecated('use playStateNotifier instead$deprecatedTipsV3_0_0')
  ValueNotifier<ZegoUIKitMediaPlayState> getPlayStateNotifier() {
    return playStateNotifier;
  }

  @Deprecated('use typeNotifier instead$deprecatedTipsV3_0_0')
  ValueNotifier<ZegoUIKitMediaType> getMediaTypeNotifier() {
    return typeNotifier;
  }

  @Deprecated('use info instead$deprecatedTipsV3_0_0')
  ZegoUIKitMediaInfo getMediaInfo() {
    return info;
  }
}
