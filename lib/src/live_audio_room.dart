// Dart imports:
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/dialogs.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/live_page.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/permissions.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoUIKitPrebuiltLiveAudioRoom extends StatefulWidget {
  const ZegoUIKitPrebuiltLiveAudioRoom({
    Key? key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.roomID,
    required this.config,
    this.tokenServerUrl = '',
  }) : super(key: key);

  /// you need to fill in the appID you obtained from console.zegocloud.com
  final int appID;

  /// for Android/iOS
  /// you need to fill in the appID you obtained from console.zegocloud.com
  final String appSign;

  /// tokenServerUrl is only for web.
  /// If you have to support Web and Android, iOS, then you can use it like this
  /// ```
  ///   ZegoUIKitPrebuiltLiveAudioRoom(
  ///     appID: appID,
  ///     appSign: kIsWeb ? '' : appSign,
  ///     userID: userID,
  ///     userName: userName,
  ///     tokenServerUrl: kIsWeb ? tokenServerUrl：'',
  ///   );
  /// ```
  final String tokenServerUrl;

  /// local user info
  final String userID;
  final String userName;

  /// You can customize the liveName arbitrarily,
  /// just need to know: users who use the same liveName can talk with each other.
  final String roomID;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;

  @override
  State<ZegoUIKitPrebuiltLiveAudioRoom> createState() =>
      _ZegoUIKitPrebuiltLiveAudioRoomState();
}

class _ZegoUIKitPrebuiltLiveAudioRoomState
    extends State<ZegoUIKitPrebuiltLiveAudioRoom> with WidgetsBindingObserver {
  late ZegoPrebuiltPlugins plugins;
  late final ZegoLiveSeatManager seatManager;

  @override
  void initState() {
    super.initState();

    correctConfigValue();

    WidgetsBinding.instance.addObserver(this);

    ZegoUIKit().getZegoUIKitVersion().then((version) {
      log('version: zego_uikit_prebuilt_live_audio_room: 1.0.7; $version');
    });

    plugins = ZegoPrebuiltPlugins(
      appID: widget.appID,
      appSign: widget.appSign,
      userID: widget.userID,
      userName: widget.userName,
      roomID: widget.roomID,
      plugins: [ZegoUIKitSignalingPlugin()],
      onPluginReLogin: () {
        seatManager.queryRoomAllAttributes(withToast: false).then((value) {
          seatManager.initRoleAndSeat();
        });
      },
    );
    seatManager = ZegoLiveSeatManager(
      userID: widget.userID,
      roomID: widget.roomID,
      plugins: plugins,
      config: widget.config,
      translationText: widget.config.translationText,
      contextQuery: () {
        return context;
      },
    );

    initToast();

    plugins.init().then((value) {
      checkPermissions().then((value) {
        ZegoLoggerService.logInfo(
          'plugins init done',
          tag: 'audio room',
          subTag: 'prebuilt',
        );
        seatManager.init().then((value) {
          ZegoLoggerService.logInfo(
            'seat manager init done',
            tag: 'audio room',
            subTag: 'prebuilt',
          );
          seatManager.initRoleAndSeat();
        });
      });
    });
    initContext();
  }

  @override
  void dispose() async {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    await seatManager.uninit();
    await plugins.uninit();

    await uninitContext();
  }

  @override
  void didUpdateWidget(ZegoUIKitPrebuiltLiveAudioRoom oldWidget) {
    super.didUpdateWidget(oldWidget);

    plugins.onUserInfoUpdate(widget.userID, widget.userName);
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
        plugins.tryReLogin();
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
      tokenServerUrl: widget.tokenServerUrl,
      plugins: plugins,
      seatManager: seatManager,
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
  }

  Future<void> checkPermissions() async {
    var isMicrophoneGranted = true;
    if (widget.config.turnOnMicrophoneWhenJoining) {
      isMicrophoneGranted = await requestPermission(Permission.microphone);
    }

    if (!isMicrophoneGranted) {
      await showAppSettingsDialog(
        context,
        widget.config.translationText.microphonePermissionSettingDialogInfo,
      );
    }
  }

  void initContext() {
    if (!kIsWeb) {
      assert(widget.appSign.isNotEmpty);
      ZegoUIKit().login(widget.userID, widget.userName).then((value) {
        ZegoUIKit()
            .init(
              appID: widget.appID,
              appSign: widget.appSign,
              scenario: ZegoScenario.Broadcast,
            )
            .then(onContextInit);
      });
    } else {
      assert(widget.tokenServerUrl.isNotEmpty);
      ZegoUIKit().login(widget.userID, widget.userName).then((value) {
        ZegoUIKit()
            .init(
              appID: widget.appID,
              tokenServerUrl: widget.tokenServerUrl,
              scenario: ZegoScenario.Broadcast,
            )
            .then(onContextInit);
      });
    }
  }

  void onContextInit(_) {
    ZegoUIKit()
      ..turnCameraOn(false)
      ..turnMicrophoneOn(widget.config.turnOnMicrophoneWhenJoining)
      ..setAudioOutputToSpeaker(widget.config.useSpeakerWhenJoining);

    if (!kIsWeb) {
      ZegoUIKit().joinRoom(widget.roomID).then((result) async {
        await onRoomLogin(result);
      });
    } else {
      getToken(widget.userID).then((token) {
        assert(token.isNotEmpty);
        ZegoUIKit().joinRoom(widget.roomID, token: token).then((result) async {
          await onRoomLogin(result);
        });
      });
    }
  }

  Future<void> onRoomLogin(ZegoRoomLoginResult result) async {
    if (0 != result.errorCode) {
      showToast('join room failed, ${result.errorCode} ${result.extendedData}');
    }
  }

  /// Get your token from tokenServer
  Future<String> getToken(String userID) async {
    final response = await http
        .get(Uri.parse('${widget.tokenServerUrl}/access_token?uid=$userID'));
    if (response.statusCode == 200) {
      final jsonObj = json.decode(response.body);
      return jsonObj['token'];
    } else {
      return '';
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
        seatManager.localRole.value != ZegoLiveAudioRoomRole.host) {
      return true;
    }

    return await showLiveDialog(
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
}
