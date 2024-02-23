/// The alignment of the seat layout.
/// This enum type is used for the [alignment] property in [ZegoLiveAudioRoomLayoutRowConfig].
enum ZegoLiveAudioRoomLayoutAlignment {
  ///  Place the seats as close to the start of the main axis as possible.
  start,

  /// Place the seats as close to the end of the main axis as possible.
  end,

  /// Place the seats as close to the middle of the main axis as possible.
  center,

  /// Place the free space evenly between the seats.
  spaceBetween,

  /// Place the free space evenly between the seats as well as half of that space before and after the first and last seat.
  spaceAround,

  /// Place the free space evenly between the seats as well as before and after the first and last seat.
  spaceEvenly,
}

/// Configuration for each row in the seat layout.
/// This type is used for the [ZegoUIKitPrebuiltLiveAudioRoomConfig].[layoutConfig].[rowConfigs] property.
class ZegoLiveAudioRoomLayoutRowConfig {
  ZegoLiveAudioRoomLayoutRowConfig({
    this.count = 4,
    this.seatSpacing = 0,
    this.alignment = ZegoLiveAudioRoomLayoutAlignment.spaceAround,
  });

  /// Number of seats in each row. Range is [1~4], default value is 4.
  int count;

  /// The horizontal spacing between each seat. It should be set to a value equal to or greater than 0.
  int seatSpacing = 0;

  /// The alignment of the seat layout.
  ZegoLiveAudioRoomLayoutAlignment alignment;

  /// @nodoc
  @override
  String toString() {
    return 'row config:{count:$count, spacing:$seatSpacing, alignment:$alignment}';
  }
}

/// Seat layout configuration options.
/// This type is used for the [ZegoUIKitPrebuiltLiveAudioRoomConfig].[layoutConfig] property.
class ZegoLiveAudioRoomLayoutConfig {
  ZegoLiveAudioRoomLayoutConfig({
    this.rowSpacing = 0,
    List<ZegoLiveAudioRoomLayoutRowConfig>? rowConfigs,
  }) : rowConfigs = rowConfigs ??
            [
              ZegoLiveAudioRoomLayoutRowConfig(),
              ZegoLiveAudioRoomLayoutRowConfig(),
            ];

  ///  Spacing between rows, should be positive
  int rowSpacing;

  /// Configuration list for each row.
  List<ZegoLiveAudioRoomLayoutRowConfig> rowConfigs;

  /// @nodoc
  @override
  String toString() {
    return 'spacing:$rowSpacing, row configs:${rowConfigs.map((e) => e.toString()).toList()}';
  }
}
