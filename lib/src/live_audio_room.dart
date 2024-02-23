// Dart imports:
import 'dart:async';
import 'dart:core';
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/dialogs.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/live_page.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/overlay_machine.dart';
import 'internal/events.dart';

/// Live Audio Room Widget.
/// You can embed this widget into any page of your project to integrate the functionality of a audio chat room.
/// You can refer to our [documentation](https://docs.zegocloud.com/article/15079),
/// or our [sample code](https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_live_audio_room_example_flutter/tree/master/live_audio_room).
///
/// {@category APIs}
/// {@category Events}
/// {@category Configs}
/// {@category Migration_v3.x}
class ZegoUIKitPrebuiltLiveAudioRoom extends StatefulWidget {
  const ZegoUIKitPrebuiltLiveAudioRoom({
    Key? key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.roomID,
    required this.config,
    this.events,
  }) : super(key: key);

  /// You can create a project and obtain an appID from the [ZEGOCLOUD Admin Console](https://console.zegocloud.com).
  final int appID;

  /// You can create a project and obtain an appSign from the [ZEGOCLOUD Admin Console](https://console.zegocloud.com).
  final String appSign;

  /// The ID of the currently logged-in user.
  /// It can be any valid string.
  /// Typically, you would use the ID from your own user system, such as Firebase.
  final String userID;

  /// The name of the currently logged-in user.
  /// It can be any valid string.
  /// Typically, you would use the name from your own user system, such as Firebase.
  final String userName;

  /// The ID of the audio chat room.
  /// This ID serves as a unique identifier for the room, so you need to ensure its uniqueness.
  /// It can be any valid string.
  /// Users who enter the same [roomID] will be logged into the same room to chat or listen to others.
  final String roomID;

  /// Initialize the configuration for the voice chat room.
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  /// Initialize the event for the voice chat room.
  final ZegoUIKitPrebuiltLiveAudioRoomEvents? events;

  @override
  State<ZegoUIKitPrebuiltLiveAudioRoom> createState() =>
      _ZegoUIKitPrebuiltLiveAudioRoomState();
}

class _ZegoUIKitPrebuiltLiveAudioRoomState
    extends State<ZegoUIKitPrebuiltLiveAudioRoom> with WidgetsBindingObserver {
  List<StreamSubscription<dynamic>?> subscriptions = [];
  ZegoLiveAudioRoomEventListener? _eventListener;

  late ZegoUIKitPrebuiltLiveAudioRoomMinimizeData minimizeData;

  ZegoUIKitPrebuiltLiveAudioRoomEvents get events =>
      (widget.events ?? ZegoUIKitPrebuiltLiveAudioRoomEvents())
        ..onLeaveConfirmation ??= defaultLeaveConfirmation;

  @override
  void initState() {
    super.initState();

    correctConfigValue();

    minimizeData = ZegoUIKitPrebuiltLiveAudioRoomMinimizeData(
      appID: widget.appID,
      appSign: widget.appSign,
      roomID: widget.roomID,
      userID: widget.userID,
      userName: widget.userName,
      config: widget.config,
      events: events,
      isPrebuiltFromMinimizing: ZegoLiveAudioRoomMiniOverlayPageState.idle !=
          ZegoLiveAudioRoomInternalMiniOverlayMachine().state(),
    );

    WidgetsBinding.instance.addObserver(this);

    ZegoUIKit().getZegoUIKitVersion().then((version) {
      ZegoLoggerService.logInfo(
        'version: zego_uikit_prebuilt_live_audio_room: 3.3.2; $version',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    });

    _eventListener = ZegoLiveAudioRoomEventListener(widget.events);
    _eventListener?.init();

    subscriptions
      ..add(ZegoUIKit().getUserJoinStream().listen(onUserJoined))
      ..add(ZegoUIKit().getUserLeaveStream().listen(onUserLeave))
      ..add(
          ZegoUIKit().getMeRemovedFromRoomStream().listen(onMeRemovedFromRoom))
      ..add(ZegoUIKit().getErrorStream().listen(onUIKitError));

    final isPrebuiltFromMinimizing =
        ZegoLiveAudioRoomMiniOverlayPageState.idle !=
            ZegoLiveAudioRoomInternalMiniOverlayMachine().state();
    if (isPrebuiltFromMinimizing) {
      ZegoLoggerService.logInfo(
        'mini machine state is not idle, plugin manager will not be init',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    } else {
      ZegoLiveAudioRoomManagers().initPluginAndManagers(
        appID: widget.appID,
        appSign: widget.appSign,
        roomID: widget.roomID,
        userID: widget.userID,
        userName: widget.userName,
        config: widget.config,
        events: events,
      );

      ZegoUIKitPrebuiltLiveAudioRoomController().private.initByPrebuilt(
            config: widget.config,
            events: events,
            connectManager: ZegoLiveAudioRoomManagers().connectManager,
            seatManager: ZegoLiveAudioRoomManagers().seatManager,
          );
      ZegoUIKitPrebuiltLiveAudioRoomController().room.private.initByPrebuilt(
            config: widget.config,
            events: events,
            connectManager: ZegoLiveAudioRoomManagers().connectManager,
            seatManager: ZegoLiveAudioRoomManagers().seatManager,
          );
      ZegoUIKitPrebuiltLiveAudioRoomController().seat.private.initByPrebuilt(
            connectManager: ZegoLiveAudioRoomManagers().connectManager,
            seatManager: ZegoLiveAudioRoomManagers().seatManager,
          );
      ZegoUIKitPrebuiltLiveAudioRoomController()
          .minimize
          .private
          .initByPrebuilt(
            minimizeData: minimizeData,
          );
      ZegoUIKitPrebuiltLiveAudioRoomController()
          .audioVideo
          .private
          .initByPrebuilt(
            seatManager: ZegoLiveAudioRoomManagers().seatManager,
            config: widget.config,
          );
    }

    ZegoLiveAudioRoomManagers().updateContextQuery(() {
      return context;
    });
    ZegoLiveAudioRoomToast.instance.init(contextQuery: () {
      return context;
    });

    /// todo check, not wake from mini page
    ZegoLiveAudioRoomManagers().plugins?.init().then((value) {
      checkPermissions().then((value) {
        ZegoLoggerService.logInfo(
          'plugins init done',
          tag: 'audio room',
          subTag: 'prebuilt',
        );
        ZegoLiveAudioRoomManagers().seatManager?.init().then((value) {
          ZegoLoggerService.logInfo(
            'seat manager init done',
            tag: 'audio room',
            subTag: 'prebuilt',
          );

          ZegoLiveAudioRoomManagers().connectManager?.init();
        });
      });
    });

    ZegoLoggerService.logInfo(
      'mini machine state is ${ZegoLiveAudioRoomInternalMiniOverlayMachine().state()}',
      tag: 'audio room',
      subTag: 'prebuilt',
    );
    if (isPrebuiltFromMinimizing) {
      ZegoLoggerService.logInfo(
        'mini machine state is not idle, context will not be init',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    } else {
      initContext();
    }

    ZegoLiveAudioRoomInternalMiniOverlayMachine().changeState(
      ZegoLiveAudioRoomMiniOverlayPageState.idle,
    );
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    _eventListener?.uninit();

    if (ZegoLiveAudioRoomMiniOverlayPageState.minimizing !=
        ZegoLiveAudioRoomInternalMiniOverlayMachine().state()) {
      ZegoLiveAudioRoomManagers().uninitPluginAndManagers();

      uninitContext();

      ZegoUIKitPrebuiltLiveAudioRoomController().private.uninitByPrebuilt();
      ZegoUIKitPrebuiltLiveAudioRoomController()
          .seat
          .private
          .uninitByPrebuilt();
      ZegoUIKitPrebuiltLiveAudioRoomController()
          .room
          .private
          .uninitByPrebuilt();
      ZegoUIKitPrebuiltLiveAudioRoomController()
          .minimize
          .private
          .uninitByPrebuilt();
      ZegoUIKitPrebuiltLiveAudioRoomController()
          .audioVideo
          .private
          .uninitByPrebuilt();
    } else {
      ZegoLoggerService.logInfo(
        'mini machine state is minimizing, room will not be leave',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    }

    for (final subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    ZegoLoggerService.logInfo(
      'didChangeAppLifecycleState $state',
      tag: 'audio room',
      subTag: 'prebuilt',
    );

    switch (state) {
      case AppLifecycleState.resumed:
        ZegoLiveAudioRoomManagers().plugins?.tryReLogin();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
      // case AppLifecycleState.hidden:
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZegoLiveAudioRoomPage(
      appID: widget.appID,
      appSign: widget.appSign,
      userID: widget.userID,
      userName: widget.userName,
      liveID: widget.roomID,
      config: widget.config,
      events: events,
      defaultEndAction: defaultEndAction,
      defaultLeaveConfirmationAction: defaultLeaveConfirmationAction,
      plugins: ZegoLiveAudioRoomManagers().plugins,
      seatManager: ZegoLiveAudioRoomManagers().seatManager!,
      connectManager: ZegoLiveAudioRoomManagers().connectManager!,
      popUpManager: ZegoLiveAudioRoomManagers().popUpManager,
      liveDurationManager: ZegoLiveAudioRoomManagers().liveDurationManager!,
      minimizeData: minimizeData,
    );
  }

  void correctConfigValue() {
    if (widget.config.bottomMenuBar.maxCount > 5) {
      widget.config.bottomMenuBar.maxCount = 5;
      ZegoLoggerService.logInfo(
        "menu bar buttons limited count's value is exceeding the maximum limit",
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    }

    for (final rowConfig in widget.config.seat.layout.rowConfigs) {
      if (rowConfig.count < 1) {
        rowConfig.count = 1;
        ZegoLoggerService.logInfo(
          'config column count(${rowConfig.count}) is small than 0, set to 1',
          tag: 'audio room',
          subTag: 'prebuilt',
        );
      }

      // if (rowConfig.count > 4) {
      //   rowConfig.count = 4;
      //   ZegoLoggerService.logInfo(
      //     'config column count(${rowConfig.count}) is bigger than 4, set to 4',
      //     tag: 'audio room',
      //     subTag: 'prebuilt',
      //   );
      // }
    }
    if (widget.config.seat.layout.rowSpacing < 0) {
      widget.config.seat.layout.rowSpacing = 0;
      ZegoLoggerService.logInfo(
        'config row spacing(${widget.config.seat.layout.rowSpacing}) '
        'is not valid, set to 0',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    }

    final totalSeatCount = widget.config.seat.layout.rowConfigs
        .fold<int>(0, (totalCount, rowConfig) => totalCount + rowConfig.count);
    final isSeatIndexValid = widget.config.seat.takeIndexWhenJoining >= 0 &&
        widget.config.seat.takeIndexWhenJoining < totalSeatCount;
    if (!isSeatIndexValid) {
      ZegoLoggerService.logInfo(
        'config seat index is not valid, change role to audience '
        'and seat index set to -1',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      widget.config.role = ZegoLiveAudioRoomRole.audience;
      widget.config.seat.takeIndexWhenJoining = -1;
    }
    if (widget.config.role == ZegoLiveAudioRoomRole.audience &&
        isSeatIndexValid) {
      ZegoLoggerService.logInfo(
        'audience config should not on seat default, set to -1',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      widget.config.seat.takeIndexWhenJoining = -1;
    }
    if (ZegoLiveAudioRoomRole.host != widget.config.role &&
        widget.config.seat.hostIndexes
            .contains(widget.config.seat.takeIndexWhenJoining)) {
      ZegoLoggerService.logInfo(
        "config ${widget.config.role}'s index is not valid, "
        'change role to audience and seat index set to -1',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      widget.config.role = ZegoLiveAudioRoomRole.audience;
      widget.config.seat.takeIndexWhenJoining = -1;
    }

    ZegoLoggerService.logInfo(
      'layout config:${widget.config.seat.layout}',
      tag: 'audio room',
      subTag: 'prebuilt',
    );
  }

  Future<void> checkPermissions() async {
    var isMicrophoneGranted = true;
    if (widget.config.turnOnMicrophoneWhenJoining) {
      isMicrophoneGranted = await requestPermission(Permission.microphone);
    }

    if (!isMicrophoneGranted) {
      if (context.mounted) {
        await showAppSettingsDialog(
          context,
          widget.config.innerText.microphonePermissionSettingDialogInfo,
          rootNavigator: widget.config.rootNavigator,
          kickOutNotifier: ZegoLiveAudioRoomManagers().kickOutNotifier,
          popUpManager: ZegoLiveAudioRoomManagers().popUpManager,
        );
      } else {
        ZegoLoggerService.logError(
          'checkPermissions, context not mounted',
          tag: 'live audio room',
          subTag: 'prebuilt',
        );
      }
    }
  }

  Future<void> initContext() async {
    assert(widget.userID.isNotEmpty);
    assert(widget.userName.isNotEmpty);
    assert(widget.appID > 0);
    assert(widget.appSign.isNotEmpty);

    ZegoUIKit().login(widget.userID, widget.userName);

    await ZegoUIKit().setAdvanceConfigs(widget.config.advanceConfigs);

    var enablePlatformView = false;
    if (Platform.isIOS && widget.config.mediaPlayer.supportTransparent) {
      enablePlatformView = true;
    }
    ZegoUIKit()
        .init(
      appID: widget.appID,
      appSign: widget.appSign,
      scenario: ZegoScenario.Broadcast,
      enablePlatformView: enablePlatformView,
    )
        .then((_) async {
      await ZegoUIKit().setAdvanceConfigs(widget.config.advanceConfigs);

      onContextInit();
    });
  }

  void onContextInit() {
    ZegoUIKit()
      ..turnCameraOn(false)
      ..turnMicrophoneOn(
        widget.config.turnOnMicrophoneWhenJoining,
        muteMode: true,
      )
      ..setAudioOutputToSpeaker(widget.config.useSpeakerWhenJoining)
      ..setAudioVideoResourceMode(ZegoAudioVideoResourceMode.onlyRTC);

    ZegoUIKit().joinRoom(widget.roomID).then((result) async {
      await onRoomLogin(result);
    });
  }

  Future<void> onRoomLogin(ZegoRoomLoginResult result) async {
    assert(result.errorCode == 0);
    if (result.errorCode != 0) {
      ZegoLoggerService.logError(
        'failed to login room:${result.errorCode},${result.extendedData}',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    }

    await ZegoLiveAudioRoomManagers().liveDurationManager!.init();

    initBackgroundMedia();
  }

  void initBackgroundMedia() {
    if (ZegoLiveAudioRoomManagers().seatManager?.localRole.value !=
        ZegoLiveAudioRoomRole.host) {
      return;
    }

    if (widget.config.backgroundMedia.path?.isNotEmpty ?? false) {
      ZegoLoggerService.logInfo(
        'try play media:${widget.config.backgroundMedia.path!}, '
        'repeat:${widget.config.backgroundMedia.enableRepeat}',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      ZegoUIKit()
          .playMedia(
        filePathOrURL: widget.config.backgroundMedia.path!,
        enableRepeat: widget.config.backgroundMedia.enableRepeat,
      )
          .then((playResult) {
        ZegoLoggerService.logInfo(
          'media play result:${playResult.errorCode}',
          tag: 'audio room',
          subTag: 'prebuilt',
        );
      });
    }
  }

  Future<void> uninitContext() async {
    await ZegoUIKit().resetSoundEffect();
    await ZegoUIKit().resetBeautyEffect();

    await ZegoUIKit().leaveRoom();

    // await ZegoUIKit().uninit();
  }

  Future<bool> defaultLeaveConfirmation(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,

    /// defaultAction to return to the previous page
    Future<bool> Function() defaultAction,
  ) {
    final endConfirmationEvent = ZegoLiveAudioRoomLeaveConfirmationEvent(
      context: event.context,
    );
    defaultAction() async {
      return defaultLeaveConfirmationAction(endConfirmationEvent);
    }

    return defaultAction.call();
  }

  Future<bool> defaultLeaveConfirmationAction(
    ZegoLiveAudioRoomLeaveConfirmationEvent event,
  ) async {
    if (widget.config.confirmDialogInfo == null ||
        ZegoLiveAudioRoomManagers().seatManager?.localRole.value !=
            ZegoLiveAudioRoomRole.host) {
      return true;
    }

    return showLiveDialog(
      context: event.context,
      title: widget.config.confirmDialogInfo!.title,
      content: widget.config.confirmDialogInfo!.message,
      leftButtonText: widget.config.confirmDialogInfo!.cancelButtonName,
      leftButtonCallback: () {
        try {
          //  pop this dialog
          Navigator.of(
            event.context,
            rootNavigator: widget.config.rootNavigator,
          ).pop(false);
        } catch (e) {
          ZegoLoggerService.logError(
            'leave confirmation left click, '
            'navigator exception:$e, '
            'event:$event',
            tag: 'live audio room',
            subTag: 'prebuilt',
          );
        }
      },
      rightButtonText: widget.config.confirmDialogInfo!.confirmButtonName,
      rightButtonCallback: () {
        try {
          //  pop this dialog
          Navigator.of(
            event.context,
            rootNavigator: widget.config.rootNavigator,
          ).pop(true);
        } catch (e) {
          ZegoLoggerService.logError(
            'leave confirmation left click, '
            'navigator exception:$e, '
            'event:$event',
            tag: 'live audio room',
            subTag: 'prebuilt',
          );
        }
      },
    );
  }

  void defaultEndAction(
    ZegoLiveAudioRoomEndEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'default end event, event:$event',
      tag: 'live audio room',
      subTag: 'prebuilt',
    );

    switch (event.reason) {
      case ZegoLiveAudioRoomEndReason.localLeave:
      case ZegoLiveAudioRoomEndReason.kickOut:
        if (event.isFromMinimizing) {
          /// now is minimizing state, not need to navigate, just switch to idle
          ZegoUIKitPrebuiltLiveAudioRoomController().minimize.hide();
        } else {
          try {
            Navigator.of(
              context,
              rootNavigator: widget.config.rootNavigator,
            ).pop(true);
          } catch (e) {
            ZegoLoggerService.logError(
              'live end, navigator exception:$e, event:$event',
              tag: 'live audio room',
              subTag: 'prebuilt',
            );
          }
        }
        break;
    }
  }

  void onUserJoined(List<ZegoUIKitUser> users) {
    onInRoomUserAttributesUpdated();

    for (final user in users) {
      ZegoUIKit()
          .getInRoomUserAttributesNotifier(user.id)
          .addListener(onInRoomUserAttributesUpdated);
    }
  }

  void onUserLeave(List<ZegoUIKitUser> users) {
    for (final user in users) {
      ZegoUIKit()
          .getInRoomUserAttributesNotifier(user.id)
          .removeListener(onInRoomUserAttributesUpdated);
    }

    onInRoomUserAttributesUpdated();
  }

  void onMeRemovedFromRoom(String fromUserID) {
    ZegoLoggerService.logInfo(
      'local user removed by $fromUserID',
      tag: 'live audio room',
      subTag: 'prebuilt',
    );

    ZegoLiveAudioRoomManagers().kickOutNotifier.value = true;

    ///more button, member list, dialogs..
    ZegoLiveAudioRoomManagers()
        .popUpManager
        .autoPop(context, widget.config.rootNavigator);

    final endEvent = ZegoLiveAudioRoomEndEvent(
      kickerUserID: fromUserID,
      reason: ZegoLiveAudioRoomEndReason.kickOut,
      isFromMinimizing: ZegoLiveAudioRoomMiniOverlayPageState.minimizing ==
          ZegoUIKitPrebuiltLiveAudioRoomController().minimize.state,
    );
    defaultAction() {
      defaultEndAction(endEvent);
    }

    if (null != events.onEnded) {
      events.onEnded!.call(endEvent, defaultAction);
    } else {
      defaultAction.call();
    }
  }

  void onUIKitError(ZegoUIKitError error) {
    ZegoLoggerService.logError(
      'on uikit error:$error',
      tag: 'live audio room',
      subTag: 'prebuilt',
    );

    events.onError?.call(error);
  }

  void onInRoomUserAttributesUpdated() {
    events.user.onCountOrPropertyChanged?.call(
      ZegoUIKit().getAllUsers(),
    );
  }
}
