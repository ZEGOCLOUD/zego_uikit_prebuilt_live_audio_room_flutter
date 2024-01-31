part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerMedia {
  final ZegoLiveAudioRoomControllerMediaImpl _mediaController =
      ZegoLiveAudioRoomControllerMediaImpl();

  ZegoLiveAudioRoomControllerMediaImpl get media => _mediaController;
}

/// media series API
class ZegoLiveAudioRoomControllerMediaImpl {
  /// volume of current media
  int get volume => ZegoUIKit().getMediaVolume();

  /// the total progress(millisecond) of current media resources
  int get totalDuration => ZegoUIKit().getMediaTotalDuration();

  /// current playing progress of current media
  int get currentProgress => ZegoUIKit().getMediaCurrentProgress();

  /// media type  of current media
  ZegoUIKitMediaType get type => ZegoUIKit().getMediaType();

  /// volume notifier of current media
  ValueNotifier<int> get volumeNotifier => ZegoUIKit().getMediaVolumeNotifier();

  /// current progress notifier of current media
  ValueNotifier<int> get currentProgressNotifier =>
      ZegoUIKit().getMediaCurrentProgressNotifier();

  /// play state notifier of current media
  ValueNotifier<ZegoUIKitMediaPlayState> get playStateNotifier =>
      ZegoUIKit().getMediaPlayStateNotifier();

  /// type notifier of current media
  ValueNotifier<ZegoUIKitMediaType> get typeNotifier =>
      ZegoUIKit().getMediaTypeNotifier();

  /// mute state notifier of current media
  ValueNotifier<bool> get muteNotifier => ZegoUIKit().getMediaMuteNotifier();

  /// info of current media
  ZegoUIKitMediaInfo get info => ZegoUIKit().getMediaInfo();

  /// start play current media
  Future<ZegoUIKitMediaPlayResult> play({
    required String filePathOrURL,
    bool enableRepeat = false,
  }) async {
    return ZegoUIKit().playMedia(
      filePathOrURL: filePathOrURL,
      enableRepeat: enableRepeat,
    );
  }

  /// stop play current media
  Future<void> stop() async {
    return ZegoUIKit().stopMedia();
  }

  /// pause current media
  Future<void> pause() async {
    return ZegoUIKit().pauseMedia();
  }

  /// resume current media
  Future<void> resume() async {
    return ZegoUIKit().resumeMedia();
  }

  /// set the current media playback progress
  /// - [millisecond] Point in time of specified playback progress
  Future<ZegoUIKitMediaSeekToResult> seekTo(int millisecond) async {
    return ZegoUIKit().seekTo(millisecond);
  }

  /// Set media player volume. Both the local play volume and the publish volume are set.
  ///
  /// - [volume] The range is 0 ~ 100. The default is 30.
  Future<void> setVolume(int volume) async {
    return ZegoUIKit().setMediaVolume(volume);
  }

  /// mute current media
  Future<void> muteLocal(bool mute) async {
    return ZegoUIKit().muteMediaLocal(mute);
  }

  /// pick pure audio media file
  Future<List<PlatformFile>> pickPureAudioFile() async {
    return ZegoUIKit().pickPureAudioMediaFile();
  }

  /// pick video media file
  Future<List<PlatformFile>> pickVideoFile() async {
    return ZegoUIKit().pickVideoMediaFile();
  }

  /// If you want to specify the allowed formats, you can set them using [allowedExtensions].
  /// Currently, for video, we support "avi", "flv", "mkv", "mov", "mp4", "mpeg", "webm", "wmv".
  /// For audio, we support "aac", "midi", "mp3", "ogg", "wav".
  Future<List<PlatformFile>> pickFile({
    List<String>? allowedExtensions = const [
      /// video
      "avi",
      "flv",
      "mkv",
      "mov",
      "mp4",
      "mpeg",
      "webm",
      "wmv",

      /// audio
      "aac",
      "midi",
      "mp3",
      "ogg",
      "wav",
    ],
  }) async {
    return ZegoUIKit().pickMediaFile(
      allowedExtensions: allowedExtensions,
    );
  }
}
