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
- Added handling for local message sending failures. When a local message fails to send, it can be retried by clicking the icon. The icon can be customized through **ZegoInRoomMessageConfig.resendIcon**.
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
