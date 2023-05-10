// Flutter imports:
import 'package:flutter/cupertino.dart';

enum ZegoMenuBarButtonName {
  leaveButton,
  toggleMicrophoneButton,
  showMemberListButton,
  soundEffectButton,
  applyToTakeSeatButton,
  minimizingButton,

  ///  lock/unlock seat
  closeSeatButton,
}

enum ZegoLiveAudioRoomRole {
  host,
  speaker,
  audience,
}

class ZegoDialogInfo {
  final String title;
  final String message;
  String cancelButtonName;
  String confirmButtonName;

  ZegoDialogInfo({
    required this.title,
    required this.message,
    this.cancelButtonName = 'Cancel',
    this.confirmButtonName = 'OK',
  });
}
