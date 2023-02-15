// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_translation.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';

class ZegoMemberListSheet extends StatefulWidget {
  const ZegoMemberListSheet({
    Key? key,
    this.avatarBuilder,
    required this.seatManager,
    required this.translationText,
  }) : super(key: key);

  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoLiveSeatManager seatManager;
  final ZegoTranslationText translationText;

  @override
  State<ZegoMemberListSheet> createState() => _ZegoMemberListSheetState();
}

class _ZegoMemberListSheetState extends State<ZegoMemberListSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          header(98.h),
          Container(height: 1.r, color: Colors.white.withOpacity(0.15)),
          SizedBox(
            height: constraints.maxHeight - 1.r - 98.h,
            child: ValueListenableBuilder<List<String>>(
              valueListenable: widget.seatManager.hostsNotifier,
              builder: (context, _, __) {
                return ValueListenableBuilder<Map<String, String>>(
                  valueListenable: widget.seatManager.seatsUserMapNotifier,
                  builder: (context, _, __) {
                    return memberListView();
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget memberListView() {
    return ZegoMemberList(
      showCameraState: false,
      showMicrophoneState: false,
      sortUserList: (ZegoUIKitUser localUser, List<ZegoUIKitUser> remoteUsers) {
        /// host(isHost attribute)
        final hostUsers = <ZegoUIKitUser>[];
        remoteUsers.removeWhere((user) {
          if (!widget.seatManager.isAttributeHost(user)) {
            return false;
          }

          hostUsers.add(user);
          return true;
        });

        /// speaker(seat attribute)
        final speakers = <ZegoUIKitUser>[];
        remoteUsers.removeWhere((user) {
          if (!widget.seatManager.isSpeaker(user)) {
            return false;
          }

          speakers.add(user);
          return true;
        });

        var sortUsers = <ZegoUIKitUser>[];

        final localIsHost = widget.seatManager.isAttributeHost(localUser);
        if (localIsHost) {
          sortUsers.add(localUser);
        }
        sortUsers += hostUsers;

        if (!localIsHost) {
          sortUsers.add(localUser);
        }

        sortUsers += speakers;
        sortUsers += remoteUsers;

        return sortUsers;
      },
      itemBuilder:
          (BuildContext context, Size size, ZegoUIKitUser user, Map extraInfo) {
        return ValueListenableBuilder<Map<String, String>>(
            valueListenable:
                ZegoUIKit().getInRoomUserAttributesNotifier(user.id),
            builder: (context, _, __) {
              return Container(
                margin: EdgeInsets.only(bottom: 36.r),
                child: Row(
                  children: [
                    avatarItem(context, user, widget.avatarBuilder),
                    SizedBox(width: 24.r),
                    userNameItem(user),
                  ],
                ),
              );
            });
      },
    );
  }

  Widget header(double height) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: 70.r,
              height: 70.r,
              child: PrebuiltLiveAudioRoomImage.asset(
                  PrebuiltLiveAudioRoomIconUrls.back),
            ),
          ),
          SizedBox(width: 10.r),
          StreamBuilder<List<ZegoUIKitUser>>(
              stream: ZegoUIKit().getUserListStream(),
              builder: (context, snapshot) {
                return Text(
                  '${widget.translationText.memberListTitle} (${ZegoUIKit().getAllUsers().length})',
                  style: TextStyle(
                    fontSize: 36.0.r,
                    color: const Color(0xffffffff),
                    decoration: TextDecoration.none,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget userNameItem(ZegoUIKitUser user) {
    final extensions = <String>[];
    if (ZegoUIKit().getLocalUser().id == user.id) {
      extensions.add('You');
    }
    if (widget.seatManager.isAttributeHost(user)) {
      extensions.add('Host');
    } else if (widget.seatManager.isSpeaker(user)) {
      extensions.add('Speaker');
    }

    return Row(
      children: [
        Text(
          user.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 32.0.r,
            color: const Color(0xffffffff),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: 5.r),
        Text(
          extensions.isEmpty ? '' : "(${extensions.join(",")})",
          style: TextStyle(
            fontSize: 32.0.r,
            color: const Color(0xffA7A6B7),
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget avatarItem(
    BuildContext context,
    ZegoUIKitUser user,
    ZegoAvatarBuilder? builder,
  ) {
    return Container(
      width: 92.r,
      height: 92.r,
      decoration:
          const BoxDecoration(color: Color(0xffDBDDE3), shape: BoxShape.circle),
      child: Center(
        child: builder?.call(context, Size(92.r, 92.r), user, {}) ??
            Text(
              user.name.isNotEmpty ? user.name.characters.first : '',
              style: TextStyle(
                fontSize: 32.0.r,
                color: const Color(0xff222222),
                decoration: TextDecoration.none,
              ),
            ),
      ),
    );
  }
}

void showMemberListSheet({
  ZegoAvatarBuilder? avatarBuilder,
  required BuildContext context,
  required ZegoLiveSeatManager seatManager,
  required ZegoTranslationText translationText,
}) {
  showModalBottomSheet(
    barrierColor: ZegoUIKitDefaultTheme.viewBarrierColor,
    backgroundColor: ZegoUIKitDefaultTheme.viewBackgroundColor,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0.r),
        topRight: Radius.circular(32.0.r),
      ),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.85,
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: ZegoMemberListSheet(
              avatarBuilder: avatarBuilder,
              seatManager: seatManager,
              translationText: translationText,
            ),
          ),
        ),
      );
    },
  );
}
