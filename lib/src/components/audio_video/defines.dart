// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

final seatItemWidth = 160.w;
final seatItemHeight = 160.r;
final seatItemRowSpacing = 7.5.w;
final seatItemColumnSpacing = 32.r;
final seatIconWidth = 108.r;
final seatIconHeight = 108.r;
final seatUserNameFontSize = 22.0.r;
final seatHostFlagHeight = 24.0.r;

final double avatarPosTop = 15.r;
final double avatarPosLeft = 22.r;

enum ZegoLiveAudioRoomLayoutAlignment {
  spaceAround,
  start,
  end,
  center,
  spaceBetween,
  spaceEvenly,
}

class ZegoLiveAudioRoomLayoutRowConfig {
  /// seat count of a row, range is [1~4]
  int count;

  // int seatSpacing;
  ZegoLiveAudioRoomLayoutAlignment alignment;

  ZegoLiveAudioRoomLayoutRowConfig({
    this.count = 4,
    this.alignment = ZegoLiveAudioRoomLayoutAlignment.spaceAround,
  });
}

class ZegoLiveAudioRoomLayoutConfig {
  /// row spacing, should be positive
  int rowSpacing;

  /// rows
  List<ZegoLiveAudioRoomLayoutRowConfig> rowConfigs;

  ZegoLiveAudioRoomLayoutConfig({
    this.rowSpacing = 0,
    List<ZegoLiveAudioRoomLayoutRowConfig>? rowConfigs,
  }) : rowConfigs = rowConfigs ??
            [
              ZegoLiveAudioRoomLayoutRowConfig(
                count: 4,
                alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround,
              ),
              ZegoLiveAudioRoomLayoutRowConfig(
                count: 4,
                alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround,
              ),
            ];
}
