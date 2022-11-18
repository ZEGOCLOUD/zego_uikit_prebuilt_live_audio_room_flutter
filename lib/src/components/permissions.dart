// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'dialogs.dart';

Future<void> checkPermissions({
  required BuildContext context,
  required ZegoTranslationText translationText,
  bool isShowDialog = false,
  List<Permission> checkStatuses = const [Permission.microphone],
}) async {
  if (checkStatuses.contains(Permission.camera)) {
    await Permission.camera.status.then((status) async {
      if (status != PermissionStatus.granted) {
        if (isShowDialog) {
          await showAppSettingsDialog(
            context,
            translationText.cameraPermissionSettingDialogInfo,
          );
        }
      }
    });
  }

  if (checkStatuses.contains(Permission.microphone)) {
    await Permission.microphone.status.then((status) async {
      if (status != PermissionStatus.granted) {
        if (isShowDialog) {
          await showAppSettingsDialog(
            context,
            translationText.microphonePermissionSettingDialogInfo,
          );
        }
      }
    });
  }
}

Future<void> requestPermissions({
  required BuildContext context,
  required ZegoTranslationText translationText,
  bool isShowDialog = false,
  List<Permission> checkStatuses = const [Permission.microphone],
}) async {
  await checkStatuses
      .request()
      .then((Map<Permission, PermissionStatus> statuses) async {
    if (checkStatuses.contains(Permission.camera) &&
        statuses[Permission.camera] != PermissionStatus.granted) {
      if (isShowDialog) {
        await showAppSettingsDialog(
          context,
          translationText.cameraPermissionSettingDialogInfo,
        );
      }
    }

    if (checkStatuses.contains(Permission.microphone) &&
        statuses[Permission.microphone] != PermissionStatus.granted) {
      if (isShowDialog) {
        await showAppSettingsDialog(
          context,
          translationText.microphonePermissionSettingDialogInfo,
        );
      }
    }
  });
}

Future<bool> showAppSettingsDialog(
  BuildContext context,
  ZegoDialogInfo dialogInfo,
) async {
  return await showLiveDialog(
    context: context,
    title: dialogInfo.title,
    content: dialogInfo.message,
    leftButtonText: dialogInfo.cancelButtonName,
    leftButtonCallback: () {
      Navigator.of(context).pop(false);
    },
    rightButtonText: dialogInfo.confirmButtonName,
    rightButtonCallback: () async {
      await openAppSettings();
      Navigator.of(context).pop(false);
    },
  );
}
