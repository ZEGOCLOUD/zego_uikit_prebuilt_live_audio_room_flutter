// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';

/// The alignment of the seat layout.
/// This enum type is used for the [alignment] property in [ZegoLiveAudioRoomLayoutRowConfig].
enum ZegoLiveAudioRoomLayoutAlignment {
  ///  Place the seats as close to the start of the main axis as possible.
  start,

  /// Place the seats as close to the end of the main axis as possible.
  end,

  /// Place the seats as close to the middle of the main axis as possible.
  center,

  /// Place the free space evenly between the seats.
  spaceBetween,

  /// Place the free space evenly between the seats as well as half of that space before and after the first and last seat.
  spaceAround,

  /// Place the free space evenly between the seats as well as before and after the first and last seat.
  spaceEvenly,
}

/// Configuration for each row in the seat layout.
/// This type is used for the [ZegoUIKitPrebuiltLiveAudioRoomConfig].[layoutConfig].[rowConfigs] property.
class ZegoLiveAudioRoomLayoutRowConfig {
  ZegoLiveAudioRoomLayoutRowConfig({
    this.count = 4,
    this.seatSpacing = 0,
    this.alignment = ZegoLiveAudioRoomLayoutAlignment.spaceAround,
  });

  /// Number of seats in each row. Range is [1~4], default value is 4.
  int count;

  /// The horizontal spacing between each seat. It should be set to a value equal to or greater than 0.
  int seatSpacing = 0;

  /// The alignment of the seat layout.
  ZegoLiveAudioRoomLayoutAlignment alignment;

  /// @nodoc
  @override
  String toString() {
    return 'row config:{count:$count, spacing:$seatSpacing, alignment:$alignment}';
  }
}

/// Seat layout configuration options.
/// This type is used for the [ZegoUIKitPrebuiltLiveAudioRoomConfig].[layoutConfig] property.
class ZegoLiveAudioRoomLayoutConfig {
  ZegoLiveAudioRoomLayoutConfig({
    this.rowSpacing = 0,
    List<ZegoLiveAudioRoomLayoutRowConfig>? rowConfigs,
  }) : rowConfigs = rowConfigs ??
            [
              ZegoLiveAudioRoomLayoutRowConfig(),
              ZegoLiveAudioRoomLayoutRowConfig(),
            ];

  ///  Spacing between rows, should be positive
  int rowSpacing;

  /// Configuration list for each row.
  List<ZegoLiveAudioRoomLayoutRowConfig> rowConfigs;

  /// @nodoc
  @override
  String toString() {
    return 'ZegoLiveAudioRoomLayoutConfig:{'
        'spacing:$rowSpacing, '
        'row configs:${rowConfigs.map((e) => e.toString()).toList()}'
        '}';
  }
}

class ZegoLiveAudioRoomPopUpSeatClickedMenuEvent {
  int index;
  bool isAHostSeat;
  bool isRoomSeatLocked;

  /// **data** from [ZegoLiveAudioRoomPopUpSeatClickedMenuInfo]
  dynamic data;

  bool localIsCoHost;
  ZegoLiveAudioRoomRole localRole;
  ZegoUIKitUser localUser;

  bool targetIsCoHost;
  ZegoLiveAudioRoomRole targetRole;

  /// null if seat is empty, no user on current seat
  ZegoUIKitUser? targetUser;

  ZegoLiveAudioRoomPopUpSeatClickedMenuEvent({
    required this.index,
    required this.isAHostSeat,
    required this.isRoomSeatLocked,
    required this.localIsCoHost,
    required this.localRole,
    required this.localUser,
    required this.targetIsCoHost,
    required this.targetRole,
    required this.targetUser,
    this.data,
  });

  @override
  String toString() {
    return '{'
        'index:$index, '
        'isAHostSeat:$isAHostSeat, '
        'isRoomSeatLocked:$isRoomSeatLocked, '
        'data:$data, '
        'localIsCoHost:$localIsCoHost, '
        'localRole:$localRole, '
        'localUser:$localUser, '
        'targetIsCoHost:$targetIsCoHost, '
        'targetRole:$targetRole, '
        'targetUser:$targetUser, '
        '}';
  }
}

/// pop up menu info when on seat clicked
class ZegoLiveAudioRoomPopUpSeatClickedMenuInfo {
  String title;
  dynamic data;

  void Function(
    ZegoLiveAudioRoomPopUpSeatClickedMenuEvent event,
  ) onClicked;

  ZegoLiveAudioRoomPopUpSeatClickedMenuInfo({
    required this.onClicked,
    required this.title,
    this.data,
  });

  @override
  String toString() {
    return 'ZegoLiveAudioRoomPopUpSeatClickedMenuInfo:{'
        'onClicked:$onClicked, '
        'title:$title, '
        'data:$data, '
        '}';
  }
}

/// pop-up item
enum ZegoLiveAudioRoomPopupItemValue {
  takeOnSeat,
  takeOffSeat,
  switchSeat,
  leaveSeat,
  muteSeat,
  unMuteSeat,
  inviteLink,
  assignCoHost,
  revokeCoHost,
  cancel,

  /// user custom
  customStartIndex,
}

typedef ZegoLiveAudioRoomAudioVideoContainerBuilder = Widget? Function(
  BuildContext context,
  List<ZegoUIKitUser> allUsers,
  List<ZegoUIKitUser> audioVideoUsers,

  /// The default seat view creator, you can also custom widget by [user]
  Widget Function(ZegoUIKitUser user, int seatIndex) audioVideoViewCreator,
);

extension ZegoLiveAudioRoomAudioVideoContainerBuilderExtension
    on ZegoLiveAudioRoomAudioVideoContainerBuilder {
  static ZegoLiveAudioRoomAudioVideoContainerBuilder center() {
    return (
      BuildContext context,
      List<ZegoUIKitUser> allUsers,
      List<ZegoUIKitUser> audioVideoUsers,
      Widget Function(ZegoUIKitUser user, int seatIndex) audioVideoViewCreator,
    ) {
      List<Widget> seatItems = [];
      for (int index = 0; index < audioVideoUsers.length; ++index) {
        final user = audioVideoUsers[index];
        seatItems.add(
          SizedBox(
            width: seatItemWidth,
            height: seatItemHeight,
            child: audioVideoViewCreator.call(user, index),
          ),
        );
      }
      return Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: seatItems,
          ),
        ),
      );
    };
  }
}
