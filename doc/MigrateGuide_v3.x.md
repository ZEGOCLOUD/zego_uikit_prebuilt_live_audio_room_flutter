
>
> This document aims to help users understand the APIs changes and feature improvements, and provide a migration guide for the upgrade process.
>
> <br />
>
> It is an `incompatible change` if marked with `breaking changes`.
> All remaining changes is compatible and uses the deprecated prompt. Of course, it will also be completely abandoned in the version after a certain period of time.
>
> <br />
>
> You can run this command in `the root directory of your project` to output warnings and partial error prompts to assist you in finding deprecated parameters/functions or errors after upgrading.
> ```shell
> dart analyze | grep zego
> ```


<br />
<br />

# Versions

- [3.1.1](#311)  **(💥 breaking changes)**
- [3.0](#30)  **(💥 breaking changes)**


<br />
<br />

# 3.1.1
---

# Introduction

>
> In this migration guide, we will explain how to upgrade from version 3.1.0 to the latest 3.1.1 version. 

# Major Interface Changes


## ZegoUIKitPrebuiltLiveAudioRoom

- rename parameters in construtor  **(💥 breaking changes)**

>
> <details>
> <summary>Compatibility Guide</summary>
> <pre><code>
>
>
>  Modify your code based on the following guidelines to make it compatible with version 3.1.1:
>
> 3.1.0 Version Code:
>
>```dart
>
>ZegoUIKitPrebuiltLiveAudioRoomConfig(
>    ...
>    messageConfig: ZegoLiveAudioRoomInRoomMessageConfig(...), 
>    effectConfig: ZegoLiveAudioRoomAudioEffectConfig(...), 
>    mediaPlayerConfig: ZegoLiveAudioRoomMediaPlayerConfig(...), 
>    backgroundMediaConfig: ZegoLiveAudioRoomBackgroundMediaConfig(...), 
>);
>
>```
>
>3.1.1 Version Code:
>
> ```dart
> /// Example code in version 3.0
>
>ZegoUIKitPrebuiltLiveAudioRoomConfig(
>    ...
>    message: ZegoLiveAudioRoomInRoomMessageConfig(...), 
>    effect: ZegoLiveAudioRoomAudioEffectConfig(...), 
>    mediaPlayer: ZegoLiveAudioRoomMediaPlayerConfig(...), 
>    backgroundMedia: ZegoLiveAudioRoomBackgroundMediaConfig(...), 
>);
>```
>
> </code></pre>
>
> </details>


<br />
<br />

# 3.0
---

>
>
> The 3.0 version has standardized and optimized the [API](APIs-topic.html) and [Event](Events-topic.html), simplifying the usage of most APIs.
>
> Most of the changes involve modifications to the calling path, such as changing from `ZegoUIKitPrebuiltLiveAudioRoomController().isMinimizing()` to `ZegoUIKitPrebuiltLiveAudioRoomController().minimize.isMinimizing`.
>
> After upgrading the live audio room kit, you can refer to the directory index to see how specific APIs from the old version can be migrated to the new version.


---

- [ZegoUIKitPrebuiltLiveAudioRoom](#zegouikitprebuiltliveaudioroom)
- [ZegoUIKitPrebuiltLiveAudioRoomController](#zegouikitprebuiltliveaudioroomcontroller)
- [ZegoUIKitPrebuiltLiveAudioRoomConfig](#zegouikitprebuiltliveaudioroomconfig)
- Deprecated Removed
  - ZegoUIKitPrebuiltLiveAudioRoom
    - remove `appDesignSize`


# Introduction

> In this migration guide, we will explain how to upgrade from version 2.x to the latest 3.0 version.
>

# Major Interface Changes

## ZegoUIKitPrebuiltLiveAudioRoom

- remove `controller`  **(💥 breaking changes)**
- add `events(ZegoUIKitPrebuiltLiveAudioRoomEvents)`  **(💥 breaking changes)**

>
> 

- rename parameters in construtor    **(💥 breaking changes)**

>
> <details>
> <summary>Compatibility Guide</summary>
> <pre><code>
>
>
>  Modify your code based on the following guidelines to make it compatible with version 3.0:
>
> 2.x Version Code:
>
>```dart
>
>ZegoUIKitPrebuiltLiveAudioRoomConfig(
>    seatConfig: ZegoLiveAudioRoomSeatConfig(...), 
>    topMenuBarConfig: ZegoLiveAudioRoomTopMenuBarConfig(...), 
>    bottomMenuBarConfig: ZegoLiveAudioRoomBottomMenuBarConfig(...), 
>    layoutConfig: ZegoLiveAudioRoomLayoutConfig(...), 
>    messageConfig: ZegoLiveAudioRoomInRoomMessageConfig(...), 
>    memberListConfig: ZegoLiveAudioRoomMemberListConfig(...), 
>    effectConfig: ZegoLiveAudioRoomAudioEffectConfig(...), 
>    durationConfig: ZegoLiveAudioRoomLiveDurationConfig(...), 
>    mediaPlayerConfig: ZegoLiveAudioRoomMediaPlayerConfig(...), 
>    backgroundMediaConfig: ZegoLiveAudioRoomBackgroundMediaConfig(...), 
>);
>
>```
>
>3.0 Version Code:
>
> ```dart
> /// Example code in version 3.0
>
>ZegoUIKitPrebuiltLiveAudioRoomConfig(
>    seat: ZegoLiveAudioRoomSeatConfig(...), 
>    topMenuBar: ZegoLiveAudioRoomTopMenuBarConfig(...), 
>    bottomMenuBar: ZegoLiveAudioRoomBottomMenuBarConfig(...), 
>    layout: ZegoLiveAudioRoomLayoutConfig(...), 
>    message: ZegoLiveAudioRoomInRoomMessageConfig(...), 
>    memberList: ZegoLiveAudioRoomMemberListConfig(...), 
>    effect: ZegoLiveAudioRoomAudioEffectConfig(...), 
>    duration: ZegoLiveAudioRoomLiveDurationConfig(...), 
>    mediaPlayer: ZegoLiveAudioRoomMediaPlayerConfig(...), 
>    backgroundMedia: ZegoLiveAudioRoomBackgroundMediaConfig(...), 
>);
>```
>
> </code></pre>
>
> </details>

    
## ZegoUIKitPrebuiltLiveAudioRoomController

>
> we have categorized the APIs according to functional modules, the API calling path looks like `ZegoUIKitPrebuiltLiveAudioRoomController().module.function()`

- move **turnMicrophoneOn** to `audioVideo.microphone.turnOn`
- seat
  - move **localIsAHost** to `seat.localIsHost`
  - move **localIsAAudience** to `seat.localIsAudience`
  - move **localIsCoHost** to `seat.localIsCoHost`
  - move **localHasHostPermissions** to `seat.localHasHostPermissions`
  - move **getSeatsUserMapNotifier** to `seat.seatsUserMapNotifier`
  - move **openSeats** to `seat.openSeats`
  - move **closeSeats** to `seat.host.close`
  - move **removeSpeakerFromSeat** to `seat.host.removeSpeaker`
  - move **acceptSeatTakingRequest** to `seat.host.acceptTakingRequest`
  - move **rejectSeatTakingRequest** to `seat.host.rejectTakingRequest`
  - move **inviteAudienceToTakeSeat** to `seat.host.inviteToTake`
  - move **leaveSeat** to `seat.speaker.leave`
  - move **takeSeat** to `seat.audience.take`
  - move **applyToTakeSeat** to `seat.audience.applyToTake`
  - move **cancelSeatTakingRequest** to `seat.audience.cancelTakingRequest`
  - move **acceptHostTakeSeatInvitation** to `seat.audience.acceptTakingInvitation`
- media
  - move **getVolume** to `volume`
  - move **getTotalDuration** to `totalDuration`
  - move **getCurrentProgress** to `currentProgress`
  - move **getType** to `type`
  - move **getVolumeNotifier** to `volumeNotifier`
  - move **getCurrentProgressNotifier** to `currentProgressNotifier`
  - move **getPlayStateNotifier** to `playStateNotifier`
  - move **getMediaTypeNotifier** to `typeNotifier`
  - move **getMediaInfo** to `info`

## ZegoUIKitPrebuiltLiveAudioRoomConfig

### class Name
- rename **ZegoInnerText** to `ZegoUIKitPrebuiltLiveAudioRoomInnerText`
- rename **ZegoMenuBarButtonName** to `ZegoLiveAudioRoomMenuBarButtonName`
- rename **ZegoDialogInfo** to `ZegoLiveAudioRoomDialogInfo`
- rename **ZegoTopMenuBarConfig** to `ZegoLiveAudioRoomTopMenuBarConfig`
- rename **ZegoBottomMenuBarConfig** to `ZegoLiveAudioRoomBottomMenuBarConfig`
- rename **ZegoInRoomMessageConfig** to `ZegoLiveAudioRoomInRoomMessageConfig`
- rename **ZegoMemberListConfig** to `ZegoLiveAudioRoomMemberListConfig`
- rename **ZegoAudioEffectConfig** to `ZegoLiveAudioRoomAudioEffectConfig`
- rename **ZegoLiveDurationConfig** to `ZegoLiveAudioRoomLiveDurationConfig`
- rename **ZegoMediaPlayerConfig** to `ZegoLiveAudioRoomMediaPlayerConfig`
- rename **ZegoBackgroundMediaConfig** to `ZegoLiveAudioRoomBackgroundMediaConfig`

### variable name
- rename **topMenuBarConfig** to `topMenuBar`
- rename **bottomMenuBarConfig** to `bottomMenuBar`
- rename **inRoomMessageConfig** to `inRoomMessage`
- rename **memberListConfig** to `memberList`
- rename **audioEffectConfig** to `audioEffect`
- rename **durationConfig** to `duration`
- rename **mediaPlayerConfig** to `mediaPlayer`
- rename **backgroundMediaConfig** to `backgroundMedia`
- seat
  - move **takeSeatIndexWhenJoining** to `seat`
  - move **closeSeatsWhenJoining** to `seat`
  - move **hostSeatIndexes** to `seat`
  - move **layoutConfig** to `seat.layout`

### event (move event to ZegoUIKitPrebuiltLiveAudioRoomEvents)  **(💥 breaking changes)**

>
> - move **onError** to `ZegoUIKitPrebuiltLiveAudioRoomEvents`
> - move **onLeaveConfirmation** to `ZegoUIKitPrebuiltLiveAudioRoomEvents`
> - move **onMicrophoneTurnOnByOthersConfirmation** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.audioVideo`
> - move **onMemberListMoreButtonPressed** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.memberList` and rename `onMoreButtonPressed`
> - move **onUserCountOrPropertyChanged** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.user` and rename `onCountOrPropertyChanged`
> - ZegoInRoomMessageConfig
>     - move **onMessageClick** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.memberList` and rename `onClicked`
>     - move **onMessageLongPress** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.memberList` and rename `onLongPress`
> - ZegoMemberListConfig
>     - move **onClicked** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.memberList`
> - ZegoLiveDurationConfig
>     - move **onDurationUpdate** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.duration` and rename `onUpdated`
>
>
> <details>
> <summary>Compatibility Guide</summary>
> <pre><code>
>
>
>  Modify your code based on the following guidelines to make it compatible with version 3.0:
>
>  2.x Version Code:
>
> ```dart
> /// Example code in version 2.x
> 
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   config: ZegoUIKitPrebuiltLiveAudioRoomConfig()
>     ..onLeaveConfirmation = (context) {
>       //
>     }
>     ..onMicrophoneTurnOnByOthersConfirmation = (context) async {
>       return true;
>     }
>     ..onUserCountOrPropertyChanged = (users) {
>       //
>     }
>     ..onMemberListMoreButtonPressed = (user) {
>       //
>     }
>     ..memberListConfig.onClicked = (user) {
>       //
>     }
>     ..inRoomMessageConfig.onMessageClick = (message) {
>       //
>     }
>     ..inRoomMessageConfig.onMessageLongPress = (message) {
>       //
>     }
>     ..durationConfig.onDurationUpdate = (duration) {
>       //
>     },
>   ...
> );
> 
> ```
>
> 3.0 Version Code:
>
> ```dart
> /// Example code in version 3.0
> 
> 
> ZegoUIKitPrebuiltLiveAudioRoom(
>     events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       onLeaveConfirmation: (
>         ZegoLiveAudioRoomLeaveConfirmationEvent event,
>         /// defaultAction to return to the previous page
>         Future<bool> Function() defaultAction,
>       ) {
>         debugPrint('onLeaveConfirmation, do whatever you want');
>        
>         /// you can call this defaultAction to return to the previous page,
>         return defaultAction.call();
>       },
>       audioVideo: ZegoLiveAudioRoomRoomEvents(
>         onMicrophoneTurnOnByOthersConfirmation: (context){
> 
>         },
>       ),
>       user: ZegoLiveAudioRoomUserEvents(
>         //  onUserCountOrPropertyChanged
>         onCountOrPropertyChanged: (context){
> 
>         },
>       ),
>       memberList: ZegoLiveAudioRoomMemberListEvents(
>         onClicked: (user){
> 
>         },
>         //  onMemberListMoreButtonPressed
>         onMoreButtonPressed: (user){
> 
>         },
>       ),
>       inRoomMessage: ZegoLiveAudioRoomInRoomMessageEvents(
>         onClicked: (message){
> 
>         },
>         onLongPress: (message){
> 
>         },
>       ),
>       duration: ZegoLiveAudioRoomDurationEvents(
>         onUpdated: (duration){
> 
>         },
>       ),
>     ),
>     ...
> );
> ```
>
> </code></pre>
>
> </details>
>
> <br />
>
> - seat  **(💥 breaking changes)**
>     - move **onSeatClosed** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat` and rename `onClosed`
>     - move **onSeatsOpened** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat` and rename `onOpened`
>     - move **onSeatClicked** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat` and rename `onClicked`
>     - move **onSeatsChanged** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat` and rename `onChanged`
>     - host
>         - move **onSeatTakingRequested** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat.host` and rename `onTakingRequested`
>         - move **onSeatTakingRequestCanceled** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat.host` and rename `onTakingRequestCanceled`
>         - move **onInviteAudienceToTakeSeatFailed** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat.host` and rename `onTakingInvitationFailed`
>         - move **onSeatTakingInviteRejected** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat.host` and rename `onTakingInvitationRejected`, and add a `ZegoUIKitUser audience` parameter which mean who reject
>     - audience
>         - move **onSeatTakingRequestFailed** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat.audience` and rename `onTakingRequestFailed`
>         - move **onSeatTakingRequestRejected** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat.audience` and rename `onTakingRequestRejected`
>         - move **onHostSeatTakingInviteSent** to `ZegoUIKitPrebuiltLiveAudioRoomEvents.seat.audience` and rename `onTakingInvitationReceived`
>
>
> <details>
> <summary>Compatibility Guide</summary>
> <pre><code>
>
>
>  Modify your code based on the following guidelines to make it compatible with version 3.0:
>
>  2.x Version Code:
>
> ```dart
> /// Example code in version 2.x
> 
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   config: ZegoUIKitPrebuiltLiveAudioRoomConfig()
>     ..onSeatClosed = () {
>       //
>     }
>     ..onSeatsOpened = () {
>       //
>     }
>     ..onSeatClicked = (int index, ZegoUIKitUser? user) {
>       //
>     }
>     ..onSeatsChanged = (Map<int, ZegoUIKitUser> takenSeats, List<int> untakenSeats) {
>       //
>     }
>     ..onSeatTakingRequested = (audience) {
>       //
>     }
>     ..onSeatTakingRequestCanceled = (audience) {
>       //
>     }
>     ..onInviteAudienceToTakeSeatFailed = () {
>       //
>     }
>     ..onSeatTakingInviteRejected = () {
>       //
>     }
>     ..onSeatTakingRequestFailed = () {
>       //
>     }
>     ..onSeatTakingRequestRejected = () {
>       //
>     }
>     ..onHostSeatTakingInviteSent = () {
>       //
>     }
>   ...
> );
> 
> ```
>
> 3.0 Version Code:
>
> ```dart
> /// Example code in version 3.0
> 
> 
> ZegoUIKitPrebuiltLiveAudioRoom(
>     events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>         onClosed: (){
> 
>         },
>         onOpened: (){
> 
>         },
>         onClicked: (int index, ZegoUIKitUser? user){
> 
>         },
>         onChanged: (Map<int, ZegoUIKitUser> takenSeats, List<int> untakenSeats){
> 
>         },
>         host: ZegoLiveAudioRoomSeatHostEvents(
>            onTakingRequested: (audience){
>                
>            },
>            onTakingRequestCanceled: (audience){
>                
>            },
>            onTakingInvitationFailed: (){
>                
>            },
>            onTakingInvitationRejected: (audience){
>                
>            },
>         ),
>         audience: ZegoLiveAudioRoomSeatAudienceEvents(
>            onTakingRequestFailed: (){
>                
>            },
>            onTakingRequestRejected: (){
>                
>            },
>            onTakingInvitationReceived: (){
>                
>            },
>         ),
>       ),
>     ),
>     ...
> );
> ```
>
> </code></pre>
>
> </details>
>
> <br />
>
> - onLeaveLiveAudioRoom/onMeRemovedFromRoom  **(💥 breaking changes)**
>   - move **onLeaveLiveAudioRoom** from **ZegoUIKitPrebuiltLiveAudioRoomConfig** to  `ZegoUIKitPrebuiltLiveAudioRoomEvents.onEnded`(ZegoLiveAudioRoomEndEvent(reason:ZegoLiveAudioRoomEndReason.`localLeave`), defaultAction)
>   - move **onMeRemovedFromRoom** from **ZegoUIKitPrebuiltLiveAudioRoomConfig** to  `ZegoUIKitPrebuiltLiveAudioRoomEvents.onEnded`(ZegoLiveAudioRoomEndEvent(reason:ZegoLiveAudioRoomEndReason.`kickOut`), defaultAction)
>
> Due to the fact that all three events indicate the end of a live audio room, they will be consolidated into `ZegoUIKitPrebuiltLiveAudioRoomEvents.onEnded` and differentiated by the `ZegoLiveAudioRoomEndEvent.reason`.
>
> And you can use `defaultAction.call()` to perform the internal default action, which returns to the previous page.
>
>
> <details>
> <summary>Compatibility Guide</summary>
> <pre><code>
>
>
>  Modify your code based on the following guidelines to make it compatible with version 3.0:
>
>  2.x Version Code:
>
> ```dart
> /// Example code in version 2.x
> 
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   config: ZegoUIKitPrebuiltLiveAudioRoomConfig()
>     ..onLeaveLiveAudioRoom = (isFromMinimizing) {
>       //
>     }
>     ..onMeRemovedFromRoom = (fromUserID) {
>       //
>     }
>   ...
> );
> 
> ```
>
> 3.0 Version Code:
>
> ```dart
> /// Example code in version 3.0
> 
> 
> ZegoUIKitPrebuiltLiveAudioRoom(
>     events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       onEnded: (
>         ZegoLiveAudioRoomEndEvent event,
>         /// defaultAction to return to the previous page
>         Future<bool> Function() defaultAction,
>       ) {
>         debugPrint('onLeaveConfirmation, do whatever you want');
>        
>         /// you can call this defaultAction to return to the previous page,
>         return defaultAction.call();
>       },
>     ),
>     ...
> );
> ```
>
> </code></pre>
>
> </details>

# Others

- Class Name
  - rename **LiveAudioRoomMiniOverlayPageState** to `ZegoLiveAudioRoomMiniOverlayPageState`

<br />
<br />
<br />
<br />
<br />

# Feedback Channels

>
>If you encounter any issues or have any questions during the migration process, please provide feedback through the following channels:
>
>- GitHub Issues: [Link to the project's issue page](https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_live_audio_room_example_flutter/issues)
>- Forum: [Link to the forum page](https://www.zegocloud.com/)


We appreciate your feedback and are here to help you successfully complete the migration process.
