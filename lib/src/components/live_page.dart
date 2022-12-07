// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'audio_video/background.dart';
import 'audio_video/foreground.dart';
import 'audio_video/seat_container.dart';
import 'bottom_bar.dart';
import 'defines.dart';
import 'message/in_room_live_commenting_view.dart';
import 'top_bar.dart';

/// user and sdk should be login and init before page enter
class ZegoLivePage extends StatefulWidget {
  const ZegoLivePage({
    Key? key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.liveID,
    required this.config,
    required this.seatManager,
    this.plugins,
    this.tokenServerUrl = '',
  }) : super(key: key);

  final int appID;
  final String appSign;
  final String tokenServerUrl;

  final String userID;
  final String userName;

  final String liveID;

  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
  final ZegoLiveSeatManager seatManager;
  final ZegoPrebuiltPlugins? plugins;

  @override
  State<ZegoLivePage> createState() => ZegoLivePageState();
}

class ZegoLivePageState extends State<ZegoLivePage>
    with SingleTickerProviderStateMixin {
  /// had sort the host be first
  bool audioVideoContainerHostHadSorted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          return await widget.config.onLeaveConfirmation!(context);
        },
        child: ScreenUtilInit(
          designSize: const Size(750, 1334),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return clickListener(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    background(context, constraints.maxHeight),
                    audioVideoContainer(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    topBar(),
                    bottomBar(),
                    messageList(),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget clickListener({required Widget child}) {
    return GestureDetector(
      onTap: () {
        /// listen only click event in empty space
      },
      child: Listener(
        ///  listen for all click events in current view, include the click
        ///  receivers(such as button...), but only listen
        onPointerDown: (e) {},
        child: AbsorbPointer(
          absorbing: false,
          child: child,
        ),
      ),
    );
  }

  Widget background(BuildContext context, double height) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 750.w,
        height: height,
        decoration: const BoxDecoration(
          color: Color(0xffF4F4F6),
        ),
        child: widget.config.background,
      ),
    );
  }

  Widget audioVideoContainer(double maxWidth, double maxHeight) {
    maxHeight -= 169.r; // top position
    maxHeight -= 124.r; // bottom bar

    bool scrollable = false;
    int fixedRow = widget.config.layoutConfig.rowConfigs.length;
    double containerHeight = seatItemHeight * fixedRow +
        widget.config.layoutConfig.rowSpacing * (fixedRow - 1);
    if (containerHeight > maxHeight) {
      containerHeight = maxHeight;
      scrollable = true;
    }

    var seatContainer = ZegoSeatContainer(
      seatManager: widget.seatManager,
      layoutConfig: widget.config.layoutConfig,
      foregroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user,
          Map extraInfo) {
        return ZegoSeatForeground(
          user: user,
          extraInfo: extraInfo,
          size: size,
          seatManager: widget.seatManager,
          config: widget.config,
        );
      },
      backgroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user,
          Map extraInfo) {
        return ZegoSeatBackground(
          user: user,
          extraInfo: extraInfo,
          size: size,
          seatManager: widget.seatManager,
          config: widget.config,
        );
      },
      sortAudioVideo: audioVideoViewSorter,
      avatarBuilder: widget.config.seatConfig.avatarBuilder,
    );

    return Positioned(
      top: 169.r,
      left: 35.w,
      child: SizedBox(
        width: maxWidth - 35.w * 2,
        height: containerHeight,
        child: scrollable
            ? CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: seatContainer,
                  ),
                ],
              )
            : seatContainer,
      ),
    );
  }

  List<ZegoUIKitUser> audioVideoViewSorter(List<ZegoUIKitUser> users) {
    return users;
  }

  Widget topBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 64.r,
      child: ValueListenableBuilder<ZegoUIKitRoomState>(
        valueListenable: ZegoUIKit().getRoomStateStream(),
        builder: (context, roomState, _) {
          return ZegoTopBar(
            config: widget.config,
            seatManager: widget.seatManager,
            translationText: widget.config.translationText,
          );
        },
      ),
    );
  }

  Widget bottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ZegoBottomBar(
        height: 124.r,
        buttonSize: zegoLiveButtonSize,
        config: widget.config,
        seatManager: widget.seatManager,
      ),
    );
  }

  Widget messageList() {
    return Positioned(
      left: 32.r,
      bottom: 124.r,
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(Size(540.r, 400.r)),
        child: ZegoInRoomLiveCommentingView(
          itemBuilder: widget.config.inRoomMessageViewConfig.itemBuilder,
        ),
      ),
    );
  }
}
