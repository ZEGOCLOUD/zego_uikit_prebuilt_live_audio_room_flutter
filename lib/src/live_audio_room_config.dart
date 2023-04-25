// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';

class ZegoUIKitPrebuiltLiveAudioRoomConfig {
  ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
      : role = ZegoLiveAudioRoomRole.host,
        takeSeatIndexWhenJoining = 0,
        closeSeatsWhenJoining = true,
        turnOnMicrophoneWhenJoining = true,
        useSpeakerWhenJoining = true,
        userInRoomAttributes = const {},
        seatConfig = ZegoLiveAudioRoomSeatConfig(),
        layoutConfig = ZegoLiveAudioRoomLayoutConfig(),
        hostSeatIndexes = const [0],
        topMenuBarConfig = ZegoTopMenuBarConfig(),
        bottomMenuBarConfig = ZegoBottomMenuBarConfig(),
        inRoomMessageViewConfig = ZegoInRoomMessageViewConfig(),
        audioEffectConfig = ZegoAudioEffectConfig(),
        innerText = ZegoInnerText(),
        confirmDialogInfo = ZegoDialogInfo(
          title: 'Leave the room',
          message: 'Are you sure to leave the room?',
          cancelButtonName: 'Cancel',
          confirmButtonName: 'OK',
        );

  ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
      : role = ZegoLiveAudioRoomRole.audience,
        turnOnMicrophoneWhenJoining = false,
        closeSeatsWhenJoining = false,
        useSpeakerWhenJoining = true,
        userInRoomAttributes = const {},
        seatConfig = ZegoLiveAudioRoomSeatConfig(),
        layoutConfig = ZegoLiveAudioRoomLayoutConfig(),
        hostSeatIndexes = const [0],
        topMenuBarConfig = ZegoTopMenuBarConfig(),
        bottomMenuBarConfig = ZegoBottomMenuBarConfig(),
        inRoomMessageViewConfig = ZegoInRoomMessageViewConfig(),
        audioEffectConfig = ZegoAudioEffectConfig(),
        innerText = ZegoInnerText();

  ZegoUIKitPrebuiltLiveAudioRoomConfig({
    this.turnOnMicrophoneWhenJoining = true,
    this.useSpeakerWhenJoining = true,
    this.closeSeatsWhenJoining = true,
    ZegoLiveAudioRoomSeatConfig? seatConfig,
    ZegoTopMenuBarConfig? topMenuBarConfig,
    ZegoBottomMenuBarConfig? bottomMenuBarConfig,
    ZegoLiveAudioRoomLayoutConfig? layoutConfig,
    ZegoInRoomMessageViewConfig? messageConfig,
    ZegoAudioEffectConfig? effectConfig,
    this.hostSeatIndexes = const [0],
    this.confirmDialogInfo,
    this.onLeaveConfirmation,
    this.onLeaveLiveAudioRoom,
    this.background,
    this.userAvatarUrl,
    this.userInRoomAttributes = const {},
    this.onUserCountOrPropertyChanged,
    this.onSeatClosed,
    this.onSeatsOpened,
    this.onSeatClicked,
    this.onSeatsChanged,
    this.onSeatTakingRequested,
    this.onSeatTakingRequestCanceled,
    this.onInviteAudienceToTakeSeatFailed,
    this.onSeatTakingInviteRejected,
    this.onSeatTakingRequestFailed,
    this.onSeatTakingRequestRejected,
    this.onHostSeatTakingInviteSent,
    this.onMemberListMoreButtonPressed,
    ZegoInnerText? translationText,
  })  : seatConfig = seatConfig ?? ZegoLiveAudioRoomSeatConfig(),
        topMenuBarConfig = topMenuBarConfig ?? ZegoTopMenuBarConfig(),
        bottomMenuBarConfig = bottomMenuBarConfig ?? ZegoBottomMenuBarConfig(),
        layoutConfig = layoutConfig ?? ZegoLiveAudioRoomLayoutConfig(),
        inRoomMessageViewConfig =
            messageConfig ?? ZegoInRoomMessageViewConfig(),
        audioEffectConfig = effectConfig ?? ZegoAudioEffectConfig(),
        innerText = translationText ?? ZegoInnerText();

  /// specify if a host or audience, speaker
  ZegoLiveAudioRoomRole role = ZegoLiveAudioRoomRole.audience;

  /// specify seat index, only work if host or speaker
  int takeSeatIndexWhenJoining = -1;

  /// only host set!! Specifies whether to lock the seat automatically after entering the room
  bool closeSeatsWhenJoining;

  /// these seat indexes if for host
  /// for audience and speakers, these seat index are prohibited.
  /// The default is[0].
  List<int> hostSeatIndexes;

  /// you can use the layout configuration to achieve the layout you want
  /// the layout uses a row/column configuration
  ZegoLiveAudioRoomLayoutConfig layoutConfig;

  /// configs about seat
  ZegoLiveAudioRoomSeatConfig seatConfig;

  /// whether to enable the microphone by default, the default value is true
  bool turnOnMicrophoneWhenJoining;

  /// whether to use the speaker by default, the default value is true;
  bool useSpeakerWhenJoining;

  /// you can customize any background you wanted
  /// ```dart
  ///
  ///  // eg:
  /// ..background = Container(
  ///     width: size.width,
  ///     height: size.height,
  ///     decoration: const BoxDecoration(
  ///       image: DecorationImage(
  ///         fit: BoxFit.fitHeight,
  ///         image: ,
  ///       )));
  /// ```
  Widget? background;

  /// configs about top bar
  ZegoTopMenuBarConfig topMenuBarConfig;

  /// configs about bottom menu bar
  ZegoBottomMenuBarConfig bottomMenuBarConfig;

  /// alert dialog information of leave
  /// if confirm info is not null, APP will pop alert dialog when you hang up
  ZegoDialogInfo? confirmDialogInfo;

  /// configs about message view
  ZegoInRoomMessageViewConfig inRoomMessageViewConfig;

  ZegoInnerText innerText;

  /// support :
  /// 1. Voice changing
  /// 2. Reverb
  ZegoAudioEffectConfig audioEffectConfig;

  /// avatar url of local user, Value is not larger than 64 bytes
  String? userAvatarUrl;

  /// in-room attributes of local user
  Map<String, String> userInRoomAttributes;

  /// It is often used to customize the process before exiting the live interface.
  /// The liveback will triggered when user click hang up button or use system's return,
  /// If you need to handle custom logic, you can set this liveback to handle (such as showAlertDialog to let user determine).
  /// if you return true in the liveback, prebuilt page will quit and return to your previous page, otherwise will ignore.
  Future<bool> Function(BuildContext context)? onLeaveConfirmation;

  /// customize handling after leave audio room
  VoidCallback? onLeaveLiveAudioRoom;

  /// if return true, will directly open the microphone
  /// when received onTurnOnYourMicrophoneRequest
  /// default is false
  Future<bool> Function(BuildContext context)?
      onMicrophoneTurnOnByOthersConfirmation;

  /// user count or user attribute changed callback
  void Function(List<ZegoUIKitUser> users)? onUserCountOrPropertyChanged;

  /// audio room's seat is closed, audience need apply to take
  VoidCallback? onSeatClosed;

  /// audio room's seat is opened, audience can take on by click empty seat
  VoidCallback? onSeatsOpened;

  /// customize the seat click event
  /// WARNING: will override prebuilt logic
  void Function(int index, ZegoUIKitUser? user)? onSeatClicked;

  /// triggered when someone gets on/gets off/switches seat
  /// @param takenSeats {seat index, seat user}
  /// @param untakenSeats [seat index]
  void Function(
    Map<int, ZegoUIKitUser> takenSeats,
    List<int> untakenSeats,
  )? onSeatsChanged;

  /// host receive, some audience's take seat request
  void Function(ZegoUIKitUser audience)? onSeatTakingRequested;

  /// host receive, audience's take seat request had canceled
  void Function(ZegoUIKitUser audience)? onSeatTakingRequestCanceled;

  /// host receive, host's invite is failed
  VoidCallback? onInviteAudienceToTakeSeatFailed;

  /// host receive, host's invite is rejected by audience
  VoidCallback? onSeatTakingInviteRejected;

  /// audience receive, audience's request is failed
  VoidCallback? onSeatTakingRequestFailed;

  /// audience receive, audience's request is rejected by host
  VoidCallback? onSeatTakingRequestRejected;

  /// audience receive, host invite audience to take seat
  VoidCallback? onHostSeatTakingInviteSent;

  /// customize the member list more button click event
  /// WARNING: will override prebuilt logic
  void Function(ZegoUIKitUser user)? onMemberListMoreButtonPressed;
}

class ZegoLiveAudioRoomSeatConfig {
  bool showSoundWaveInAudioMode = true;

  /// custom seat un-locked(no one on the seat) icon
  Image? openIcon;

  /// custom seat locked icon
  Image? closeIcon;

  ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  /// customize your user's avatar, default we use userID's first character as avatar
  /// User avatars are generally stored in your server, ZegoUIKitPrebuiltLiveAudioRoom does not know each user's avatar, so by default, ZegoUIKitPrebuiltLiveAudioRoom will use the first letter of the user name to draw the default user avatar, as shown in the following figure,
  ///
  /// |When the user is not speaking|When the user is speaking|
  /// |--|--|
  /// |<img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/_default_avatar_nowave.jpg" width="10%">|<img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/_default_avatar.jpg" width="10%">|
  ///
  /// If you need to display the real avatar of your user, you can use the avatarBuilder to set the user avatar builder method (set user avatar widget builder), the usage is as follows:
  ///
  /// ```dart
  ///
  ///  // eg:
  ///  avatarBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
  ///    return user != null
  ///        ? Container(
  ///            decoration: BoxDecoration(
  ///              shape: BoxShape.circle,
  ///              image: DecorationImage(
  ///                image: NetworkImage(
  ///                  'https://your_server/app/avatar/${user.id}.png',
  ///                ),
  ///              ),
  ///            ),
  ///          )
  ///        : const SizedBox();
  ///  },
  ///
  /// ```
  ///
  ZegoAvatarBuilder? avatarBuilder;

  ZegoLiveAudioRoomSeatConfig({
    this.openIcon,
    this.closeIcon,
    this.showSoundWaveInAudioMode = true,
    this.avatarBuilder,
    this.foregroundBuilder,
    this.backgroundBuilder,
  });
}

class ZegoTopMenuBarConfig {
  /// these buttons will displayed on the menu bar, order by the list
  /// only support [minimizingButton] right now!!
  List<ZegoMenuBarButtonName> buttons;

  ZegoTopMenuBarConfig({
    this.buttons = const [],
  });
}

class ZegoBottomMenuBarConfig {
  /// support message if set true
  bool showInRoomMessageButton;

  /// these buttons will displayed on the menu bar, order by the list
  List<ZegoMenuBarButtonName> hostButtons = [];
  List<ZegoMenuBarButtonName> speakerButtons = [];
  List<ZegoMenuBarButtonName> audienceButtons = [];

  /// these buttons will sequentially added to menu bar,
  /// and auto added extra buttons to the pop-up menu
  /// when the limit [maxCount] is exceeded
  List<Widget> hostExtendButtons = [];
  List<Widget> speakerExtendButtons = [];
  List<Widget> audienceExtendButtons = [];

  /// limited item count display on menu bar,
  /// if this count is exceeded, More button is displayed
  int maxCount;

  ZegoBottomMenuBarConfig({
    this.showInRoomMessageButton = true,
    this.hostButtons = const [
      ZegoMenuBarButtonName.soundEffectButton,
      ZegoMenuBarButtonName.toggleMicrophoneButton,
      ZegoMenuBarButtonName.showMemberListButton,
      ZegoMenuBarButtonName.closeSeatButton,
    ],
    this.speakerButtons = const [
      ZegoMenuBarButtonName.soundEffectButton,
      ZegoMenuBarButtonName.toggleMicrophoneButton,
      ZegoMenuBarButtonName.showMemberListButton,
    ],
    this.audienceButtons = const [
      ZegoMenuBarButtonName.showMemberListButton,
      ZegoMenuBarButtonName.applyToTakeSeatButton,
    ],
    this.hostExtendButtons = const [],
    this.speakerExtendButtons = const [],
    this.audienceExtendButtons = const [],
    this.maxCount = 5,
  });
}

class ZegoInRoomMessageViewConfig {
  /// hide message view if invisible
  bool visible;

  /// customize your item view of message list
  ZegoInRoomMessageItemBuilder? itemBuilder;

  ZegoInRoomMessageViewConfig({
    this.visible = true,
    this.itemBuilder,
  });
}

class ZegoAudioEffectConfig {
  List<VoiceChangerType> voiceChangeEffect;
  List<ReverbType> reverbEffect;

  ZegoAudioEffectConfig({
    this.voiceChangeEffect = const [
      VoiceChangerType.littleGirl,
      VoiceChangerType.deep,
      VoiceChangerType.robot,
      VoiceChangerType.ethereal,
      VoiceChangerType.littleBoy,
      VoiceChangerType.female,
      VoiceChangerType.male,
      VoiceChangerType.optimusPrime,
      VoiceChangerType.crystalClear,
      VoiceChangerType.cMajor,
      VoiceChangerType.aMajor,
      VoiceChangerType.harmonicMinor,
    ],
    this.reverbEffect = const [
      ReverbType.ktv,
      ReverbType.hall,
      ReverbType.concert,
      ReverbType.rock,
      ReverbType.smallRoom,
      ReverbType.largeRoom,
      ReverbType.valley,
      ReverbType.recordingStudio,
      ReverbType.basement,
      ReverbType.popular,
      ReverbType.gramophone,
    ],
  });

  ZegoAudioEffectConfig.none({
    this.voiceChangeEffect = const [],
    this.reverbEffect = const [],
  });

  bool get isSupportVoiceChange => voiceChangeEffect.isNotEmpty;

  bool get isSupportReverb => reverbEffect.isNotEmpty;
}
