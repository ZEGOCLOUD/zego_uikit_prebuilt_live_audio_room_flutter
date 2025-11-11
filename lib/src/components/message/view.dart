// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/events.dart';

/// @nodoc
class ZegoLiveAudioRoomInRoomLiveMessageView extends StatefulWidget {
  final String liveID;
  final ZegoLiveAudioRoomInRoomMessageConfig? config;
  final ZegoLiveAudioRoomInRoomMessageEvents? events;
  final ZegoAvatarBuilder? avatarBuilder;

  const ZegoLiveAudioRoomInRoomLiveMessageView({
    super.key,
    required this.liveID,
    this.config,
    this.events,
    this.avatarBuilder,
  });

  @override
  State<ZegoLiveAudioRoomInRoomLiveMessageView> createState() =>
      _ZegoLiveAudioRoomInRoomLiveMessageViewState();
}

/// @nodoc
class _ZegoLiveAudioRoomInRoomLiveMessageViewState
    extends State<ZegoLiveAudioRoomInRoomLiveMessageView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: widget.config?.background ?? Container(),
          ),
          ZegoInRoomMessageView(
            historyMessages: ZegoUIKit().getInRoomMessages(
              targetRoomID: widget.liveID,
            ),
            stream: ZegoUIKit().getInRoomMessageListStream(
              targetRoomID: widget.liveID,
            ),
            itemBuilder: widget.config?.itemBuilder ??
                (BuildContext context, ZegoInRoomMessage message, _) {
                  return ZegoInRoomMessageViewItem(
                    roomID: widget.liveID,
                    message: message,
                    avatarBuilder: widget.avatarBuilder,
                    showName: widget.config?.showName ?? true,
                    showAvatar: widget.config?.showAvatar ?? true,
                    resendIcon: widget.config?.resendIcon,
                    borderRadius: widget.config?.borderRadius,
                    paddings: widget.config?.paddings,
                    opacity: widget.config?.opacity,
                    backgroundColor: widget.config?.backgroundColor,
                    maxLines: widget.config?.maxLines,
                    nameTextStyle: widget.config?.nameTextStyle,
                    messageTextStyle: widget.config?.messageTextStyle,
                    onItemClick: widget.events?.onClicked,
                    onItemLongPress: widget.events?.onLongPress,
                  );
                },
          ),
        ],
      ),
    );
  }
}
