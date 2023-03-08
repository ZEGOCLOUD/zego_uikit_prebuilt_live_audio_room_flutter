// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/avatar_default_item.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_sheet_menu.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_inner_text.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/seat/seat_manager.dart';

typedef ZegoMemberListSheetMoreButtonPressed = void Function(
  ZegoUIKitUser user,
);

class ZegoMemberListSheet extends StatefulWidget {
  const ZegoMemberListSheet({
    Key? key,
    this.avatarBuilder,
    required this.isPluginEnabled,
    required this.seatManager,
    required this.connectManager,
    required this.innerText,
    required this.onMoreButtonPressed,
  }) : super(key: key);

  final bool isPluginEnabled;
  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoLiveSeatManager seatManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoInnerText innerText;
  final ZegoMemberListSheetMoreButtonPressed? onMoreButtonPressed;

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
                        return ValueListenableBuilder<List<ZegoUIKitUser>>(
                            valueListenable: widget.connectManager
                                .audiencesRequestingTakeSeatNotifier,
                            builder: (context, requestCoHostUsers, _) {
                              return memberListView();
                            });
                      });
                }),
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

        /// requesting speaker
        final usersInRequestSpeaker = <ZegoUIKitUser>[];
        remoteUsers.removeWhere((remoteUser) {
          if (isUserInRequestSpeaker(remoteUser.id)) {
            usersInRequestSpeaker.add(remoteUser);
            return true;
          }
          return false;
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
        sortUsers += usersInRequestSpeaker;
        sortUsers += remoteUsers;

        return sortUsers;
      },
      itemBuilder: (
        BuildContext context,
        Size size,
        ZegoUIKitUser user,
        Map<String, dynamic> extraInfo,
      ) {
        return ValueListenableBuilder<Map<String, String>>(
            valueListenable:
                ZegoUIKit().getInRoomUserAttributesNotifier(user.id),
            builder: (context, _, __) {
              return Container(
                margin: EdgeInsets.only(bottom: 36.r),
                child: Row(
                  children: [
                    SizedBox(
                      width: 92.r,
                      height: 92.r,
                      child: ZegoAvatarDefaultItem(
                        user: user,
                        avatarBuilder: widget.avatarBuilder,
                      ),
                    ),
                    SizedBox(width: 24.r),
                    userNameItem(user),
                    const Expanded(child: SizedBox()),
                    controlsItem(user),
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
                  '${widget.innerText.memberListTitle} (${ZegoUIKit().getAllUsers().length})',
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

  Widget controlsItem(ZegoUIKitUser user) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.seatManager.isSeatLockedNotifier,
      builder: (context, isSeatLocked, _) {
        return ValueListenableBuilder<List<ZegoUIKitUser>>(
          valueListenable:
              widget.connectManager.audiencesRequestingTakeSeatNotifier,
          builder: (context, requestTakeSeatUsers, _) {
            final index = requestTakeSeatUsers.indexWhere(
                (requestCoHostUser) => user.id == requestCoHostUser.id);
            if (-1 != index) {
              if (isSeatLocked) {
                /// on show agree/disagree when seat is locked
                return requestTakeSeatUserControlItem(user);
              }
            } else if (widget.seatManager.localIsAHost) {
              return hostControlItem(user);
            }

            return Container();
          },
        );
      },
    );
  }

  Widget requestTakeSeatUserControlItem(ZegoUIKitUser user) {
    return Row(
      children: [
        controlButton(
            text: widget.innerText.disagreeButton,
            backgroundColor: const Color(0xffA7A6B7),
            onPressed: () {
              ZegoUIKit()
                  .getSignalingPlugin()
                  .refuseInvitation(inviterID: user.id, data: '')
                  .then((result) {
                ZegoLoggerService.logInfo(
                  'refuse audience ${user.name} link request, $result',
                  tag: 'live audio',
                  subTag: 'member list',
                );
                if (result.error == null) {
                  widget.connectManager.removeRequestCoHostUsers(user);
                } else {
                  showDebugToast('error:${result.error}');
                }
              });
            }),
        SizedBox(width: 12.r),
        controlButton(
            text: widget.innerText.agreeButton,
            gradient: const LinearGradient(
              colors: [Color(0xffA754FF), Color(0xff510DF1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: () {
              ZegoUIKit()
                  .getSignalingPlugin()
                  .acceptInvitation(inviterID: user.id, data: '')
                  .then((result) {
                ZegoLoggerService.logInfo(
                  'accept audience ${user.name} link request, result:$result',
                  tag: 'live audio',
                  subTag: 'member list',
                );
                if (result.error == null) {
                  widget.connectManager.removeRequestCoHostUsers(user);
                } else {
                  showDebugToast('error:${result.error}');
                }
              });
            }),
      ],
    );
  }

  Widget hostControlItem(ZegoUIKitUser user) {
    if (ZegoUIKit().getLocalUser().id == user.id) {
      return Container();
    }

    final popupItems = <PopupItem>[];

    if (widget.isPluginEnabled &&
        // locked
        widget.seatManager.isSeatLockedNotifier.value &&
        //  not host
        !widget.seatManager.hostsNotifier.value.contains(user.id) &&
        //  not on seat
        !widget.seatManager.seatsUserMapNotifier.value.values
            .contains(user.id)) {
      popupItems.add(
        PopupItem(
          PopupItemValue.inviteLink,
          widget.innerText.inviteToTakeSeatMenuDialogButton
              .replaceFirst(widget.innerText.param_1, user.name),
          data: user.id,
        ),
      );
    }

    if (popupItems.isNotEmpty) {
      /// show useless more button if not a host
      popupItems.add(PopupItem(
        PopupItemValue.cancel,
        widget.innerText.cancelMenuDialogButton,
      ));
    }

    return ZegoTextIconButton(
      buttonSize: Size(60.r, 60.r),
      iconSize: Size(60.r, 60.r),
      icon: ButtonIcon(
        icon: PrebuiltLiveAudioRoomImage.asset(
            PrebuiltLiveAudioRoomIconUrls.memberMore),
      ),
      onPressed: () {
        /// product manager say close sheet together
        Navigator.of(context).pop();

        if (widget.onMoreButtonPressed != null) {
          /// No more popup menus, let the customer handle
          widget.onMoreButtonPressed!.call(user);
          return;
        }

        if (popupItems.isNotEmpty) {
          showPopUpSheet(
            context: context,
            userID: user.id,
            popupItems: popupItems,
            seatManager: widget.seatManager,
            connectManager: widget.connectManager,
            innerText: widget.innerText,
          );
        }
      },
    );
  }

  Widget controlButton({
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Gradient? gradient,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(165.r, 64.r)),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(32.r),
            gradient: gradient,
          ),
          child: Align(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28.r,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isUserInRequestSpeaker(String userID) {
    return -1 !=
        widget.connectManager.audiencesRequestingTakeSeatNotifier.value
            .indexWhere((requestUser) => userID == requestUser.id);
  }
}

void showMemberListSheet({
  ZegoAvatarBuilder? avatarBuilder,
  required bool isPluginEnabled,
  required BuildContext context,
  required ZegoLiveSeatManager seatManager,
  required ZegoLiveConnectManager connectManager,
  required ZegoInnerText innerText,
  required ZegoMemberListSheetMoreButtonPressed? onMoreButtonPressed,
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
              isPluginEnabled: isPluginEnabled,
              seatManager: seatManager,
              connectManager: connectManager,
              innerText: innerText,
              onMoreButtonPressed: onMoreButtonPressed,
            ),
          ),
        ),
      );
    },
  );
}
