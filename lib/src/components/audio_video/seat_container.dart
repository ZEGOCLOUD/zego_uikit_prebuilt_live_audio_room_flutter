// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';
import 'layout_grid.dart';

/// container of seat
class ZegoSeatContainer extends StatefulWidget {
  const ZegoSeatContainer({
    Key? key,
    required this.seatManager,
    required this.layout,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.sortAudioVideo,
  }) : super(key: key);

  final ZegoLiveSeatManager seatManager;

  final ZegoLayoutGridConfig layout;

  /// foreground builder of audio video view
  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;

  /// background builder of audio video view
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  /// sorter
  final ZegoAudioVideoViewSorter? sortAudioVideo;

  @override
  State<ZegoSeatContainer> createState() => _ZegoAudioVideoContainerState();
}

class _ZegoAudioVideoContainerState extends State<ZegoSeatContainer> {
  List<ZegoUIKitUser> userList = [];
  List<StreamSubscription<dynamic>?> subscriptions = [];

  @override
  void initState() {
    super.initState();

    widget.seatManager.seatsUserMapNotifier.addListener(onSeatsUserChanged);
    widget.seatManager.hostsNotifier.addListener(onSeatsUserChanged);
  }

  @override
  void dispose() {
    super.dispose();

    widget.seatManager.seatsUserMapNotifier.removeListener(onSeatsUserChanged);
    widget.seatManager.hostsNotifier.removeListener(onSeatsUserChanged);

    for (var subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    updateUserList(
      widget.seatManager.seatsUserMapNotifier.value,
      widget.seatManager.hostsNotifier.value,
    );

    return StreamBuilder<List<ZegoUIKitUser>>(
      stream: ZegoUIKit().getAudioVideoListStream(),
      builder: (context, snapshot) {
        return ZegoLayoutGrid(
          layoutConfig: widget.layout,
          backgroundBuilder: widget.backgroundBuilder,
          foregroundBuilder: widget.foregroundBuilder,
          userList: userList,
          usersItemIndex: getUsersItemIndexIfSpecify(),
        );
      },
    );
  }

  void onSeatsUserChanged() {
    setState(() {
      updateUserList(
        widget.seatManager.seatsUserMapNotifier.value,
        widget.seatManager.hostsNotifier.value,
      );
    });
  }

  Map<String, int> getUsersItemIndexIfSpecify() {
    /// specify user item index by seat index
    Map<String, int> usersItemIndex = {}; //  map<user id, item index>

    if (widget.seatManager.hostsNotifier.value.isNotEmpty) {
      usersItemIndex[widget.seatManager.hostsNotifier.value.first] = 0;
    }

    widget.seatManager.seatsUserMapNotifier.value.forEach((seatIndex, userID) {
      usersItemIndex[userID] = int.parse(seatIndex);
    });

    return usersItemIndex;
  }

  void updateUserList(Map<String, String> seatsUser, List<String> hosts) {
    userList.clear();

    for (var hostID in hosts) {
      var host = ZegoUIKit().getUser(hostID);
      if (null != host) {
        userList.add(host);
      }
    }
    seatsUser.forEach((seatIndex, seatUserID) {
      var seatUser = ZegoUIKit().getUser(seatUserID);
      if (null != seatUser) {
        userList.add(seatUser);
      }
    });

    userList =
        widget.sortAudioVideo?.call(List<ZegoUIKitUser>.from(userList)) ??
            userList;
  }
}
