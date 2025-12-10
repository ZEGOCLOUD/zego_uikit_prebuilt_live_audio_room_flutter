// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/audio_video/audio_room_layout.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/style.dart';

/// @nodoc
/// container of seat
class ZegoLiveAudioRoomSeatContainer extends StatefulWidget {
  const ZegoLiveAudioRoomSeatContainer({
    super.key,
    required this.liveID,
    required this.seatManager,
    required this.style,
    required this.layoutConfig,
    this.avatarBuilder,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.sortAudioVideo,
    this.showSoundWavesInAudioMode = true,
    this.soundWaveColor,
  });

  final String liveID;
  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoUIKitPrebuiltLiveAudioRoomStyle style;
  final ZegoLiveAudioRoomLayoutConfig layoutConfig;

  //// foreground builder of audio video view
  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;

  //// background builder of audio video view
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  //// sorter
  final ZegoAudioVideoViewSorter? sortAudioVideo;

  ////avatar
  final ZegoAvatarBuilder? avatarBuilder;

  final bool showSoundWavesInAudioMode;

  final Color? soundWaveColor;

  @override
  State<ZegoLiveAudioRoomSeatContainer> createState() =>
      _ZegoAudioVideoContainerState();
}

/// @nodoc
class _ZegoAudioVideoContainerState
    extends State<ZegoLiveAudioRoomSeatContainer> {
  bool waitingUserJoinRoom = false;
  final userListNotifier = ValueNotifier<List<ZegoUIKitUser>>([]);
  List<StreamSubscription<dynamic>?> subscriptions = [];
  Map<String, String>? previousSeatsUser;

  /// Store previous seatsUser (seat index -> user id)

  @override
  void initState() {
    super.initState();

    updateUserList(widget.seatManager.seatsUserMapNotifier.value);
    widget.seatManager.seatsUserMapNotifier.addListener(onSeatsUserChanged);
    subscriptions.add(ZegoUIKit()
        .getUserListStream(targetRoomID: widget.liveID)
        .listen(onUserListUpdated));
    subscriptions.add(ZegoUIKit()
        .getAudioVideoListStream(targetRoomID: widget.liveID)
        .listen(onAudioVideoListUpdated));
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
    return ValueListenableBuilder<List<ZegoUIKitUser>>(
        valueListenable: userListNotifier,
        builder: (context, users, _) {
          return ZegoLiveAudioRoomLayout(
            liveID: widget.liveID,
            layoutConfig: widget.layoutConfig,
            backgroundBuilder: widget.backgroundBuilder,
            foregroundBuilder: widget.foregroundBuilder,
            userList: users,
            usersItemIndex: getUsersItemIndexIfSpecify(),
            showSoundWavesInAudioMode: widget.showSoundWavesInAudioMode,
            soundWaveColor: widget.soundWaveColor,
            avatarBuilder: widget.avatarBuilder,
          );
        });
  }

  void onAudioVideoListUpdated(List<ZegoUIKitUser> users) {
    updateUserList(widget.seatManager.seatsUserMapNotifier.value);
  }

  void onSeatsUserChanged() {
    waitingUserJoinRoom = false;
    updateUserList(widget.seatManager.seatsUserMapNotifier.value);
  }

  void onUserListUpdated(List<ZegoUIKitUser> users) {
    if (!waitingUserJoinRoom) {
      return;
    }

    onSeatsUserChanged();
  }

  Map<String, int> getUsersItemIndexIfSpecify() {
    //// specify user item index by seat index
    final usersItemIndex = <String, int>{};

    ///  map<user id, item index>

    /// if (widget.seatManager.hostsNotifier.value.isNotEmpty) {
    ///   usersItemIndex[widget.seatManager.hostsNotifier.value.first] = 0;
    /// }

    widget.seatManager.seatsUserMapNotifier.value.forEach((seatIndex, userID) {
      usersItemIndex[userID] = int.parse(seatIndex);
    });

    return usersItemIndex;
  }

  void updateUserList(Map<String, String> seatsUser) {
    final audioVideoUserIDList = ZegoUIKit()
        .getAudioVideoList(targetRoomID: widget.liveID)
        .map((e) => e.id)
        .toList();

    List<ZegoUIKitUser> newUsers = [];
    seatsUser.forEach((seatIndex, seatUserID) {
      final seatUser = ZegoUIKit().getUser(
        targetRoomID: widget.liveID,
        seatUserID,
      );
      if (seatUser.isEmpty()) {
        //// user not enter room now
        waitingUserJoinRoom = true;
      } else {
        if (audioVideoUserIDList.contains(seatUser.id)) {
          //// Only users already in the stream list are displayed; otherwise, wait for the stream list to update
          newUsers.add(seatUser);
        }
      }
    });

    if (null != widget.sortAudioVideo) {
      newUsers = widget.sortAudioVideo!.call(newUsers);
    }
    final newUserIDs = newUsers.map((e) => e.id).toList();
    final oldUserIDs = userListNotifier.value.map((e) => e.id).toList();

    /// Check if user id list has changed
    bool userIDsChanged =
        !const DeepCollectionEquality().equals(newUserIDs, oldUserIDs);

    /// Check if seat index for user id has changed (only if userIDs haven't changed)
    bool seatIndexChanged = false;
    if (!userIDsChanged && previousSeatsUser != null) {
      /// Create reverse mapping: user id -> seat index
      final previousUserToSeat = <String, String>{};
      previousSeatsUser!.forEach((seatIndex, userID) {
        previousUserToSeat[userID] = seatIndex;
      });

      final currentUserToSeat = <String, String>{};
      seatsUser.forEach((seatIndex, userID) {
        currentUserToSeat[userID] = seatIndex;
      });

      /// Check if any user id's seat index has changed
      for (final userID in currentUserToSeat.keys) {
        if (previousUserToSeat.containsKey(userID)) {
          if (previousUserToSeat[userID] != currentUserToSeat[userID]) {
            seatIndexChanged = true;
            break;
          }
        }
      }
    }

    if (userIDsChanged || seatIndexChanged) {
      userListNotifier.value = newUsers;
    }

    /// Save current seatsUser as baseline for next comparison
    previousSeatsUser = Map<String, String>.from(seatsUser);
  }
}
