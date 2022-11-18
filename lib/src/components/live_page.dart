// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/plugins.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'audio_video/background.dart';
import 'audio_video/foreground.dart';
import 'audio_video/layout_grid.dart';
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

    correctConfigValue();
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
                    background(constraints.maxHeight),
                    audioVideoContainer(),
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

  void correctConfigValue() {
    if (widget.config.bottomMenuBarConfig.maxCount > 5) {
      widget.config.bottomMenuBarConfig.maxCount = 5;
      debugPrint('menu bar buttons limited count\'s value  is exceeding the '
          'maximum limit');
    }
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

  Widget background(double height) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 750.w,
        height: height,
        decoration: const BoxDecoration(
          color: Color(0xffF4F4F6),
        ),
      ),
    );
  }

  Widget audioVideoContainer() {
    int fixedRow = 2;
    int fixedColumn = 4;
    double width = 152.w * fixedColumn + (fixedColumn - 1) * 7.5.w;
    double height = 171.r * fixedRow + 32.r * (fixedRow - 1);

    var audioVideoContainerLayout = ZegoLayoutGridConfig(
      fixedRow: fixedRow,
      fixedColumn: fixedColumn,
      itemPadding: 10.r,
      layoutPadding: 0,
    );

    var seatContainer = ZegoSeatContainer(
      seatManager: widget.seatManager,
      layout: audioVideoContainerLayout,
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
    );

    return Positioned(
      top: 169.r,
      left: 50.w,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: seatContainer,
            ),
          ],
        ),
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
            roomID: ZegoUIKit().getRoom().id,
            roomTitle: widget.config.translationText.prebuiltTitle,
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
        child: const ZegoInRoomLiveCommentingView(),
      ),
    );
  }
}
