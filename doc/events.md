- [onLeaveConfirmation](#onleaveconfirmation)
- [onEnded](#onended)
- [onError](#onerror)
- [seat](#seat)
    - [onClosed](#onclosed)
    - [onOpened](#onopened)
    - [onClicked](#onclicked)
    - [onChanged](#onchanged)
        - [host](#host)
            - [onTakingRequested](#ontakingrequested)
            - [onTakingRequestCanceled](#ontakingrequestcanceled)
            - [onTakingInvitationFailed](#ontakinginvitationfailed)
            - [onTakingInvitationRejected](#ontakinginvitationrejected)
        - [audience](#audience)
            - [onTakingRequestFailed](#ontakingrequestfailed)
            - [onTakingRequestRejected](#ontakingrequestrejected)
            - [onTakingInvitationReceived](#ontakinginvitationreceived)
- [user](#ZegoUIKitPrebuiltLiveAudioRoomuserevents)
    - [onEnter](#onenter)
    - [onLeave](#onleave)
    - [onCountOrPropertyChanged](#oncountorpropertychanged)
- [room](#ZegoUIKitPrebuiltLiveAudioRoomroomevents)
    - [onStateChanged](#onstatechanged)
- [audioVideo](#ZegoUIKitPrebuiltLiveAudioRoomaudiovideoevents)
    - [onMicrophoneStateChanged](#onmicrophonestatechanged)
    - [onAudioOutputChanged](#onaudiooutputchanged)
    - [onMicrophoneTurnOnByOthersConfirmation](#onmicrophoneturnonbyothersconfirmation)
- [memberList](#zegoliveaudioroommemberlistevents)
    - [onClicked](#onclicked-2)
    - [onMoreButtonPressed](#onmorebuttonpressed)
- [inRoomMessage](#zegoliveaudioroominroommessageevents)
    - [onClicked](#onclicked-3)
    - [onLongPress](#onlongpress)
- [duration](#zegoliveaudioroomdurationevents)
    - [onUpdated](#onupdated)

---

# onLeaveConfirmation

>
> Confirmation callback method before leaving the audio chat room.
>
> If you want to perform more complex business logic before exiting the
audio chat room, such as updating some records to the backend, you can use the [onLeaveConfirmation] parameter to set it.
> This parameter requires you to provide a callback method that returns an
asynchronous result.
> If you return true in the callback, the prebuilt page will quit and
return to your previous page, otherwise it will be ignored.
>
>- function prototype:
>```dart
> Future<bool> Function(
>   ZegoLiveAudioRoomLeaveConfirmationEvent event,
>   /// defaultAction to return to the previous page
>   Future<bool> Function() defaultAction,
> )? onLeaveConfirmation;
>
>class ZegoLiveAudioRoomLeaveConfirmationEvent {
>  BuildContext context;
>}
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     onLeaveConfirmation: (
>       ZegoLiveAudioRoomLeaveConfirmationEvent event,
>       VoidCallback defaultAction,
>     ) {
>         debugPrint('onLeaveConfirmation, do whatever you want');
>         
>         /// you can call this defaultAction to return to the previous page,
>         return defaultAction.call();
>     },
>   ),
>   ...
> );
>```

# onEnded

>
> This callback method is called when live audio room ended
>
> The default behavior of host is return to the previous page(only host) or
hide the minimize page.
> If you override this callback, you must perform the page navigation
> yourself while it was in a normal state, or hide the minimize page if in
minimize state.
> otherwise the user will remain on the live streaming page.
> the easy way is call `defaultAction.call()`
>
> The [ZegoLiveAudioRoomEndEvent.isFromMinimizing] it means that the user
left the chat room while it was in a minimized state.
> You **can not** return to the previous page while it was **in a minimized
state**!!!
> On the other hand, if the value of the parameter is false, it means that
the user left the chat room while it was in a normal state (i.e., not minimized).
>
>- function prototype:
>```dart
> void Function(
>   ZegoLiveAudioRoomEndEvent event,
>   VoidCallback defaultAction,
> )? onEnded;
>
>class ZegoLiveAudioRoomEndEvent {
>  /// the user ID of who kick you out
>  String? kickerUserID;
>
>  /// end reason
>  ZegoLiveAudioRoomEndReason reason;
>
>  /// The [isFromMinimizing] it means that the user left the live streaming
>  /// while it was in a minimized state.
>  ///
>  /// You **can not** return to the previous page while it was **in a minimized state**!!!
>  /// just hide the minimize page by [ZegoUIKitPrebuiltLiveStreamingController().minimize.hide()]
>  ///
>  /// On the other hand, if the value of the parameter is false, it means
>  /// that the user left the live streaming while it was not minimized.
>  bool isFromMinimizing;
>}
>
>/// The default behavior is to return to the previous page.
>///
>/// If you override this callback, you must perform the page navigation
>/// yourself to return to the previous page!!!
>/// otherwise the user will remain on the current call page !!!!!
>enum ZegoLiveAudioRoomEndReason {
>  /// local user leave
>  localLeave,
>
>  /// being kicked out
>  kickOut,
>}
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     onEnded: (
>       ZegoLiveAudioRoomEndEvent event,
>       VoidCallback defaultAction,
>     ) {
>         debugPrint('onEnded, do whatever you want');
>         
>         /// you can call this defaultAction to return to the previous page,
>         return defaultAction.call();
>     },
>   ),
>   ...
> );
>```

# onError

>
> error stream
>
>- function prototype:
>```dart
>Function(ZegoUIKitError)? onError
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     onError: (
>       ZegoUIKitError error,
>     ) {
>     },
>   ),
>   ...
> );
>```

# ZegoLiveAudioRoomSeatEvents

> events about seats

### onClosed

>
> Notification that a seat has been closed (locked).
> After closing a seat, audience members need to request permission from
the host to join the seat, or the host can invite audience members directly.
>
>- function prototype:
>```dart
>VoidCallback? onClosed
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           onClosed: () {
>               ...
>           },
>       ),
>   ),
>);
>```

### onOpened

>
> Notification that a seat has been opened (unlocked).
> After opening a seat, all audience members can freely choose an empty
seat to join and start chatting with others.
>
>- function prototype:
>```dart
>VoidCallback? onOpened;
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           onOpened: () {
>               ...
>           },
>       ),
>   ),
>);
>```

### onClicked

>
> A callback function that is called when a seat is clicked.
>
> The [index] parameter is the index of the seat that was clicked.
> The [user] parameter is the user who is currently sitting in the seat, or
`null` if the seat is empty.
>
> Note that when you set this callback, the **default behavior** of
clicking on a seat to display a menu **will be disabled**.
> You need to handle it yourself.
> You can refer to the usage of [ZegoUIKitPrebuiltLiveAudioRoomController] for reference.
>
>- function prototype:
>```dart
>void Function(int index, ZegoUIKitUser? user)? onClicked
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           onClicked: (int index, ZegoUIKitUser? user) {
>               ...
>           },
>       ),
>   ),
>);
>```

### onChanged

>
> A callback function that is called when someone gets on/off/switches seat
>
> The [takenSeats] parameter is a map that maps the index of each taken
seat to the user who is currently sitting in that seat.
> The [untakenSeats] parameter is a list of the indexes of all untaken seats.
>
>- function prototype:
>```dart
>  void Function(
>   Map<int, ZegoUIKitUser> takenSeats,
>   List<int> untakenSeats,
> )? onChanged;
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           onChanged: (Map<int, ZegoUIKitUser> takenSeats, List<int> untakenSeats) {
>               ...
>           },
>       ),
>   ),
>);
>```

## host

> events about seat's host

### onTakingRequested

>
> The host has received a seat request from an `audience`.
>
>- function prototype:
>```dart
>void Function(ZegoUIKitUser audience)? onTakingRequested
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           host: ZegoLiveAudioRoomSeatHostEvents(
>               onTakingRequested: (audience){
>                   ...
>               },
>           ),
>       ),
>   ),
>);
>```

### onTakingRequestCanceled

>
> The host has received a notification that the `audience` has canceled the seat request.
>
>- function prototype:
>```dart
>void Function(ZegoUIKitUser audience)? onTakingRequestCanceled
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           host: ZegoLiveAudioRoomSeatHostEvents(
>               onTakingRequestCanceled: (audience){
>                   ...
>               },
>           ),
>       ),
>   ),
>);
>```

### onTakingInvitationFailed

>
> The host has received a notification that the invitation for the audience
to take a seat has failed.
> This is usually due to network issues or if the audience has already
logged out of the app and can no longer receive the invitation.
>
>- function prototype:
>```dart
>VoidCallback? onTakingInvitationFailed
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           host: ZegoLiveAudioRoomSeatHostEvents(
>               onTakingInvitationFailed: (){
>                   ...
>               },
>           ),
>       ),
>   ),
>);
>```

### onTakingInvitationRejected

>
> The host has received a notification that the invitation for the audience to take a seat has been rejected.
>
>- function prototype:
>```dart
>VoidCallback? onTakingInvitationRejected
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           host: ZegoLiveAudioRoomSeatHostEvents(
>               onTakingInvitationRejected: (){
>                   ...
>               },
>           ),
>       ),
>   ),
>);
>```

## audience

> events about seat's audience

### onTakingRequestFailed

>
> The audience has received a notification that the application to take a
seat has failed.
> This is usually due to network issues or the host has logged out of the
app and can no longer receive seat applications.
>
>- function prototype:
>```dart
>VoidCallback? onTakingRequestFailed;
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           audience: ZegoLiveAudioRoomSeatAudienceEvents(
>               onTakingRequestFailed: (){
>                   ...
>               },
>           ),
>       ),
>   ),
>);
>```

### onTakingRequestRejected

>
> The audience received a notification that their request to take seats was declined by the host.
>
>- function prototype:
>```dart
>VoidCallback? onTakingRequestRejected
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           audience: ZegoLiveAudioRoomSeatAudienceEvents(
>               onTakingRequestRejected: (){
>                   ...
>               },
>           ),
>       ),
>   ),
>);
>```

### onTakingInvitationReceived

>
> The audience has received a notification that the host has invited them to take a seat.
>
>- function prototype:
>```dart
>VoidCallback? onTakingInvitationReceived
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       seat: ZegoLiveAudioRoomSeatEvents(
>           audience: ZegoLiveAudioRoomSeatAudienceEvents(
>               onTakingInvitationReceived: (){
>                   ...
>               },
>           ),
>       ),
>   ),
>);
>```

# ZegoLiveAudioRoomUserEvents

> events about user

## onEnter

>
> This callback is triggered when user enter
>
>- function prototype:
>```dart
>void Function(ZegoUIKitUser)? onEnter;
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       user: ZegoLiveAudioRoomUserEvents(
>           onEnter: (user) {
>               ...
>           },
>       ),
>   ),
>);
>```

## onLeave

>
> This callback is triggered when user leave
>
>- function prototype:
>```dart
>void Function(ZegoUIKitUser)? onLeave;
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       user: ZegoLiveAudioRoomUserEvents(
>           onLeave: (user) {
>               ...
>           },
>       ),
>   ),
>);
>```

## onCountOrPropertyChanged

>
> This callback method is triggered when the user count or attributes related to these users change
>
>- function prototype:
>```dart
>void Function(List<ZegoUIKitUser> users)? onCountOrPropertyChanged
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       user: ZegoLiveAudioRoomUserEvents(
>           onCountOrPropertyChanged: (users) {
>               ...
>           },
>       ),
>   ),
>);
>```

# ZegoLiveAudioRoomRoomEvents

>
> events about room

## onStateChanged

>
> This callback is triggered when room state changed, you can get the current call room entry status by using the **state.reason**.
>
>- function prototype:
>```dart
>void Function(ZegoUIKitRoomState)? onStateChanged;
>
>class ZegoUIKitRoomState {
>  ///  Room state change reason.
>  ZegoRoomStateChangedReason reason;
>
>  /// Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for >details.
>  int errorCode;
>
>  /// Extended Information with state updates. When the room login is successful, the key >"room_session_id" can be used to obtain the unique RoomSessionID of each audio and video communication, >which identifies the continuous communication from the first user in the room to the end of the audio and >video communication. It can be used in scenarios such as call quality scoring and call problem diagnosis.
>  Map<String, dynamic> extendedData;
>}
>
>/// Room state change reason.
>enum ZegoRoomStateChangedReason {
>  /// Logging in to the room. When calling [loginRoom] to log in to the room or [switchRoom] to switch to >the target room, it will enter this state, indicating that it is requesting to connect to the server. The >application interface is usually displayed through this state.
>  Logining,
>
>  /// Log in to the room successfully. When the room is successfully logged in or switched, it will enter >this state, indicating that the login to the room has been successful, and users can normally receive >callback notifications of other users in the room and all stream information additions and deletions.
>  Logined,
>
>  /// Failed to log in to the room. When the login or switch room fails, it will enter this state, >indicating that the login or switch room has failed, for example, AppID or Token is incorrect, etc.
>  LoginFailed,
>
>  /// The room connection is temporarily interrupted. If the interruption occurs due to poor network >quality, the SDK will retry internally.
>  Reconnecting,
>
>  /// The room is successfully reconnected. If there is an interruption due to poor network quality, the >SDK will retry internally, and enter this state after successful reconnection.
>  Reconnected,
>
>  /// The room fails to reconnect. If there is an interruption due to poor network quality, the SDK will >retry internally, and enter this state after the reconnection fails.
>  ReconnectFailed,
>
>  /// Kicked out of the room by the server. For example, if you log in to the room with the same user >name in other places, and the local end is kicked out of the room, it will enter this state.
>  KickOut,
>
>  /// Logout of the room is successful. It is in this state by default before logging into the room. When >calling [logoutRoom] to log out of the room successfully or [switchRoom] to log out of the current room >successfully, it will enter this state.
>  Logout,
>
>  /// Failed to log out of the room. Enter this state when calling [logoutRoom] fails to log out of the >room or [switchRoom] fails to log out of the current room internally.
>  LogoutFailed
>}
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       user: ZegoLiveAudioRoomRoomEvents(
>           onStateChanged: (state) {
>               ...
>           },
>       ),
>   ),
>);
>```

# ZegoLiveAudioRoomAudioVideoEvents

>
> events about audio video

## onMicrophoneStateChanged

>
> This callback is triggered when microphone state changed
>
>- function prototype:
>``` dart
>void Function(bool)? onMicrophoneStateChanged;
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       audioVideo: ZegoLiveAudioRoomAudioVideoEvents(
>           onMicrophoneStateChanged: (isOpened) {
>               ...
>           },
>       ),
>   ),
>);
>```

## onAudioOutputChanged

>
> This callback is triggered when audio output device changed
>
>- function prototype:
>``` dart
>void Function(ZegoUIKitAudioRoute)? onAudioOutputChanged;
>```
>- example:
>```dart
>ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>       audioVideo: ZegoLiveAudioRoomAudioVideoEvents(
>           onAudioOutputChanged: (audioRoute) {
>               ...
>           },
>       ),
>   ),
>);
>```

## onMicrophoneTurnOnByOthersConfirmation

>
> This callback method is called when someone requests to open your
> microphone, typically when the host wants to open your microphone.
>
> This method requires returning an asynchronous result.
>
> You can display a dialog in this callback to confirm whether to open the
> microphone.
>
> Alternatively, you can return `true` without any processing, indicating
> that when someone requests to open your microphone, it can be directly opened.
>
> By default, this method does nothing and returns `false`, indicating that
> others cannot open your microphone.
>
> Example：
>
> ```dart
>
>  // eg:
> ..onMicrophoneTurnOnByOthersConfirmation =
>     (BuildContext context) async {
>   const textStyle = TextStyle(
>     fontSize: 10,
>     color: Colors.white70,
>   );
>
>   return await showDialog(
>     context: context,
>     barrierDismissible: false,
>     builder: (BuildContext context) {
>       return AlertDialog(
>         backgroundColor: Colors.blue[900]!.withOpacity(0.9),
>         title: const Text(
>           'You have a request to turn on your microphone',
>           style: textStyle,
>         ),
>         content: const Text(
>           'Do you agree to turn on the microphone?',
>           style: textStyle,
>         ),
>         actions: [
>           ElevatedButton(
>             child: const Text('Cancel', style: textStyle),
>             onPressed: () => Navigator.of(context).pop(false),
>           ),
>           ElevatedButton(
>             child: const Text('OK', style: textStyle),
>             onPressed: () {
>               Navigator.of(context).pop(true);
>             },
>           ),
>         ],
>       );
>     },
>   );
> },
> ```
>
>- function prototype:
>```dart
>Future<bool> Function(BuildContext context)? onMicrophoneTurnOnByOthersConfirmation
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     audioVideo: ZegoLiveAudioRoomAudioVideoEvents(
>       onMicrophoneTurnOnByOthersConfirmation: (
>         context,
>       ) {
>       },
>     ),
>   ),
>   ...
> );
>```

# ZegoLiveAudioRoomMemberListEvents

## onClicked

>
> Local message sending callback, This callback method is called when a message is sent successfully or fails to send.
>
>- function prototype:
>```dart
>void Function(ZegoUIKitUser user)? onClicked
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     memberList: ZegoLiveAudioRoomMemberListEvents(
>       onClicked: (ZegoUIKitUser) {
>
>       },
>     ),
>   ),
>   ...
> );
>```

## onMoreButtonPressed

>
> Callback method when the "More" button on the row corresponding to `user`
in the member list is pressed.
> If you want to perform additional operations when the "More" button on the
member list is clicked, such as viewing the profile of `user`.
>
> Note that when you set this callback, the **default behavior** of popping
up a menu when clicking the "More" button on the member list will be **overridden**, and you need to handle it yourself.
> You can refer to the usage of `ZegoUIKitPrebuiltLiveAudioRoomController`.
>
>- function prototype:
>```dart
>void Function(ZegoUIKitUser user)? onMoreButtonPressed
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     memberList: ZegoLiveAudioRoomMemberListEvents(
>       onMoreButtonPressed: (ZegoUIKitUser) {
>
>       },
>     ),
>   ),
>   ...
> );
>```

# ZegoLiveAudioRoomInRoomMessageEvents

## onClicked

>
> Triggered when has click on the message item
>
>- function prototype:
>```dart
>void Function(ZegoInRoomMessage message) onClicked
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     inRoomMessage: ZegoLiveAudioRoomInRoomMessageEvents(
>       onClicked: (ZegoInRoomMessage) {
>
>       },
>     ),
>   ),
>   ...
> );
>```

## onLongPress

>
> Triggered when a pointer has remained in contact with the message item at
> the same location for a long period of time.
>
>- function prototype:
>```dart
>void Function(ZegoInRoomMessage message) onLongPress
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     inRoomMessage: ZegoLiveAudioRoomInRoomMessageEvents(
>       onLongPress: (ZegoInRoomMessage) {
>
>       },
>     ),
>   ),
>   ...
> );
>```

# ZegoLiveAudioRoomDurationEvents

## onUpdate

>
> Call timing callback function, called every second.
>
> Example: Set to automatically leave after 5 minutes.
>```dart
> ..duration.onUpdate = (Duration duration) {
>   if (duration.inSeconds >= 5 * 60) {
>     ZegoUIKitPrebuiltLiveAudioRoomController().leave(context);
>   }
> }
> ```
>
>- function prototype:
>```dart
>void Function(Duration)? onUpdate
>```
>- example:
>```dart
> ZegoUIKitPrebuiltLiveAudioRoom(
>   ...
>   events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
>     duration: ZegoLiveAudioRoomDurationEvents(
>       onUpdate: (Duration) {
>
>       },
>     ),
>   ),
>   ...
> );
>```