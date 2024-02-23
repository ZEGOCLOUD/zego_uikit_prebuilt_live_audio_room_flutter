// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:

/// @nodoc
class ZegoLiveAudioRoomAvatarDefaultItem extends StatefulWidget {
  const ZegoLiveAudioRoomAvatarDefaultItem({
    Key? key,
    this.user,
    this.avatarBuilder,
  }) : super(key: key);

  final ZegoUIKitUser? user;
  final ZegoAvatarBuilder? avatarBuilder;

  @override
  State<ZegoLiveAudioRoomAvatarDefaultItem> createState() =>
      _ZegoLiveAudioRoomAvatarDefaultItemState();
}

/// @nodoc
class _ZegoLiveAudioRoomAvatarDefaultItemState
    extends State<ZegoLiveAudioRoomAvatarDefaultItem> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xffDBDDE3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: avatarBuilderWithURL(
                  context,
                  Size(constraints.maxWidth, constraints.maxHeight),
                  widget.user, {}) ??
              textAvatar(),
        ),
      );
    });
  }

  Widget? avatarBuilderWithURL(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    final avatarURL = user?.inRoomAttributes.value[attributeKeyAvatar] ?? '';

    return widget.avatarBuilder?.call(
          context,
          size,
          user,
          extraInfo,
        ) ??
        (avatarURL.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: avatarURL,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) {
                  ZegoLoggerService.logInfo(
                    '$user avatar url is invalid',
                    tag: 'live audio',
                    subTag: 'live page',
                  );
                  return textAvatar();
                },
              )
            : textAvatar());
  }

  Widget textAvatar() {
    return Text(
      (widget.user?.name.isNotEmpty ?? false)
          ? widget.user!.name.characters.first
          : '',
      style: TextStyle(
        fontSize: 32.0.zR,
        color: const Color(0xff222222),
        decoration: TextDecoration.none,
      ),
    );
  }
}
