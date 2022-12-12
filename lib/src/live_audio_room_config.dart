// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'components/audio_video/defines.dart';
import 'live_audio_room_defines.dart';
import 'live_audio_room_translation.dart';

class ZegoUIKitPrebuiltLiveAudioRoomConfig {
  ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
      : role = ZegoLiveAudioRoomRole.host,
        takeSeatIndexWhenJoining = 0,
        turnOnMicrophoneWhenJoining = true,
        useSpeakerWhenJoining = true,
        seatConfig = ZegoLiveAudioRoomSeatConfig(),
        layoutConfig = ZegoLiveAudioRoomLayoutConfig(),
        hostSeatIndexes = const [0],
        bottomMenuBarConfig = ZegoBottomMenuBarConfig(),
        inRoomMessageViewConfig = ZegoInRoomMessageViewConfig(),
        audioEffectConfig = ZegoAudioEffectConfig(),
        translationText = ZegoTranslationText(),
        confirmDialogInfo = ZegoDialogInfo(
          title: "Leave the room",
          message: "Are you sure to leave the room?",
          cancelButtonName: "Cancel",
          confirmButtonName: "OK",
        );

  ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
      : role = ZegoLiveAudioRoomRole.audience,
        turnOnMicrophoneWhenJoining = false,
        useSpeakerWhenJoining = true,
        seatConfig = ZegoLiveAudioRoomSeatConfig(),
        layoutConfig = ZegoLiveAudioRoomLayoutConfig(),
        hostSeatIndexes = const [0],
        bottomMenuBarConfig = ZegoBottomMenuBarConfig(),
        inRoomMessageViewConfig = ZegoInRoomMessageViewConfig(),
        audioEffectConfig = ZegoAudioEffectConfig(),
        translationText = ZegoTranslationText();

  ZegoUIKitPrebuiltLiveAudioRoomConfig({
    this.turnOnMicrophoneWhenJoining = true,
    this.useSpeakerWhenJoining = true,
    ZegoLiveAudioRoomSeatConfig? seatConfig,
    ZegoBottomMenuBarConfig? bottomMenuBarConfig,
    ZegoLiveAudioRoomLayoutConfig? layoutConfig,
    ZegoInRoomMessageViewConfig? messageConfig,
    ZegoAudioEffectConfig? effectConfig,
    this.hostSeatIndexes = const [0],
    this.confirmDialogInfo,
    this.onLeaveConfirmation,
    this.onLeaveLiveAudioRoom,
    ZegoTranslationText? translationText,
  })  : seatConfig = seatConfig ?? ZegoLiveAudioRoomSeatConfig(),
        bottomMenuBarConfig = bottomMenuBarConfig ?? ZegoBottomMenuBarConfig(),
        layoutConfig = layoutConfig ?? ZegoLiveAudioRoomLayoutConfig(),
        inRoomMessageViewConfig =
            messageConfig ?? ZegoInRoomMessageViewConfig(),
        audioEffectConfig = effectConfig ?? ZegoAudioEffectConfig(),
        translationText = translationText ?? ZegoTranslationText();

  /// specify if a host or audience, speaker
  ZegoLiveAudioRoomRole role = ZegoLiveAudioRoomRole.audience;

  /// specify seat index, only work if host or speaker
  int takeSeatIndexWhenJoining = -1;

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

  /// configs about bottom menu bar
  ZegoBottomMenuBarConfig bottomMenuBarConfig;

  /// alert dialog information of leave
  /// if confirm info is not null, APP will pop alert dialog when you hang up
  ZegoDialogInfo? confirmDialogInfo;

  /// It is often used to customize the process before exiting the live interface.
  /// The liveback will triggered when user click hang up button or use system's return,
  /// If you need to handle custom logic, you can set this liveback to handle (such as showAlertDialog to let user determine).
  /// if you return true in the liveback, prebuilt page will quit and return to your previous page, otherwise will ignore.
  Future<bool> Function(BuildContext context)? onLeaveConfirmation;

  /// customize handling after leave audio room
  VoidCallback? onLeaveLiveAudioRoom;

  /// configs about message view
  ZegoInRoomMessageViewConfig inRoomMessageViewConfig;

  ZegoTranslationText translationText;

  /// support :
  /// 1. Voice changing
  /// 2. Reverb
  ZegoAudioEffectConfig audioEffectConfig;
}

class ZegoLiveAudioRoomSeatConfig {
  bool showSoundWaveInAudioMode = true;

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
    this.showSoundWaveInAudioMode = true,
    this.avatarBuilder,
    this.foregroundBuilder,
    this.backgroundBuilder,
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
    ],
    this.speakerButtons = const [
      ZegoMenuBarButtonName.soundEffectButton,
      ZegoMenuBarButtonName.toggleMicrophoneButton,
      ZegoMenuBarButtonName.showMemberListButton,
    ],
    this.audienceButtons = const [
      ZegoMenuBarButtonName.showMemberListButton,
    ],
    this.hostExtendButtons = const [],
    this.speakerExtendButtons = const [],
    this.audienceExtendButtons = const [],
    this.maxCount = 5,
  });
}

class ZegoInRoomMessageViewConfig {
  /// customize your item view of message list
  ZegoInRoomMessageItemBuilder? itemBuilder;

  ZegoInRoomMessageViewConfig({
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
