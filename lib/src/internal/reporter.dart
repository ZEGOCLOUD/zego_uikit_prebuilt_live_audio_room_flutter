// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

class ZegoAudioRoomReporter {
  static String eventInit = "liveaudioroom/init";
  static String eventUninit = "liveaudioroom/unInit";

  /// Version number of each kit, usually in three segments
  static String eventKeyKitVersion = "liveaudioroom_version";

  Future<void> report({
    required String event,
    Map<String, Object> params = const {},
  }) async {
    ZegoUIKit().reporter().report(event: event, params: params);
  }

  factory ZegoAudioRoomReporter() {
    return instance;
  }

  ZegoAudioRoomReporter._internal();

  static final ZegoAudioRoomReporter instance =
      ZegoAudioRoomReporter._internal();
}
