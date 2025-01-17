// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';

/// Configuration for initializing the Live Audio Room.
/// This class is used as the [config] parameter for the constructor of [ZegoUIKitPrebuiltLiveAudioRoom].
class ZegoUIKitPrebuiltLiveAudioRoomConfig {
  /// Configuration for all seats.
  ZegoLiveAudioRoomSeatConfig seat;

  /// Configuration options for the top menu bar (toolbar).
  /// You can use these options to customize the appearance and behavior of the top menu bar.
  ZegoLiveAudioRoomTopMenuBarConfig topMenuBar;

  /// Configuration options for the bottom menu bar (toolbar).
  /// You can use these options to customize the appearance and behavior of the bottom menu bar.
  ZegoLiveAudioRoomBottomMenuBarConfig bottomMenuBar;

  /// Configuration options for the message list.
  ZegoLiveAudioRoomInRoomMessageConfig inRoomMessage;

  /// You can use this to modify your voice and control reverb.
  ZegoLiveAudioRoomAudioEffectConfig audioEffect;

  /// Live audio room timing configuration.
  ZegoLiveAudioRoomLiveDurationConfig duration;

  ZegoLiveAudioRoomPIPConfig pip;

  /// the config of media player
  ZegoLiveAudioRoomMediaPlayerConfig mediaPlayer;

  /// the config of background music, the feature currently only works for the host
  ZegoLiveAudioRoomBackgroundMediaConfig backgroundMedia;

  /// Configuration related to the bottom member list, including displaying the member list, member list styles, and more.
  ZegoLiveAudioRoomMemberListConfig memberList;

  ///  config of menus
  ZegoLiveAudioRoomPopUpMenuConfig popUpMenu;

  ZegoLiveAudioRoomSignalingPluginConfig signalingPlugin;

  /// Specifies the initial role when joining the live audio room.
  /// The role change after joining is not constrained by this property.
  ZegoLiveAudioRoomRole role = ZegoLiveAudioRoomRole.audience;

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

  /// The foreground of the live audio room.
  ///
  /// If you need to nest some widgets in [ZegoUIKitPrebuiltLiveAudioRoom], please use [foreground] nesting, otherwise these widgets will be lost when you minimize and restore the [ZegoUIKitPrebuiltLiveAudioRoom]
  Widget? foreground;

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

  /// Configuration options for modifying all text content on the UI.
  /// All visible text content on the UI can be modified using this single property.
  ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText;

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
  ZegoLiveAudioRoomDialogInfo? confirmDialogInfo;

  /// same as Flutter's Navigator's param
  /// If `rootNavigator` is set to true, the state from the furthest instance of
  /// this class is given instead. Useful for pushing contents above all
  /// subsequent instances of [Navigator].
  bool rootNavigator;

  /// Set advanced engine configuration, Used to enable advanced functions.
  /// For details, please consult ZEGO technical support.
  Map<String, String> advanceConfigs;

  /// The blank space between seat and bottomBar, which can be used to place custom widgets freely.
  Widget Function(BuildContext context)? emptyAreaBuilder;

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
        turnOnMicrophoneWhenJoining = true,
        useSpeakerWhenJoining = true,
        rootNavigator = false,
        userInRoomAttributes = const {},
        advanceConfigs = const {},
        seat = ZegoLiveAudioRoomSeatConfig(
          layout: ZegoLiveAudioRoomLayoutConfig(),
          takeIndexWhenJoining: 0,
          closeWhenJoining: true,
          hostIndexes: const [0],
        ),
        topMenuBar = ZegoLiveAudioRoomTopMenuBarConfig(),
        bottomMenuBar = ZegoLiveAudioRoomBottomMenuBarConfig(),
        inRoomMessage = ZegoLiveAudioRoomInRoomMessageConfig(),
        popUpMenu = ZegoLiveAudioRoomPopUpMenuConfig(),
        signalingPlugin = ZegoLiveAudioRoomSignalingPluginConfig(),
        memberList = ZegoLiveAudioRoomMemberListConfig(),
        audioEffect = ZegoLiveAudioRoomAudioEffectConfig(),
        duration = ZegoLiveAudioRoomLiveDurationConfig(),
        pip = ZegoLiveAudioRoomPIPConfig(),
        mediaPlayer = ZegoLiveAudioRoomMediaPlayerConfig(),
        backgroundMedia = ZegoLiveAudioRoomBackgroundMediaConfig(),
        innerText = ZegoUIKitPrebuiltLiveAudioRoomInnerText(),
        confirmDialogInfo = ZegoLiveAudioRoomDialogInfo(
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
        useSpeakerWhenJoining = true,
        rootNavigator = false,
        userInRoomAttributes = const {},
        advanceConfigs = const {},
        seat = ZegoLiveAudioRoomSeatConfig(
          layout: ZegoLiveAudioRoomLayoutConfig(),
          closeWhenJoining: false,
          hostIndexes: const [0],
        ),
        topMenuBar = ZegoLiveAudioRoomTopMenuBarConfig(),
        bottomMenuBar = ZegoLiveAudioRoomBottomMenuBarConfig(),
        inRoomMessage = ZegoLiveAudioRoomInRoomMessageConfig(),
        popUpMenu = ZegoLiveAudioRoomPopUpMenuConfig(),
        signalingPlugin = ZegoLiveAudioRoomSignalingPluginConfig(),
        memberList = ZegoLiveAudioRoomMemberListConfig(),
        audioEffect = ZegoLiveAudioRoomAudioEffectConfig(),
        duration = ZegoLiveAudioRoomLiveDurationConfig(),
        pip = ZegoLiveAudioRoomPIPConfig(),
        mediaPlayer = ZegoLiveAudioRoomMediaPlayerConfig(),
        backgroundMedia = ZegoLiveAudioRoomBackgroundMediaConfig(),
        innerText = ZegoUIKitPrebuiltLiveAudioRoomInnerText();

  ZegoUIKitPrebuiltLiveAudioRoomConfig({
    this.turnOnMicrophoneWhenJoining = true,
    this.useSpeakerWhenJoining = true,
    this.confirmDialogInfo,
    this.rootNavigator = false,
    this.foreground,
    this.background,
    this.userAvatarUrl,
    this.userInRoomAttributes = const {},
    this.advanceConfigs = const {},
    ZegoUIKitPrebuiltLiveAudioRoomInnerText? translationText,
    ZegoLiveAudioRoomSeatConfig? seat,
    ZegoLiveAudioRoomTopMenuBarConfig? topMenuBar,
    ZegoLiveAudioRoomBottomMenuBarConfig? bottomMenuBar,
    ZegoLiveAudioRoomLayoutConfig? layout,
    ZegoLiveAudioRoomInRoomMessageConfig? message,
    ZegoLiveAudioRoomPopUpMenuConfig? popUpMenu,
    ZegoLiveAudioRoomSignalingPluginConfig? signalingPlugin,
    ZegoLiveAudioRoomMemberListConfig? memberList,
    ZegoLiveAudioRoomAudioEffectConfig? effect,
    ZegoLiveAudioRoomLiveDurationConfig? duration,
    ZegoLiveAudioRoomPIPConfig? pip,
    ZegoLiveAudioRoomMediaPlayerConfig? mediaPlayer,
    ZegoLiveAudioRoomBackgroundMediaConfig? backgroundMedia,
  })  : seat = seat ??
            ZegoLiveAudioRoomSeatConfig(
              layout: ZegoLiveAudioRoomLayoutConfig(),
              closeWhenJoining: true,
              hostIndexes: const [0],
            ),
        topMenuBar = topMenuBar ?? ZegoLiveAudioRoomTopMenuBarConfig(),
        bottomMenuBar = bottomMenuBar ?? ZegoLiveAudioRoomBottomMenuBarConfig(),
        inRoomMessage = message ?? ZegoLiveAudioRoomInRoomMessageConfig(),
        memberList = memberList ?? ZegoLiveAudioRoomMemberListConfig(),
        popUpMenu = popUpMenu ?? ZegoLiveAudioRoomPopUpMenuConfig(),
        signalingPlugin =
            signalingPlugin ?? ZegoLiveAudioRoomSignalingPluginConfig(),
        audioEffect = effect ?? ZegoLiveAudioRoomAudioEffectConfig(),
        duration = duration ?? ZegoLiveAudioRoomLiveDurationConfig(),
        pip = pip ?? ZegoLiveAudioRoomPIPConfig(),
        mediaPlayer = mediaPlayer ?? ZegoLiveAudioRoomMediaPlayerConfig(),
        backgroundMedia =
            backgroundMedia ?? ZegoLiveAudioRoomBackgroundMediaConfig(),
        innerText =
            translationText ?? ZegoUIKitPrebuiltLiveAudioRoomInnerText();

  @override
  String toString() {
    return 'ZegoUIKitPrebuiltLiveAudioRoomConfig:{'
        'seat:$seat, '
        'topMenuBar:$topMenuBar, '
        'bottomMenuBar:$bottomMenuBar, '
        'inRoomMessage:$inRoomMessage, '
        'audioEffect:$audioEffect, '
        'duration:$duration, '
        'pip:$pip, '
        'mediaPlayer:$mediaPlayer, '
        'backgroundMedia:$backgroundMedia, '
        'memberList:$memberList, '
        'popUpMenu:$popUpMenu, '
        'signalingPlugin:$signalingPlugin, '
        'role:$role, '
        'turnOnMicrophoneWhenJoining:$turnOnMicrophoneWhenJoining, '
        'useSpeakerWhenJoining:$useSpeakerWhenJoining, '
        'foreground:$foreground, '
        'background:$background, '
        'innerText:$innerText, '
        'userAvatarUrl:$userAvatarUrl, '
        'userInRoomAttributes:$userInRoomAttributes, '
        'confirmDialogInfo:$confirmDialogInfo, '
        'rootNavigator:$rootNavigator, '
        'advanceConfigs:$advanceConfigs, '
        'emptyAreaBuilder:$emptyAreaBuilder, '
        '}';
  }
}

/// Configuration options for controlling seat behavior and style.
/// This type is used for the [seat] property in [ZegoUIKitPrebuiltLiveAudioRoomConfig].
class ZegoLiveAudioRoomSeatConfig {
  /// The default layout of the audio chat room supports free layout with multiple rows and columns of seats.
  /// You can use this parameter to control the specific style of each row and column.
  ZegoLiveAudioRoomLayoutConfig layout;

  /// the topLeft point of seat
  Point<double>? topLeft;

  /// Specifies the seat to occupy when joining the live audio room.
  /// This is only valid when the role is set to host or speaker.
  int takeIndexWhenJoining;

  /// By default, the speaker will auto switch seat when click the seat that
  /// can be take on(the room is not locked the seats, and the seat is empty)
  ///
  /// If you don't want to switch automatically, return false.
  bool Function(int seatIndex)? canAutoSwitchOnClicked;

  /// When the audience take on seat, do you want specify a seat? If so,
  /// return to the seat you want to specify
  int Function(ZegoUIKitUser user)? takeIndexWhenAudienceRequesting;

  /// Specifies whether to lock the seat automatically after entering the room.
  /// It only takes effect when set by the host
  /// The default value is `true`.
  bool closeWhenJoining;

  /// Specifies the list of seats occupied by the host.
  /// Once specified, these seats can only be used by the host and cannot be occupied by speakers or audience members.
  /// The default value is `[0]`.
  List<int> hostIndexes;

  /// Whether to display a wave indicator around the avatar.
  bool showSoundWaveInAudioMode;

  ///  sound wave color
  Color? soundWaveColor;

  /// The icon displayed for empty seats when all seats are open (seats in the audio chat room are not locked).
  Image? openIcon;

  /// The icon displayed for empty seats when all seats are closed (seats in the audio chat room are locked).
  Image? closeIcon;

  /// icon for host
  Image? hostRoleIcon;

  /// icon for co-host
  Image? coHostRoleIcon;

  /// icon when speaker's microphone off
  Image? microphoneOffIcon;

  /// Whether to retain the original foreground
  bool keepOriginalForeground;

  /// Use this to customize the foreground view of the seat, and the `ZegoUIKitPrebuiltLiveAudioRoom` will returns the current user on the seat and the corresponding seat index.
  ///
  /// Please note that this will overwrite the original foreground(user name, host flag, co-host flag, mic-off flag).
  /// If you want to keep the original foreground, please set [keepOriginalForeground] be true.
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
    ZegoLiveAudioRoomLayoutConfig? layout,
    this.topLeft,
    this.takeIndexWhenJoining = -1,
    this.canAutoSwitchOnClicked,
    this.takeIndexWhenAudienceRequesting,
    this.closeWhenJoining = true,
    this.hostIndexes = const [0],
    this.openIcon,
    this.closeIcon,
    this.showSoundWaveInAudioMode = true,
    this.soundWaveColor,
    this.avatarBuilder,
    this.keepOriginalForeground = false,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.hostRoleIcon,
    this.coHostRoleIcon,
    this.microphoneOffIcon,
  }) : layout = layout ?? ZegoLiveAudioRoomLayoutConfig();

  @override
  String toString() {
    return 'ZegoLiveAudioRoomSeatConfig:{'
        'layout:$layout, '
        'takeIndexWhenJoining:$takeIndexWhenJoining, '
        'canSwitchOnEmptySeatClicked:$canAutoSwitchOnClicked, '
        'takeIndexWhenAudienceRequesting:$takeIndexWhenAudienceRequesting, '
        'closeWhenJoining:$closeWhenJoining, '
        'hostIndexes:$hostIndexes, '
        'openIcon:$openIcon, '
        'closeIcon:$closeIcon, '
        'showSoundWaveInAudioMode:$showSoundWaveInAudioMode, '
        'avatarBuilder:$avatarBuilder, '
        'keepOriginalForeground:$keepOriginalForeground, '
        'foregroundBuilder:$foregroundBuilder, '
        'backgroundBuilder:$backgroundBuilder, '
        'hostRoleIcon:$hostRoleIcon, '
        'coHostRoleIcon:$coHostRoleIcon, '
        'microphoneOffIcon:$microphoneOffIcon, '
        '}';
  }
}

/// Configuration options for the top menu bar (toolbar).
class ZegoLiveAudioRoomTopMenuBarConfig {
  /// These buttons will displayed on the menu bar, order by the list
  /// only support: showMemberListButton/leaveButton/minimizingButton/pipButton
  List<ZegoLiveAudioRoomMenuBarButtonName> buttons;

  ZegoLiveAudioRoomTopMenuBarConfig({
    this.buttons = const [
      ZegoLiveAudioRoomMenuBarButtonName.minimizingButton,
      ZegoLiveAudioRoomMenuBarButtonName.leaveButton,
    ],
  });

  @override
  String toString() {
    return 'ZegoLiveAudioRoomTopMenuBarConfig:{'
        'buttons:$buttons, '
        '}';
  }
}

/// Configuration options for the bottom menu bar (toolbar).
/// You can set the properties of this class through the [ZegoUIKitPrebuiltLiveAudioRoomConfig.bottomMenuBar] attribute.
class ZegoLiveAudioRoomBottomMenuBarConfig {
  /// If set to `false`, the bottom bar will be hidden. The default value is `true`.
  bool visible;

  /// When set to `true`, the button for sending messages will be displayed.
  /// If you want to disable text messaging in the live audio room, set it to `false`.
  bool showInRoomMessageButton;

  /// Controls the maximum number of buttons (including predefined and custom buttons) to be displayed in the menu bar (toolbar).
  /// When the number of buttons exceeds the `maxCount` limit, a "More" button will appear.
  /// Clicking on it will display a panel showing other buttons that cannot be displayed in the menu bar (toolbar).
  int maxCount;

  /// The list of predefined buttons to be displayed when the user role is set to host.
  List<ZegoLiveAudioRoomMenuBarButtonName> hostButtons = [];

  /// The list of predefined buttons to be displayed when the user role is set to speaker.
  List<ZegoLiveAudioRoomMenuBarButtonName> speakerButtons = [];

  /// The list of predefined buttons to be displayed when the user role is set to audience.
  List<ZegoLiveAudioRoomMenuBarButtonName> audienceButtons = [];

  /// The list of custom buttons to be displayed when the user role is set to host.
  List<Widget> hostExtendButtons = [];

  /// The list of custom buttons to be displayed when the user role is set to speaker.
  List<Widget> speakerExtendButtons = [];

  /// The list of custom buttons to be displayed when the user role is set to audience.
  List<Widget> audienceExtendButtons = [];

  ZegoLiveAudioRoomBottomMenuBarConfig({
    this.visible = true,
    this.showInRoomMessageButton = true,
    this.hostButtons = const [
      ZegoLiveAudioRoomMenuBarButtonName.soundEffectButton,
      ZegoLiveAudioRoomMenuBarButtonName.toggleMicrophoneButton,
      ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton,
      ZegoLiveAudioRoomMenuBarButtonName.closeSeatButton,
    ],
    this.speakerButtons = const [
      ZegoLiveAudioRoomMenuBarButtonName.soundEffectButton,
      ZegoLiveAudioRoomMenuBarButtonName.toggleMicrophoneButton,
      ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton,
    ],
    this.audienceButtons = const [
      ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton,
      ZegoLiveAudioRoomMenuBarButtonName.applyToTakeSeatButton,
    ],
    this.hostExtendButtons = const [],
    this.speakerExtendButtons = const [],
    this.audienceExtendButtons = const [],
    this.maxCount = 5,
  });

  @override
  String toString() {
    return 'ZegoLiveAudioRoomBottomMenuBarConfig:{'
        'visible:$visible, '
        'showInRoomMessageButton:$showInRoomMessageButton, '
        'maxCount:$maxCount, '
        'hostButtons:$hostButtons, '
        'speakerButtons:$speakerButtons, '
        'audienceButtons:$audienceButtons, '
        'hostExtendButtons:$hostExtendButtons, '
        'speakerExtendButtons:$speakerExtendButtons, '
        'audienceExtendButtons:$audienceExtendButtons, '
        '}';
  }
}

/// Control options for the bottom-left message list.
/// This class is used for the [ZegoUIKitPrebuiltLiveAudioRoomConfig.inRoomMessage].
///
/// If you want to customize chat messages, you can specify the [ZegoLiveAudioRoomInRoomMessageConfig.itemBuilder].
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
class ZegoLiveAudioRoomInRoomMessageConfig {
  /// Use this to customize the style and content of each chat message list item.
  /// For example, you can modify the background color, opacity, border radius, or add additional information like the sender's level or role.
  ZegoInRoomMessageItemBuilder? itemBuilder;

  /// background
  Widget? background;

  /// If set to `false`, the message list will be hidden. The default value is `true`.
  bool visible;

  /// The width of chat message list view
  double? width;

  /// The height of chat message list view
  double? height;

  /// The offset of chat message list view bottom-left position
  Offset? bottomLeft;

  /// display user name in message list view or not
  bool showName;

  /// display user avatar in message list view or not
  bool showAvatar;

  /// The opacity of the background color for chat message list items, default value of 0.5.
  /// If you set the [backgroundColor], the [opacity] setting will be overridden.
  double opacity;

  /// The background of chat message list items
  /// If you set the [backgroundColor], the [opacity] setting will be overridden.
  /// You can use `backgroundColor.withOpacity(0.5)` to set the opacity of the background color.
  Color? backgroundColor;

  /// The max lines of chat message list items, default value is not limit.
  int? maxLines;

  /// The name text style of chat message list items
  TextStyle? nameTextStyle;

  /// The message text style of chat message list items
  TextStyle? messageTextStyle;

  /// The border radius of chat message list items
  BorderRadiusGeometry? borderRadius;

  /// The paddings of chat message list items
  EdgeInsetsGeometry? paddings;

  /// resend button icon
  Widget? resendIcon;

  ZegoLiveAudioRoomInRoomMessageConfig({
    this.visible = true,
    this.width,
    this.height,
    this.bottomLeft,
    this.opacity = 0.5,
    this.maxLines,
    this.nameTextStyle,
    this.messageTextStyle,
    this.backgroundColor,
    this.borderRadius,
    this.paddings,
    this.resendIcon,
    this.background,
    this.itemBuilder,
    this.showName = true,
    this.showAvatar = true,
  });

  @override
  String toString() {
    return 'ZegoLiveAudioRoomInRoomMessageConfig:{'
        'visible:$visible, '
        'width:$width, '
        'height:$height, '
        'bottomLeft:$bottomLeft, '
        'opacity:$opacity, '
        'maxLines:$maxLines, '
        'nameTextStyle:$nameTextStyle, '
        'messageTextStyle:$messageTextStyle, '
        'backgroundColor:$backgroundColor, '
        'borderRadius:$borderRadius, '
        'paddings:$paddings, '
        'resendIcon:$resendIcon, '
        'background:$background, '
        'itemBuilder:$itemBuilder, '
        'showName:$showName, '
        'showAvatar:$showAvatar, '
        '}';
  }
}

/// Configuration for the member list.
///
/// You can use the [ZegoUIKitPrebuiltLiveAudioRoomConfig.memberList] property to set the properties inside this class.
///
/// If you want to use a custom member list item view, you can set the [ZegoLiveAudioRoomMemberListConfig.itemBuilder] property, and pass your custom view's builder function to it.
///
/// In addition, you can listen for item click events through [onClicked].
class ZegoLiveAudioRoomMemberListConfig {
  /// Custom member list item view.
  ///
  /// For example, suppose you have implemented a `CustomMemberListItem` component that can render a member list item view based on the user information. You can set it up like this:
  ///
  ///```dart
  /// ZegoLiveAudioRoomMemberListConfig(
  ///   itemBuilder: (BuildContext context, Size size, ZegoUIKitUser user, Map<String, dynamic> extraInfo) {
  ///     return CustomMemberListItem(user: user);
  ///   },
  /// );
  ///```
  ///
  /// In this example, we pass the builder function of the custom view, `CustomMemberListItem`, to the [itemBuilder] property so that the member list item will be rendered using the custom component.
  ZegoMemberListItemBuilder? itemBuilder;

  ZegoLiveAudioRoomMemberListConfig({
    this.itemBuilder,
  });

  @override
  String toString() {
    return 'ZegoLiveAudioRoomMemberListConfig:{'
        'itemBuilder:$itemBuilder, '
        '}';
  }
}

/// pop up menu config
class ZegoLiveAudioRoomPopUpMenuConfig {
  /// pop up menu when on seat clicked
  ZegoLiveAudioRoomPopUpSeatClickedMenuConfig seatClicked;

  ZegoLiveAudioRoomPopUpMenuConfig(
      {ZegoLiveAudioRoomPopUpSeatClickedMenuConfig? seatClicked})
      : seatClicked =
            seatClicked ?? ZegoLiveAudioRoomPopUpSeatClickedMenuConfig();

  @override
  String toString() {
    return 'ZegoLiveAudioRoomPopUpMenuConfig:{'
        'seatClicked:$seatClicked, '
        '}';
  }
}

/// pop up menu when on seat clicked
class ZegoLiveAudioRoomPopUpSeatClickedMenuConfig {
  /// If you don't want some system menus (except cancel, customStartIndex)
  /// to appear, specify to hide them here
  List<ZegoLiveAudioRoomPopupItemValue> hiddenMenus = [];

  /// The custom menus to be displayed when the seat's user is host.
  List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo> hostExtendMenus;

  /// The custom menus to be displayed when the seat's user is co-host.
  List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo> coHostExtendMenus;

  /// The custom menus to be displayed when the seat's user is speaker.
  List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo> speakerExtendMenus;

  /// The custom menus to be displayed when the seat's user is audience.
  List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo> audienceExtendMenus;

  /// The custom menus to be displayed when seat is empty.
  List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo> emptyExtendMenus;

  ZegoLiveAudioRoomPopUpSeatClickedMenuConfig({
    this.hiddenMenus = const [],
    this.hostExtendMenus = const [],
    this.coHostExtendMenus = const [],
    this.speakerExtendMenus = const [],
    this.audienceExtendMenus = const [],
    this.emptyExtendMenus = const [],
  });

  @override
  String toString() {
    return 'ZegoLiveAudioRoomPopUpSeatClickedMenuConfig:{'
        'hiddenMenus:$hiddenMenus, '
        'hostExtendMenus:$hostExtendMenus, '
        'coHostExtendMenus:$coHostExtendMenus, '
        'speakerExtendMenus:$speakerExtendMenus, '
        'audienceExtendMenus:$audienceExtendMenus, '
        'emptyExtendMenus:$emptyExtendMenus, '
        '}';
  }
}

/// Configuration options for voice changer and reverberation effects.
/// This class is used for the [audioEffect] property in [ZegoUIKitPrebuiltLiveAudioRoomConfig].
class ZegoLiveAudioRoomAudioEffectConfig {
  /// List of voice changer effects.
  /// If you don't want a certain effect, simply remove it from the list.
  List<VoiceChangerType> voiceChangeEffect;

  /// List of reverb effects.
  /// If you don't want a certain effect, simply remove it from the list.
  List<ReverbType> reverbEffect;

  ZegoLiveAudioRoomAudioEffectConfig({
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

  ZegoLiveAudioRoomAudioEffectConfig.none({
    this.voiceChangeEffect = const [],
    this.reverbEffect = const [],
  });

  bool get isSupportVoiceChange => voiceChangeEffect.isNotEmpty;

  bool get isSupportReverb => reverbEffect.isNotEmpty;

  @override
  String toString() {
    return 'ZegoLiveAudioRoomAudioEffectConfig:{'
        'voiceChangeEffect:$voiceChangeEffect, '
        'reverbEffect:$reverbEffect, '
        '}';
  }
}

/// Live Audio Room timing configuration.
class ZegoLiveAudioRoomLiveDurationConfig {
  /// Whether to display Live Audio Room timing.
  bool isVisible;

  ZegoLiveAudioRoomLiveDurationConfig({
    this.isVisible = true,
  });
  @override
  String toString() {
    return 'ZegoLiveAudioRoomLiveDurationConfig:{'
        'isVisible:$isVisible, '
        '}';
  }
}

/// Live Audio Room background media configuration.
class ZegoLiveAudioRoomBackgroundMediaConfig {
  /// the path of background music, which can be either a local path or a network address.
  /// supported formats by default include MP3, MP4, FLV, WAV, AAC, M3U8, and FLAC.
  String? path;

  /// whether to repeat playback.
  bool enableRepeat;

  ZegoLiveAudioRoomBackgroundMediaConfig({
    this.path,
    this.enableRepeat = true,
  });
  @override
  String toString() {
    return 'ZegoLiveAudioRoomBackgroundMediaConfig:{'
        'path:$path, '
        'enableRepeat:$enableRepeat, '
        '}';
  }
}

/// media player config
class ZegoLiveAudioRoomMediaPlayerConfig {
  /// In iOS, to achieve transparency for a video using a platform view, you need to set [supportTransparent] to true.
  bool supportTransparent;

  ZegoLiveAudioRoomMediaPlayerConfig({
    this.supportTransparent = false,
  });
  @override
  String toString() {
    return 'ZegoLiveAudioRoomMediaPlayerConfig:{'
        'supportTransparent:$supportTransparent, '
        '}';
  }
}

/// pip config
class ZegoLiveAudioRoomPIPConfig {
  ZegoLiveAudioRoomPIPConfig({
    this.aspectWidth = 1,
    this.aspectHeight = 1,
    this.enableWhenBackground = true,
    ZegoLiveAudioRoomPIPAndroidConfig? android,
  }) : android = android ?? ZegoLiveAudioRoomPIPAndroidConfig();

  /// android config
  ZegoLiveAudioRoomPIPAndroidConfig android;

  /// aspect width
  int aspectWidth;

  /// aspect height
  int aspectHeight;

  /// android: only available on SDK higher than 31(>=31)
  /// iOS: not limit
  bool enableWhenBackground;

  @override
  String toString() {
    return 'ZegoLiveAudioRoomPIPConfig:{'
        'android:$android, '
        'aspectWidth:$aspectWidth, '
        'aspectHeight:$aspectHeight, '
        'enableWhenAppBackToDesktop:$enableWhenBackground, '
        '}';
  }
}

/// android pip
/// only available on SDK higher than 26(>=26)
class ZegoLiveAudioRoomPIPAndroidConfig {
  ZegoLiveAudioRoomPIPAndroidConfig({
    this.background,
    this.userNameTextColor,
    this.showUserName = true,
  });

  /// default is black
  Widget? background;

  ///  show user name or not
  bool showUserName;

  /// default is white
  Color? userNameTextColor;

  @override
  String toString() {
    return 'ZegoLiveAudioRoomPIPAndroidConfig:{'
        'showUserName:$showUserName, '
        'userNameTextColor:$userNameTextColor, '
        '}';
  }
}

class ZegoLiveAudioRoomSignalingPluginConfig {
  bool leaveRoomOnDispose;
  bool uninitOnDispose;

  ZegoLiveAudioRoomSignalingPluginConfig({
    this.leaveRoomOnDispose = true,
    this.uninitOnDispose = true,
  });
}
