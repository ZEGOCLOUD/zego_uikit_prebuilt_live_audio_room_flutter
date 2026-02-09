# Events

- [ZegoUIKitPrebuiltLiveAudioRoomEvents](#zegouikitprebuiltliveaudioroomevents)
  - [seat](#zegoliveaudioroomseatevents)
    - [host](#zegoliveaudioroomseathostevents)
    - [audience](#zegoliveaudioroomseataudienceevents)
  - [user](#zegoliveaudioroomuserevents)
  - [room](#zegoliveaudioroomroomevents)
  - [audioVideo](#zegoliveaudioroomaudiovideoevents)
  - [inRoomMessage](#zegoliveaudioroominroommessageevents)
  - [memberList](#zegoliveaudioroommemberlistevents)
  - [duration](#zegoliveaudioroomdurationevents)
  - [media](#zegouikitmediaplayerevent)
  - [onLeaveConfirmation](#onleaveconfirmation)
  - [onEnded](#onended)
  - [onError](#onerror)

---

## ZegoUIKitPrebuiltLiveAudioRoomEvents

- **Description**
  You can listen to events that you are interested in here.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **seat** | Events about seat. | `ZegoLiveAudioRoomSeatEvents` | |
| **user** | Events about user. | `ZegoLiveAudioRoomUserEvents` | |
| **room** | Events about room. | `ZegoLiveAudioRoomRoomEvents` | |
| **audioVideo** | Events about audio video. | `ZegoLiveAudioRoomAudioVideoEvents` | |
| **inRoomMessage** | Events about message. | `ZegoLiveAudioRoomInRoomMessageEvents` | |
| **memberList** | Events about member list. | `ZegoLiveAudioRoomMemberListEvents` | |
| **duration** | Events about duration. | `ZegoLiveAudioRoomDurationEvents` | |
| **media** | Events about media. | `ZegoUIKitMediaPlayerEvent` | |
| **onLeaveConfirmation** | Confirmation callback before leaving the audio chat room. | `Future<bool> Function(ZegoLiveAudioRoomLeaveConfirmationEvent event, Future<bool> Function() defaultAction)?` | `null` |
| **onEnded** | Callback when live audio room ended. | `void Function(ZegoLiveAudioRoomEndEvent event, VoidCallback defaultAction)?` | `null` |
| **onError** | Error callback. | `Function(ZegoUIKitError)?` | `null` |

## ZegoLiveAudioRoomSeatEvents

- **Description**
  Events about seats.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **host** | Events about seat's host. | `ZegoLiveAudioRoomSeatHostEvents?` | |
| **audience** | Events about seat's audience. | `ZegoLiveAudioRoomSeatAudienceEvents?` | |
| **onClosed** | Notification that a seat has been closed (locked). | `VoidCallback?` | `null` |
| **onOpened** | Notification that a seat has been opened (unlocked). | `VoidCallback?` | `null` |
| **onClicked** | Callback when a seat is clicked. | `void Function(int index, ZegoUIKitUser? user)?` | `null` |
| **onChanged** | Callback when someone gets on/off/switches seat. | `void Function(Map<int, ZegoUIKitUser> takenSeats, List<int> untakenSeats)?` | `null` |

### onClosed

- **Description**
  Notification that a seat has been closed (locked). After closing a seat, audience members need to request permission from the host to join the seat, or the host can invite audience members directly.

- **Prototype**
  ```dart
  VoidCallback?
  ```

- **Example**
  ```dart
  onClosed: () {
    // Seat closed logic
  }
  ```

### onOpened

- **Description**
  Notification that a seat has been opened (unlocked). After opening a seat, all audience members can freely choose an empty seat to join and start chatting with others.

- **Prototype**
  ```dart
  VoidCallback?
  ```

- **Example**
  ```dart
  onOpened: () {
    // Seat opened logic
  }
  ```

### onClicked

- **Description**
  A callback function that is called when a seat is clicked. The [index] parameter is the index of the seat that was clicked. The [user] parameter is the user who is currently sitting in the seat, or `null` if the seat is empty. Note that when you set this callback, the default behavior of clicking on a seat to display a menu will be disabled.

- **Prototype**
  ```dart
  void Function(int index, ZegoUIKitUser? user)?
  ```

- **Example**
  ```dart
  onClicked: (int index, ZegoUIKitUser? user) {
    // Handle seat click
  }
  ```

### onChanged

- **Description**
  A callback function that is called when someone gets on/off/switches seat. The [takenSeats] parameter is a map that maps the index of each taken seat to the user who is currently sitting in that seat. The [untakenSeats] parameter is a list of the indexes of all untaken seats.

- **Prototype**
  ```dart
  void Function(
    Map<int, ZegoUIKitUser> takenSeats,
    List<int> untakenSeats,
  )?
  ```

- **Example**
  ```dart
  onChanged: (Map<int, ZegoUIKitUser> takenSeats, List<int> untakenSeats) {
    // Handle seat changes
  }
  ```

## ZegoLiveAudioRoomSeatHostEvents

- **Description**
  Events about seat's host.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onTakingRequested** | The host has received a seat request from an audience. | `void Function(ZegoUIKitUser audience)?` | `null` |
| **onTakingRequestCanceled** | The host has received a notification that the audience has canceled the seat request. | `void Function(ZegoUIKitUser audience)?` | `null` |
| **onTakingInvitationFailed** | The host has received a notification that the invitation for the audience to take a seat has failed. | `VoidCallback?` | `null` |
| **onTakingInvitationRejected** | The host has received a notification that the invitation for the audience to take a seat has been rejected. | `void Function(ZegoUIKitUser audience)?` | `null` |

### onTakingRequested

- **Description**
  The host has received a seat request from an audience.

- **Prototype**
  ```dart
  void Function(ZegoUIKitUser audience)?
  ```

- **Example**
  ```dart
  onTakingRequested: (ZegoUIKitUser audience) {
    // Handle seat request
  }
  ```

### onTakingRequestCanceled

- **Description**
  The host has received a notification that the audience has canceled the seat request.

- **Prototype**
  ```dart
  void Function(ZegoUIKitUser audience)?
  ```

- **Example**
  ```dart
  onTakingRequestCanceled: (ZegoUIKitUser audience) {
    // Handle request cancellation
  }
  ```

### onTakingInvitationFailed

- **Description**
  The host has received a notification that the invitation for the audience to take a seat has failed. This is usually due to network issues or if the audience has already logged out of the app.

- **Prototype**
  ```dart
  VoidCallback?
  ```

- **Example**
  ```dart
  onTakingInvitationFailed: () {
    // Handle invitation failure
  }
  ```

### onTakingInvitationRejected

- **Description**
  The host has received a notification that the invitation for the audience to take a seat has been rejected.

- **Prototype**
  ```dart
  void Function(ZegoUIKitUser audience)?
  ```

- **Example**
  ```dart
  onTakingInvitationRejected: (ZegoUIKitUser audience) {
    // Handle invitation rejection
  }
  ```

## ZegoLiveAudioRoomSeatAudienceEvents

- **Description**
  Events about seat's audience.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onTakingRequestFailed** | The audience has received a notification that the application to take a seat has failed. | `VoidCallback?` | `null` |
| **onTakingRequestRejected** | The audience received a notification that their request to take seats was declined by the host. | `VoidCallback?` | `null` |
| **onTakingInvitationReceived** | The audience has received a notification that the host has invited them to take a seat. | `VoidCallback?` | `null` |
| **onTakingFailed** | The audience take a seat has failed, invited or requested. | `VoidCallback?` | `null` |

### onTakingRequestFailed

- **Description**
  The audience has received a notification that the application to take a seat has failed. This is usually due to network issues or the host has logged out of the app.

- **Prototype**
  ```dart
  VoidCallback?
  ```

- **Example**
  ```dart
  onTakingRequestFailed: () {
    // Handle request failure
  }
  ```

### onTakingRequestRejected

- **Description**
  The audience received a notification that their request to take seats was declined by the host.

- **Prototype**
  ```dart
  VoidCallback?
  ```

- **Example**
  ```dart
  onTakingRequestRejected: () {
    // Handle request rejection
  }
  ```

### onTakingInvitationReceived

- **Description**
  The audience has received a notification that the host has invited them to take a seat.

- **Prototype**
  ```dart
  VoidCallback?
  ```

- **Example**
  ```dart
  onTakingInvitationReceived: () {
    // Handle invitation receipt
  }
  ```

### onTakingFailed

- **Description**
  The audience take a seat has failed, invited or requested.

- **Prototype**
  ```dart
  VoidCallback?
  ```

- **Example**
  ```dart
  onTakingFailed: () {
    // Handle taking seat failure
  }
  ```

## ZegoLiveAudioRoomUserEvents

- **Description**
  Events about user.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onEnter** | This callback is triggered when user enter. | `void Function(ZegoUIKitUser)?` | `null` |
| **onLeave** | This callback is triggered when user leave. | `void Function(ZegoUIKitUser)?` | `null` |
| **onCountOrPropertyChanged** | This callback method is triggered when the user count or attributes related to these users change. | `void Function(List<ZegoUIKitUser> users)?` | `null` |

### onEnter

- **Description**
  This callback is triggered when user enter.

- **Prototype**
  ```dart
  void Function(ZegoUIKitUser)?
  ```

- **Example**
  ```dart
  onEnter: (ZegoUIKitUser user) {
    // Handle user enter
  }
  ```

### onLeave

- **Description**
  This callback is triggered when user leave.

- **Prototype**
  ```dart
  void Function(ZegoUIKitUser)?
  ```

- **Example**
  ```dart
  onLeave: (ZegoUIKitUser user) {
    // Handle user leave
  }
  ```

### onCountOrPropertyChanged

- **Description**
  This callback method is triggered when the user count or attributes related to these users change.

- **Prototype**
  ```dart
  void Function(List<ZegoUIKitUser> users)?
  ```

- **Example**
  ```dart
  onCountOrPropertyChanged: (List<ZegoUIKitUser> users) {
    // Handle user count or property changes
  }
  ```

## ZegoLiveAudioRoomRoomEvents

- **Description**
  Events about room.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onStateChanged** | Triggered when room state changed. | `void Function(ZegoUIKitRoomState)?` | `null` |
| **onTokenExpired** | The room Token authentication is about to expire. | `String? Function(int remainSeconds)?` | `null` |

### onStateChanged

- **Description**
  Triggered when room state changed.

- **Prototype**
  ```dart
  void Function(ZegoUIKitRoomState)?
  ```

- **Example**
  ```dart
  onStateChanged: (ZegoUIKitRoomState state) {
    // Handle room state change
  }
  ```

### onTokenExpired

- **Description**
  The room Token authentication is about to expire. It will be sent 30 seconds before the Token expires. After receiving this callback, the Token can be updated through `ZegoUIKitPrebuiltLiveAudioRoomController.room.renewToken`.

- **Prototype**
  ```dart
  String? Function(int remainSeconds)?
  ```

- **Example**
  ```dart
  onTokenExpired: (int remainSeconds) {
    // Renew token
    return 'new_token';
  }
  ```

## ZegoLiveAudioRoomAudioVideoEvents

- **Description**
  Events about audio-video.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onMicrophoneStateChanged** | This callback is triggered when microphone state changed. | `void Function(bool)?` | `null` |
| **onAudioOutputChanged** | This callback is triggered when audio output device changed. | `void Function(ZegoUIKitAudioRoute)?` | `null` |
| **onMicrophoneTurnOnByOthersConfirmation** | This callback is called when someone requests to open your microphone. | `Future<bool> Function(BuildContext context)?` | `null` |

### onMicrophoneStateChanged

- **Description**
  This callback is triggered when microphone state changed.

- **Prototype**
  ```dart
  void Function(bool)?
  ```

- **Example**
  ```dart
  onMicrophoneStateChanged: (bool isOpened) {
    // Handle microphone state change
  }
  ```

### onAudioOutputChanged

- **Description**
  This callback is triggered when audio output device changed.

- **Prototype**
  ```dart
  void Function(ZegoUIKitAudioRoute)?
  ```

- **Example**
  ```dart
  onAudioOutputChanged: (ZegoUIKitAudioRoute route) {
    // Handle audio output change
  }
  ```

### onMicrophoneTurnOnByOthersConfirmation

- **Description**
  This callback method is called when someone requests to open your microphone, typically when the host wants to open the speaker's microphone. This method requires returning an asynchronous result. You can display a dialog in this callback to confirm whether to open the microphone.

- **Prototype**
  ```dart
  Future<bool> Function(BuildContext context)?
  ```

- **Example**
  ```dart
  onMicrophoneTurnOnByOthersConfirmation: (BuildContext context) async {
    const textStyle = TextStyle(
      fontSize: 10,
      color: Colors.white70,
    );

    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900]!.withValues(alpha: 0.9),
          title: const Text(
            'You have a request to turn on your microphone',
            style: textStyle,
          ),
          content: const Text(
            'Do you agree to turn on the microphone?',
            style: textStyle,
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel', style: textStyle),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('OK', style: textStyle),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
  ```

## ZegoLiveAudioRoomInRoomMessageEvents

- **Description**
  Events about in-room message.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onClicked** | Triggered when has click on the message item. | `ZegoInRoomMessageViewItemPressEvent?` | `null` |
| **onLongPress** | Triggered when a pointer has remained in contact with the message item at the same location for a long period of time. | `ZegoInRoomMessageViewItemPressEvent?` | `null` |

### onClicked

- **Description**
  Triggered when has click on the message item.

- **Prototype**
  ```dart
  ZegoInRoomMessageViewItemPressEvent?
  ```

- **Example**
  ```dart
  onClicked: (ZegoInRoomMessageViewItemPressEvent event) {
    // Handle message click
  }
  ```

### onLongPress

- **Description**
  Triggered when a pointer has remained in contact with the message item at the same location for a long period of time.

- **Prototype**
  ```dart
  ZegoInRoomMessageViewItemPressEvent?
  ```

- **Example**
  ```dart
  onLongPress: (ZegoInRoomMessageViewItemPressEvent event) {
    // Handle message long press
  }
  ```

## ZegoLiveAudioRoomMemberListEvents

- **Description**
  Events about member list.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onClicked** | You can listen to the user click event on the member list. | `void Function(ZegoUIKitUser user)?` | `null` |
| **onMoreButtonPressed** | Callback when the "More" button on the member list is pressed. | `void Function(ZegoUIKitUser user)?` | `null` |

### onClicked

- **Description**
  You can listen to the user click event on the member list, for example, if you want to display specific information about a member after they are clicked.

- **Prototype**
  ```dart
  void Function(ZegoUIKitUser user)?
  ```

- **Example**
  ```dart
  onClicked: (ZegoUIKitUser user) {
    // Handle member list click
  }
  ```

### onMoreButtonPressed

- **Description**
  Callback method when the "More" button on the row corresponding to `user` in the member list is pressed. If you want to perform additional operations when the "More" button on the member list is clicked. Note that when you set this callback, the default behavior of popping up a menu will be overridden.

- **Prototype**
  ```dart
  void Function(ZegoUIKitUser user)?
  ```

- **Example**
  ```dart
  onMoreButtonPressed: (ZegoUIKitUser user) {
    // Handle more button press
  }
  ```

## ZegoLiveAudioRoomDurationEvents

- **Description**
  Events about duration.

- **Properties**

| Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| **onUpdated** | Call timing callback function, called every second. | `void Function(Duration)?` | `null` |

### onUpdated

- **Description**
  Call timing callback function, called every second.

- **Prototype**
  ```dart
  void Function(Duration)?
  ```

- **Example**
  ```dart
  // Example: Do something after 5 minutes.
  onUpdated: (Duration duration) {
    if (duration.inSeconds >= 5 * 60) {
      ///  Do something...
    }
  }
  ```

## ZegoUIKitMediaPlayerEvent

- **Description**
  Events about media player.

### onPlayStateChanged

- **Description**
  Play state callback.

- **Prototype**
  ```dart
  void Function(ZegoUIKitMediaPlayState)?
  ```

- **Example**
  ```dart
  onPlayStateChanged: (ZegoUIKitMediaPlayState state) {
    // Handle play state change
  }
  ```

## onLeaveConfirmation

- **Description**
  Confirmation callback method before leaving the audio chat room. If you want to perform more complex business logic before exiting the audio chat room, such as updating some records to the backend, you can use this parameter. This parameter requires you to provide a callback method that returns an asynchronous result. If you return true in the callback, the prebuilt page will quit and return to your previous page, otherwise it will be ignored.

- **Prototype**
  ```dart
  Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
    Future<bool> Function() defaultAction,
  )?
  ```

- **Example**
  ```dart
  onLeaveConfirmation: (
      ZegoLiveAudioRoomLeaveConfirmationEvent event,
      /// defaultAction to return to the previous page
      Future<bool> Function() defaultAction,
  ) {
    debugPrint('onLeaveConfirmation, do whatever you want');

    /// you can call this defaultAction to return to the previous page,
    return defaultAction.call();
  }
  ```

## onEnded

- **Description**
  This callback method is called when live audio room ended. The default behavior of host is return to the previous page (only host) or hide the minimize page. If you override this callback, you must perform the page navigation yourself while it was in a normal state, or hide the minimize page if in minimize state. The easy way is call `defaultAction.call()`.

- **Prototype**
  ```dart
  void Function(
    ZegoLiveAudioRoomEndEvent event,
    VoidCallback defaultAction,
  )?
  ```

- **Example**
  ```dart
  onEnded: (
      ZegoLiveAudioRoomEndEvent event,
      /// defaultAction to return to the previous page
      VoidCallback defaultAction,
  ) {
    debugPrint('onEnded, do whatever you want');

    /// you can call this defaultAction to return to the previous page,
    defaultAction.call();
  }
  ```

## onError

- **Description**
  Error stream.

- **Prototype**
  ```dart
  Function(ZegoUIKitError)?
  ```

- **Example**
  ```dart
  onError: (ZegoUIKitError error) {
    debugPrint('onError: $error');
  }
  ```
