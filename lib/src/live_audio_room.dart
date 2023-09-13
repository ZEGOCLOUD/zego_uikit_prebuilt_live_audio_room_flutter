// Dart imports:
import 'dart:async';
import 'dart:core';

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
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/mini_overlay_machine.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/minimizing/prebuilt_data.dart';

/// Live Audio Room Widget.
/// You can embed this widget into any page of your project to integrate the functionality of a audio chat room.
/// You can refer to our [documentation](https://docs.zegocloud.com/article/15079),
/// or our [sample code](https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_live_audio_room_example_flutter/tree/master/live_audio_room).
class ZegoUIKitPrebuiltLiveAudioRoom extends StatefulWidget {
  const ZegoUIKitPrebuiltLiveAudioRoom({
    Key? key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.roomID,
    required this.config,
    this.controller,
    @Deprecated('Since 2.4.1') this.appDesignSize,
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

  /// You can invoke the methods provided by [ZegoUIKitPrebuiltLiveAudioRoom] through the [controller].
  final ZegoLiveAudioRoomController? controller;

  /// Initialize the configuration for the voice chat room.
  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  @Deprecated('Since 2.4.1')
  final Size? appDesignSize;

  /// @nodoc
  @override
  State<ZegoUIKitPrebuiltLiveAudioRoom> createState() =>
      _ZegoUIKitPrebuiltLiveAudioRoomState();
}

/// @nodoc
class _ZegoUIKitPrebuiltLiveAudioRoomState
    extends State<ZegoUIKitPrebuiltLiveAudioRoom> with WidgetsBindingObserver {
  List<StreamSubscription<dynamic>?> subscriptions = [];

  bool isFromMinimizing = false;
  late ZegoUIKitPrebuiltLiveAudioRoomData prebuiltData;

  @override
  void initState() {
    super.initState();

    correctConfigValue();

    prebuiltData = ZegoUIKitPrebuiltLiveAudioRoomData(
      appID: widget.appID,
      appSign: widget.appSign,
      roomID: widget.roomID,
      userID: widget.userID,
      userName: widget.userName,
      config: widget.config,
      controller: widget.controller,
      isPrebuiltFromMinimizing: LiveAudioRoomMiniOverlayPageState.idle !=
          ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state(),
    );

    WidgetsBinding.instance?.addObserver(this);

    ZegoUIKit().getZegoUIKitVersion().then((version) {
      ZegoLoggerService.logInfo(
        'version: zego_uikit_prebuilt_live_audio_room: 2.11.2; $version',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    });

    subscriptions
      ..add(ZegoUIKit().getUserJoinStream().listen(onUserJoined))
      ..add(ZegoUIKit().getUserLeaveStream().listen(onUserLeave))
      ..add(
          ZegoUIKit().getMeRemovedFromRoomStream().listen(onMeRemovedFromRoom));

    isFromMinimizing = LiveAudioRoomMiniOverlayPageState.idle !=
        ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state();
    if (!isFromMinimizing) {
      ZegoLiveAudioRoomManagers().initPluginAndManagers(
        prebuiltData: prebuiltData,
      );
    }
    ZegoLiveAudioRoomManagers().updateContextQuery(() {
      return context;
    });

    widget.controller?.initByPrebuilt(
      config: widget.config,
      connectManager: ZegoLiveAudioRoomManagers().connectManager,
      seatManager: ZegoLiveAudioRoomManagers().seatManager,
    );

    initToast();

    /// not wake from mini page
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
      'mini machine state is ${ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state()}',
      tag: 'audio room',
      subTag: 'prebuilt',
    );
    if (isFromMinimizing) {
      ZegoLoggerService.logInfo(
        'mini machine state is not idle, context will not be init',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    } else {
      initContext();
    }

    ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().changeState(
      LiveAudioRoomMiniOverlayPageState.idle,
    );
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance?.removeObserver(this);

    if (LiveAudioRoomMiniOverlayPageState.minimizing !=
        ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state()) {
      ZegoLiveAudioRoomManagers().unintPluginAndManagers();

      uninitContext();

      widget.controller?.uninitByPrebuilt();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.config.onLeaveConfirmation ??= onLeaveConfirmation;

    return ZegoLivePage(
      appID: widget.appID,
      appSign: widget.appSign,
      userID: widget.userID,
      userName: widget.userName,
      liveID: widget.roomID,
      config: widget.config,
      plugins: ZegoLiveAudioRoomManagers().plugins,
      seatManager: ZegoLiveAudioRoomManagers().seatManager!,
      connectManager: ZegoLiveAudioRoomManagers().connectManager!,
      popUpManager: ZegoLiveAudioRoomManagers().popUpManager,
      liveDurationManager: ZegoLiveAudioRoomManagers().liveDurationManager!,
      prebuiltController: widget.controller,
      prebuiltAudioRoomData: prebuiltData,
    );
  }

  void correctConfigValue() {
    if (widget.config.bottomMenuBarConfig.maxCount > 5) {
      widget.config.bottomMenuBarConfig.maxCount = 5;
      ZegoLoggerService.logInfo(
        "menu bar buttons limited count's value is exceeding the maximum limit",
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    }

    for (final rowConfig in widget.config.layoutConfig.rowConfigs) {
      if (rowConfig.count < 1) {
        rowConfig.count = 1;
        ZegoLoggerService.logInfo(
          'config column count(${rowConfig.count}) is small than 0, set to 1',
          tag: 'audio room',
          subTag: 'prebuilt',
        );
      }
      if (rowConfig.count > 4) {
        rowConfig.count = 4;
        ZegoLoggerService.logInfo(
          'config column count(${rowConfig.count}) is bigger than 4, set to 4',
          tag: 'audio room',
          subTag: 'prebuilt',
        );
      }
    }
    if (widget.config.layoutConfig.rowSpacing < 0) {
      widget.config.layoutConfig.rowSpacing = 0;
      ZegoLoggerService.logInfo(
        'config row spacing(${widget.config.layoutConfig.rowSpacing}) '
        'is not valid, set to 0',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    }

    final totalSeatCount = widget.config.layoutConfig.rowConfigs
        .fold<int>(0, (totalCount, rowConfig) => totalCount + rowConfig.count);
    final isSeatIndexValid = widget.config.takeSeatIndexWhenJoining >= 0 &&
        widget.config.takeSeatIndexWhenJoining < totalSeatCount;
    if (!isSeatIndexValid) {
      ZegoLoggerService.logInfo(
        'config seat index is not valid, change role to audience '
        'and seat index set to -1',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      widget.config.role = ZegoLiveAudioRoomRole.audience;
      widget.config.takeSeatIndexWhenJoining = -1;
    }
    if (widget.config.role == ZegoLiveAudioRoomRole.audience &&
        isSeatIndexValid) {
      ZegoLoggerService.logInfo(
        'audience config should not on seat default, set to -1',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      widget.config.takeSeatIndexWhenJoining = -1;
    }
    if (ZegoLiveAudioRoomRole.host != widget.config.role &&
        widget.config.hostSeatIndexes
            .contains(widget.config.takeSeatIndexWhenJoining)) {
      ZegoLoggerService.logInfo(
        "config ${widget.config.role.toString()}'s index is not valid, "
        'change role to audience and seat index set to -1',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      widget.config.role = ZegoLiveAudioRoomRole.audience;
      widget.config.takeSeatIndexWhenJoining = -1;
    }

    ZegoLoggerService.logInfo(
      'layout config:${widget.config.layoutConfig}',
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
      await showAppSettingsDialog(
        context,
        widget.config.innerText.microphonePermissionSettingDialogInfo,
        rootNavigator: widget.config.rootNavigator,
        kickOutNotifier: ZegoLiveAudioRoomManagers().kickOutNotifier,
        popUpManager: ZegoLiveAudioRoomManagers().popUpManager,
      );
    }
  }

  void initContext() async {
    assert(widget.userID.isNotEmpty);
    assert(widget.userName.isNotEmpty);
    assert(widget.appID > 0);
    assert(widget.appSign.isNotEmpty);

    ZegoUIKit().login(widget.userID, widget.userName);

    await ZegoUIKit().setAdvanceConfigs(widget.config.advanceConfigs);

    ZegoUIKit()
        .init(
      appID: widget.appID,
      appSign: widget.appSign,
      scenario: ZegoScenario.Broadcast,
    )
        .then((_) async {
      await ZegoUIKit().setAdvanceConfigs(widget.config.advanceConfigs);

      onContextInit();
    });
  }

  void onContextInit() {
    ZegoUIKit()
      ..turnCameraOn(false)
      ..turnMicrophoneOn(widget.config.turnOnMicrophoneWhenJoining)
      ..setAudioOutputToSpeaker(widget.config.useSpeakerWhenJoining)
      ..setAudioVideoResourceMode(ZegoAudioVideoResourceMode.RTCOnly);

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

    if (widget.config.backgroundMediaConfig.path?.isNotEmpty ?? false) {
      ZegoLoggerService.logInfo(
        'try play media:${widget.config.backgroundMediaConfig.path!}, '
        'repeat:${widget.config.backgroundMediaConfig.enableRepeat}',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
      ZegoUIKit()
          .playMedia(
        filePathOrURL: widget.config.backgroundMediaConfig.path!,
        enableRepeat: widget.config.backgroundMediaConfig.enableRepeat,
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

  void initToast() {
    ZegoToast.instance.init(contextQuery: () {
      return context;
    });
  }

  Future<bool> onLeaveConfirmation(BuildContext context) async {
    if (widget.config.confirmDialogInfo == null ||
        ZegoLiveAudioRoomManagers().seatManager?.localRole.value !=
            ZegoLiveAudioRoomRole.host) {
      return true;
    }

    return showLiveDialog(
      context: context,
      title: widget.config.confirmDialogInfo!.title,
      content: widget.config.confirmDialogInfo!.message,
      leftButtonText: widget.config.confirmDialogInfo!.cancelButtonName,
      leftButtonCallback: () {
        //  pop this dialog
        Navigator.of(
          context,
          rootNavigator: widget.config.rootNavigator,
        ).pop(false);
      },
      rightButtonText: widget.config.confirmDialogInfo!.confirmButtonName,
      rightButtonCallback: () {
        //  pop this dialog
        Navigator.of(
          context,
          rootNavigator: widget.config.rootNavigator,
        ).pop(true);
      },
    );
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

    if (null != widget.config.onMeRemovedFromRoom) {
      widget.config.onMeRemovedFromRoom!.call(fromUserID);
    } else {
      //  pop this dialog
      Navigator.of(
        context,
        rootNavigator: widget.config.rootNavigator,
      ).pop(true);
    }
  }

  void onInRoomUserAttributesUpdated() {
    widget.config.onUserCountOrPropertyChanged?.call(ZegoUIKit().getAllUsers());
  }
}
