part of 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerMedia {
  final ZegoLiveAudioRoomMediaController _mediaController =
      ZegoLiveAudioRoomMediaController();

  ZegoLiveAudioRoomMediaController get media => _mediaController;
}

/// @nodoc
class ZegoLiveAudioRoomMediaController {
  /// Start playing.
  Future<MediaPlayResult> play({
    required String filePathOrURL,
    bool enableRepeat = false,
  }) async {
    return ZegoUIKit().playMedia(
      filePathOrURL: filePathOrURL,
      enableRepeat: enableRepeat,
    );
  }

  /// Stop playing.
  Future<void> stop() async {
    return ZegoUIKit().stopMedia();
  }

  /// Pause playing.
  Future<void> pause() async {
    return ZegoUIKit().pauseMedia();
  }

  /// Resume playing.
  Future<void> resume() async {
    return ZegoUIKit().resumeMedia();
  }

  /// - [millisecond] Point in time of specified playback progress
  Future<MediaSeekToResult> seekTo(int millisecond) async {
    return ZegoUIKit().seekTo(millisecond);
  }

  /// Set media player volume. Both the local play volume and the publish volume are set.
  ///
  /// - [volume] The range is 0 ~ 100. The default is 30.
  Future<void> setVolume(int volume) async {
    return ZegoUIKit().setMediaVolume(volume);
  }

  int getVolume() {
    return ZegoUIKit().getMediaVolume();
  }

  Future<void> muteLocal(bool mute) {
    return ZegoUIKit().muteMediaLocal(mute);
  }

  /// Get the total progress of your media resources, Returns Unit is millisecond.
  int getTotalDuration() {
    return ZegoUIKit().getMediaTotalDuration();
  }

  /// Get current playing progress.
  int getCurrentProgress() {
    return ZegoUIKit().getMediaCurrentProgress();
  }

  MediaType getType() {
    return ZegoUIKit().getMediaType();
  }

  ValueNotifier<int> getVolumeNotifier() {
    return ZegoUIKit().getMediaVolumeNotifier();
  }

  ValueNotifier<int> getCurrentProgressNotifier() {
    return ZegoUIKit().getMediaCurrentProgressNotifier();
  }

  ValueNotifier<MediaPlayState> getPlayStateNotifier() {
    return ZegoUIKit().getMediaPlayStateNotifier();
  }

  ValueNotifier<MediaType> getMediaTypeNotifier() {
    return ZegoUIKit().getMediaTypeNotifier();
  }

  Future<List<PlatformFile>> pickPureAudioFile() async {
    return ZegoUIKit().pickPureAudioMediaFile();
  }

  Future<List<PlatformFile>> pickVideoFile() async {
    return ZegoUIKit().pickVideoMediaFile();
  }

  Future<List<PlatformFile>> pickFile() async {
    return ZegoUIKit().pickMediaFile();
  }

  MediaInfo getMediaInfo() {
    return ZegoUIKit().getMediaInfo();
  }
}
