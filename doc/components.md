# Components

- [ZegoUIKitPrebuiltLiveAudioRoom](#zegouikitprebuiltliveaudioroom)
- [ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage](#zegouikitprebuiltliveaudioroomminioverlaypage)
- [ZegoUIKitPrebuiltLiveAudioRoomMiniPopScope](#zegouikitprebuiltliveaudioroomminipopscope)

---

## ZegoUIKitPrebuiltLiveAudioRoom

- **Description**
  Live Audio Room Widget. You can embed this widget into any page of your project to integrate the functionality of a audio chat room.

- **Parameters**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **appID** | You can create a project and obtain an appID from the ZEGOCLOUD Admin Console. | `int` | |
| **appSign** | The appSign applied from ZEGOCLOUD Admin Console. Used for login authentication. | `String` | `''` |
| **token** | The token used for authentication. If appSign is not provided, this must be set. | `String` | `''` |
| **userID** | The ID of the currently logged-in user. | `String` | |
| **userName** | The name of the currently logged-in user. | `String` | |
| **roomID** | The ID of the audio chat room. Users who enter the same roomID will be logged into the same room. | `String` | |
| **config** | Initialize the configuration for the voice chat room. | `ZegoUIKitPrebuiltLiveAudioRoomConfig` | |
| **events** | Initialize the event for the voice chat room. | `ZegoUIKitPrebuiltLiveAudioRoomEvents?` | `null` |
| **style** | Style configuration for the live audio room. | `ZegoUIKitPrebuiltLiveAudioRoomStyle?` | `null` |

---

## ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage

- **Description**
  The page can be minimized within the app. To support the minimize functionality, you need to add the minimize button to the top menu bar or call the minimize API directly, and nest this widget in your MaterialApp.

- **Parameters**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **contextQuery** | You need to return the context of NavigatorState in this callback. | `BuildContext Function()` | |
| **rootNavigator** | Whether to use the root navigator. | `bool` | `true` |
| **navigatorWithSafeArea** | Whether to add safe area for the navigator. | `bool` | `true` |
| **size** | Size of the minimizing page. | `Size?` | `null` |
| **topLeft** | Position of the minimizing page. | `Offset` | `Offset(100, 100)` |
| **borderRadius** | Border radius of the minimizing page. | `double` | `12.0` |
| **borderColor** | Border color of the minimizing page. | `Color` | `Colors.black12` |
| **soundWaveColor** | Sound wave color of the minimizing page. | `Color` | `Color(0xff2254f6)` |
| **backgroundColor** | Background color of the minimizing page. | `Color` | `Colors.white` |
| **padding** | Padding of the minimizing page. | `double` | `0.0` |
| **showDevices** | Show devices or not. | `bool` | `true` |
| **showUserName** | Show user name or not. | `bool` | `true` |
| **showLeaveButton** | Show leave button or not. | `bool` | `true` |
| **leaveButtonIcon** | Leave button icon. | `Widget?` | `null` |
| **supportClickZoom** | Support double tap to zoom. | `bool` | `true` |
| **foreground** | Foreground widget. | `Widget?` | `null` |
| **builder** | Builder for customizing the overlay item. | `Widget Function(ZegoUIKitUser? activeUser)?` | `null` |
| **foregroundBuilder** | Foreground builder for customizing the user view. | `ZegoAudioVideoViewForegroundBuilder?` | `null` |
| **backgroundBuilder** | Background builder for customizing the user view. | `ZegoAudioVideoViewBackgroundBuilder?` | `null` |
| **avatarBuilder** | Avatar builder for customizing the user avatar. | `ZegoAvatarBuilder?` | `null` |

---

## ZegoUIKitPrebuiltLiveAudioRoomMiniPopScope

- **Description**
  When minimizing, it is not allowed to directly return to the previous page, otherwise the page will be destroyed. This widget prevents the back button from destroying the page during minimizing state.

- **Parameters**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **child** | The widget below this widget in the tree. | `Widget` | |
| **canPop** | When in the minimizing state, is it allowed back to the desktop or not. | `bool` | |
| **onPopInvoked** | If you don't want to back to the desktop directly, you can customize the pop logic. | `void Function(bool isMinimizing)?` | `null` |
