// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/avatar_default_item.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/pop_up_sheet_menu.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/toast.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/connect/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/seat/seat_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';

/// @nodoc
typedef ZegoLiveAudioRoomMemberListSheetMoreButtonPressed = void Function(
  ZegoUIKitUser user,
);

/// @nodoc
class ZegoLiveAudioRoomMemberListSheet extends StatefulWidget {
  const ZegoLiveAudioRoomMemberListSheet({
    Key? key,
    this.avatarBuilder,
    this.itemBuilder,
    this.hiddenUserIDsNotifier,
    required this.isPluginEnabled,
    required this.seatManager,
    required this.connectManager,
    required this.innerText,
    required this.onMoreButtonPressed,
    required this.popUpManager,
  }) : super(key: key);

  final bool isPluginEnabled;
  final ZegoLiveAudioRoomSeatManager seatManager;
  final ZegoLiveAudioRoomConnectManager connectManager;
  final ZegoLiveAudioRoomPopUpManager popUpManager;
  final ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText;
  final ZegoLiveAudioRoomMemberListSheetMoreButtonPressed? onMoreButtonPressed;
  final ValueNotifier<List<String>>? hiddenUserIDsNotifier;

  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoMemberListItemBuilder? itemBuilder;

  @override
  State<ZegoLiveAudioRoomMemberListSheet> createState() =>
      _ZegoLiveAudioRoomMemberListSheetState();
}

/// @nodoc
class _ZegoLiveAudioRoomMemberListSheetState
    extends State<ZegoLiveAudioRoomMemberListSheet> {
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
          header(98.zH),
          Container(height: 1.zR, color: Colors.white.withOpacity(0.15)),
          SizedBox(
            height: constraints.maxHeight - 1.zR - 98.zH,
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
    return ValueListenableBuilder<List<String>>(
        valueListenable:
            widget.hiddenUserIDsNotifier ?? ValueNotifier<List<String>>([]),
        builder: (context, hiddenUserIDs, _) {
          return ZegoMemberList(
            showCameraState: false,
            showMicrophoneState: false,
            hiddenUserIDs: hiddenUserIDs,
            sortUserList:
                (ZegoUIKitUser localUser, List<ZegoUIKitUser> remoteUsers) {
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
            itemBuilder: widget.itemBuilder ??
                (
                  BuildContext context,
                  Size size,
                  ZegoUIKitUser user,
                  Map<String, dynamic> extraInfo,
                ) {
                  return ValueListenableBuilder<Map<String, String>>(
                      valueListenable:
                          ZegoUIKit().getInRoomUserAttributesNotifier(user.id),
                      builder: (context, _, __) {
                        return GestureDetector(
                          onTap: () {
                            widget.seatManager.events.memberList.onClicked
                                ?.call(user);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 36.zR),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 92.zR,
                                  height: 92.zR,
                                  child: ZegoLiveAudioRoomAvatarDefaultItem(
                                    user: user,
                                    avatarBuilder: widget.avatarBuilder,
                                  ),
                                ),
                                SizedBox(width: 24.zR),
                                userNameItem(user),
                                const Expanded(child: SizedBox()),
                                controlsItem(user),
                              ],
                            ),
                          ),
                        );
                      });
                },
          );
        });
  }

  Widget header(double height) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: widget.seatManager.config.rootNavigator,
              ).pop();
            },
            child: SizedBox(
              width: 70.zR,
              height: 70.zR,
              child:
                  ZegoLiveAudioRoomImage.asset(ZegoLiveAudioRoomIconUrls.back),
            ),
          ),
          SizedBox(width: 10.zR),
          StreamBuilder<List<ZegoUIKitUser>>(
              stream: ZegoUIKit().getUserListStream(),
              builder: (context, snapshot) {
                return Text(
                  '${widget.innerText.memberListTitle} (${ZegoUIKit().getAllUsers().length})',
                  style: TextStyle(
                    fontSize: 36.0.zR,
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
            fontSize: 32.0.zR,
            color: const Color(0xffffffff),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: 5.zR),
        Text(
          extensions.isEmpty ? '' : "(${extensions.join(",")})",
          style: TextStyle(
            fontSize: 32.0.zR,
            color: const Color(0xffA7A6B7),
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget controlsItem(ZegoUIKitUser user) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.seatManager.isRoomSeatLockedNotifier,
      builder: (context, isRoomSeatLocked, _) {
        return ValueListenableBuilder<List<ZegoUIKitUser>>(
          valueListenable:
              widget.connectManager.audiencesRequestingTakeSeatNotifier,
          builder: (context, requestTakeSeatUsers, _) {
            final index = requestTakeSeatUsers.indexWhere(
                (requestCoHostUser) => user.id == requestCoHostUser.id);
            if (-1 != index) {
              if (isRoomSeatLocked) {
                /// on show agree/disagree when seat is locked
                return requestTakeSeatUserControlItem(user);
              }
            } else if (widget.seatManager.localHasHostPermissions) {
              return hostPermissionControlItems(user);
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
            text: widget.innerText.memberListDisagreeButton,
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
        SizedBox(width: 12.zR),
        controlButton(
            text: widget.innerText.memberListAgreeButton,
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

  Widget hostPermissionControlItems(ZegoUIKitUser user) {
    if (ZegoUIKit().getLocalUser().id == user.id) {
      return Container();
    }

    final popupItems = <ZegoLiveAudioRoomPopupItem>[];

    if (widget.isPluginEnabled &&
        // locked
        widget.seatManager.isRoomSeatLockedNotifier.value &&
        //  not host
        !widget.seatManager.hostsNotifier.value.contains(user.id) &&
        //  not on seat
        !widget.seatManager.seatsUserMapNotifier.value.values
            .contains(user.id)) {
      popupItems.add(
        ZegoLiveAudioRoomPopupItem(
          ZegoLiveAudioRoomPopupItemValue.inviteLink,
          widget.innerText.inviteToTakeSeatMenuDialogButton
              .replaceFirst(widget.innerText.param_1, user.name),
          data: user.id,
        ),
      );
    }

    if (popupItems.isNotEmpty) {
      /// show useless more button if not a host
      popupItems.add(ZegoLiveAudioRoomPopupItem(
        ZegoLiveAudioRoomPopupItemValue.cancel,
        widget.innerText.cancelMenuDialogButton,
      ));
    }

    return ZegoTextIconButton(
      buttonSize: Size(60.zR, 60.zR),
      iconSize: Size(60.zR, 60.zR),
      icon: ButtonIcon(
        icon: ZegoLiveAudioRoomImage.asset(
          ZegoLiveAudioRoomIconUrls.memberMore,
        ),
      ),
      onPressed: () {
        /// product manager say close sheet together
        Navigator.of(
          context,
          rootNavigator: widget.seatManager.config.rootNavigator,
        ).pop();

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
            popUpManager: widget.popUpManager,
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
      constraints: BoxConstraints.loose(Size(165.zR, 64.zR)),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(32.zR),
            gradient: gradient,
          ),
          child: Align(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28.zR,
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
  ZegoMemberListItemBuilder? itemBuilder,
  required bool isPluginEnabled,
  required BuildContext context,
  required ZegoLiveAudioRoomSeatManager seatManager,
  required ZegoLiveAudioRoomConnectManager connectManager,
  required ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText,
  required ZegoLiveAudioRoomMemberListSheetMoreButtonPressed?
      onMoreButtonPressed,
  required ZegoLiveAudioRoomPopUpManager popUpManager,
  ValueNotifier<List<String>>? hiddenUserIDsNotifier,
}) {
  final key = DateTime.now().millisecondsSinceEpoch;
  popUpManager.addAPopUpSheet(key);

  showModalBottomSheet(
    barrierColor: ZegoUIKitDefaultTheme.viewBarrierColor,
    backgroundColor: ZegoUIKitDefaultTheme.viewBackgroundColor,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0.zR),
        topRight: Radius.circular(32.0.zR),
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
            child: ZegoLiveAudioRoomMemberListSheet(
              avatarBuilder: avatarBuilder,
              itemBuilder: itemBuilder,
              isPluginEnabled: isPluginEnabled,
              seatManager: seatManager,
              connectManager: connectManager,
              popUpManager: popUpManager,
              innerText: innerText,
              onMoreButtonPressed: onMoreButtonPressed,
              hiddenUserIDsNotifier: hiddenUserIDsNotifier,
            ),
          ),
        ),
      );
    },
  ).whenComplete(() {
    popUpManager.removeAPopUpSheet(key);
  });
}
