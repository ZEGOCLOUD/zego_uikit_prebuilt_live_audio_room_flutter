part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// Mixin for in-room message functionality.
///
/// This mixin provides access to the message controller.
mixin ZegoLiveAudioRoomControllerMessage {
  final _messageImpl = AudioRoomMessageControllerImpl();

  /// Gets the message controller instance.
  AudioRoomMessageControllerImpl get message => _messageImpl;
}

/// Controller for in-room messaging operations.
///
/// This class provides APIs for sending and receiving chat messages in the audio room.
class AudioRoomMessageControllerImpl {
  /// Sends a chat message to the room.
  ///
  /// [message] - The message content to send.
  /// [type] - The type of message. Default is broadcast message.
  ///
  /// Returns `true` if the message was sent successfully, `false` otherwise.
  /// Error codes can be found at: https://docs.zegocloud.com/en/5548.html
  Future<bool> send(
    String message, {
    ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage,
  }) async {
    ZegoLoggerService.logInfo(
      'send',
      tag: 'audio-room',
      subTag: 'controller.message',
    );

    return ZegoUIKit().sendInRoomMessage(
        targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
        message,
        type: type);
  }

  /// Retrieves a list of chat messages that already exist in the room.
  ///
  /// [type] - The type of messages to retrieve. Default is broadcast message.
  ///
  /// Returns a list of [ZegoInRoomMessage] objects.
  List<ZegoInRoomMessage> list({
    ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage,
  }) {
    return ZegoUIKit().getInRoomMessages(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      type: type,
    );
  }

  /// Gets a stream of chat messages that dynamically updates when new messages are received.
  ///
  /// [type] - The type of messages to listen for. Default is broadcast message.
  ///
  /// You can use a `StreamBuilder` to listen to this stream and update the UI in real time.
  ///
  /// Example:
  ///
  /// ```dart
  /// StreamBuilder<List<ZegoInRoomMessage>>(
  ///   stream: liveController.message.stream(),
  ///   builder: (context, snapshot) {
  ///     final messages = snapshot.data ?? <ZegoInRoomMessage>[];
  ///     return ListView.builder(
  ///       itemCount: messages.length,
  ///       itemBuilder: (context, index) {
  ///         final message = messages[index];
  ///         return Text('${message.user.name}: ${message.message}');
  ///       },
  ///     );
  ///   },
  /// )
  /// ```
  Stream<List<ZegoInRoomMessage>> stream({
    ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage,
  }) {
    return ZegoUIKit().getInRoomMessageListStream(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      type: type,
    );
  }

  /// Clears chat messages.
  ///
  /// [type] - The type of messages to clear. Default is broadcast message.
  /// [clearRemote] - Whether to clear messages from remote users as well. Default is true.
  ///
  /// Returns `true` if the messages were cleared successfully.
  Future<bool> clear({
    ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage,
    bool clearRemote = true,
  }) {
    ZegoLoggerService.logInfo(
      'clear',
      tag: 'audio-room',
      subTag: 'controller.message',
    );

    return ZegoUIKit().clearMessage(
      targetRoomID: ZegoUIKitPrebuiltLiveAudioRoomController().private.liveID,
      type: type,
      clearRemote: clearRemote,
    );
  }
}
