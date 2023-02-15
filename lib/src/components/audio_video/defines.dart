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
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

class ZegoLiveAudioRoomLayoutRowConfig {
  ZegoLiveAudioRoomLayoutRowConfig({
    this.count = 4,
    this.seatSpacing = 0,
    this.alignment = ZegoLiveAudioRoomLayoutAlignment.spaceAround,
  });

  /// seat count of a row, range is [1~4]
  int count;

  ///  spacing between seats, should be positive
  int seatSpacing = 0;

  /// seat alignment
  ZegoLiveAudioRoomLayoutAlignment alignment;
}

class ZegoLiveAudioRoomLayoutConfig {
  ZegoLiveAudioRoomLayoutConfig({
    this.rowSpacing = 0,
    List<ZegoLiveAudioRoomLayoutRowConfig>? rowConfigs,
  }) : rowConfigs = rowConfigs ??
            [
              ZegoLiveAudioRoomLayoutRowConfig(),
              ZegoLiveAudioRoomLayoutRowConfig(),
            ];

  ///  spacing between rows, should be positive
  int rowSpacing;

  /// rows
  List<ZegoLiveAudioRoomLayoutRowConfig> rowConfigs;
}
