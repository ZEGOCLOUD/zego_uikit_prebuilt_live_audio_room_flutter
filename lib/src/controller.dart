// Dart imports:
import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:floating/floating.dart';
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/dialogs.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller/private/media_player.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/protocol.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/overlay_machine.dart';

part 'controller/media.dart';

part 'controller/message.dart';

part 'controller/seat.dart';

part 'controller/audio_video.dart';

part 'controller/minimize.dart';

part 'controller/pip.dart';

part 'controller/room.dart';

part 'controller/user.dart';

part 'controller/private/room.dart';

part 'controller/private/private.dart';

part 'controller/private/audio_video.dart';

part 'controller/private/minimize.dart';

part 'controller/private/pip.dart';

part 'controller/private/seat.dart';

part 'controller/private/user.dart';

part 'controller/private/media.dart';

/// Used to control the audio chat room functionality.
///
/// [ZegoUIKitPrebuiltLiveAudioRoomController] is a **singleton instance** class,
/// you can directly invoke it by ZegoUIKitPrebuiltLiveAudioRoomController().
///
/// If the default audio chat room UI and interactions do not meet your requirements, you can use this [ZegoUIKitPrebuiltLiveAudioRoomController] to actively control the business logic.
/// This class is used by setting the [controller] parameter in the constructor of [ZegoUIKitPrebuiltLiveAudioRoom].
class ZegoUIKitPrebuiltLiveAudioRoomController
    with
        ZegoLiveAudioRoomControllerPrivate,
        ZegoLiveAudioRoomControllerMedia,
        ZegoLiveAudioRoomControllerMessage,
        ZegoLiveAudioRoomControllerMinimizing,
        ZegoLiveAudioRoomControllerPIP,
        ZegoLiveAudioRoomControllerSeat,
        ZegoLiveAudioRoomControllerAudioVideo,
        ZegoLiveAudioRoomControllerRoom,
        ZegoLiveAudioRoomControllerUser {
  factory ZegoUIKitPrebuiltLiveAudioRoomController() => instance;

  String get version => "3.16.2";

  /// This function is used to end the Live Audio Room.
  ///
  /// You can pass the context [context] for any necessary pop-ups or page transitions.
  /// By using the [showConfirmation] parameter, you can control whether to display a confirmation dialog to confirm ending the Live Audio Room.
  ///
  /// This function behaves the same as the close button in the calling
  /// interface's top right corner, and it is also affected by the
  /// [ZegoUIKitPrebuiltLiveAudioRoomEvents.onLeaveConfirmation] and
  /// [ZegoUIKitPrebuiltLiveAudioRoomEvents.onEnded] settings in the config.
  Future<bool> leave(
    BuildContext context, {
    bool showConfirmation = true,
  }) async {
    ZegoLoggerService.logInfo(
      'leave',
      tag: 'audio-room',
      subTag: 'controller',
    );

    final result = await room.private._leave(
      context,
      showConfirmation: showConfirmation,
    );

    await ZegoUIKitPrebuiltLiveAudioRoomController().pip.cancelBackground();

    private.uninitByPrebuilt();
    seat.private.uninitByPrebuilt();
    room.private.uninitByPrebuilt();
    user.private.uninitByPrebuilt();
    media.private.uninitByPrebuilt();
    minimize.private.uninitByPrebuilt();
    pip.private.uninitByPrebuilt();
    audioVideo.private.uninitByPrebuilt();

    ZegoLoggerService.logInfo(
      'leave, finished',
      tag: 'audio-room',
      subTag: 'controller',
    );

    return result;
  }

  /// hide some user in member list
  void hideInMemberList(List<String> userIDs) {
    ZegoLoggerService.logInfo(
      'hideInMemberList',
      tag: 'audio-room',
      subTag: 'controller',
    );

    private.hiddenUsersOfMemberListNotifier.value = List<String>.from(userIDs);
  }

  ZegoUIKitPrebuiltLiveAudioRoomController._internal() {
    ZegoLoggerService.logInfo(
      'ZegoUIKitPrebuiltLiveAudioRoomController create',
      tag: 'call',
      subTag: 'audio room controller(${identityHashCode(this)})',
    );
  }

  static final ZegoUIKitPrebuiltLiveAudioRoomController instance =
      ZegoUIKitPrebuiltLiveAudioRoomController._internal();
}
