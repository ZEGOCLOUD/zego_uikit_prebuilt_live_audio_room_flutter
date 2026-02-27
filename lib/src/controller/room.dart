part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// Mixin for room-related functionality.
///
/// This mixin provides access to the room controller.
mixin ZegoLiveAudioRoomControllerRoom {
  final _roomImpl = ZegoLiveAudioRoomControllerRoomImpl();

  /// Gets the room controller instance.
  ZegoLiveAudioRoomControllerRoomImpl get room => _roomImpl;
}

/// Controller for room operations.
///
/// This class provides APIs for managing room properties, commands, and user management.
class ZegoLiveAudioRoomControllerRoomImpl
    with ZegoLiveAudioRoomControllerRoomPrivate {
  /// Updates a single room property.
  ///
  /// [key] - The property key to update.
  /// [value] - The property value to set.
  /// [isForce] - Whether to force update even if the room is owned by another user. Default is false.
  /// [isDeleteAfterOwnerLeft] - Whether to delete the property when the owner leaves. Default is false.
  /// [isUpdateOwner] - Whether to update the owner of the property. Default is false.
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> updateProperty({
    required String key,
    required String value,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) async {
    return updateProperties(
      roomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      roomProperties: {key: value},
      isForce: isForce,
      isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
      isUpdateOwner: isUpdateOwner,
    );
  }

  /// Updates multiple room properties at once.
  ///
  /// [roomID] - The room ID to update properties for.
  /// [roomProperties] - A map of property keys and values to update.
  /// [isForce] - Whether to force update even if the room is owned by another user. Default is false.
  /// [isDeleteAfterOwnerLeft] - Whether to delete the property when the owner leaves. Default is false.
  /// [isUpdateOwner] - Whether to update the owner of the property. Default is false.
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> updateProperties({
    required String roomID,
    required Map<String, String> roomProperties,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'signaling is null',
        tag: 'audio-room',
        subTag: 'controller.room, updateProperties',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'roomID:$roomID, '
      'roomProperties:$roomProperties, '
      'isForce:$isForce, '
      'isDeleteAfterOwnerLeft:$isDeleteAfterOwnerLeft, '
      'isUpdateOwner:$isUpdateOwner, ',
      tag: 'audio-room',
      subTag: 'controller.room, updateProperties',
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
          'error:$result',
          tag: 'audio-room',
          subTag: 'controller.room, updateProperties',
        );

        return false;
      }

      return true;
    });
  }

  /// Deletes room properties.
  ///
  /// [roomID] - The room ID to delete properties from.
  /// [keys] - The list of property keys to delete.
  /// [isForce] - Whether to force delete even if the room is owned by another user. Default is false.
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> deleteProperties({
    required String roomID,
    required List<String> keys,
    bool isForce = false,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'signaling is null',
        tag: 'audio-room',
        subTag: 'controller.room, deleteRoomProperties',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'roomID:$roomID, '
      'keys:$keys, '
      'isForce:$isForce, ',
      tag: 'audio-room',
      subTag: 'controller.room, deleteRoomProperties',
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
          'error:$result',
          tag: 'audio-room',
          subTag: 'controller.room, deleteRoomProperties',
        );

        return false;
      }

      return true;
    });
  }

  /// Queries room properties.
  ///
  /// [roomID] - The room ID to query properties from.
  ///
  /// Returns a map of property keys and values.
  Future<Map<String, String>> queryProperties({
    required String roomID,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'signaling is null',
        tag: 'audio-room',
        subTag: 'controller.room， queryProperties',
      );

      return <String, String>{};
    }

    ZegoLoggerService.logInfo(
      'roomID:$roomID, ',
      tag: 'audio-room',
      subTag: 'controller.room， queryProperties',
    );

    return ZegoUIKit()
        .getSignalingPlugin()
        .queryRoomProperties(
          roomID: roomID,
        )
        .then((result) {
      if (null != result.error) {
        ZegoLoggerService.logInfo(
          'error:${result.error}',
          tag: 'audio-room',
          subTag: 'controller.room， queryProperties',
        );

        return <String, String>{};
      }

      return result.properties;
    });
  }

  /// Gets a stream of room property updates.
  ///
  /// Listen to this stream to be notified when room properties are updated.
  Stream<ZegoSignalingPluginRoomPropertiesUpdatedEvent> propertiesStream() {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'propertiesStream, signaling is null',
        tag: 'audio-room',
        subTag: 'controller.room',
      );

      return const Stream.empty();
    }

    return ZegoUIKit().getSignalingPlugin().getRoomPropertiesStream();
  }

  /// Sends a command message to the room.
  ///
  /// Command messages are sent to all users in the room and are useful for custom signaling.
  ///
  /// [roomID] - The room ID to send the command to.
  /// [command] - The command data as UTF-8 encoded bytes.
  ///
  /// Example:
  /// ```dart
  /// import 'dart:convert';
  /// import 'dart:typed_data';
  ///
  /// Uint8List dataBytes = Uint8List.fromList(utf8.encode('your command'));
  /// ```
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> sendCommand({
    required String roomID,
    required Uint8List command,
  }) async {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'signaling is null',
        tag: 'audio-room',
        subTag: 'controller.room，sendCommand',
      );

      return false;
    }

    ZegoLoggerService.logInfo(
      'roomID:$roomID, ',
      tag: 'audio-room',
      subTag: 'controller.room，sendCommand',
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
          'error:${result.error}',
          tag: 'audio-room',
          subTag: 'controller.room，sendCommand',
        );

        return false;
      }
      return true;
    });
  }

  /// Gets a stream of command messages received in the room.
  ///
  /// Listen to this stream to receive command messages sent by other users.
  ///
  /// To decode a received Uint8List back to a string:
  /// ```dart
  /// import 'dart:convert';
  /// String commandString = utf8.decode(event.message);
  /// ```
  Stream<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      commandReceivedStream() {
    if (null == ZegoUIKit().getPlugin(ZegoUIKitPluginType.signaling)) {
      ZegoLoggerService.logInfo(
        'commandReceivedStream, signaling is null',
        tag: 'audio-room',
        subTag: 'controller.room',
      );

      return const Stream.empty();
    }

    return ZegoUIKit()
        .getSignalingPlugin()
        .getInRoomCommandMessageReceivedEventStream();
  }

  /// Removes users from the room (kicks them out).
  ///
  /// [userIDs] - A list of user IDs to remove from the room.
  ///
  /// Returns `true` if successful, `false` otherwise.
  /// Error codes can be found at: https://docs.zegocloud.com/en/5548.html
  Future<bool> removeUser(List<String> userIDs) async {
    ZegoLoggerService.logInfo(
      'remove user:$userIDs',
      tag: 'audio-room',
      subTag: 'controller.room',
    );

    return ZegoUIKit().removeUserFromRoom(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      userIDs,
    );
  }

  /// Renews the room token.
  ///
  /// Call this when you receive the [ZegoLiveAudioRoomRoomEvents.onTokenExpired] callback.
  ///
  /// [token] - The new token to use for authentication.
  Future<void> renewToken(String token) async {
    await ZegoUIKit().renewRoomToken(
      token,
      targetRoomID: ZegoUIKit().getCurrentRoom().id,
    );

    if (ZegoPluginAdapter().getPlugin(ZegoUIKitPluginType.signaling) != null) {
      ZegoUIKit().getSignalingPlugin().renewToken(token);
    }
  }
}
