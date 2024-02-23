# [ZegoUIKitPrebuiltLiveAudioRoomConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoUIKitPrebuiltLiveAudioRoomConfig-class.html)

# construtors
- [`host`](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoUIKitPrebuiltLiveAudioRoomConfig/ZegoUIKitPrebuiltLiveAudioRoomConfig.host.html): Default initialization parameters for the host.
- [`audience`](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoUIKitPrebuiltLiveAudioRoomConfig/ZegoUIKitPrebuiltLiveAudioRoomConfig.audience.html): Default initialization parameters for the audience.

# parameters


## [ZegoLiveAudioRoomSeatConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomSeatConfig-class.html) seat

>
>  Configuration for all seats.


- [ZegoLiveAudioRoomLayoutConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomLayoutConfig-class.html) `layout`:
>
> The default layout of the audio chat room supports free layout with multiple rows and columns of seats.
>
> You can use this parameter to control the specific style of each row and column.
- int rowSpacing: Spacing between rows, should be positive
- List\<[ZegoLiveAudioRoomLayoutRowConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomLayoutRowConfig-class.html)\> rowConfigs: Configuration list for each row.

- int `takeIndexWhenJoining`:
>
> Specifies the seat to occupy when joining the live audio room.
>
> This is only valid when the role is set to host or speaker.

- bool `closeWhenJoining`:
>
> Specifies whether to lock the seat automatically after entering the room.
>
> It only takes effect when set by the host

- List\<int\> `hostIndexes`:
>
> Specifies the list of seats occupied by the host.
>
> Once specified, these seats can only be used by the host and cannot be occupied by speakers or audience members.
>
> The default value is `[0]`.

- bool `showSoundWaveInAudioMode`: Whether to display a wave indicator around the avatar.

- Image? `openIcon`: The icon displayed for empty seats when all seats are open (seats in the audio chat room are not locked).

- Image? `closeIcon`: The icon displayed for empty seats when all seats are closed (seats in the audio chat room are locked).

- [ZegoAudioVideoViewForegroundBuilder](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoAudioVideoViewForegroundBuilder.html)? `foregroundBuilder`:
>
> Use this to customize the foreground view of the seat, and the `ZegoUIKitPrebuiltLiveAudioRoom` will returns the current user on the seat and the corresponding seat index.

- [ZegoAudioVideoViewBackgroundBuilder](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoAudioVideoViewBackgroundBuilder.html)? `backgroundBuilder`:
>
> Use this to customize the background view of the seat, and the `ZegoUIKitPrebuiltLiveAudioRoom` returns the current user on the seat and the corresponding seat index.

- [ZegoAvatarBuilder](https://pub.dev/documentation/zego_uikit/latest/zego_uikit/ZegoAvatarBuilder.html)? `avatarBuilder`: Use this to customize the avatar, and replace the default avatar with it.


## [ZegoLiveAudioRoomTopMenuBarConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomTopMenuBarConfig-class.html) topMenuBar

>
>  Configuration options for the top menu bar (toolbar).
>  You can use these options to customize the appearance and behavior of the top menu bar.

- List\<[ZegoLiveAudioRoomMenuBarButtonName](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomMenuBarButtonName.html)\> `buttons`: These buttons will displayed on the menu bar, order by the list only support [minimizingButton] right now

## [ZegoLiveAudioRoomBottomMenuBarConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomBottomMenuBarConfig-class.html) bottomMenuBar

>
>  Configuration options for the bottom menu bar (toolbar).
>  You can use these options to customize the appearance and behavior of the bottom menu bar.



- bool `showInRoomMessageButton`:
>
> When set to `true`, the button for sending messages will be displayed.
> If you want to disable text messaging in the live audio room, set it to `false`.

- List\<[ZegoLiveAudioRoomMenuBarButtonName](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomMenuBarButtonName.html)\> `hostButtons`: The list of predefined buttons to be displayed when the user role is set to host.

- List\<[ZegoLiveAudioRoomMenuBarButtonName](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomMenuBarButtonName.html)\> `speakerButtons`: The list of predefined buttons to be displayed when the user role is set to speaker.

- List\<[ZegoLiveAudioRoomMenuBarButtonName](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomMenuBarButtonName.html)\> `audienceButtons`: The list of predefined buttons to be displayed when the user role is set to audience.

- List\<Widget\> `hostExtendButtons`: The list of custom buttons to be displayed when the user role is set to host.

- List\<Widget\> `speakerExtendButtons`: The list of custom buttons to be displayed when the user role is set to speaker.

- List\<Widget\> `audienceExtendButtons`: The list of custom buttons to be displayed when the user role is set to audience.

- int `maxCount`:
>
> Controls the maximum number of buttons (including predefined and custom buttons) to be displayed in the menu bar (toolbar).
> When the number of buttons exceeds the `maxCount` limit, a "More" button will appear.
> Clicking on it will display a panel showing other buttons that cannot be displayed in the menu bar (toolbar).


## [ZegoLiveAudioRoomInRoomMessageConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomInRoomMessageConfig-class.html) inRoomMessage

>
>  Configuration options for the message list.

- [ZegoInRoomMessageItemBuilder](https://pub.dev/documentation/zego_uikit/latest/zego_uikit/ZegoInRoomMessageItemBuilder.html)? `itemBuilder`:
>
> Use this to customize the style and content of each chat message list item.
> For example, you can modify the background color, opacity, border radius, or add additional information like the sender's level or role.

- Widget? `background`: background

- bool `visible`: If set to `false`, the message list will be hidden. The default value is `true`.

- double? `width`: The width of chat message list view

- double? `height`: The height of chat message list view

- Offset? `bottomLeft`: The offset of chat message list view bottom-left position

- bool `showName`: display user name in message list view or not

- bool `showAvatar`: display user avatar in message list view or not

- double `opacity`:
>
> The opacity of the background color for chat message list items, default value of 0.5.
> If you set the [backgroundColor], the [opacity] setting will be overridden.

- Color? `backgroundColor`:
>
> The background of chat message list items
> If you set the [backgroundColor], the [opacity] setting will be overridden.
> You can use `backgroundColor.withOpacity(0.5)` to set the opacity of the background color.

- int? `maxLines`: The max lines of chat message list items, default value is not limit.

- TextStyle? `nameTextStyle`: The name text style of chat message list items

- TextStyle? `messageTextStyle`: The message text style of chat message list items

- BorderRadiusGeometry? `borderRadius`: The border radius of chat message list items

- EdgeInsetsGeometry? `paddings`: The paddings of chat message list items

- Widget? `resendIcon`: resend button icon

## [ZegoLiveAudioRoomAudioEffectConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomAudioEffectConfig-class.html) audioEffect

>
>  You can use this to modify your voice and control reverb.

- List\<[VoiceChangerType](https://pub.dev/documentation/zego_uikit/latest/zego_uikit/VoiceChangerType.html)\> voiceChangeEffect: List of voice changer effects. If you don't want a certain effect, simply remove it from the list.

>
> ```dart
>
>/// Enumeration of voice changer types.
>enum VoiceChangerType {
>  /// No voice changer.
>  none,
>
>  /// Little boy voice.
>  littleBoy,
>
>  /// Little girl voice.
>  littleGirl,
>
>  /// Ethereal voice.
>  ethereal,
>
>  /// Female voice.
>  female,
>
>  /// Male voice.
>  male,
>
>  /// Robot voice.
>  robot,
>
>  /// Optimus Prime voice.
>  optimusPrime,
>
>  /// Deep voice.
>  deep,
>
>  /// Crystal clear voice.
>  crystalClear,
>
>  /// C major male voice.
>  cMajor,
>
>  /// A major male voice.
>  aMajor,
>
>  /// Harmonic minor voice.
>  harmonicMinor,
>}
>
> ```

- List\<[ReverbType](https://pub.dev/documentation/zego_uikit/latest/zego_uikit/ReverbType.html)\> reverbEffect: List of reverb effects. If you don't want a certain effect, simply remove it from the list.

>
>```dart
>/// Enumeration of reverb types.
>enum ReverbType {
>  /// No reverb.
>  none,
>
>  /// KTV reverb.
>  ktv,
>
>  /// Hall reverb.
>  hall,
>
>  /// Concert reverb.
>  concert,
>
>  /// Rock reverb.
>  rock,
>
>  /// Small room reverb.
>  smallRoom,
>
>  /// Large room reverb.
>  largeRoom,
>
>  /// Valley reverb.
>  valley,
>
>  /// Recording studio reverb.
>  recordingStudio,
>
>  /// Basement reverb.
>  basement,
>
>  /// Popular reverb.
>  popular,
>
>  /// Gramophone reverb.
>  gramophone,
>}
>```

## [ZegoLiveAudioRoomLiveDurationConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomLiveDurationConfig-class.html) duration

>
>  Live audio room timing configuration.

- bool isVisible: Whether to display Live Audio Room timing.

## [ZegoLiveAudioRoomMediaPlayerConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomMediaPlayerConfig-class.html) mediaPlayer

>
>  the config of media player

- bool supportTransparent: In iOS, to achieve transparency for a video using a platform view, you need to set [supportTransparent] to true.

## [ZegoLiveAudioRoomBackgroundMediaConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomBackgroundMediaConfig-class.html) backgroundMedia

>
>  the config of background music, the feature currently only works for the host

- String? path:
>
>  the path of background music, which can be either a local path or a network address.
>
>  supported formats by default include MP3, MP4, FLV, WAV, AAC, M3U8, and FLAC.

- bool enableRepeat: whether to repeat playback.

## [ZegoLiveAudioRoomMemberListConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomMemberListConfig-class.html) memberList

>
>  Configuration related to the bottom member list, including displaying the member list, member list styles, and more.

- [ZegoMemberListItemBuilder](https://pub.dev/documentation/zego_uikit/latest/zego_uikit/ZegoMemberListItemBuilder.html)? itemBuilder:
>
>  Custom member list item view.
> For example, suppose you have implemented a `CustomMemberListItem` component that can render a member list item view based on the user information. You can set it up like this:
>
>```dart
> ZegoLiveAudioRoomMemberListConfig(
>   itemBuilder: (BuildContext context, Size size, ZegoUIKitUser user, Map<String, dynamic> extraInfo) {
>     return CustomMemberListItem(user: user);
>   },
> );
>```
>
> In this example, we pass the builder function of the custom view, `CustomMemberListItem`, to the [itemBuilder] property so that the member list item will be rendered using the custom component.



## [ZegoLiveAudioRoomRole](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomRole.html) role

>
>  Specifies the initial role when joining the live audio room.
>  The role change after joining is not constrained by this property.
>
> ```dart
> User roles in the live audio room.
> This enum type is used for the [role] property in [ZegoUIKitPrebuiltLiveAudioRoomConfig].
>enum ZegoLiveAudioRoomRole {
>  ///  `host` is the user with the highest authority in the live audio room. They have control over all functionalities in the room, such as disabling text chat for audience members, inviting audience members to become speakers on seats, demoting speakers to audience members, etc.
>  host,
>
>  /// `speaker` can engage in voice chat with the host or other speakers in the live audio room. They do not have any additional special privileges.
>  speaker,
>
>  /// `audience` can listen to the voice chat of the host and other speakers in the live audio room, and can also send text messages.
>  audience,
>}
> ```


## bool turnOnMicrophoneWhenJoining

>
>  Whether to open the microphone when joining the audio chat room.
>
>  If you want to join the audio chat room with your microphone closed, set this value to false
>  if you want to join the audio chat room with your microphone open, set this value to true.
>  The default value is `true`.
>
>  Note that this parameter is independent of the user's role.
>  Even if the user is an audience, they can set this value to true, and they can start chatting with others through voice after joining the room.
>  Therefore, in general, if the role is an audience, this value should be set to false.

## bool useSpeakerWhenJoining

>
>  Whether to use the speaker to play audio when joining the audio chat room.
>  The default value is `true`.
>  If this value is set to `false`, the system's default playback device, such as the earpiece or Bluetooth headset, will be used for audio playback.

## Widget? foreground

>
>  The foreground of the live audio room.
>
>  If you need to nest some widgets in [ZegoUIKitPrebuiltLiveAudioRoom], please use [foreground] nesting, otherwise these widgets will be lost when you minimize and restore the [ZegoUIKitPrebuiltLiveAudioRoom]

## Widget? background

>
>  The background of the audio chat room.
>
>  You can use any Widget as the background of the audio chat room, such as a video, a GIF animation, an image, a web page, etc.
>  If you need to dynamically change the background content, you will need to implement the logic for dynamic modification within the Widget you return.
>
>  ```dart
> 
>   // eg:
>  ..background = Container(
>      width: size.width,
>      height: size.height,
>      decoration: const BoxDecoration(
>        image: DecorationImage(
>          fit: BoxFit.fitHeight,
>          image: ,
>        )))
>  ```

## [ZegoUIKitPrebuiltLiveAudioRoomInnerText](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoUIKitPrebuiltLiveAudioRoomInnerText-class.html) innerText

>
>  Configuration options for modifying all text content on the UI.
>  All visible text content on the UI can be modified using this single property.

## String? userAvatarUrl

>
>  Set the avatar URL for the current user.
>
>  Note that the default maximum length for avatars is 64 bytes, exceeding this limit may result in the avatar not being displayed.
>  We recommend using short URLs for setting the avatar URL.
>  If you have a specific need for using long avatar URLs, please contact [technical support](https://www.zegocloud.com).

## Map<String, String> userInRoomAttributes

>
>  Set the attributes for the current user in the current joined audio room.
>  [userAvatarUrl] actually uses this attribute and occupies a property with the key "avatar".
>
>  For a single user, the sum of all Key-Value pairs must be within 100 bytes and a maximum of 20 pairs can be configured.
>  Each Key must be within 8 bytes, Each Value must be within 64 bytes.
>  If you want to increase the upper limit, please contact [technical support](https://www.zegocloud.com).

## [ZegoLiveAudioRoomDialogInfo](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoLiveAudioRoomDialogInfo-class.html)? confirmDialogInfo

>
>  Confirmation dialog information when leaving the audio chat room.
>  If not set, clicking the exit button will directly exit the audio chat room.
>  If set, a confirmation dialog will be displayed when clicking the exit button, and you will need to confirm the exit before actually exiting.

## bool rootNavigator

>
>  same as Flutter's Navigator's param
>  If `rootNavigator` is set to true, the state from the furthest instance of
>  this class is given instead. Useful for pushing contents above all
>  subsequent instances of [Navigator].

## Map<String, String> advanceConfigs

>
>  Set advanced engine configuration, Used to enable advanced functions.
>  For details, please consult ZEGO technical support.

## Widget Function(BuildContext context)? emptyAreaBuilder

>
>  The blank space between seat and bottomBar, which can be used to place custom widgets freely.
