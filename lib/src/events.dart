// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';

/// You can listen to events that you are interested in here, such as Co-hosting
class ZegoUIKitPrebuiltLiveAudioRoomEvents {
  /// events about seat
  ZegoLiveAudioRoomSeatEvents seat;

  /// events about user
  ZegoLiveAudioRoomUserEvents user;

  /// events about room
  ZegoLiveAudioRoomRoomEvents room;

  /// events about audio video
  ZegoLiveAudioRoomAudioVideoEvents audioVideo;

  /// events about message
  ZegoLiveAudioRoomInRoomMessageEvents inRoomMessage;

  /// events about member list
  ZegoLiveAudioRoomMemberListEvents memberList;

  /// events about duration
  ZegoLiveAudioRoomDurationEvents duration;

  /// Confirmation callback method before leaving the audio chat room.
  ///
  /// If you want to perform more complex business logic before exiting the audio chat room, such as updating some records to the backend, you can use the [onLeaveConfirmation] parameter to set it.
  /// This parameter requires you to provide a callback method that returns an asynchronous result.
  /// If you return true in the callback, the prebuilt page will quit and return to your previous page, otherwise it will be ignored.
  ///
  /// Sample Code:
  ///
  /// ``` dart
  /// onLeaveConfirmation: (
  ///     ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ///     /// defaultAction to return to the previous page
  ///     Future<bool> Function() defaultAction,
  /// ) {
  ///   debugPrint('onLeaveConfirmation, do whatever you want');
  ///
  ///   /// you can call this defaultAction to return to the previous page,
  ///   return defaultAction.call();
  /// }
  /// ```
  Future<bool> Function(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,

    /// defaultAction to return to the previous page
    Future<bool> Function() defaultAction,
  )? onLeaveConfirmation;

  /// This callback method is called when live audio room ended
  ///
  /// The default behavior of host is return to the previous page(only host) or hide the minimize page.
  /// If you override this callback, you must perform the page navigation
  /// yourself while it was in a normal state, or hide the minimize page if in minimize state.
  /// otherwise the user will remain on the live streaming page.
  /// the easy way is call `defaultAction.call()`
  ///
  /// The [ZegoLiveAudioRoomEndEvent.isFromMinimizing] it means that the user left the chat room while it was in a minimized state.
  /// You **can not** return to the previous page while it was **in a minimized state**!!!
  /// On the other hand, if the value of the parameter is false, it means that the user left the chat room while it was in a normal state (i.e., not minimized).
  ///
  /// Sample Code:
  ///
  /// ``` dart
  /// onEnded: (
  ///     ZegoLiveAudioRoomEndEvent event,
  ///     /// defaultAction to return to the previous page
  ///     Future<bool> Function() defaultAction,
  /// ) {
  ///   debugPrint('onEnded, do whatever you want');
  ///
  ///   /// you can call this defaultAction to return to the previous page,
  ///   return defaultAction.call();
  /// }
  /// ```
  void Function(
    ZegoLiveAudioRoomEndEvent event,
    VoidCallback defaultAction,
  )? onEnded;

  /// error stream
  Function(ZegoUIKitError)? onError;

  ZegoUIKitPrebuiltLiveAudioRoomEvents({
    this.onLeaveConfirmation,
    this.onEnded,
    this.onError,
    ZegoLiveAudioRoomInRoomMessageEvents? inRoomMessage,
    ZegoLiveAudioRoomMemberListEvents? memberList,
    ZegoLiveAudioRoomDurationEvents? duration,
    ZegoLiveAudioRoomSeatEvents? seat,
    ZegoLiveAudioRoomUserEvents? user,
    ZegoLiveAudioRoomRoomEvents? room,
    ZegoLiveAudioRoomAudioVideoEvents? audioVideo,
  })  : seat = seat ?? ZegoLiveAudioRoomSeatEvents(),
        inRoomMessage = inRoomMessage ?? ZegoLiveAudioRoomInRoomMessageEvents(),
        memberList = memberList ?? ZegoLiveAudioRoomMemberListEvents(),
        duration = duration ?? ZegoLiveAudioRoomDurationEvents(),
        user = user ?? ZegoLiveAudioRoomUserEvents(),
        room = room ?? ZegoLiveAudioRoomRoomEvents(),
        audioVideo = audioVideo ?? ZegoLiveAudioRoomAudioVideoEvents();
}

/// events about seats
class ZegoLiveAudioRoomSeatEvents {
  /// events about seat's host
  ZegoLiveAudioRoomSeatHostEvents? host;

  /// events about seat's audience
  ZegoLiveAudioRoomSeatAudienceEvents? audience;

  /// Notification that a seat has been closed (locked).
  /// After closing a seat, audience members need to request permission from the host to join the seat, or the host can invite audience members directly.
  VoidCallback? onClosed;

  /// Notification that a seat has been opened (unlocked).
  /// After opening a seat, all audience members can freely choose an empty seat to join and start chatting with others.
  VoidCallback? onOpened;

  /// A callback function that is called when a seat is clicked.
  ///
  /// The [index] parameter is the index of the seat that was clicked.
  /// The [user] parameter is the user who is currently sitting in the seat, or `null` if the seat is empty.
  ///
  /// Note that when you set this callback, the **default behavior** of clicking on a seat to display a menu **will be disabled**.
  /// You need to handle it yourself.
  /// You can refer to the usage of [ZegoUIKitPrebuiltLiveAudioRoomController] for reference.
  void Function(int index, ZegoUIKitUser? user)? onClicked;

  /// A callback function that is called when someone gets on/off/switches seat
  ///
  /// The [takenSeats] parameter is a map that maps the index of each taken seat to the user who is currently sitting in that seat.
  /// The [untakenSeats] parameter is a list of the indexes of all untaken seats.
  void Function(
    Map<int, ZegoUIKitUser> takenSeats,
    List<int> untakenSeats,
  )? onChanged;

  ZegoLiveAudioRoomSeatEvents({
    this.onClosed,
    this.onOpened,
    this.onClicked,
    this.onChanged,
    ZegoLiveAudioRoomSeatHostEvents? host,
    ZegoLiveAudioRoomSeatAudienceEvents? audience,
  })  : host = host ?? ZegoLiveAudioRoomSeatHostEvents(),
        audience = audience ?? ZegoLiveAudioRoomSeatAudienceEvents();
}

/// events about seat's host
class ZegoLiveAudioRoomSeatHostEvents {
  /// The host has received a seat request from an `audience`.
  void Function(ZegoUIKitUser audience)? onTakingRequested;

  /// The host has received a notification that the `audience` has canceled the seat request.
  void Function(ZegoUIKitUser audience)? onTakingRequestCanceled;

  /// The host has received a notification that the invitation for the audience to take a seat has failed.
  /// This is usually due to network issues or if the audience has already logged out of the app and can no longer receive the invitation.
  VoidCallback? onTakingInvitationFailed;

  /// The host has received a notification that the invitation for the audience to take a seat has been rejected.
  void Function(ZegoUIKitUser audience)? onTakingInvitationRejected;

  ZegoLiveAudioRoomSeatHostEvents({
    this.onTakingRequested,
    this.onTakingRequestCanceled,
    this.onTakingInvitationFailed,
    this.onTakingInvitationRejected,
  });
}

/// events about seat's audience
class ZegoLiveAudioRoomSeatAudienceEvents {
  /// The audience has received a notification that the application to take a seat has failed.
  /// This is usually due to network issues or the host has logged out of the app and can no longer receive seat applications.
  VoidCallback? onTakingRequestFailed;

  /// The audience received a notification that their request to take seats was declined by the host.
  VoidCallback? onTakingRequestRejected;

  /// The audience has received a notification that the host has invited them to take a seat.
  VoidCallback? onTakingInvitationReceived;

  ZegoLiveAudioRoomSeatAudienceEvents({
    this.onTakingRequestFailed,
    this.onTakingRequestRejected,
    this.onTakingInvitationReceived,
  });
}

/// events about in-room message
class ZegoLiveAudioRoomInRoomMessageEvents {
  /// Triggered when has click on the message item
  ZegoInRoomMessageViewItemPressEvent? onClicked;

  /// Triggered when a pointer has remained in contact with the message item at
  /// the same location for a long period of time.
  ZegoInRoomMessageViewItemPressEvent? onLongPress;

  ZegoLiveAudioRoomInRoomMessageEvents({
    this.onClicked,
    this.onLongPress,
  });
}

/// events about member list
class ZegoLiveAudioRoomMemberListEvents {
  /// You can listen to the user click event on the member list,
  /// for example, if you want to display specific information about a member after they are clicked.
  void Function(ZegoUIKitUser user)? onClicked;

  /// Callback method when the "More" button on the row corresponding to `user` in the member list is pressed.
  /// If you want to perform additional operations when the "More" button on the member list is clicked, such as viewing the profile of `user`.
  ///
  /// Note that when you set this callback, the **default behavior** of popping up a menu when clicking the "More" button on the member list will be **overridden**, and you need to handle it yourself.
  /// You can refer to the usage of `ZegoUIKitPrebuiltLiveAudioRoomController`.
  void Function(ZegoUIKitUser user)? onMoreButtonPressed;

  ZegoLiveAudioRoomMemberListEvents({
    this.onClicked,
    this.onMoreButtonPressed,
  });
}

/// events about duration
class ZegoLiveAudioRoomDurationEvents {
  /// Call timing callback function, called every second.
  ///
  /// Example: Do something after 5 minutes.
  /// ..duration.isVisible = true
  /// ..duration.onDurationUpdate = (Duration duration) {
  ///   if (duration.inSeconds >= 5 * 60) {
  ///     ///  Do something...
  ///   }
  /// }
  void Function(Duration)? onUpdated;

  ZegoLiveAudioRoomDurationEvents({
    this.onUpdated,
  });
}

/// events about user
class ZegoLiveAudioRoomUserEvents {
  /// This callback is triggered when user enter
  void Function(ZegoUIKitUser)? onEnter;

  /// This callback is triggered when user leave
  void Function(ZegoUIKitUser)? onLeave;

  /// This callback method is triggered when the user count or attributes related to these users change.
  void Function(List<ZegoUIKitUser> users)? onCountOrPropertyChanged;

  ZegoLiveAudioRoomUserEvents({
    this.onEnter,
    this.onLeave,
    this.onCountOrPropertyChanged,
  });
}

/// events about room
class ZegoLiveAudioRoomRoomEvents {
  void Function(ZegoUIKitRoomState)? onStateChanged;

  ZegoLiveAudioRoomRoomEvents({
    this.onStateChanged,
  });
}

/// events about audio-video
class ZegoLiveAudioRoomAudioVideoEvents {
  /// This callback is triggered when microphone state changed
  void Function(bool)? onMicrophoneStateChanged;

  /// This callback is triggered when audio output device changed
  void Function(ZegoUIKitAudioRoute)? onAudioOutputChanged;

  /// This callback method is called when someone requests to open your microphone, typically when the host wants to open the speaker's microphone.
  /// This method requires returning an asynchronous result.
  /// You can display a dialog in this callback to confirm whether to open the microphone.
  /// Alternatively, you can return `true` without any processing, indicating that when someone requests to open your microphone, it can be directly opened.
  /// By default, this method does nothing and returns `false`, indicating that others cannot open your microphone.
  ///
  /// Example：
  ///
  /// ```dart
  ///
  ///  // eg:
  /// ..onMicrophoneTurnOnByOthersConfirmation =
  ///     (BuildContext context) async {
  ///   const textStyle = TextStyle(
  ///     fontSize: 10,
  ///     color: Colors.white70,
  ///   );
  ///
  ///   return await showDialog(
  ///     context: context,
  ///     barrierDismissible: false,
  ///     builder: (BuildContext context) {
  ///       return AlertDialog(
  ///         backgroundColor: Colors.blue[900]!.withOpacity(0.9),
  ///         title: const Text(
  ///           'You have a request to turn on your microphone',
  ///           style: textStyle,
  ///         ),
  ///         content: const Text(
  ///           'Do you agree to turn on the microphone?',
  ///           style: textStyle,
  ///         ),
  ///         actions: [
  ///           ElevatedButton(
  ///             child: const Text('Cancel', style: textStyle),
  ///             onPressed: () => Navigator.of(context).pop(false),
  ///           ),
  ///           ElevatedButton(
  ///             child: const Text('OK', style: textStyle),
  ///             onPressed: () {
  ///               Navigator.of(context).pop(true);
  ///             },
  ///           ),
  ///         ],
  ///       );
  ///     },
  ///   );
  /// },
  /// ```
  Future<bool> Function(BuildContext context)?
      onMicrophoneTurnOnByOthersConfirmation;

  ZegoLiveAudioRoomAudioVideoEvents({
    this.onMicrophoneStateChanged,
    this.onAudioOutputChanged,
    this.onMicrophoneTurnOnByOthersConfirmation,
  });
}
