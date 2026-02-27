// Flutter imports:
import 'package:flutter/cupertino.dart';

/// The reason why the Live Audio Room ended.
///
/// This enum is used in [ZegoLiveAudioRoomEndEvent] to indicate the cause of the room ending.
enum ZegoLiveAudioRoomEndReason {
  /// The local user voluntarily left the room.
  localLeave,

  /// The user was kicked out of the room by another user.
  kickOut,
}

/// Event that is triggered when the Live Audio Room ends.
///
/// This event is passed to the [ZegoUIKitPrebuiltLiveAudioRoomEvents.onEnded] callback.
class ZegoLiveAudioRoomEndEvent {
  /// Creates an end event.
  ///
  /// [reason] - The reason why the room ended.
  /// [isFromMinimizing] - Whether the user left while the room was minimized.
  /// [kickerUserID] - The user ID of the person who kicked the local user out (only applicable when [reason] is [ZegoLiveAudioRoomEndReason.kickOut]).
  ZegoLiveAudioRoomEndEvent({
    required this.reason,
    required this.isFromMinimizing,
    this.kickerUserID,
  });

  /// The user ID of who kicked you out.
  /// This is only valid when [reason] is [ZegoLiveAudioRoomEndReason.kickOut].
  String? kickerUserID;

  /// The reason why the room ended.
  ZegoLiveAudioRoomEndReason reason;

  /// Whether the user left while the room was in a minimized state.
  ///
  /// You **cannot** return to the previous page while it is **in a minimized state**!!!
  /// In this case, you should hide the minimize page by calling `minimize.hide()`.
  ///
  /// If the value is `false`, it means the user left while the room was not minimized.
  bool isFromMinimizing;

  @override
  String toString() {
    return 'ZegoLiveAudioRoomEndEvent{'
        'kickerUserID:$kickerUserID, '
        'isFromMinimizing:$isFromMinimizing, '
        'reason:$reason, '
        '}';
  }
}

/// Event that is triggered when the user attempts to leave the Live Audio Room.
///
/// This event is passed to the [ZegoUIKitPrebuiltLiveAudioRoomEvents.onLeaveConfirmation] callback.
class ZegoLiveAudioRoomLeaveConfirmationEvent {
  /// Creates a leave confirmation event.
  ///
  /// [context] - The build context of the current page.
  ZegoLiveAudioRoomLeaveConfirmationEvent({
    required this.context,
  });

  /// The build context of the current page.
  BuildContext context;
}
