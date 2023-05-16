// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';

/// Configuration for initializing the Live Audio Room.
/// This class is used as the [config] parameter for the constructor of [ZegoUIKitPrebuiltLiveAudioRoom].
class ZegoUIKitPrebuiltLiveAudioRoomConfig {
  /// Default initialization parameters for the host.
  /// If a configuration item does not meet your expectations, you can directly override its value.
  ///
  /// Example:
  ///
  /// ```dart
  /// ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
  /// ..hostSeatIndexes = [0]
  /// ```
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

  /// Default initialization parameters for the audience.
  /// If a configuration item does not meet your expectations, you can directly override its value.
  ///
  /// Example:
  ///
  /// ```dart
  /// ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
  /// ..hostSeatIndexes = [0]
  /// ```
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

  /// Specifies the initial role when joining the live audio room.
  /// The role change after joining is not constrained by this property.
  ZegoLiveAudioRoomRole role = ZegoLiveAudioRoomRole.audience;

  /// Specifies the seat to occupy when joining the live audio room.
  /// This is only valid when the role is set to host or speaker.
  int takeSeatIndexWhenJoining = -1;

  /// Specifies whether to lock the seat automatically after entering the room.
  /// It only takes effect when set by the host
  /// The default value is `true`.
  bool closeSeatsWhenJoining;

  /// Specifies the list of seats occupied by the host.
  /// Once specified, these seats can only be used by the host and cannot be occupied by speakers or audience members.
  /// The default value is `[0]`.
  List<int> hostSeatIndexes;

  /// The default layout of the audio chat room supports free layout with multiple rows and columns of seats.
  /// You can use this parameter to control the specific style of each row and column.
  ZegoLiveAudioRoomLayoutConfig layoutConfig;

  /// Configuration for all seats.
  ZegoLiveAudioRoomSeatConfig seatConfig;

  /// Whether to open the microphone when joining the audio chat room.
  ///
  /// If you want to join the audio chat room with your microphone closed, set this value to false;
  /// if you want to join the audio chat room with your microphone open, set this value to true.
  /// The default value is `true`.
  ///
  /// Note that this parameter is independent of the user's role.
  /// Even if the user is an audience, they can set this value to true, and they can start chatting with others through voice after joining the room.
  /// Therefore, in general, if the role is an audience, this value should be set to false.
  bool turnOnMicrophoneWhenJoining;

  /// Whether to use the speaker to play audio when joining the audio chat room.
  /// The default value is `true`.
  /// If this value is set to `false`, the system's default playback device, such as the earpiece or Bluetooth headset, will be used for audio playback.
  bool useSpeakerWhenJoining;

  /// The background of the audio chat room.
  ///
  /// You can use any Widget as the background of the audio chat room, such as a video, a GIF animation, an image, a web page, etc.
  /// If you need to dynamically change the background content, you will need to implement the logic for dynamic modification within the Widget you return.
  ///
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

  /// Configuration options for the top menu bar (toolbar).
  /// You can use these options to customize the appearance and behavior of the top menu bar.
  ZegoTopMenuBarConfig topMenuBarConfig;

  /// Configuration options for the bottom menu bar (toolbar).
  /// You can use these options to customize the appearance and behavior of the bottom menu bar.
  ZegoBottomMenuBarConfig bottomMenuBarConfig;

  /// Configuration options for the message list.
  ZegoInRoomMessageViewConfig inRoomMessageViewConfig;

  /// Configuration options for modifying all text content on the UI.
  /// All visible text content on the UI can be modified using this single property.
  ZegoInnerText innerText;

  /// You can use this to modify your voice and control reverb.
  ZegoAudioEffectConfig audioEffectConfig;

  /// Set the avatar URL for the current user.
  ///
  /// Note that the default maximum length for avatars is 64 bytes, exceeding this limit may result in the avatar not being displayed.
  /// We recommend using short URLs for setting the avatar URL.
  /// If you have a specific need for using long avatar URLs, please contact [technical support](https://www.zegocloud.com).
  String? userAvatarUrl;

  /// Set the attributes for the current user in the current joined audio room.
  /// [userAvatarUrl] actually uses this attribute and occupies a property with the key "avatar".
  ///
  /// For a single user, the sum of all Key-Value pairs must be within 100 bytes and a maximum of 20 pairs can be configured.
  /// Each Key must be within 8 bytes, Each Value must be within 64 bytes.
  /// If you want to increase the upper limit, please contact [technical support](https://www.zegocloud.com).
  Map<String, String> userInRoomAttributes;

  /// Confirmation dialog information when leaving the audio chat room.
  /// If not set, clicking the exit button will directly exit the audio chat room.
  /// If set, a confirmation dialog will be displayed when clicking the exit button, and you will need to confirm the exit before actually exiting.
  ZegoDialogInfo? confirmDialogInfo;

  /// Confirmation callback method before leaving the audio chat room.
  ///
  /// If you want to perform more complex business logic before exiting the audio chat room, such as updating some records to the backend, you can use the [onLeaveConfirmation] parameter to set it.
  /// This parameter requires you to provide a callback method that returns an asynchronous result.
  /// If you return true in the callback, the prebuilt page will quit and return to your previous page, otherwise it will be ignored.
  Future<bool> Function(BuildContext context)? onLeaveConfirmation;

  /// This callback is triggered after leaving the audio chat room.
  /// You can perform business-related prompts or other actions in this callback.
  VoidCallback? onLeaveLiveAudioRoom;

  /// This callback method is called when someone requests to open your microphone, typically when the host wants to open the speaker's microphone.
  /// This method requires returning an asynchronous result.
  /// You can display a dialog in this callback to confirm whether to open the microphone.
  /// Alternatively, you can return `true` without any processing, indicating that when someone requests to open your microphone, it can be directly opened.
  /// By default, this method does nothing and returns `false`, indicating that others cannot open your microphone.
  Future<bool> Function(BuildContext context)?
      onMicrophoneTurnOnByOthersConfirmation;

  /// This callback method is triggered when the user count or attributes related to these users change.
  void Function(List<ZegoUIKitUser> users)? onUserCountOrPropertyChanged;

  /// Notification that a seat has been closed (locked).
  /// After closing a seat, audience members need to request permission from the host to join the seat, or the host can invite audience members directly.
  VoidCallback? onSeatClosed;

  /// Notification that a seat has been opened (unlocked).
  /// After opening a seat, all audience members can freely choose an empty seat to join and start chatting with others.
  VoidCallback? onSeatsOpened;

  /// A callback function that is called when a seat is clicked.
  ///
  /// The [index] parameter is the index of the seat that was clicked.
  /// The [user] parameter is the user who is currently sitting in the seat, or `null` if the seat is empty.
  ///
  /// Note that when you set this callback, the **default behavior** of clicking on a seat to display a menu **will be disabled**.
  /// You need to handle it yourself.
  /// You can refer to the usage of [ZegoLiveAudioRoomController] for reference.
  void Function(int index, ZegoUIKitUser? user)? onSeatClicked;

  /// A callback function that is called when someone gets on/off/switches seat
  ///
  /// The [takenSeats] parameter is a map that maps the index of each taken seat to the user who is currently sitting in that seat.
  /// The [untakenSeats] parameter is a list of the indexes of all untaken seats.
  void Function(
    Map<int, ZegoUIKitUser> takenSeats,
    List<int> untakenSeats,
  )? onSeatsChanged;

  /// The host has received a seat request from an `audience`.
  void Function(ZegoUIKitUser audience)? onSeatTakingRequested;

  /// The host has received a notification that the `audience` has canceled the seat request.
  void Function(ZegoUIKitUser audience)? onSeatTakingRequestCanceled;

  /// The host has received a notification that the invitation for the audience to take a seat has failed.
  /// This is usually due to network issues or if the audience has already logged out of the app and can no longer receive the invitation.
  VoidCallback? onInviteAudienceToTakeSeatFailed;

  /// The host has received a notification that the invitation for the audience to take a seat has been rejected.
  VoidCallback? onSeatTakingInviteRejected;

  /// The audience has received a notification that the application to take a seat has failed.
  /// This is usually due to network issues or the host has logged out of the app and can no longer receive seat applications.
  VoidCallback? onSeatTakingRequestFailed;

  /// The audience received a notification that their request to take seats was declined by the host.
  VoidCallback? onSeatTakingRequestRejected;

  /// The audience has received a notification that the host has invited them to take a seat.
  VoidCallback? onHostSeatTakingInviteSent;

  /// Callback method when the "More" button on the row corresponding to `user` in the member list is pressed.
  /// If you want to perform additional operations when the "More" button on the member list is clicked, such as viewing the profile of `user`.
  ///
  /// Note that when you set this callback, the **default behavior** of popping up a menu when clicking the "More" button on the member list will be **overridden**, and you need to handle it yourself.
  /// You can refer to the usage of `ZegoLiveAudioRoomController`.
  void Function(ZegoUIKitUser user)? onMemberListMoreButtonPressed;
}

/// Configuration options for controlling seat behavior and style.
/// This type is used for the [seatConfig] property in [ZegoUIKitPrebuiltLiveAudioRoomConfig].
class ZegoLiveAudioRoomSeatConfig {
  /// Whether to display a wave indicator around the avatar.
  bool showSoundWaveInAudioMode = true;

  /// The icon displayed for empty seats when all seats are open (seats in the audio chat room are not locked).
  Image? openIcon;

  /// The icon displayed for empty seats when all seats are closed (seats in the audio chat room are locked).
  Image? closeIcon;

  /// Use this to customize the foreground view of the seat, and the `ZegoUIKitPrebuiltLiveAudioRoom` will returns the current user on the seat and the corresponding seat index.
  ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;

  /// Use this to customize the background view of the seat, and the `ZegoUIKitPrebuiltLiveAudioRoom` returns the current user on the seat and the corresponding seat index.
  ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  /// Use this to customize the avatar, and replace the default avatar with it.
  ///
  /// Example：
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

/// Configuration options for the top menu bar (toolbar).
class ZegoTopMenuBarConfig {
  /// These buttons will displayed on the menu bar, order by the list
  List<ZegoMenuBarButtonName> buttons;

  ZegoTopMenuBarConfig({
    this.buttons = const [],
  });
}

/// Configuration options for the bottom menu bar (toolbar).
/// You can set the properties of this class through the [ZegoUIKitPrebuiltLiveAudioRoomConfig].[bottomMenuBarConfig] attribute.
class ZegoBottomMenuBarConfig {
  /// When set to `true`, the button for sending messages will be displayed.
  /// If you want to disable text messaging in the live audio room, set it to `false`.
  bool showInRoomMessageButton;

  /// The list of predefined buttons to be displayed when the user role is set to host.
  List<ZegoMenuBarButtonName> hostButtons = [];

  /// The list of predefined buttons to be displayed when the user role is set to speaker.
  List<ZegoMenuBarButtonName> speakerButtons = [];

  /// The list of predefined buttons to be displayed when the user role is set to audience.
  List<ZegoMenuBarButtonName> audienceButtons = [];

  /// The list of custom buttons to be displayed when the user role is set to host.
  List<Widget> hostExtendButtons = [];

  /// The list of custom buttons to be displayed when the user role is set to speaker.
  List<Widget> speakerExtendButtons = [];

  /// The list of custom buttons to be displayed when the user role is set to audience.
  List<Widget> audienceExtendButtons = [];

  /// Controls the maximum number of buttons (including predefined and custom buttons) to be displayed in the menu bar (toolbar).
  /// When the number of buttons exceeds the `maxCount` limit, a "More" button will appear.
  /// Clicking on it will display a panel showing other buttons that cannot be displayed in the menu bar (toolbar).
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

/// Control options for the bottom-left message list.
/// This class is used for the [inRoomMessageViewConfig] property of [ZegoUIKitPrebuiltLiveAudioRoomConfig].
///
/// If you want to customize chat messages, you can specify the [itemBuilder] in [ZegoInRoomMessageViewConfig].
///
/// Example:
///
/// ZegoInRoomMessageViewConfig(
///   itemBuilder: (BuildContext context, ZegoRoomMessage message) {
///     return ListTile(
///       title: Text(message.message),
///       subtitle: Text(message.user.id),
///     );
///   },
/// );
class ZegoInRoomMessageViewConfig {
  /// If set to `false`, the message list will be hidden. The default value is `true`.
  bool visible;

  /// Use this to customize the style and content of each chat message list item.
  /// For example, you can modify the background color, opacity, border radius, or add additional information like the sender's level or role.
  ZegoInRoomMessageItemBuilder? itemBuilder;

  ZegoInRoomMessageViewConfig({
    this.visible = true,
    this.itemBuilder,
  });
}

/// Configuration options for voice changer and reverberation effects.
/// This class is used for the [audioEffectConfig] property in [ZegoUIKitPrebuiltLiveAudioRoomConfig].
class ZegoAudioEffectConfig {
  /// List of voice changer effects.
  /// If you don't want a certain effect, simply remove it from the list.
  List<VoiceChangerType> voiceChangeEffect;

  /// List of reverb effects.
  /// If you don't want a certain effect, simply remove it from the list.
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

  /// @nodoc
  ZegoAudioEffectConfig.none({
    this.voiceChangeEffect = const [],
    this.reverbEffect = const [],
  });

  /// @nodoc
  bool get isSupportVoiceChange => voiceChangeEffect.isNotEmpty;

  /// @nodoc
  bool get isSupportReverb => reverbEffect.isNotEmpty;
}
