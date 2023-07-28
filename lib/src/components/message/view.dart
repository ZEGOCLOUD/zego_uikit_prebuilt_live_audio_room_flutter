// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/message/view_item.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';

/// @nodoc
class ZegoInRoomLiveCommentingView extends StatefulWidget {
  final ZegoInRoomMessageViewConfig? config;
  final ZegoAvatarBuilder? avatarBuilder;

  const ZegoInRoomLiveCommentingView({
    Key? key,
    this.config,
    this.avatarBuilder,
  }) : super(key: key);

  @override
  State<ZegoInRoomLiveCommentingView> createState() =>
      _ZegoInRoomLiveCommentingViewState();
}

/// @nodoc
class _ZegoInRoomLiveCommentingViewState
    extends State<ZegoInRoomLiveCommentingView> {
  @override
  Widget build(BuildContext context) {
    return ZegoInRoomMessageView(
      historyMessages: ZegoUIKit().getInRoomMessages(),
      stream: ZegoUIKit().getInRoomMessageListStream(),
      itemBuilder: widget.config?.itemBuilder ??
          (BuildContext context, ZegoInRoomMessage message, _) {
            return ZegoInRoomLiveCommentingViewItem(
              message: message,
              avatarBuilder: widget.avatarBuilder,
              showName: widget.config?.showName ?? true,
              showAvatar: widget.config?.showAvatar ?? true,
              maxLines: widget.config?.maxLines,
            );
          },
    );
  }
}
