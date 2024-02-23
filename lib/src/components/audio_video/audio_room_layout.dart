// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.defines.dart';

/// @nodoc
const layoutGridItemIndexKey = 'index';

/// @nodoc
/// picture in picture layout
class ZegoLiveAudioRoomLayout extends StatefulWidget {
  const ZegoLiveAudioRoomLayout({
    Key? key,
    required this.userList,
    required this.layoutConfig,
    this.avatarBuilder,
    this.backgroundColor,
    this.borderRadius,
    this.showSoundWavesInAudioMode = true,
    this.usersItemIndex = const {},
    this.foregroundBuilder,
    this.backgroundBuilder,
  }) : super(key: key);

  final List<ZegoUIKitUser> userList;
  final Map<String, int> usersItemIndex; //  map<user id, item index>
  final ZegoLiveAudioRoomLayoutConfig layoutConfig;

  final Color? backgroundColor;
  final double? borderRadius;
  final bool showSoundWavesInAudioMode;

  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;
  final ZegoAvatarBuilder? avatarBuilder;

  @override
  State<ZegoLiveAudioRoomLayout> createState() =>
      _ZegoLiveAudioRoomLayoutState();
}

/// @nodoc
class _ZegoLiveAudioRoomLayoutState extends State<ZegoLiveAudioRoomLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final users = List<ZegoUIKitUser?>.from(widget.userList);

    /// fill empty cell
    final totalCount = widget.layoutConfig.rowConfigs.fold<int>(
      0,
      (previousTotalCount, rowConfig) => previousTotalCount + rowConfig.count,
    );
    for (var diff = totalCount - users.length; diff > 0; diff--) {
      users.add(null);
    }

    /// swap users if specify the user cell index
    widget.usersItemIndex.forEach((targetUserID, targetItemIndex) {
      final targetUserCurrentIndex =
          users.indexWhere((user) => user?.id == targetUserID);
      if (-1 == targetUserCurrentIndex) {
        return;
      }

      if (targetUserCurrentIndex != targetItemIndex) {
        final targetUser = users[targetUserCurrentIndex];
        users[targetUserCurrentIndex] = users[targetItemIndex];
        users[targetItemIndex] = targetUser;
      }
    });

    var baseIndex = 0;
    var currentRowIndex = -1;
    return Column(
      children: widget.layoutConfig.rowConfigs
          .map((ZegoLiveAudioRoomLayoutRowConfig rowConfig) {
        final rowUsers = users.sublist(0, rowConfig.count);
        users.removeRange(0, rowConfig.count);

        currentRowIndex += 1;
        final addMargin =
            currentRowIndex < (widget.layoutConfig.rowConfigs.length - 1);
        final rowWidget = Container(
          margin: addMargin
              ? EdgeInsets.only(
                  bottom: widget.layoutConfig.rowSpacing.toDouble(),
                )
              : null,
          child: Row(
            mainAxisAlignment: getRowAlignment(rowConfig.alignment),
            children: getRowChildren(rowUsers, rowConfig, baseIndex),
          ),
        );

        baseIndex += rowConfig.count;

        return rowWidget;
      }).toList(),
    );
  }

  List<Widget> getRowChildren(
    List<ZegoUIKitUser?> users,
    ZegoLiveAudioRoomLayoutRowConfig rowConfig,
    int baseIndex,
  ) {
    final children = List<Widget>.generate(
      rowConfig.count,
      (int index) {
        final targetUser = users.elementAt(index);
        return SizedBox(
          width: seatItemWidth,
          height: seatItemHeight,
          child: ValueListenableBuilder<bool>(
              valueListenable:
                  ZegoUIKit().getMicrophoneStateNotifier(targetUser?.id ?? ''),
              builder: (context, isMicrophoneEnabled, _) {
                return ZegoAudioVideoView(
                  user: targetUser,
                  borderRadius: widget.borderRadius,
                  borderColor: Colors.transparent,
                  extraInfo: {layoutGridItemIndexKey: baseIndex + index},
                  foregroundBuilder: widget.foregroundBuilder,
                  backgroundBuilder: widget.backgroundBuilder,
                  avatarConfig: ZegoAvatarConfig(
                    showInAudioMode: true,
                    showSoundWavesInAudioMode: widget.showSoundWavesInAudioMode,
                    builder: widget.avatarBuilder,
                    soundWaveColor: const Color(0xff2254f6),
                    size: Size(seatIconWidth, seatIconHeight),
                    verticalAlignment: ZegoAvatarAlignment.start,
                  ),
                );
              }),
        );
      },
    );

    if (children.isEmpty) {
      return children;
    }

    if ([
      ZegoLiveAudioRoomLayoutAlignment.start,
      ZegoLiveAudioRoomLayoutAlignment.end,
      ZegoLiveAudioRoomLayoutAlignment.center,
    ].contains(rowConfig.alignment)) {
      final rowSpaceIndexes = List<int>.generate(children.length, (i) => i)
        ..removeAt(0);
      for (final rowSpaceIndex in rowSpaceIndexes.reversed) {
        children.insert(
          rowSpaceIndex,
          SizedBox(
            width: rowConfig.seatSpacing.toDouble(),
          ),
        );
      }
    }

    return children;
  }

  MainAxisAlignment getRowAlignment(
      ZegoLiveAudioRoomLayoutAlignment alignment) {
    switch (alignment) {
      case ZegoLiveAudioRoomLayoutAlignment.start:
        return MainAxisAlignment.start;
      case ZegoLiveAudioRoomLayoutAlignment.end:
        return MainAxisAlignment.end;
      case ZegoLiveAudioRoomLayoutAlignment.center:
        return MainAxisAlignment.center;
      case ZegoLiveAudioRoomLayoutAlignment.spaceBetween:
        return MainAxisAlignment.spaceBetween;
      case ZegoLiveAudioRoomLayoutAlignment.spaceAround:
        return MainAxisAlignment.spaceAround;
      case ZegoLiveAudioRoomLayoutAlignment.spaceEvenly:
        return MainAxisAlignment.spaceEvenly;
    }
  }
}
