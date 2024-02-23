// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/audio_room_layout.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';

/// @nodoc
/// container of seat
class ZegoLiveAudioRoomSeatContainer extends StatefulWidget {
  const ZegoLiveAudioRoomSeatContainer({
    Key? key,
    required this.seatManager,
    required this.layoutConfig,
    this.avatarBuilder,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.sortAudioVideo,
    this.showSoundWavesInAudioMode = true,
  }) : super(key: key);

  final ZegoLiveAudioRoomSeatManager seatManager;

  final ZegoLiveAudioRoomLayoutConfig layoutConfig;

  /// foreground builder of audio video view
  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;

  /// background builder of audio video view
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  /// sorter
  final ZegoAudioVideoViewSorter? sortAudioVideo;

  ///avatar
  final ZegoAvatarBuilder? avatarBuilder;

  final bool showSoundWavesInAudioMode;

  @override
  State<ZegoLiveAudioRoomSeatContainer> createState() =>
      _ZegoAudioVideoContainerState();
}

/// @nodoc
class _ZegoAudioVideoContainerState
    extends State<ZegoLiveAudioRoomSeatContainer> {
  bool pendingUsers = false;
  List<ZegoUIKitUser> userList = [];
  List<StreamSubscription<dynamic>?> subscriptions = [];

  @override
  void initState() {
    super.initState();

    widget.seatManager.seatsUserMapNotifier.addListener(onSeatsUserChanged);
    subscriptions
        .add(ZegoUIKit().getUserListStream().listen(onUserListUpdated));
  }

  @override
  void dispose() {
    super.dispose();

    widget.seatManager.seatsUserMapNotifier.removeListener(onSeatsUserChanged);

    for (final subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    updateUserList(widget.seatManager.seatsUserMapNotifier.value);

    return StreamBuilder<List<ZegoUIKitUser>>(
      stream: ZegoUIKit().getAudioVideoListStream(),
      builder: (context, snapshot) {
        return ZegoLiveAudioRoomLayout(
          layoutConfig: widget.layoutConfig,
          backgroundBuilder: widget.backgroundBuilder,
          foregroundBuilder: widget.foregroundBuilder,
          userList: userList,
          usersItemIndex: getUsersItemIndexIfSpecify(),
          showSoundWavesInAudioMode: widget.showSoundWavesInAudioMode,
          avatarBuilder: widget.avatarBuilder,
        );
      },
    );
  }

  void onSeatsUserChanged() {
    pendingUsers = false;
    setState(() {
      updateUserList(widget.seatManager.seatsUserMapNotifier.value);
    });
  }

  void onUserListUpdated(List<ZegoUIKitUser> users) {
    if (!pendingUsers) {
      return;
    }

    onSeatsUserChanged();
  }

  Map<String, int> getUsersItemIndexIfSpecify() {
    /// specify user item index by seat index
    final usersItemIndex = <String, int>{}; //  map<user id, item index>

    // if (widget.seatManager.hostsNotifier.value.isNotEmpty) {
    //   usersItemIndex[widget.seatManager.hostsNotifier.value.first] = 0;
    // }

    widget.seatManager.seatsUserMapNotifier.value.forEach((seatIndex, userID) {
      usersItemIndex[userID] = int.parse(seatIndex);
    });

    return usersItemIndex;
  }

  void updateUserList(Map<String, String> seatsUser) {
    userList.clear();

    seatsUser.forEach((seatIndex, seatUserID) {
      final seatUser = ZegoUIKit().getUser(seatUserID);
      if (!seatUser.isEmpty()) {
        userList.add(seatUser);
      } else {
        pendingUsers = true;
      }
    });

    userList =
        widget.sortAudioVideo?.call(List<ZegoUIKitUser>.from(userList)) ??
            userList;
  }
}
