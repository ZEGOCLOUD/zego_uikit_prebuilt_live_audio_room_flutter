// Project imports:
import 'live_audio_room_defines.dart';

/// %0: is a string placeholder, represents the first parameter of prompt
class ZegoTranslationText {
  final String param_1 = "%0";

  String takeSeatMenuButton;

  String removeSpeakerMenuDialogButton;
  String cancelMenuDialogButton;

  String memberListTitle;
  String removeSpeakerFailedToast;

  ZegoDialogInfo cameraPermissionSettingDialogInfo;
  ZegoDialogInfo microphonePermissionSettingDialogInfo;
  ZegoDialogInfo removeFromSeatDialogInfo;
  ZegoDialogInfo leaveSeatDialogInfo;

  ZegoTranslationText({
    String? takeSeatMenuButton,
    String? prebuiltTitle,
    String? removeSpeakerMenuDialogButton,
    String? cancelMenuDialogButton,
    String? memberListTitle,
    String? removeSpeakerFailedToast,
    ZegoDialogInfo? cameraPermissionSettingDialogInfo,
    ZegoDialogInfo? microphonePermissionSettingDialogInfo,
    ZegoDialogInfo? removeFromSeatDialogInfo,
    ZegoDialogInfo? leaveSeatDialogInfo,
  })  : takeSeatMenuButton = takeSeatMenuButton ?? "Take the seat",
        removeSpeakerMenuDialogButton =
            removeSpeakerMenuDialogButton ?? "Remove %0 from seat",
        cancelMenuDialogButton = cancelMenuDialogButton ?? "Cancel",
        memberListTitle = memberListTitle ?? "Attendance",
        removeSpeakerFailedToast =
            removeSpeakerFailedToast ?? "Failed to remove %0 from seat",
        cameraPermissionSettingDialogInfo = cameraPermissionSettingDialogInfo ??
            ZegoDialogInfo(
              title: "Can not use Camera!",
              message: "Please enable camera access in the system settings!",
              cancelButtonName: "Cancel",
              confirmButtonName: "Settings",
            ),
        microphonePermissionSettingDialogInfo =
            microphonePermissionSettingDialogInfo ??
                ZegoDialogInfo(
                  title: "Can not use Microphone!",
                  message:
                      "Please enable microphone access in the system settings!",
                  cancelButtonName: "Cancel",
                  confirmButtonName: "Settings",
                ),
        removeFromSeatDialogInfo = removeFromSeatDialogInfo ??
            ZegoDialogInfo(
              title: "Remove the speaker",
              message: "Are you sure to remove %0 from the seat?",
              cancelButtonName: "Cancel",
              confirmButtonName: "OK",
            ),
        leaveSeatDialogInfo = leaveSeatDialogInfo ??
            ZegoDialogInfo(
              title: "Leave the seat",
              message: "Are you sure to leave seat?",
              cancelButtonName: "Cancel",
              confirmButtonName: "OK",
            );
}
