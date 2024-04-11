part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerRoom {
  final _roomImpl = ZegoLiveAudioRoomControllerRoomImpl();

  ZegoLiveAudioRoomControllerRoomImpl get room => _roomImpl;
}

/// Here are the APIs related to screen sharing.
class ZegoLiveAudioRoomControllerRoomImpl
    with ZegoLiveAudioRoomControllerRoomPrivate {
  /// set/update room property
  ///
  /// @param isForce: Whether the operation is mandatory, that is, the property of the room whose owner is another user can be modified.
  /// @param isDeleteAfterOwnerLeft: Room attributes are automatically deleted after the owner leaves the room.
  /// @param isUpdateOwner: Whether to update the owner of the room attribute involved.
  Future<bool> updateProperty({
    required String roomID,
    required String key,
    required String value,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) async {
    return updateProperties(
      roomID: roomID,
      roomProperties: {key: value},
      isForce: isForce,
      isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
      isUpdateOwner: isUpdateOwner,
    );
  }

  /// set/update room properties
  ///
  /// @param isForce: Whether the operation is mandatory, that is, the property of the room whose owner is another user can be modified.
  /// @param isDeleteAfterOwnerLeft: Room attributes are automatically deleted after the owner leaves the room.
  /// @param isUpdateOwner: Whether to update the owner of the room attribute involved.
  Future<bool> updateProperties({
    required String roomID,
    required Map<String, String> roomProperties,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'updateProperties, signaling is null',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'updateProperties, '
      'roomID:$roomID, '
      'roomProperties:$roomProperties, '
      'isForce:$isForce, '
      'isDeleteAfterOwnerLeft:$isDeleteAfterOwnerLeft, '
      'isUpdateOwner:$isUpdateOwner, ',
      tag: 'audio room',
      subTag: 'controller.room',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .updateRoomProperties(
          roomID: roomID,
          roomProperties: roomProperties,
          isForce: isForce,
          isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
          isUpdateOwner: isUpdateOwner,
        )
        .then((result) {
      if (null != result.error) {
        ZegoLoggerService.logInfo(
          'updateProperties, error:$result',
          tag: 'audio room',
          subTag: 'controller.room',
        );

        return false;
      }

      return true;
    });
  }

  /// delete room properties
  Future<bool> deleteProperties({
    required String roomID,
    required List<String> keys,
    bool isForce = false,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'deleteRoomProperties, signaling is null',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'deleteRoomProperties, '
      'roomID:$roomID, '
      'keys:$keys, '
      'isForce:$isForce, ',
      tag: 'audio room',
      subTag: 'controller.room',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .deleteRoomProperties(
          roomID: roomID,
          keys: keys,
          isForce: isForce,
        )
        .then((result) {
      if (null != result.error) {
        ZegoLoggerService.logInfo(
          'deleteRoomProperties, error:$result',
          tag: 'audio room',
          subTag: 'controller.room',
        );

        return false;
      }

      return true;
    });
  }

  /// query room properties
  Future<Map<String, String>> queryProperties({
    required String roomID,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'queryRoomProperties, signaling is null',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return <String, String>{};
    }

    ZegoLoggerService.logInfo(
      'queryProperties, '
      'roomID:$roomID, ',
      tag: 'audio room',
      subTag: 'controller.room',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .queryRoomProperties(
          roomID: roomID,
        )
        .then((result) {
      if (null != result.error) {
        ZegoLoggerService.logInfo(
          'queryRoomProperties, error:${result.error}',
          tag: 'audio room',
          subTag: 'controller.room',
        );

        return <String, String>{};
      }

      return result.properties;
    });
  }

  /// room properties stream notify
  Stream<ZegoSignalingPluginRoomPropertiesUpdatedEvent> propertiesStream() {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'getRoomPropertiesStream, signaling is null',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return const Stream.empty();
    }

    return ZegoUIKit().getSignalingPlugin().getRoomPropertiesStream();
  }

  /// send room command
  ///
  /// string encoded in UTF-8 and convert to Uint8List
  ///
  /// import 'dart:convert';
  /// import 'dart:typed_data';
  ///
  /// Uint8List dataBytes = Uint8List.fromList(utf8.encode(commandString));
  Future<bool> sendCommand({
    required String roomID,
    required Uint8List command,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'sendCommand, signaling is null',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'sendCommand, '
      'roomID:$roomID, ',
      tag: 'audio room',
      subTag: 'controller.room',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .sendInRoomCommandMessage(
          roomID: roomID,
          message: command,
        )
        .then((result) {
      if (null != result.error) {
        ZegoLoggerService.logInfo(
          'sendCommand, error:${result.error}',
          tag: 'audio room',
          subTag: 'controller.room',
        );

        return false;
      }
      return true;
    });
  }

  /// room command stream notify
  ///
  /// If you have a string encoded in UTF-8 and want to convert a Uint8List
  /// to that string, you can use the following method:
  ///
  /// import 'dart:convert';
  /// import 'dart:typed_data';
  ///
  /// Uint8List dataBytes = Uint8List.fromList(utf8.encode(commandString));
  Stream<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      commandReceivedStream() {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'commandReceivedStream, signaling is null',
        tag: 'audio room',
        subTag: 'controller.room',
      );

      return const Stream.empty();
    }

    return ZegoUIKit()
        .getSignalingPlugin()
        .getInRoomCommandMessageReceivedEventStream();
  }
}
