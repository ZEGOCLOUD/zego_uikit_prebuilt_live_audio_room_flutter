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
  /// Creates a row configuration.
  ///
  /// [count] - Number of seats in each row. Range is `1` to `4`, default value is 4.
  /// [seatSpacing] - The horizontal spacing between each seat. Default is 0.
  /// [alignment] - The alignment of the seat layout. Default is [ZegoLiveAudioRoomLayoutAlignment.spaceAround].
  ZegoLiveAudioRoomLayoutRowConfig({
    this.count = 4,
    this.seatSpacing = 0,
    this.alignment = ZegoLiveAudioRoomLayoutAlignment.spaceAround,
  });

  /// Number of seats in each row. Range is `1` to `4`, default value is 4.
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
  /// Creates a layout configuration.
  ///
  /// [rowSpacing] - Spacing between rows. Default is 0.
  /// [rowConfigs] - Configuration list for each row. If not provided, defaults to two rows with 4 seats each.
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

/// Event data passed when a seat is clicked in the popup menu.
///
/// This class contains information about the seat that was clicked and the current user context.
class ZegoLiveAudioRoomPopUpSeatClickedMenuEvent {
  /// Creates a seat clicked menu event.
  ///
  /// [index] - The index of the seat that was clicked.
  /// [isAHostSeat] - Whether the clicked seat is a host seat.
  /// [isRoomSeatLocked] - Whether the room seats are currently locked.
  /// [localIsCoHost] - Whether the local user is a co-host.
  /// [localRole] - The role of the local user.
  /// [localUser] - The local user information.
  /// [targetIsCoHost] - Whether the user on the target seat is a co-host.
  /// [targetRole] - The role of the user on the target seat.
  /// [targetUser] - The user on the target seat (null if seat is empty).
  /// [data] - Custom data passed with the menu item.
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

  /// The index of the seat that was clicked.
  int index;

  /// Whether the clicked seat is a host seat.
  bool isAHostSeat;

  /// Whether the room seats are currently locked.
  bool isRoomSeatLocked;

  /// Custom data passed from [ZegoLiveAudioRoomPopUpSeatClickedMenuInfo].
  dynamic data;

  /// Whether the local user is a co-host.
  bool localIsCoHost;

  /// The role of the local user.
  ZegoLiveAudioRoomRole localRole;

  /// The local user information.
  ZegoUIKitUser localUser;

  /// Whether the user on the target seat is a co-host.
  bool targetIsCoHost;

  /// The role of the user on the target seat.
  ZegoLiveAudioRoomRole targetRole;

  /// The user on the target seat, null if seat is empty (no user on current seat).
  ZegoUIKitUser? targetUser;

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

/// Configuration for custom popup menu items when a seat is clicked.
///
/// This class is used in [ZegoLiveAudioRoomPopUpSeatClickedMenuConfig] to define custom menu items.
class ZegoLiveAudioRoomPopUpSeatClickedMenuInfo {
  /// Creates a seat clicked menu info.
  ///
  /// [onClicked] - Callback function when the menu item is clicked.
  /// [title] - The display title of the menu item.
  /// [data] - Custom data to be passed to the click callback.
  ZegoLiveAudioRoomPopUpSeatClickedMenuInfo({
    required this.onClicked,
    required this.title,
    this.data,
  });

  /// The display title of the menu item.
  String title;

  /// Custom data to be passed to the click callback.
  dynamic data;

  /// Callback function triggered when this menu item is clicked.
  void Function(
    ZegoLiveAudioRoomPopUpSeatClickedMenuEvent event,
  ) onClicked;

  @override
  String toString() {
    return 'ZegoLiveAudioRoomPopUpSeatClickedMenuInfo:{'
        'onClicked:$onClicked, '
        'title:$title, '
        'data:$data, '
        '}';
  }
}

/// Predefined popup menu item values.
///
/// These values represent the built-in menu actions available when clicking on a seat.
enum ZegoLiveAudioRoomPopupItemValue {
  /// Take on a seat (audience joins as speaker).
  takeOnSeat,

  /// Take off from a seat (speaker becomes audience).
  takeOffSeat,

  /// Switch to another seat.
  switchSeat,

  /// Leave the seat.
  leaveSeat,

  /// Mute the speaker on the seat.
  muteSeat,

  /// Unmute the speaker on the seat.
  unMuteSeat,

  /// Invite a user to take a seat.
  inviteLink,

  /// Assign the user as a co-host.
  assignCoHost,

  /// Revoke co-host privileges.
  revokeCoHost,

  /// Cancel the current action.
  cancel,

  /// Starting index for user-defined custom menu items.
  customStartIndex,
}

/// A builder function for creating a custom audio-video container layout.
///
/// This typedef is used in [ZegoLiveAudioRoomSeatConfig.containerBuilder] to customize the seat layout.
///
/// [context] - The build context.
/// [allUsers] - All users in the room.
/// [audioVideoUsers] - Users who are currently on seats (speaking).
/// [audioVideoViewCreator] - The default seat view creator, you can also customize widget by `user`.
typedef ZegoLiveAudioRoomAudioVideoContainerBuilder = Widget? Function(
  BuildContext context,
  List<ZegoUIKitUser> allUsers,
  List<ZegoUIKitUser> audioVideoUsers,

  /// The default seat view creator, you can also custom widget by `user`
  Widget Function(ZegoUIKitUser user, int seatIndex) audioVideoViewCreator,
);

/// Extension methods for [ZegoLiveAudioRoomAudioVideoContainerBuilder].
extension ZegoLiveAudioRoomAudioVideoContainerBuilderExtension
    on ZegoLiveAudioRoomAudioVideoContainerBuilder {
  /// Creates a center-aligned layout builder.
  ///
  /// This creates a horizontally scrollable container with seats centered in each row.
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
