// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil_zego/flutter_screenutil_zego.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class ZegoAvatarDefaultItem extends StatefulWidget {
  const ZegoAvatarDefaultItem({
    Key? key,
    this.user,
    this.avatarBuilder,
  }) : super(key: key);

  final ZegoUIKitUser? user;
  final ZegoAvatarBuilder? avatarBuilder;

  @override
  State<ZegoAvatarDefaultItem> createState() => _ZegoAvatarDefaultItemState();
}

class _ZegoAvatarDefaultItemState extends State<ZegoAvatarDefaultItem> {
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
    return avatarURL.isNotEmpty
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
                '${user?.toString()} avatar url is invalid',
                tag: 'live audio',
                subTag: 'live page',
              );
              return textAvatar();
            },
          )
        : widget.avatarBuilder?.call(
            context,
            size,
            user,
            extraInfo,
          );
  }

  Widget textAvatar() {
    return Text(
      (widget.user?.name.isNotEmpty ?? false)
          ? widget.user!.name.characters.first
          : '',
      style: TextStyle(
        fontSize: 32.0.r,
        color: const Color(0xff222222),
        decoration: TextDecoration.none,
      ),
    );
  }
}
