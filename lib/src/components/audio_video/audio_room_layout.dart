// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'defines.dart';

const layoutGridItemIndexKey = "index";

/// picture in picture layout
class ZegoAudioRoomLayout extends StatefulWidget {
  const ZegoAudioRoomLayout({
    Key? key,
    required this.userList,
    required this.layoutConfig,
    this.backgroundColor,
    this.borderRadius,
    this.usersItemIndex = const {},
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.avatarBuilder,
  }) : super(key: key);

  final List<ZegoUIKitUser> userList;
  final Map<String, int> usersItemIndex; //  map<user id, item index>
  final ZegoLiveAudioRoomLayoutConfig layoutConfig;

  final Color? backgroundColor;
  final double? borderRadius;

  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;
  final ZegoAvatarBuilder? avatarBuilder;

  @override
  State<ZegoAudioRoomLayout> createState() => _ZegoAudioRoomLayoutState();
}

class _ZegoAudioRoomLayoutState extends State<ZegoAudioRoomLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var users = List<ZegoUIKitUser?>.from(widget.userList);

    /// fill empty cell
    int totalCount = widget.layoutConfig.rowConfigs
        .fold(0, (totalCount, rowConfig) => totalCount + rowConfig.count);
    for (int diff = totalCount - users.length; diff > 0; diff--) {
      users.add(null);
    }

    /// swap users if specify the user cell index
    widget.usersItemIndex.forEach((targetUserID, targetItemIndex) {
      var targetUserCurrentIndex =
          users.indexWhere((user) => user?.id == targetUserID);
      if (-1 == targetUserCurrentIndex) {
        return;
      }

      if (targetUserCurrentIndex != targetItemIndex) {
        var targetUser = users[targetUserCurrentIndex];
        users[targetUserCurrentIndex] = users[targetItemIndex];
        users[targetItemIndex] = targetUser;
      }
    });

    int baseIndex = 0;
    int currentRowIndex = -1;
    return Column(
      children: widget.layoutConfig.rowConfigs
          .map((ZegoLiveAudioRoomLayoutRowConfig rowConfig) {
        var rowUsers = users.sublist(0, rowConfig.count);
        users.removeRange(0, rowConfig.count);

        currentRowIndex += 1;
        var addMargin =
            currentRowIndex < (widget.layoutConfig.rowConfigs.length - 1);
        var rowWidget = Container(
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
    var children = List<Widget>.generate(
      rowConfig.count,
      (int index) {
        var targetUser = users.elementAt(index);
        return SizedBox(
          width: seatItemWidth,
          height: seatItemHeight,
          child: ValueListenableBuilder<bool>(
              valueListenable:
                  ZegoUIKit().getMicrophoneStateNotifier(targetUser?.id ?? ""),
              builder: (context, isMicrophoneEnabled, _) {
                return ZegoAudioVideoView(
                  user: targetUser,
                  borderRadius: widget.borderRadius,
                  borderColor: Colors.transparent,
                  extraInfo: {layoutGridItemIndexKey: baseIndex + index},
                  foregroundBuilder: widget.foregroundBuilder,
                  backgroundBuilder: widget.backgroundBuilder,
                  avatarConfig: ZegoAvatarConfig(
                    showInAudioMode: isMicrophoneEnabled,
                    showSoundWavesInAudioMode: true,
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
      var rowSpaceIndexes = List<int>.generate(children.length, (i) => i);
      rowSpaceIndexes.removeAt(0);
      for (var rowSpaceIndex in rowSpaceIndexes.reversed) {
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
