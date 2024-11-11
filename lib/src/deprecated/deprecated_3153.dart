// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

const deprecatedTipsV3_15_3 = ', '
    'deprecated since 3.15.3, '
    'will be removed after 4.0.0,'
    'Migrate Guide:https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Migration_3.x-topic.html';

extension ZegoLiveAudioRoomTopMenuBarConfigDeprecatedExtension
    on ZegoLiveAudioRoomTopMenuBarConfig {
  @Deprecated('use showLeaveButton instead$deprecatedTipsV3_15_3')
  bool get showLeaveButton =>
      buttons.contains(ZegoLiveAudioRoomMenuBarButtonName.leaveButton);
}
