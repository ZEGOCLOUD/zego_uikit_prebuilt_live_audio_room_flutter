// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/duration_time_board.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/core_managers.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';

class ZegoMinimizingAudioRoomPage extends StatefulWidget {
  const ZegoMinimizingAudioRoomPage({
    Key? key,
    required this.size,
    this.borderRadius = 6.0,
    this.borderColor,
    this.backgroundColor,
    this.userNameTextColor,
    this.padding = 0.0,
    this.withCircleBorder = true,
    this.showDevices = true,
    this.showUserName = true,
    this.showLeaveButton = true,
    this.showMicrophoneButton = true,
    this.soundWaveColor = const Color(0xff2254f6),
    this.leaveButtonIcon,
    this.foreground,
    this.background,
    this.builder,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.avatarBuilder,
    this.durationConfig,
    this.durationEvents,
  }) : super(key: key);

  final Size size;
  final double padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool withCircleBorder;
  final bool showDevices;
  final bool showUserName;
  final Color? userNameTextColor;
  final bool showLeaveButton;
  final bool showMicrophoneButton;
  final Widget? leaveButtonIcon;

  final Color soundWaveColor;
  final Widget? foreground;
  final Widget? background;
  final Widget Function(ZegoUIKitUser? activeUser)? builder;

  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;
  final ZegoAvatarBuilder? avatarBuilder;

  final ZegoLiveAudioRoomLiveDurationConfig? durationConfig;
  final ZegoLiveAudioRoomDurationEvents? durationEvents;

  @override
  State<ZegoMinimizingAudioRoomPage> createState() =>
      ZegoMinimizingAudioRoomPageState();
}

class ZegoMinimizingAudioRoomPageState
    extends State<ZegoMinimizingAudioRoomPage> {
  StreamSubscription<dynamic>? audioVideoListSubscription;
  List<StreamSubscription<dynamic>?> soundLevelSubscriptions = [];
  Timer? activeUserTimer;
  final activeUserIDNotifier = ValueNotifier<String?>(null);
  final Map<String, List<double>> rangeSoundLevels = {};

  Size get buttonArea => Size(widget.size.width * 0.3, widget.size.width * 0.3);

  Size get buttonSize => Size(widget.size.width * 0.2, widget.size.width * 0.2);

  double get userNameFontSize => widget.size.width * 0.08;

  @override
  void initState() {
    super.initState();

    listenAudioVideoList();
    activeUserTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateActiveUserByTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();

    activeUserTimer?.cancel();
    activeUserTimer = null;
    audioVideoListSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: activeUserIDNotifier,
      builder: (context, activeUserID, _) {
        final activeUser = ZegoUIKit().getUser(activeUserID ?? '');
        return widget.withCircleBorder
            ? circleBorder(
                child: minimizingUserWidget(activeUser),
              )
            : minimizingUserWidget(activeUser);
      },
    );
  }

  Widget circleBorder({required Widget child}) {
    final decoration = BoxDecoration(
      border: Border.all(
        color: widget.borderColor ?? const Color(0xffA4A4A4),
        width: 1,
      ),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    );

    return Container(
      padding: EdgeInsets.all(widget.padding),
      decoration: decoration,
      child: PhysicalModel(
        color: widget.backgroundColor ?? const Color(0xffA4A4A4),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        clipBehavior: Clip.antiAlias,
        elevation: 6.0,
        shadowColor: Colors.black,
        child: child,
      ),
    );
  }

  Widget minimizingUserWidget(ZegoUIKitUser? activeUser) {
    final spacing = widget.size.height * 0.08;
    return widget.builder?.call(activeUser) ??
        Stack(
          children: [
            widget.background ?? Container(),
            ZegoAudioVideoView(
              user: activeUser,
              avatarConfig: ZegoAvatarConfig(
                showInAudioMode: true,
                showSoundWavesInAudioMode: true,
                builder: widget.avatarBuilder,
                soundWaveColor: widget.soundWaveColor,
                size: Size(
                  widget.size.width * 0.6,
                  widget.size.height * 0.6,
                ),
                verticalAlignment: ZegoAvatarAlignment.center,
              ),
              foregroundBuilder: widget.foregroundBuilder,
              backgroundBuilder: widget.backgroundBuilder,
            ),
            Positioned(
              bottom: spacing,
              child: userName(context, activeUser),
            ),
            Positioned(
              right: spacing,
              bottom: userNameFontSize + spacing,
              child: devices(activeUser),
            ),
            Positioned(
              top: spacing,
              left: spacing,
              child: redPoint(),
            ),
            durationTimeBoard(),
            widget.foreground ?? Container(),
            widget.showLeaveButton
                ? Positioned(
                    top: spacing,
                    right: spacing,
                    child: leaveButton(),
                  )
                : Container(),
          ],
        );
  }

  Widget leaveButton() {
    return ZegoTextIconButton(
      buttonSize: buttonArea,
      iconSize: buttonSize,
      icon: ButtonIcon(
        icon: widget.leaveButtonIcon ??
            ZegoLiveAudioRoomImage.asset(
              ZegoLiveAudioRoomIconUrls.topQuit,
            ),
        backgroundColor: Colors.white,
      ),
      onPressed: () async {
        await ZegoUIKitPrebuiltLiveAudioRoomController().leave(
          context,
          showConfirmation: false,
        );
      },
    );
  }

  Widget durationTimeBoard() {
    if (null == ZegoLiveAudioRoomManagers().liveDurationManager) {
      return Container();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 2,
      child: LiveDurationTimeBoard(
        config: widget.durationConfig ?? ZegoLiveAudioRoomLiveDurationConfig(),
        events: widget.durationEvents ?? ZegoLiveAudioRoomDurationEvents(),
        manager: ZegoLiveAudioRoomManagers().liveDurationManager!,
        fontSize: userNameFontSize,
      ),
    );
  }

  Widget devices(ZegoUIKitUser? activeUser) {
    if (null == activeUser) {
      return Container();
    }

    if (!widget.showDevices) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.showMicrophoneButton
            ? microphoneButton(activeUser)
            : Container(),
      ],
    );
  }

  Widget microphoneButton(ZegoUIKitUser activeUser) {
    return ValueListenableBuilder<bool>(
      valueListenable: ZegoUIKit().getMicrophoneStateNotifier(activeUser.id),
      builder: (context, isMicrophoneEnabled, _) {
        return GestureDetector(
          onTap: activeUser.id == ZegoUIKit().getLocalUser().id
              ? () {
                  ZegoUIKit().turnMicrophoneOn(
                    !isMicrophoneEnabled,
                    userID: activeUser.id,
                    muteMode: true,
                  );
                }
              : null,
          child: Container(
            width: buttonArea.width,
            height: buttonArea.height,
            decoration: BoxDecoration(
              color: isMicrophoneEnabled
                  ? controlBarButtonCheckedBackgroundColor
                  : controlBarButtonBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: buttonSize.width,
                height: buttonSize.height,
                child: ZegoLiveAudioRoomImage.asset(
                  isMicrophoneEnabled
                      ? ZegoLiveAudioRoomIconUrls.toolbarMicNormal
                      : ZegoLiveAudioRoomIconUrls.toolbarMicOff,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget userName(BuildContext context, ZegoUIKitUser? activeUser) {
    return widget.showUserName
        ? SizedBox(
            width: widget.size.width / 3 * 2,
            child: Text(
              activeUser?.name ?? '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: userNameFontSize,
                color: widget.userNameTextColor ?? Colors.black,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          )
        : Container();
  }

  Widget redPoint() {
    if (null == ZegoLiveAudioRoomManagers().connectManager) {
      return Container();
    }

    return ValueListenableBuilder<
        List<ZegoLiveAudioRoomRequestingTakeSeatListItem>>(
      valueListenable: ZegoLiveAudioRoomManagers()
          .connectManager!
          .audiencesRequestingTakeSeatNotifier,
      builder: (context, requestTakeSeatUsers, _) {
        if (requestTakeSeatUsers.isEmpty) {
          return Container();
        } else {
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            width: 20.zR,
            height: 20.zR,
          );
        }
      },
    );
  }

  void listenAudioVideoList() {
    audioVideoListSubscription =
        ZegoUIKit().getAudioVideoListStream().listen(onAudioVideoListUpdated);

    onAudioVideoListUpdated(ZegoUIKit().getAudioVideoList());
    activeUserIDNotifier.value = ZegoUIKit().getAudioVideoList().isEmpty
        ? ZegoUIKit().getLocalUser().id
        : ZegoUIKit().getAudioVideoList().first.id;
  }

  void onAudioVideoListUpdated(List<ZegoUIKitUser> users) {
    for (final subscription in soundLevelSubscriptions) {
      subscription?.cancel();
    }
    rangeSoundLevels.clear();

    for (final user in users) {
      soundLevelSubscriptions.add(user.soundLevel.listen((soundLevel) {
        if (rangeSoundLevels.containsKey(user.id)) {
          rangeSoundLevels[user.id]!.add(soundLevel);
        } else {
          rangeSoundLevels[user.id] = [soundLevel];
        }
      }));
    }
  }

  void updateActiveUserByTimer() {
    var maxAverageSoundLevel = 0.0;
    var activeUserID = '';
    rangeSoundLevels.forEach((userID, soundLevels) {
      final averageSoundLevel =
          soundLevels.reduce((a, b) => a + b) / soundLevels.length;

      if (averageSoundLevel > maxAverageSoundLevel) {
        activeUserID = userID;
        maxAverageSoundLevel = averageSoundLevel;
      }
    });
    activeUserIDNotifier.value = activeUserID;
    if (activeUserIDNotifier.value?.isEmpty ?? true) {
      activeUserIDNotifier.value = ZegoUIKit().getLocalUser().id;
    }

    rangeSoundLevels.clear();
  }
}
