// Flutter imports:
import 'package:flutter/cupertino.dart';

export 'seat/defines.dart';

/// prefab button on menu bar
enum ZegoTopMenuBarButtonName {
  minimizingButton,
}

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

typedef ZegoLiveAudioRoomBackgroundBuilder = Widget Function(
  BuildContext context,
  Size size,
  Map<String, dynamic> extraInfo,
);
