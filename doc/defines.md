# Defines

- [ZegoLiveAudioRoomLayoutAlignment](#zegoliveaudioroomlayoutalignment)
- [ZegoLiveAudioRoomLayoutRowConfig](#zegoliveaudioroomlayoutrowconfig)
- [ZegoLiveAudioRoomLayoutConfig](#zegoliveaudioroomlayoutconfig)
- [ZegoLiveAudioRoomPopupItemValue](#zegoliveaudioroompopupitemvalue)
- [ZegoLiveAudioRoomMenuBarButtonName](#zegoliveaudioroommenubarbuttonname)
- [ZegoLiveAudioRoomRole](#zegoliveaudioroomrole)
- [ZegoLiveAudioRoomDialogInfo](#zegoliveaudioroomdialoginfo)
- [ZegoLiveAudioRoomPopUpSeatClickedMenuInfo](#zegoliveaudioroompopupseatclickedmenuinfo)
- [ZegoLiveAudioRoomPopUpSeatClickedMenuEvent](#zegoliveaudioroompopupseatclickedmenuevent)
- [ZegoLiveAudioRoomEndReason](#zegoliveaudioroomendreason)
- [ZegoLiveAudioRoomEndEvent](#zegoliveaudioroomendevent)
- [ZegoLiveAudioRoomLeaveConfirmationEvent](#zegoliveaudioroomleaveconfirmationevent)
- [ZegoLiveAudioRoomMiniOverlayPageState](#zegoliveaudioroomminioverlaypagestate)
- [ZegoUIKitPrebuiltLiveAudioRoomStyle](#zegouikitprebuiltliveaudioroomstyle)
- [ZegoLiveAudioRoomAudioVideoContainerBuilder](#zegoliveaudioroomaudiovideocontainerbuilder)

---

## ZegoLiveAudioRoomLayoutAlignment

- **Description**
  The alignment of the seat layout.

- **Enum Values**

| Name | Description | Value |
| :--- | :--- | :--- |
| **start** | Place the seats as close to the start of the main axis as possible. | |
| **end** | Place the seats as close to the end of the main axis as possible. | |
| **center** | Place the seats as close to the middle of the main axis as possible. | |
| **spaceBetween** | Place the free space evenly between the seats. | |
| **spaceAround** | Place the free space evenly between the seats as well as half of that space before and after the first and last seat. | |
| **spaceEvenly** | Place the free space evenly between the seats as well as before and after the first and last seat. | |

## ZegoLiveAudioRoomLayoutRowConfig

- **Description**
  Configuration for each row in the seat layout.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **count** | Number of seats in each row. Range is [1~4]. | `int` | `4` |
| **seatSpacing** | The horizontal spacing between each seat. | `int` | `0` |
| **alignment** | The alignment of the seat layout. | `ZegoLiveAudioRoomLayoutAlignment` | `ZegoLiveAudioRoomLayoutAlignment.spaceAround` |

## ZegoLiveAudioRoomLayoutConfig

- **Description**
  Seat layout configuration options.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **rowSpacing** | Spacing between rows, should be positive. | `int` | `0` |
| **rowConfigs** | Configuration list for each row. | `List<ZegoLiveAudioRoomLayoutRowConfig>` | Two default `ZegoLiveAudioRoomLayoutRowConfig` instances |

## ZegoLiveAudioRoomPopupItemValue

- **Description**
  Pop-up menu item values.

- **Enum Values**

| Name | Description | Value |
| :--- | :--- | :--- |
| **takeOnSeat** | Take on seat action. | |
| **takeOffSeat** | Take off seat action. | |
| **switchSeat** | Switch seat action. | |
| **leaveSeat** | Leave seat action. | |
| **muteSeat** | Mute seat action. | |
| **unMuteSeat** | Unmute seat action. | |
| **inviteLink** | Invite link action. | |
| **assignCoHost** | Assign co-host action. | |
| **revokeCoHost** | Revoke co-host action. | |
| **cancel** | Cancel action. | |
| **customStartIndex** | User custom menu start index. | |

## ZegoLiveAudioRoomMenuBarButtonName

- **Description**
  These are the predefined buttons that can be added to the top or bottom toolbar.

- **Enum Values**

| Name | Description | Value |
| :--- | :--- | :--- |
| **leaveButton** | Button for leaving the audio chat room. | |
| **toggleMicrophoneButton** | Button for controlling the microphone switch. | |
| **showMemberListButton** | Button for controlling the visibility of the member list. | |
| **soundEffectButton** | Button for controlling the display or hiding of the sound effect adjustment panel. | |
| **applyToTakeSeatButton** | Button for audience members to apply for a seat and join others in a voice chat. | |
| **minimizingButton** | Button for minimizing the current `ZegoUIKitPrebuiltLiveAudioRoom` widget within the app. | |
| **pipButton** | Button for PIP the current `ZegoUIKitPrebuiltLiveAudioRoom` widget outside the app. | |
| **closeSeatButton** | Button for toggling the seat availability. | |

## ZegoLiveAudioRoomRole

- **Description**
  User roles in the live audio room.

- **Enum Values**

| Name | Description | Value |
| :--- | :--- | :--- |
| **host** | The user with the highest authority in the live audio room. They have control over all functionalities in the room, such as disabling text chat for audience members, inviting audience members to become speakers on seats, demoting speakers to audience members, etc. | |
| **speaker** | Can engage in voice chat with the host or other speakers in the live audio room. They do not have any additional special privileges. | |
| **audience** | Can listen to the voice chat of the host and other speakers in the live audio room, and can also send text messages. | |

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

## ZegoLiveAudioRoomPopUpSeatClickedMenuInfo

- **Description**
  Pop-up menu info when seat is clicked.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **title** | Menu title. | `String` | |
| **data** | Custom data passed to the callback. | `dynamic` | `null` |
| **onClicked** | Callback when menu item is clicked. | `void Function(ZegoLiveAudioRoomPopUpSeatClickedMenuEvent event)` | |

## ZegoLiveAudioRoomPopUpSeatClickedMenuEvent

- **Description**
  Event data when seat pop-up menu is clicked.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **index** | The seat index. | `int` | |
| **isAHostSeat** | Whether the seat is a host seat. | `bool` | |
| **isRoomSeatLocked** | Whether the room seat is locked. | `bool` | |
| **data** | Custom data from `ZegoLiveAudioRoomPopUpSeatClickedMenuInfo`. | `dynamic` | `null` |
| **localIsCoHost** | Whether local user is co-host. | `bool` | |
| **localRole** | Local user's role. | `ZegoLiveAudioRoomRole` | |
| **localUser** | Local user object. | `ZegoUIKitUser` | |
| **targetIsCoHost** | Whether target user is co-host. | `bool` | |
| **targetRole** | Target user's role. | `ZegoLiveAudioRoomRole` | |
| **targetUser** | Target user on the seat, null if seat is empty. | `ZegoUIKitUser?` | |

## ZegoLiveAudioRoomEndReason

- **Description**
  The default behavior is to return to the previous page.

- **Enum Values**

| Name | Description | Value |
| :--- | :--- | :--- |
| **localLeave** | Local user leaves the room. | |
| **kickOut** | User is kicked out of the room. | |

## ZegoLiveAudioRoomEndEvent

- **Description**
  Event data when live audio room ends.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **reason** | End reason. | `ZegoLiveAudioRoomEndReason` | |
| **isFromMinimizing** | Whether the event occurred during minimizing state. | `bool` | |
| **kickerUserID** | The user ID of who kicked you out. | `String?` | `null` |

## ZegoLiveAudioRoomLeaveConfirmationEvent

- **Description**
  Event data for leave confirmation.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **context** | Build context. | `BuildContext` | |

## ZegoLiveAudioRoomMiniOverlayPageState

- **Description**
  Page state of current minimize page.

- **Enum Values**

| Name | Description | Value |
| :--- | :--- | :--- |
| **idle** | No active minimize state. | |
| **inAudioRoom** | Currently in the audio room. | |
| **minimizing** | Currently minimized. | |

## ZegoUIKitPrebuiltLiveAudioRoomStyle

- **Description**
  Style configuration for the live audio room.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **opacity** | Opacity value for UI elements. | `double` | `0.7` |

## ZegoLiveAudioRoomAudioVideoContainerBuilder

- **Description**
  Builder function for customizing the audio/video container layout.

- **Prototype**
  ```dart
  typedef ZegoLiveAudioRoomAudioVideoContainerBuilder = Widget? Function(
    BuildContext context,
    List<ZegoUIKitUser> allUsers,
    List<ZegoUIKitUser> audioVideoUsers,
    Widget Function(ZegoUIKitUser user, int seatIndex) audioVideoViewCreator,
  );
  ```

- **Helper Methods**

### center()

- **Description**
  Creates a center-aligned layout builder. This creates a horizontally scrollable container with seats centered in each row.

- **Prototype**
  ```dart
  static ZegoLiveAudioRoomAudioVideoContainerBuilder center()
  ```

- **Example**
  ```dart
  ZegoLiveAudioRoomAudioVideoContainerBuilder.center()
  ```
