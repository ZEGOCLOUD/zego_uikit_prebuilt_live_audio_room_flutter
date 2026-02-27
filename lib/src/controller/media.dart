part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// Mixin for media player functionality.
///
/// This mixin provides access to the media player controller.
mixin ZegoLiveAudioRoomControllerMedia {
  final ZegoLiveAudioRoomControllerMediaImpl _mediaController =
      ZegoLiveAudioRoomControllerMediaImpl();

  /// Gets the media player controller instance.
  ZegoLiveAudioRoomControllerMediaImpl get media => _mediaController;
}

/// Controller for media player operations.
///
/// This class provides APIs for controlling media playback in the audio room.
class ZegoLiveAudioRoomControllerMediaImpl
    with ZegoLiveAudioRoomControllerMediaPrivate {
  /// Gets the default media player configuration.
  ZegoLiveAudioRoomControllerMediaDefaultPlayer get defaultPlayer =>
      private.defaultPlayer;

  /// Gets the current volume of the media player.
  ///
  /// Returns a value from 0 to 100.
  int get volume => ZegoUIKit().getMediaVolume();

  /// Gets the total duration of the current media.
  ///
  /// Returns the duration in milliseconds.
  int get totalDuration => ZegoUIKit().getMediaTotalDuration();

  /// Gets the current playback progress of the media.
  ///
  /// Returns the current position in milliseconds.
  int get currentProgress => ZegoUIKit().getMediaCurrentProgress();

  /// Gets the current media type.
  ZegoUIKitMediaType get type => ZegoUIKit().getMediaType();

  /// Gets the volume notifier of the media player.
  ///
  /// Use this to listen to volume changes.
  ValueNotifier<int> get volumeNotifier => ZegoUIKit().getMediaVolumeNotifier();

  /// Gets the current progress notifier of the media player.
  ///
  /// Use this to listen to playback progress changes.
  ValueNotifier<int> get currentProgressNotifier =>
      ZegoUIKit().getMediaCurrentProgressNotifier();

  /// Gets the play state notifier of the media player.
  ///
  /// Use this to listen to play state changes (playing, paused, stopped).
  ValueNotifier<ZegoUIKitMediaPlayState> get playStateNotifier =>
      ZegoUIKit().getMediaPlayStateNotifier();

  /// Gets the media type notifier.
  ///
  /// Use this to listen to media type changes.
  ValueNotifier<ZegoUIKitMediaType> get typeNotifier =>
      ZegoUIKit().getMediaTypeNotifier();

  /// Gets the mute state notifier of the media player.
  ValueNotifier<bool> get muteNotifier => ZegoUIKit().getMediaMuteNotifier();

  /// Gets the info of the current media.
  ZegoUIKitMediaInfo get info => ZegoUIKit().getMediaInfo();

  /// Starts playing the specified media file.
  ///
  /// [filePathOrURL] - The file path or URL of the media to play.
  /// [enableRepeat] - Whether to repeat playback. Default is false.
  /// [autoStart] - Whether to start playing immediately. Default is true.
  Future<ZegoUIKitMediaPlayResult> play({
    required String filePathOrURL,
    bool enableRepeat = false,
    bool autoStart = true,
  }) async {
    ZegoLoggerService.logInfo(
      'play, '
      'filePathOrURL:$filePathOrURL, '
      'enableRepeat:$enableRepeat, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().playMedia(
      filePathOrURL: filePathOrURL,
      enableRepeat: enableRepeat,
      autoStart: autoStart,
    );
  }

  /// Stops playing the current media.
  Future<void> stop() async {
    ZegoLoggerService.logInfo(
      'stop, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().stopMedia();
  }

  /// Destroys the media player and releases resources.
  Future<void> destroy() async {
    ZegoLoggerService.logInfo(
      'destroy, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().destroyMedia();
  }

  /// Pauses the current media playback.
  Future<void> pause() async {
    ZegoLoggerService.logInfo(
      'pause, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().pauseMedia();
  }

  /// Resumes the paused media playback.
  Future<void> resume() async {
    ZegoLoggerService.logInfo(
      'resume, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().resumeMedia();
  }

  /// Seeks to the specified position in the media.
  ///
  /// [millisecond] - The position to seek to, in milliseconds.
  Future<ZegoUIKitMediaSeekToResult> seekTo(int millisecond) async {
    ZegoLoggerService.logInfo(
      'seekTo, '
      'millisecond:$millisecond, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().seekTo(millisecond);
  }

  /// Sets the media player volume.
  ///
  /// This sets both the local play volume and the publish volume.
  ///
  /// [volume] - The volume level from 0 to 100. Default is 30.
  /// [isSyncToRemote] - If true, syncs both local play and publish volume. If false, only adjusts local play volume. Default is false.
  Future<void> setVolume(
    int volume, {
    bool isSyncToRemote = false,
  }) async {
    ZegoLoggerService.logInfo(
      'setVolume, '
      'volume:$volume, '
      'isSyncToRemote:$isSyncToRemote, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().setMediaVolume(
      volume,
      isSyncToRemote: isSyncToRemote,
    );
  }

  /// Mutes or unmutes the media player locally.
  ///
  /// [mute] - If true, mutes the media; if false, unmutes it.
  Future<void> muteLocal(bool mute) async {
    ZegoLoggerService.logInfo(
      'muteLocal, '
      'mute:$mute, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().muteMediaLocal(mute);
  }

  /// Opens the file picker to select a pure audio file.
  ///
  /// Returns a list of selected audio files.
  Future<List<ZegoUIKitPlatformFile>> pickPureAudioFile() async {
    ZegoLoggerService.logInfo(
      'pickPureAudioFile, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().pickPureAudioMediaFile();
  }

  /// Opens the file picker to select a video file.
  ///
  /// Returns a list of selected video files.
  Future<List<ZegoUIKitPlatformFile>> pickVideoFile() async {
    ZegoLoggerService.logInfo(
      'pickVideoFile, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().pickVideoMediaFile();
  }

  /// Opens the file picker to select a media file (audio or video).
  ///
  /// [allowedExtensions] - If specified, only files with these extensions will be shown.
  ///   - Supported video formats: "avi", "flv", "mkv", "mov", "mp4", "mpeg", "webm", "wmv"
  ///   - Supported audio formats: "aac", "midi", "mp3", "ogg", "wav"
  Future<List<ZegoUIKitPlatformFile>> pickFile(
      {List<String>? allowedExtensions}) async {
    ZegoLoggerService.logInfo(
      'pickFile, '
      'allowedExtensions:$allowedExtensions, ',
      tag: 'audio-room',
      subTag: 'controller.media',
    );

    return ZegoUIKit().pickMediaFile(
      allowedExtensions: allowedExtensions,
    );
  }
}
