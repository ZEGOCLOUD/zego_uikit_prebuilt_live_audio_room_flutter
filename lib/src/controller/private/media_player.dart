// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/config.dart';

class ZegoLiveAudioRoomControllerMediaDefaultPlayer
    with ZegoLiveAudioRoomControllerMediaDefaultPlayerPrivate {
  ValueNotifier<bool> get visibleNotifier => private.visibleNotifier;

  void sharing(String filePathOrURL) {
    ZegoLoggerService.logInfo(
      'sharing, '
      'path:$filePathOrURL',
      tag: 'audio-room',
      subTag: 'controller.media.player',
    );

    if (!(private.config?.mediaPlayer.defaultPlayer.support ?? false)) {
      ZegoLoggerService.logInfo(
        'sharing, but {config.mediaPlayer.defaultPlayer.support} is not support',
        tag: 'audio-room',
        subTag: 'controller.media.player',
      );

      return;
    }

    String fileExtension = '';
    if (filePathOrURL.contains('.')) {
      fileExtension = filePathOrURL.split('.').last.toLowerCase();
    }
    final supportExtensions = [
      ...zegoMediaVideoExtensions,
      ...zegoMediaAudioExtensions,
    ];
    if (!supportExtensions.contains(fileExtension)) {
      ZegoLoggerService.logInfo(
        'extension($fileExtension) is not valid, only support:$supportExtensions',
        tag: 'audio-room',
        subTag: 'controller.media.player',
      );

      return;
    }

    show();
    private.sharingPathNotifier.value = filePathOrURL;
  }

  void show() {
    ZegoLoggerService.logInfo(
      'showPlayer, ',
      tag: 'audio-room',
      subTag: 'controller.media.player',
    );

    private.visibleNotifier.value = true;
  }

  void hide({
    bool needStop = true,
  }) {
    ZegoLoggerService.logInfo(
      'hidePlayer, '
      'needStop:$needStop, ',
      tag: 'audio-room',
      subTag: 'controller.media.player',
    );

    if (needStop) {
      ZegoUIKit().stopMedia();
    }

    private.visibleNotifier.value = false;
  }
}

mixin ZegoLiveAudioRoomControllerMediaDefaultPlayerPrivate {
  final _impl = ZegoLiveAudioRoomControllerMediaDefaultPlayerPrivateImpl();

  /// Don't call that
  ZegoLiveAudioRoomControllerMediaDefaultPlayerPrivateImpl get private => _impl;
}

/// @nodoc
class ZegoLiveAudioRoomControllerMediaDefaultPlayerPrivateImpl {
  ZegoUIKitPrebuiltLiveAudioRoomConfig? config;
  final sharingPathNotifier = ValueNotifier<String?>(null);
  final visibleNotifier = ValueNotifier<bool>(false);

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveStreaming.
  /// DO NOT CALL!!!
  /// Call Inside By Prebuilt
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveAudioRoomConfig config,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.media.p',
    );

    this.config = config;

    ZegoUIKit().getMediaPlayStateNotifier().addListener(onPlayStateChanged);
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveStreaming.
  /// DO NOT CALL!!!
  /// Call Inside By Prebuilt
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'uninit by prebuilt',
      tag: 'audio-room',
      subTag: 'controller.media.p',
    );

    ZegoUIKit().getMediaPlayStateNotifier().removeListener(onPlayStateChanged);

    config = null;
    visibleNotifier.value = false;
    sharingPathNotifier.value = null;
  }

  void onPlayStateChanged() {
    final playState = ZegoUIKit().getMediaPlayStateNotifier().value;

    ZegoLoggerService.logInfo(
      'onPlayStateChanged, state:$playState',
      tag: 'audio-room',
      subTag: 'controller.media.p',
    );

    if (ZegoUIKitMediaPlayState.noPlay == playState) {
      sharingPathNotifier.value = null;
    }
  }
}
