// Dart imports:
import 'dart:async';
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil_zego/flutter_screenutil_zego.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/dialogs.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/live_page.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/minimizing/prebuilt_data.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

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

  /// you need to fill in the appID you obtained from console.zegocloud.com
  final int appID;

  /// for Android/iOS
  /// you need to fill in the appID you obtained from console.zegocloud.com
  final String appSign;

  /// local user info
  final String userID;
  final String userName;

  /// You can customize the liveName arbitrarily,
  /// just need to know: users who use the same liveName can talk with each other.
  final String roomID;

  final ZegoLiveAudioRoomController? controller;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  final Size? appDesignSize;

  @override
  State<ZegoUIKitPrebuiltLiveAudioRoom> createState() =>
      _ZegoUIKitPrebuiltLiveAudioRoomState();
}

class _ZegoUIKitPrebuiltLiveAudioRoomState
    extends State<ZegoUIKitPrebuiltLiveAudioRoom> with WidgetsBindingObserver {
  List<StreamSubscription<dynamic>?> subscriptions = [];

  bool isFromMinimizing = false;
  late ZegoUIKitPrebuiltLiveAudioRoomData prebuiltAudioRoomData;

  @override
  void initState() {
    super.initState();

    correctConfigValue();

    prebuiltAudioRoomData = ZegoUIKitPrebuiltLiveAudioRoomData(
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
        'version: zego_uikit_prebuilt_live_audio_room: 2.4.3; $version',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
    });

    subscriptions
      ..add(ZegoUIKit().getUserJoinStream().listen(onUserJoined))
      ..add(ZegoUIKit().getUserLeaveStream().listen(onUserLeave));

    isFromMinimizing = LiveAudioRoomMiniOverlayPageState.idle !=
        ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state();
    if (!isFromMinimizing) {
      ZegoLiveAudioRoomManagers().initPluginAndManagers(prebuiltAudioRoomData);
    }
    ZegoLiveAudioRoomManagers().updateContextQuery(() {
      return context;
    });

    widget.controller?.initByPrebuilt(
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

    widget.controller?.uninitByPrebuilt();

    if (LiveAudioRoomMiniOverlayPageState.minimizing !=
        ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().state()) {
      ZegoLiveAudioRoomManagers().unintPluginAndManagers();

      uninitContext();
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
      prebuiltController: widget.controller,
      prebuiltAudioRoomData: prebuiltAudioRoomData,
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
      'layout config:${widget.config.layoutConfig.toString()}',
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
      );
    }
  }

  void initContext() {
    assert(widget.userID.isNotEmpty);
    assert(widget.userName.isNotEmpty);
    assert(widget.appID > 0);
    assert(widget.appSign.isNotEmpty);

    ZegoUIKit().login(widget.userID, widget.userName);

    ZegoUIKit()
        .init(
          appID: widget.appID,
          appSign: widget.appSign,
          scenario: ZegoScenario.Broadcast,
        )
        .then(onContextInit);
  }

  void onContextInit(_) {
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
      ZegoLoggerService.logInfo(
        'failed to login room:${result.errorCode},${result.extendedData}',
        tag: 'audio room',
        subTag: 'prebuilt',
      );
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
        Navigator.of(context).pop(false);
      },
      rightButtonText: widget.config.confirmDialogInfo!.confirmButtonName,
      rightButtonCallback: () {
        //  pop this dialog
        Navigator.of(context).pop(true);
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

  void onInRoomUserAttributesUpdated() {
    widget.config.onUserCountOrPropertyChanged?.call(ZegoUIKit().getAllUsers());
  }
}
