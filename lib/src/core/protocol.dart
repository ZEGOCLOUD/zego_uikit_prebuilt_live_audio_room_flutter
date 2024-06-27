// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

class ZegoAudioRoomAudienceRequestConnectProtocol {
  const ZegoAudioRoomAudienceRequestConnectProtocol({
    required this.user,
    required this.targetIndex,
  });

  /// invitee's name
  final ZegoUIKitUser user;

  /// invitee's live id
  final int targetIndex;

  bool get isEmpty => user.isEmpty() || -1 == targetIndex;

  String toJsonString() => isEmpty
      ? ''
      : jsonEncode(
          {
            'user_id': user.id,
            'user_name': user.name,
            'index': targetIndex,
          },
        );

  factory ZegoAudioRoomAudienceRequestConnectProtocol.fromJsonString(
    String jsonString,
  ) {
    if (jsonString.isEmpty) {
      return ZegoAudioRoomAudienceRequestConnectProtocol(
        user: ZegoUIKitUser.empty(),
        targetIndex: -1,
      );
    }

    Map<String, dynamic> jsonMap = {};
    try {
      jsonMap = jsonDecode(jsonString) as Map<String, dynamic>? ?? {};
    } catch (e) {
      ZegoLoggerService.logInfo(
        '$jsonString is not a json',
        tag: 'audio-room',
        subTag: 'audience connect protocol',
      );
    }
    return ZegoAudioRoomAudienceRequestConnectProtocol(
      user: ZegoUIKitUser(
        id: jsonMap['user_id'] ?? '',
        name: jsonMap['user_name'] ?? '',
      ),
      targetIndex: jsonMap['index'] ?? -1,
    );
  }
}
