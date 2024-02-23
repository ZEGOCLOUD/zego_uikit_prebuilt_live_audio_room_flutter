/// These are the predefined buttons that can be added to the top or bottom toolbar.
///
/// This enum type is used in ZegoUIKitPrebuiltLiveAudioRoomConfig.bottomMenuBar and ZegoUIKitPrebuiltLiveAudioRoomConfig.topMenuBar.
/// Please note that these buttons are not role-specific and can be added to anyone's toolbar.
/// The Live Audio Room SDK simply defaults to defining which buttons can be displayed on the corresponding role's toolbar.
///
/// For example, if you don't want the speaker on the seat to be able to turn off their microphone, you can exclude the toggleMicrophoneButton from ZegoLiveAudioRoomBottomMenuBarConfig.speakerButtons.
/// For example, if your business scenario allows audiences to view the member list or you don't want audiences to view the member list, and so on.
/// For example, if your business scenario only allows the host to invite audiences to the seat and doesn't allow audiences to apply as speakers, you can exclude the applyToTakeSeatButton from ZegoLiveAudioRoomBottomMenuBarConfig.audienceButtons.
enum ZegoLiveAudioRoomMenuBarButtonName {
  /// Button for leaving the audio chat room.
  /// You can proactively add a leave button to the bottom or top toolbar to optimize the interaction experience based on your business needs.
  leaveButton,

  /// Button for controlling the microphone switch.
  toggleMicrophoneButton,

  /// Button for controlling the visibility of the member list.
  showMemberListButton,

  /// Button for controlling the display or hiding of the sound effect adjustment panel.
  /// Typically, only the host and speakers will be speaking, so this button is usually displayed on their toolbars.
  soundEffectButton,

  /// Button for audience members to apply for a seat and join others in a voice chat.
  /// Typically placed on the audience toolbar.
  applyToTakeSeatButton,

  /// Button for minimizing the current [ZegoUIKitPrebuiltLiveAudioRoom] widget within the app.
  /// When clicked, the [ZegoUIKitPrebuiltLiveAudioRoom] widget will shrink into a small draggable widget within the app.
  ///
  /// If you need to nest some widgets in [ZegoUIKitPrebuiltLiveAudioRoom], please use [foreground] nesting,
  /// otherwise these widgets will be lost when you minimize and restore the [ZegoUIKitPrebuiltLiveAudioRoom]
  minimizingButton,

  /// Button for toggling the seat availability.
  /// When the seat is **open**, all audience members can freely choose an empty seat to join and start chatting with others.
  /// If the seat is **closed**, audience members need to request permission from the host or be invited by the host to occupy a seat.
  closeSeatButton,
}

/// User roles in the live audio room.
/// This enum type is used for the [role] property in [ZegoUIKitPrebuiltLiveAudioRoomConfig].
enum ZegoLiveAudioRoomRole {
  /// `host` is the user with the highest authority in the live audio room. They have control over all functionalities in the room, such as disabling text chat for audience members, inviting audience members to become speakers on seats, demoting speakers to audience members, etc.
  host,

  /// `speaker` can engage in voice chat with the host or other speakers in the live audio room. They do not have any additional special privileges.
  speaker,

  /// `audience` can listen to the voice chat of the host and other speakers in the live audio room, and can also send text messages.
  audience,
}

/// Dialog information.
/// Used to control whether certain features display a dialog, such as whether to show a confirmation dialog before leaving the audio chat room.
/// This class is used for setting some text in ZegoUIKitPrebuiltLiveAudioRoomInnerText and ZegoUIKitPrebuiltLiveAudioRoomConfig.confirmDialogInfo.
class ZegoLiveAudioRoomDialogInfo {
  /// Dialog title
  final String title;

  /// Dialog text content
  final String message;

  /// Text content on the cancel button. Default value is 'Cancel'.
  String cancelButtonName;

  /// Text content on the confirm button. Default value is 'OK'.
  String confirmButtonName;

  ZegoLiveAudioRoomDialogInfo({
    required this.title,
    required this.message,
    this.cancelButtonName = 'Cancel',
    this.confirmButtonName = 'OK',
  });
}
