// Flutter imports:

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/mini_overlay_machine.dart';

part 'package:zego_uikit_prebuilt_live_audio_room/src/controller/media.dart';

part 'package:zego_uikit_prebuilt_live_audio_room/src/controller/message.dart';

part 'package:zego_uikit_prebuilt_live_audio_room/src/controller/seat.dart';

part 'package:zego_uikit_prebuilt_live_audio_room/src/controller/controller_p.dart';

/// Used to control the audio chat room functionality.
///
/// If the default audio chat room UI and interactions do not meet your requirements, you can use this [ZegoLiveAudioRoomController] to actively control the business logic.
/// This class is used by setting the [controller] parameter in the constructor of [ZegoUIKitPrebuiltLiveAudioRoom].
class ZegoLiveAudioRoomController
    with
        ZegoLiveAudioRoomControllerPrivate,
        ZegoLiveAudioRoomControllerMedia,
        ZegoLiveAudioRoomControllerMessage {
  ///  enable or disable the microphone of a specified user. If userID is empty or null, it controls the local microphone. The isOn parameter specifies whether the microphone should be turned on or off, where true means it is turned on and false means it is turned off.
  void turnMicrophoneOn(bool isOn, {String? userID}) {
    ZegoUIKit().turnMicrophoneOn(isOn, userID: userID);
  }

  /// This function is used to end the Live Audio Room.
  ///
  /// You can pass the context [context] for any necessary pop-ups or page transitions.
  /// By using the [showConfirmation] parameter, you can control whether to display a confirmation dialog to confirm ending the Live Audio Room.
  ///
  /// This function behaves the same as the close button in the calling interface's top right corner, and it is also affected by the [ZegoUIKitPrebuiltLiveStreamingConfig.onLeaveConfirmation] and [ZegoUIKitPrebuiltLiveStreamingConfig.onLeaveLiveAudioRoom] settings in the config.
  Future<bool> leave(
    BuildContext context, {
    bool showConfirmation = true,
  }) async {
    if (null == _seatManager) {
      ZegoLoggerService.logInfo(
        'leave, param is invalid, seatManager:$_seatManager',
        tag: 'audio room',
        subTag: 'controller',
      );

      return false;
    }

    if (_seatManager?.isLeavingRoom ?? false) {
      ZegoLoggerService.logInfo(
        'leave, is leave requesting...',
        tag: 'audio room',
        subTag: 'controller',
      );

      return false;
    }

    if (_seatManager?.isRoomAttributesBatching ?? false) {
      ZegoLoggerService.logInfo(
        'room attribute is batching, ignore',
        tag: 'audio room',
        subTag: 'leave button',
      );
      return false;
    }

    ZegoLoggerService.logInfo(
      'leave, show confirmation:$showConfirmation',
      tag: 'audio room',
      subTag: 'controller',
    );

    if (showConfirmation) {
      ///  if there is a user-defined event before the click,
      ///  wait the synchronize execution result
      final canLeave =
          await _prebuiltConfig?.onLeaveConfirmation?.call(context) ?? true;
      if (!canLeave) {
        ZegoLoggerService.logInfo(
          'leave, refuse',
          tag: 'audio room',
          subTag: 'controller',
        );

        return false;
      }

      /// take off seat when leave room
      await _seatManager?.leaveSeat(showDialog: false);
      _seatManager?.isLeavingRoom = true;
    }

    await ZegoUIKit().resetSoundEffect();
    await ZegoUIKit().resetBeautyEffect();

    final result = await ZegoUIKit().leaveRoom().then((result) {
      ZegoLoggerService.logInfo(
        'leave, leave room result, ${result.errorCode} ${result.extendedData}',
        tag: 'audio room',
        subTag: 'controller',
      );

      return 0 == result.errorCode;
    });

    final isFromMinimizing = LiveAudioRoomMiniOverlayPageState.minimizing ==
        ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state();
    if (isFromMinimizing) {
      /// leave in minimizing
      await ZegoUIKit().getSignalingPlugin().leaveRoom();

      /// not need logout
      // await ZegoUIKit().getSignalingPlugin().logout();
      /// not need destroy signaling sdk
      await ZegoUIKit().getSignalingPlugin().uninit(forceDestroy: false);

      await ZegoLiveAudioRoomManagers().unintPluginAndManagers();

      ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().changeState(
        LiveAudioRoomMiniOverlayPageState.idle,
      );

      _prebuiltConfig?.onLeaveLiveAudioRoom?.call(isFromMinimizing);
    } else {
      if (_prebuiltConfig?.onLeaveLiveAudioRoom != null) {
        _prebuiltConfig?.onLeaveLiveAudioRoom!.call(isFromMinimizing);
      } else {
        Navigator.of(
          context,
          rootNavigator: _prebuiltConfig?.rootNavigator ?? true,
        ).pop();
      }
    }

    uninitByPrebuilt();

    ZegoLoggerService.logInfo(
      'leave, finished',
      tag: 'audio room',
      subTag: 'controller',
    );

    return result;
  }

  ///--------end of host invite audience to take seat's api--------------

  ///
  void hideInMemberList(List<String> userIDs) {
    _hiddenUsersOfMemberListNotifier.value = List<String>.from(userIDs);
  }
}
