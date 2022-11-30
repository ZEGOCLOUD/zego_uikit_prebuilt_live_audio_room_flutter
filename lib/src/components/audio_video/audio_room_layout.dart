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

    int currentRowIndex = -1;
    int currentItemIndex = -1;
    return Column(
      children: widget.layoutConfig.rowConfigs
          .map((ZegoLiveAudioRoomLayoutRowConfig rowConfig) {
        currentRowIndex += 1;
        var addMargin =
            currentRowIndex < (widget.layoutConfig.rowConfigs.length - 1);
        return Container(
          margin: addMargin
              ? EdgeInsets.only(
                  bottom: widget.layoutConfig.rowSpacing.toDouble(),
                )
              : null,
          child: Row(
            mainAxisAlignment: getRowAlignment(rowConfig.alignment),
            children: List<Widget>.generate(
              rowConfig.count,
              (int index) {
                // return Text(index.toString());
                currentItemIndex += 1;
                var itemIndex = currentItemIndex;
                var targetUser = users.elementAt(itemIndex);
                return SizedBox(
                  width: seatItemWidth,
                  height: seatItemHeight,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: ZegoUIKit()
                          .getMicrophoneStateNotifier(targetUser?.id ?? ""),
                      builder: (context, isMicrophoneEnabled, _) {
                        return ZegoAudioVideoView(
                          user: targetUser,
                          borderRadius: widget.borderRadius,
                          borderColor: Colors.transparent,
                          extraInfo: {layoutGridItemIndexKey: itemIndex},
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
            ),
          ),
        );
      }).toList(),
    );
  }

  MainAxisAlignment getRowAlignment(
      ZegoLiveAudioRoomLayoutAlignment alignment) {
    switch (alignment) {
      case ZegoLiveAudioRoomLayoutAlignment.spaceAround:
        return MainAxisAlignment.spaceAround;
      case ZegoLiveAudioRoomLayoutAlignment.start:
        return MainAxisAlignment.start;
      case ZegoLiveAudioRoomLayoutAlignment.end:
        return MainAxisAlignment.end;
      case ZegoLiveAudioRoomLayoutAlignment.center:
        return MainAxisAlignment.center;
      case ZegoLiveAudioRoomLayoutAlignment.spaceBetween:
        return MainAxisAlignment.spaceBetween;
      case ZegoLiveAudioRoomLayoutAlignment.spaceEvenly:
        return MainAxisAlignment.spaceEvenly;
    }
  }
}
