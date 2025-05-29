## 3.16.2

- Update dependency

## 3.16.0

- Features
  - Add signalingPlugin to config to fix the issue of not receiving invitations again when exiting LIVE(please set uninitOnDispose to false) if using LIVE and call-invitation at the same time.
  - Support playing multimedia (video/audio) directly.
    - API: Add **defaultPlayer** in **ZegoUIKitPrebuiltLiveAudioRoomController().media**. play on default player through **sharing/show/hide** API
    - Config: Add **ZegoLiveAudioRoomMediaPlayerDefaultPlayerConfig** in **ZegoLiveAudioRoomMediaPlayerConfig**
  - Support the member-list button can be added to the top toolbar, which is not displayed by default and can be configured through **topMenuBar.buttons**.
  - Support the fully customizable function of the seat area, use **topLeft** positioning, specify the size by **containerSize**, and customize the seat display with **containerBuilder**

## 3.15.10

- Update dependency

## 3.15.9

- Bugs
  - Flutter version 3.29.0 Adaptation
  
## 3.15.8

- Update dependency

## 3.15.7

- Fix screen-sharing outside the app, remote pull-based streaming has no sound

## 3.15.6

- Update dependency

## 3.15.5

- Update dependency

## 3.15.4

- Update dependency

## 3.15.3

- Features
  - member-list button can be added to the top toolbar, which is not displayed by default.
- Update dependency

## 3.15.2

- Bugs
  - Catch and log crashes in certain scenes

## 3.15.1

- Update dependency

## 3.15.0

- Features
  - **ZegoUIKitPrebuiltLiveAudioRoomController().seat**
    - Added `isRoomSeatLocked` to determine if the seats of room has been locked
    - Added `isAHostSeatIndex` to determine if it is the seat specified in **ZegoUIKitPrebuiltLiveAudioRoomConfig.seat.hostIndexes**
  - **ZegoUIKitPrebuiltLiveAudioRoomConfig** add `popUpMenu` configuration
    - Through `seatClicked`, you can customize the pop-up menu when click the seat
      - The default menu can be hidden through `hiddenMenus`
      - Customize the extended menu on empty seats through `emptyExtendMenus`
      - Extended menus can be customized according to user role through `hostExtendMenus`/`coHostExtendMenus`/`speakerExtendMenus`/`audienceExtendMenus`

## 3.14.3

- Bugs
  - Fix the occasional crash of pip on some android machines

## 3.14.2

- Update dependency

## 3.14.1

- Bugs
  - hide pip logic in iOS, or an exception will occur

## 3.14.0

- Features
  - Support PIP(android only)


## 3.13.1

- Update dependency

## 3.13.0

- Features
  - Support **assignCoHost** by **ZegoUIKitPrebuiltLiveAudioRoomController.seat**

## 3.12.1

- Update dependency

## 3.12.0

- Features
  - You can customize the seating area position by setting `seat.topLeft` in `ZegoUIKitPrebuiltLiveAudioRoomConfig`

## 3.11.3

- Update dependency

## 3.11.2

- Support sound wave color by `ZegoUIKitPrebuiltLiveAudioRoomConfig.seat.soundWaveColor` 

## 3.11.1

- Update document

## 3.11.0

- Features
  - Support sync remote media volume by **isSyncToRemote** in **ZegoUIKitPrebuiltLiveAudioRoomController().media.setVolume** 

## 3.10.0

- Features
  - Support clear messages by `ZegoUIKitPrebuiltLiveAudioRoomController().message.clear()`


## 3.9.1

- Update dependency

## 3.9.0

- Features
  - Added `ZegoUIKitPrebuiltLiveAudioRoomMiniPopScope` to protect the interface from being destroyed when minimized
  - Added `license` in `ZegoBeautyPluginConfig` to setting license to beauty

## 3.8.1

- Update dependency

## 3.8.0

- Features
  - Support login by token 

## 3.7.6

- Optimization score warning

## 3.7.4

- Update dependency.
- ZegoInRoomMessage: The type of `messageID` is changed from **int** to **String**.💥 [breaking changes](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Migration_v3.x-topic.html#384)

## 3.7.3

- Update dependency.

## 3.7.2

- Update dependency.

## 3.7.1

- Update dependency.

## 3.7.0

- Features: 
  - Support specify the seat index when the audience take on seat by `ZegoUIKitPrebuiltLiveAudioRoomConfig.seat.takeIndexWhenAudienceRequesting`
  
## 3.6.7

- Update dependency.

## 3.6.6

- add `isForce` in `ZegoUIKitPrebuiltLiveAudioRoomController().seat.take`, Specify whether to force take seat when someone is on.

## 3.6.5

- Update dependency.

## 3.6.4

- Update dependency.

## 3.6.3

- Update dependency.

## 3.6.2

- Update dependency.

## 3.6.1

- Update dependency.

## 3.6.0

- Support to hide the top leave button by `ZegoLiveAudioRoomTopMenuBarConfig.showLeaveButton`
- Support to hide the bottom toolbar by `ZegoLiveAudioRoomBottomMenuBarConfig.visible`
- By setting the **showDialogConfirm** parameter to true in `ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.removeSpeaker`, the host can remove the speaker from the stage directly.

## 3.5.0

- Add `getEmptySeats` in `ZegoUIKitPrebuiltLiveAudioRoomController.seat`

## 3.4.0

- Add `hostRoleIcon`, `coHostRoleIcon` and `microphoneOffIcon` in `ZegoUIKitPrebuiltLiveAudioRoomConfig.seat` to support custom partial icons
- Add `keepOriginalForeground` in `ZegoUIKitPrebuiltLiveAudioRoomConfig.seat` to support keeping the original foreground when customizing foregroundBuilder
- Add `getSeatIndexByUserID` in `ZegoUIKitPrebuiltLiveAudioRoomController.seat` to get the user's seat index
- Fix `ZegoUIKitPrebuiltLiveAudioRoomController.muteStateNotifier` get wrong state when switching microphone scene

## 3.3.2

- Update dependency.

## 3.3.1

- Update dependency.

## 3.3.0

- Add `muteLocally` and `muteLocallyByUserID` to the `ZegoUIKitPrebuiltLiveAudioRoomController.seat`.

## 3.2.0

- Add `destroy` to the `ZegoUIKitPrebuiltLiveAudioRoomController.media`.
- Add `getUserByIndex` to the `ZegoUIKitPrebuiltLiveAudioRoomController.seat`.
- Add `mute` and `muteByUserID` to the `ZegoUIKitPrebuiltLiveAudioRoomController.seat.host`.

## 3.1.3

- Update document.

## 3.1.2

- Update document.

## 3.1.1

- >
> rename some parameter name in ZegoUIKitPrebuiltLiveAudioRoomConfig's constructor function
> 💥 [breaking changes](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Migration_v3.x-topic.html#311)

- Add configs document

## 3.1.0

- Support scrolling on layout. When the number of seats exceeds the screen width or height, the seats area will be displayed by scrolling (horizontally or vertically).

## 3.0.0

- >
>
> The 3.0 version has standardized and optimized the API and Event, simplifying the usage of most APIs.
>
> Most of the changes involve modifications to the calling path, such as changing from ZegoUIKitPrebuiltLiveAudioRoomController().isMinimizing() to ZegoUIKitPrebuiltLiveAudioRoomController()
> .minimize.isMinimizing.
>
> 💥 [breaking changes](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Migration_v3.x-topic.html#30)

- Support user/room/audioVideo series events

## 2.18.1

- Update dependency.

## 2.18.0

- Add SEI API in `controller.audioVideo`

## 2.17.0

- Add media player config

## 2.16.3

- Update dependency.

## 2.16.2

- Update dependency.

## 2.16.1

- Update dependency.

## 2.16.0

- add minimize APIs in ZegoLiveAudioRoomController
- make ZegoLiveAudioRoomController be a singleton instance class

## 2.15.2

- fix the issue of the controller not being able to select MP3 files.

## 2.15.1

- Update dependency.

## 2.15.0

- Support leave in minimize state, if you don't want to display the leave button, you can hide it by setting **showLeaveButton** to false.

## 2.14.1

- fix some UI issues

## 2.14.0

- ZegoUIKitPrebuiltLiveAudioRoomConfig adds the emptyAreaBuilder, and ZegoLiveAudioRoomController adds the getSeatsUserMapNotifier method.

## 2.13.7

- Update dependency.

## 2.13.6

- Update dependency.

## 2.13.5

- Fixing the issue of **seatConfig.showSoundWaveInAudioMode** parameter malfunction.

## 2.13.4

- Compatible with AppLifecycleState.hidden in flutter 3.13.0

## 2.13.3

- update dart dependency

## 2.13.2

- Optimization warnings from analysis

## 2.13.1

- Optimization warnings from analysis

## 2.13.0

- Support listening for errors in the beauty and signaling plugins and uikit library.

## 2.12.0

- Support close/open specific seat by **targetIndex** closeSeats/openSeats of controller

## 2.11.4

- update dart dependency

## 2.11.3

- remove http library dependency.

## 2.11.2

- Update dependency.

## 2.11.1

- Update dependency.

## 2.11.0

- Add a member list configuration, you can customize the member list item view by using **ZegoMemberListConfig.itemBuilder**, and listen for click events through **ZegoMemberListConfig.onClicked**.

## 2.10.0

- Add **advanceConfigs** config, which to set advanced engine configuration

## 2.9.2

- update dependency

## 2.9.1

- update dependency

## 2.9.0

- Added notifications for click and long-press events in the chat message, which can be monitored through **ZegoInRoomMessageConfig.onMessageClick** and **ZegoInRoomMessageConfig.onMessageLongPress**.
- Added handling for local message sending failures. When a local message fails to send, it can be retried by clicking the icon. The icon can be customized through **
  ZegoInRoomMessageConfig.resendIcon**.
- Added avatar display to messages by default. If avatars are not desired, they can be hidden through **ZegoInRoomMessageConfig.showAvatar**.
- Added message sending and receiving API to the controller.
- Adjusted the message display to default to showing the entire content. If not all content needs to be displayed, the maximum number of displayed lines can be modified through
  **ZegoInRoomMessageConfig.maxLines**. When the maximum number of lines is exceeded, the message will automatically collapse.
- Supported customizing the location of the message display container. The offset value of the bottom left corner can be set through **ZegoInRoomMessageConfig.bottomLeft** to adjust the position.
- Support set chat background by **ZegoInRoomMessageConfig.background**.

## 2.8.5

- Adjusted the message display to default to showing the entire content. If not all content needs to be displayed, the maximum number of displayed lines can be modified through
  **ZegoInRoomMessageConfig.maxLines**. When the maximum number of lines is exceeded, the message will automatically collapse.
- Added avatar display to messages by default. If avatars are not desired, they can be hidden through **ZegoInRoomMessageConfig.showAvatar**.

## 2.8.4

- Fixed the issue of not receiving calls when prebuilt_call is used in conjunction with prebuilt_live_audio_room.

## 2.8.3

- Fix the black screen issue when sharing media on iOS.

## 2.8.2

- Update dependencies

## 2.8.1

- support mute local media volume

## 2.8.0

- support media sharing

## 2.7.1

- Update dependencies

## 2.7.0

- Add a "leave" method to the controller that allows for actively leave the current live.

## 2.6.2

- Optimizing timing function.

## 2.6.1

- Fixed the issue where users were kicked out when both camera and microphone permissions were not denied but the permission dialog could not be dismissed.

## 2.6.0

- Support server-based timing

## 2.5.0

- Support host remove audience or speaker from audio room.

## 2.4.15

- Update dependencies

## 2.4.14

- fix the issue of conflict with extension key of the `flutter_screenutil` package.

## 2.4.13

- fix some user login status issues when used `zego_uikit_prebuilt_live_audio_room` with `zego_zimkit`

## 2.4.12

- Update dependencies

## 2.4.11

- Update Readme

## 2.4.10

- Update comments

## 2.4.9

- deprecate flutter_screenutil_zego package

## 2.4.8

- Fix some issues of co-hosts

## 2.4.7

- support the host in setting co-hosts.

## 2.4.6

- support hide users in member-list

## 2.4.4

- Update dependencies

## 2.4.3

- Fix some issues

## 2.4.2

- mark 'appDesignSize' as Deprecated

## 2.4.1

- Update dependencies

## 2.4.0

- To differentiate the 'appDesignSize' between the App and ZegoUIKitPrebuiltLiveAudioRoom, we introduced the 'flutter_screenutil_zego' library and removed the 'appDesignSize' parameter from the
  ZegoUIKitPrebuiltLiveAudioRoom that was previously present.

## 2.3.1

- Fixed the issue of frequent restoration and minimizing the UI, which triggered the interface rate limit.

## 2.3.0

- supports in-app minimization.

## 2.2.3

- fixed appDesignSize for ScreenUtil that didn't work

## 2.2.2

- fixed avatarURL occasionally not working
- seat config adds foreground color/openIcon/closeIcon configuration options
- controller adds a take seat method
- add assert to key parameters to ensure prebuilt run normally

## 2.2.1

- move controller's callbacks to config
- add turnMicrophoneOn function in controller
- fixed an issue where the avatar was not visible when the microphone was off
- support RTL text direction
- add voice effect text customization

## 2.2.0

- support avatar url setting
- support user in-room attributes setting
- add user count update notify
- add user attribute update notify
- fix some bugs

## 2.1.1

- add more callbacks

## 2.1.0

- support request to take seat
- support lock/unlock seat
- support mute users
- support custom click event of the seat
- support custom background
- support custom message list item
- support hide message view

## 2.0.1

- fix cancel related issue.

## 2.0.0

- Architecture upgrade based on adapter.

## 1.0.8

* downgrade flutter_screenutil to ">=5.5.3+2 <5.6.1"

## 1.0.7

* fix bugs
* update resources
* update a dependency to the latest release
* support sdk log

## 1.0.6

* update a dependency to the latest release

## 1.0.5

* fix some bugs
* update a dependency to the latest release

## 1.0.4

* fix some bugs
* add custom background feature

## 1.0.3

* update a dependency to the latest release

## 1.0.2

* fix some bugs
* support more layout

## 1.0.1

* fix some bugs

## 1.0.0

* upload initial release.
