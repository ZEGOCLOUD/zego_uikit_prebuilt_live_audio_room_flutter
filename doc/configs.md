# Configs

- [ZegoUIKitPrebuiltLiveAudioRoomConfig](#zegouikitprebuiltliveaudioroomconfig)
  - [seat](#zegoliveaudioroomseatconfig)
    - [layout](#zegoliveaudioroomlayoutconfig)
      - [rowConfigs](#zegoliveaudioroomlayoutrowconfig)
  - [topMenuBar](#zegoliveaudioroomtopmenubarconfig)
  - [bottomMenuBar](#zegoliveaudioroombottommenubarconfig)
  - [inRoomMessage](#zegoliveaudioroominroommessageconfig)
  - [audioEffect](#zegoliveaudioroomaudioeffectconfig)
  - [duration](#zegoliveaudioroomlivedurationconfig)
  - [pip](#zegoliveaudioroompipconfig)
    - [android](#zegoliveaudioroompipandroidconfig)
  - [mediaPlayer](#zegoliveaudioroommediaplayerconfig)
    - [defaultPlayer](#zegoliveaudioroommediaplayerdefaultplayerconfig)
  - [backgroundMedia](#zegoliveaudioroombackgroundmediaconfig)
  - [memberList](#zegoliveaudioroommemberlistconfig)
  - [popUpMenu](#zegoliveaudioroompopupmenuconfig)
    - [seatClicked](#zegoliveaudioroompopupseatclickedmenuconfig)
  - [signalingPlugin](#zegoliveaudioroomsignalingpluginconfig)
  - [innerText](#zegouikitprebuiltliveaudioroominnertext)
  - [confirmDialogInfo](#zegoliveaudioroomdialoginfo)

---

## ZegoUIKitPrebuiltLiveAudioRoomConfig

- **Description**
  Configuration for initializing the Live Audio Room.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **seat** | Configuration for all seats. | `ZegoLiveAudioRoomSeatConfig` | |
| **topMenuBar** | Configuration options for the top menu bar (toolbar). | `ZegoLiveAudioRoomTopMenuBarConfig` | |
| **bottomMenuBar** | Configuration options for the bottom menu bar (toolbar). | `ZegoLiveAudioRoomBottomMenuBarConfig` | |
| **inRoomMessage** | Configuration options for the message list. | `ZegoLiveAudioRoomInRoomMessageConfig` | |
| **audioEffect** | You can use this to modify your voice and control reverb. | `ZegoLiveAudioRoomAudioEffectConfig` | |
| **duration** | Live audio room timing configuration. | `ZegoLiveAudioRoomLiveDurationConfig` | |
| **pip** | Configuration for Picture-in-Picture mode. | `ZegoLiveAudioRoomPIPConfig` | |
| **mediaPlayer** | The config of media player. | `ZegoLiveAudioRoomMediaPlayerConfig` | |
| **backgroundMedia** | The config of background music, the feature currently only works for the host. | `ZegoLiveAudioRoomBackgroundMediaConfig` | |
| **memberList** | Configuration related to the bottom member list. | `ZegoLiveAudioRoomMemberListConfig` | |
| **popUpMenu** | Config of menus. | `ZegoLiveAudioRoomPopUpMenuConfig` | |
| **signalingPlugin** | Configuration for signaling plugin. | `ZegoLiveAudioRoomSignalingPluginConfig` | |
| **role** | Specifies the initial role when joining the live audio room. | `ZegoLiveAudioRoomRole` | `ZegoLiveAudioRoomRole.audience` |
| **turnOnMicrophoneWhenJoining** | Whether to open the microphone when joining the audio chat room. | `bool` | `true` |
| **useSpeakerWhenJoining** | Whether to use the speaker to play audio when joining the audio chat room. | `bool` | `true` |
| **foreground** | The foreground of the live audio room. | `Widget?` | `null` |
| **background** | The background of the audio chat room. | `Widget?` | `null` |
| **innerText** | Configuration options for modifying all text content on the UI. | `ZegoUIKitPrebuiltLiveAudioRoomInnerText` | |
| **userAvatarUrl** | Set the avatar URL for the current user. | `String?` | `null` |
| **userInRoomAttributes** | Set the attributes for the current user in the current joined audio room. | `Map<String, String>` | `{}` |
| **confirmDialogInfo** | Confirmation dialog information when leaving the audio chat room. | `ZegoLiveAudioRoomDialogInfo?` | `null` |
| **rootNavigator** | same as Flutter's Navigator's param. | `bool` | `false` |
| **advanceConfigs** | Set advanced engine configuration. | `Map<String, String>` | `{}` |
| **emptyAreaBuilder** | The blank space between seat and bottomBar, which can be used to place custom widgets freely. | `Widget Function(BuildContext context)?` | `null` |

## ZegoLiveAudioRoomSeatConfig

- **Description**
  Configuration options for controlling seat behavior and style.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **layout** | The default layout of the audio chat room supports free layout with multiple rows and columns of seats. | `ZegoLiveAudioRoomLayoutConfig` | |
| **topLeft** | The topLeft point of seat. | `Point<double>?` | `null` |
| **containerSize** | The size of seat container. | `Size?` | `null` |
| **containerBuilder** | Custom seat container totally. | `ZegoLiveAudioRoomAudioVideoContainerBuilder?` | `null` |
| **takeIndexWhenJoining** | Specifies the seat to occupy when joining the live audio room. Only valid when role is host or speaker. | `int` | `-1` |
| **canAutoSwitchOnClicked** | Whether to auto switch seat when clicking on an empty seat. | `bool Function(int seatIndex)?` | `null` |
| **takeIndexWhenAudienceRequesting** | When the audience take on seat, do you want specify a seat? | `int Function(ZegoUIKitUser user)?` | `null` |
| **closeWhenJoining** | Specifies whether to lock the seat automatically after entering the room. | `bool` | `true` |
| **hostIndexes** | Specifies the list of seats occupied by the host. Once specified, these seats can only be used by the host. | `List<int>` | `[0]` |
| **showSoundWaveInAudioMode** | Whether to display a wave indicator around the avatar. | `bool` | `true` |
| **soundWaveColor** | Sound wave color. | `Color?` | `null` |
| **openIcon** | The icon displayed for empty seats when all seats are open (seats not locked). | `Image?` | `null` |
| **closeIcon** | The icon displayed for empty seats when all seats are closed (seats locked). | `Image?` | `null` |
| **hostRoleIcon** | Icon for host. | `Image?` | `null` |
| **coHostRoleIcon** | Icon for co-host. | `Image?` | `null` |
| **microphoneOffIcon** | Icon when speaker's microphone off. | `Image?` | `null` |
| **keepOriginalForeground** | Whether to retain the original foreground. | `bool` | `false` |
| **foregroundBuilder** | Use this to customize the foreground view of the seat. | `ZegoAudioVideoViewForegroundBuilder?` | `null` |
| **backgroundBuilder** | Use this to customize the background view of the seat. | `ZegoAudioVideoViewBackgroundBuilder?` | `null` |
| **avatarBuilder** | Use this to customize the avatar. | `ZegoAvatarBuilder?` | `null` |

## ZegoLiveAudioRoomLayoutConfig

- **Description**
  Seat layout configuration options.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **rowSpacing** | Spacing between rows, should be positive. | `int` | `0` |
| **rowConfigs** | Configuration list for each row. | `List<ZegoLiveAudioRoomLayoutRowConfig>` | Two default configs |

## ZegoLiveAudioRoomLayoutRowConfig

- **Description**
  Configuration for each row in the seat layout.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **count** | Number of seats in each row. Range is [1~4]. | `int` | `4` |
| **seatSpacing** | The horizontal spacing between each seat. | `int` | `0` |
| **alignment** | The alignment of the seat layout. | `ZegoLiveAudioRoomLayoutAlignment` | `ZegoLiveAudioRoomLayoutAlignment.spaceAround` |

## ZegoLiveAudioRoomTopMenuBarConfig

- **Description**
  Configuration options for the top menu bar (toolbar). Only support: showMemberListButton, leaveButton, minimizingButton, pipButton.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **buttons** | These buttons will displayed on the menu bar. | `List<ZegoLiveAudioRoomMenuBarButtonName>` | `[minimizingButton, leaveButton]` |

## ZegoLiveAudioRoomBottomMenuBarConfig

- **Description**
  Configuration options for the bottom menu bar (toolbar).

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **visible** | If set to false, the bottom bar will be hidden. | `bool` | `true` |
| **showInRoomMessageButton** | When set to true, the button for sending messages will be displayed. | `bool` | `true` |
| **maxCount** | Controls the maximum number of buttons to be displayed in the menu bar. | `int` | `5` |
| **hostButtons** | The list of predefined buttons for host role. | `List<ZegoLiveAudioRoomMenuBarButtonName>` | `[soundEffectButton, toggleMicrophoneButton, showMemberListButton, closeSeatButton]` |
| **speakerButtons** | The list of predefined buttons for speaker role. | `List<ZegoLiveAudioRoomMenuBarButtonName>` | `[soundEffectButton, toggleMicrophoneButton, showMemberListButton]` |
| **audienceButtons** | The list of predefined buttons for audience role. | `List<ZegoLiveAudioRoomMenuBarButtonName>` | `[showMemberListButton, applyToTakeSeatButton]` |
| **hostExtendButtons** | The list of custom buttons for host role. | `List<Widget>` | `[]` |
| **speakerExtendButtons** | The list of custom buttons for speaker role. | `List<Widget>` | `[]` |
| **audienceExtendButtons** | The list of custom buttons for audience role. | `List<Widget>` | `[]` |

## ZegoLiveAudioRoomInRoomMessageConfig

- **Description**
  Control options for the bottom-left message list.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **itemBuilder** | Use this to customize the style and content of each chat message list item. | `ZegoInRoomMessageItemBuilder?` | `null` |
| **background** | Message view background (not item). | `Widget?` | `null` |
| **visible** | If set to false, the message list will be hidden. | `bool` | `true` |
| **width** | The width of chat message list view. | `double?` | `null` |
| **height** | The height of chat message list view. | `double?` | `null` |
| **bottomLeft** | The offset of chat message list view bottom-left position. | `Offset?` | `null` |
| **showName** | Display user name in message list view or not. | `bool` | `true` |
| **showAvatar** | Display user avatar in message list view or not. | `bool` | `true` |
| **opacity** | The opacity of the background color for chat message list items. | `double` | `0.5` |
| **backgroundColor** | The background of chat message list items. | `Color?` | `null` |
| **maxLines** | The max lines of chat message list items. | `int?` | `null` |
| **nameTextStyle** | The name text style of chat message list items. | `TextStyle?` | `null` |
| **messageTextStyle** | The message text style of chat message list items. | `TextStyle?` | `null` |
| **borderRadius** | The border radius of chat message list items. | `BorderRadiusGeometry?` | `null` |
| **paddings** | The paddings of chat message list items. | `EdgeInsetsGeometry?` | `null` |
| **resendIcon** | Resend button icon. | `Widget?` | `null` |

## ZegoLiveAudioRoomAudioEffectConfig

- **Description**
  Configuration options for voice changer and reverberation effects.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **voiceChangeEffect** | List of voice changer effects. | `List<VoiceChangerType>` | Multiple effects |
| **reverbEffect** | List of reverb effects. | `List<ReverbType>` | Multiple effects |

## ZegoLiveAudioRoomLiveDurationConfig

- **Description**
  Live Audio Room timing configuration.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **isVisible** | Whether to display Live Audio Room timing. | `bool` | `true` |

## ZegoLiveAudioRoomPIPConfig

- **Description**
  PIP (Picture-in-Picture) configuration.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **android** | Android specific PIP configuration. | `ZegoLiveAudioRoomPIPAndroidConfig` | |
| **aspectWidth** | Aspect width. | `int` | `1` |
| **aspectHeight** | Aspect height. | `int` | `1` |
| **enableWhenBackground** | Enable PIP when app is in background. Android: only available on SDK higher than 31. | `bool` | `true` |

## ZegoLiveAudioRoomPIPAndroidConfig

- **Description**
  Android PIP configuration. Only available on SDK higher than 26.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **background** | Background widget. Default is black. | `Widget?` | `null` |
| **showUserName** | Show user name or not. | `bool` | `true` |
| **userNameTextColor** | User name text color. Default is white. | `Color?` | `null` |

## ZegoLiveAudioRoomMediaPlayerConfig

- **Description**
  Media player configuration.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **supportTransparent** | In iOS, to achieve transparency for a video using a platform view, you need to set this to true. | `bool` | `false` |
| **defaultPlayer** | Default player config. | `ZegoLiveAudioRoomMediaPlayerDefaultPlayerConfig` | |

## ZegoLiveAudioRoomMediaPlayerDefaultPlayerConfig

- **Description**
  Default media player query parameter configuration.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **support** | Support or not. | `bool` | `false` |
| **rolesCanControl** | Roles can control (pick/start/stop). | `List<ZegoLiveAudioRoomRole>` | `[host]` |
| **topLeftQuery** | Top-left position query. | `Point<double> Function(ZegoLiveAudioRoomMediaPlayerQueryParameter)?` | `null` |
| **rectQuery** | Rect query. | `Rect? Function(ZegoLiveAudioRoomMediaPlayerQueryParameter)?` | `null` |
| **configQuery** | Config query. | `ZegoUIKitMediaPlayerConfig? Function(ZegoLiveAudioRoomMediaPlayerQueryParameter)?` | `null` |
| **styleQuery** | Style query. | `ZegoUIKitMediaPlayerStyle? Function(ZegoLiveAudioRoomMediaPlayerQueryParameter)?` | `null` |

## ZegoLiveAudioRoomBackgroundMediaConfig

- **Description**
  Live Audio Room background media configuration.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **path** | The path of background music, which can be either a local path or a network address. | `String?` | `null` |
| **enableRepeat** | Whether to repeat playback. | `bool` | `true` |

## ZegoLiveAudioRoomMemberListConfig

- **Description**
  Configuration for the member list.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **itemBuilder** | Custom member list item view. | `ZegoMemberListItemBuilder?` | `null` |

## ZegoLiveAudioRoomPopUpMenuConfig

- **Description**
  Pop up menu configuration.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **seatClicked** | Pop up menu when on seat clicked. | `ZegoLiveAudioRoomPopUpSeatClickedMenuConfig` | |

## ZegoLiveAudioRoomPopUpSeatClickedMenuConfig

- **Description**
  Pop up menu when on seat clicked.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **hiddenMenus** | If you don't want some system menus to appear, specify to hide them here. | `List<ZegoLiveAudioRoomPopupItemValue>` | `[]` |
| **hostExtendMenus** | The custom menus to be displayed when the seat's user is host. | `List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo>` | `[]` |
| **coHostExtendMenus** | The custom menus to be displayed when the seat's user is co-host. | `List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo>` | `[]` |
| **speakerExtendMenus** | The custom menus to be displayed when the seat's user is speaker. | `List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo>` | `[]` |
| **audienceExtendMenus** | The custom menus to be displayed when the seat's user is audience. | `List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo>` | `[]` |
| **emptyExtendMenus** | The custom menus to be displayed when seat is empty. | `List<ZegoLiveAudioRoomPopUpSeatClickedMenuInfo>` | `[]` |

## ZegoLiveAudioRoomSignalingPluginConfig

- **Description**
  Configuration for signaling plugin.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **leaveRoomOnDispose** | Leave room on dispose. | `bool` | `true` |
| **uninitOnDispose** | Uninit on dispose. | `bool` | `true` |

## ZegoUIKitPrebuiltLiveAudioRoomInnerText

- **Description**
  Control the text on the UI. Modify the values of the corresponding properties to modify the text on the UI.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **takeSeatMenuButton** | The button displayed in the popup menu when the audience clicks to request take a seat. | `String` | `'Take the seat'` |
| **switchSeatMenuButton** | The button displayed when audience clicks to switch seat. | `String` | `'Switch the seat'` |
| **removeSpeakerMenuDialogButton** | The button when host moves speaker down from seat. | `String` | `'Remove %0 from seat'` |
| **muteSpeakerMenuDialogButton** | The button when host mutes speaker. | `String` | `'Mute %0'` |
| **cancelMenuDialogButton** | The cancel button in the popup menu. | `String` | `'Cancel'` |
| **removeUserMenuDialogButton** | The text of button which host kick out audience or speakers from the live audio room. | `String` | `'Remove %0 from the room'` |
| **memberListTitle** | The title of the member list. | `String` | `'Audience'` |
| **memberListRoleYou** | The label for displaying yourself in the member list. | `String` | `'You'` |
| **memberListRoleHost** | The label for displaying the host in the member list. | `String` | `'Host'` |
| **memberListRoleSpeaker** | The label for displaying speakers in the member list. | `String` | `'Speaker'` |
| **removeSpeakerFailedToast** | The toast message when host fails to move speaker down. | `String` | `'Failed to remove %0 from seat'` |
| **messageEmptyToast** | The placeholder text in the chat input box. | `String` | `'Say something...'` |
| **cameraPermissionSettingDialogInfo** | The dialog for camera permission settings. | `ZegoLiveAudioRoomDialogInfo` | |
| **microphonePermissionSettingDialogInfo** | The dialog for microphone permission settings. | `ZegoLiveAudioRoomDialogInfo` | |
| **removeFromSeatDialogInfo** | The confirmation dialog before host moves speaker down. | `ZegoLiveAudioRoomDialogInfo` | |
| **leaveSeatDialogInfo** | The confirmation dialog before speaker voluntarily leaves seat. | `ZegoLiveAudioRoomDialogInfo` | |
| **applyToTakeSeatButton** | The button for audience members to apply for taking a seat. | `String` | `'Apply to take seat'` |
| **cancelTheTakeSeatApplicationButton** | The button to cancel the application. | `String` | `'Cancel'` |
| **memberListAgreeButton** | The button to accept an audience member's seat application. | `String` | `'Agree'` |
| **memberListDisagreeButton** | The button to reject an audience member's seat application. | `String` | `'Disagree'` |
| **inviteToTakeSeatMenuDialogButton** | The button to invite audience to take seat. | `String` | `'Invite %0 to take seat'` |
| **hostInviteTakeSeatDialog** | The invitation dialog when host invites audience to take seat. | `ZegoLiveAudioRoomDialogInfo` | |
| **assignAsCoHostMenuDialogButton** | The button to assign speaker as co-host. | `String` | `'Assign %0 as Co-Host'` |
| **revokeCoHostPrivilegesMenuDialogButton** | The button to revoke co-host privileges. | `String` | `"Revoke %0's Co-Host Privileges"` |
| **audioEffectTitle** | The title of the audio effects dialog. | `String` | `'Audio effects'` |
| **audioEffectReverbTitle** | The title of the reverb category. | `String` | `'Reverb'` |
| **audioEffectVoiceChangingTitle** | The title of the voice changing category. | `String` | `'Voice changing'` |
| **voiceChangerNoneTitle** | Voice changing effect: None. | `String` | `'None'` |
| **voiceChangerLittleBoyTitle** | Voice changing effect: Little Boy. | `String` | `'Little boy'` |
| **voiceChangerLittleGirlTitle** | Voice changing effect: Little Girl. | `String` | `'Little girl'` |
| **voiceChangerDeepTitle** | Voice changing effect: Deep. | `String` | `'Deep'` |
| **voiceChangerCrystalClearTitle** | Voice changing effect: Crystal-clear. | `String` | `'Crystal-clear'` |
| **voiceChangerRobotTitle** | Voice changing effect: Robot. | `String` | `'Robot'` |
| **voiceChangerEtherealTitle** | Voice changing effect: Ethereal. | `String` | `'Ethereal'` |
| **voiceChangerFemaleTitle** | Voice changing effect: Female. | `String` | `'Female'` |
| **voiceChangerMaleTitle** | Voice changing effect: Male. | `String` | `'Male'` |
| **voiceChangerOptimusPrimeTitle** | Voice changing effect: Optimus Prime. | `String` | `'Optimus Prime'` |
| **voiceChangerCMajorTitle** | Voice changing effect: C major. | `String` | `'C major'` |
| **voiceChangerAMajorTitle** | Voice changing effect: A major. | `String` | `'A major'` |
| **voiceChangerHarmonicMinorTitle** | Voice changing effect: Harmonic minor. | `String` | `'Harmonic minor'` |
| **reverbTypeNoneTitle** | Reverb effect: None. | `String` | `'None'` |
| **reverbTypeKTVTitle** | Reverb effect: Karaoke. | `String` | `'Karaoke'` |
| **reverbTypeHallTitle** | Reverb effect: Hall. | `String` | `'Hall'` |
| **reverbTypeConcertTitle** | Reverb effect: Concert. | `String` | `'Concert'` |
| **reverbTypeRockTitle** | Reverb effect: Rock. | `String` | `'Rock'` |
| **reverbTypeSmallRoomTitle** | Reverb effect: Small room. | `String` | `'Small room'` |
| **reverbTypeLargeRoomTitle** | Reverb effect: Large room. | `String` | `'Large room'` |
| **reverbTypeValleyTitle** | Reverb effect: Valley. | `String` | `'Valley'` |
| **reverbTypeRecordingStudioTitle** | Reverb effect: Recording studio. | `String` | `'Recording studio'` |
| **reverbTypeBasementTitle** | Reverb effect: Basement. | `String` | `'Basement'` |
| **reverbTypePopularTitle** | Reverb effect: Pop. | `String` | `'Pop'` |
| **reverbTypeGramophoneTitle** | Reverb effect: Gramophone. | `String` | `'Gramophone'` |
| **screenSharingTipText** | When sharing the screen, the text prompt on the sharing side. | `String` | `'You are sharing screen'` |
| **stopScreenSharingButtonText** | When screen sharing, stop sharing button. | `String` | `'Stop sharing'` |

## ZegoLiveAudioRoomDialogInfo

- **Description**
  Dialog information. Used to control whether certain features display a dialog.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **title** | Dialog title. | `String` | |
| **message** | Dialog text content. | `String` | |
| **cancelButtonName** | Text content on the cancel button. | `String` | `'Cancel'` |
| **confirmButtonName** | Text content on the confirm button. | `String` | `'OK'` |
