part of 'package:zego_uikit_prebuilt_live_audio_room/src/controller.dart';

/// @nodoc
mixin ZegoLiveAudioRoomControllerMessage {
  final _messageImpl = AudioRoomMessageControllerImpl();

  AudioRoomMessageControllerImpl get message => _messageImpl;
}

/// Here are the APIs related to message.
class AudioRoomMessageControllerImpl {
  /// sends the chat message
  ///
  /// @return Error code, please refer to the error codes document https://docs.zegocloud.com/en/5548.html for details.
  ///
  /// @return A `Future` that representing whether the request was successful.
  Future<bool> send(
    String message, {
    ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage,
  }) async {
    ZegoLoggerService.logInfo(
      'send',
      tag: 'audio-room',
      subTag: 'controller.message',
    );

    return ZegoUIKit().sendInRoomMessage(message, type: type);
  }

  /// Retrieves a list of chat messages that already exist in the room.
  ///
  /// @return A `List` of [ZegoInRoomMessage] objects representing the chat messages that
  /// already exist in the room.
  List<ZegoInRoomMessage> list({
    ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage,
  }) {
    return ZegoUIKit().getInRoomMessages(type: type);
  }

  /// Retrieves a list stream of chat messages that already exist in the room.
  /// the stream will dynamically update when new chat messages are received,
  /// and you can use a `StreamBuilder` to listen to it and update the UI in real time.
  ///
  /// @return A `List` of [ZegoInRoomMessage] objects representing the chat messages that
  /// already exist in the room.
  ///
  /// Example:
  ///
  /// ```dart
  /// ..foreground = Positioned(
  ///     left: 10,
  ///     bottom: 50,
  ///     child: StreamBuilder<List<ZegoInRoomMessage>>(
  ///       stream: liveController.message.stream(),
  ///       builder: (context, snapshot) {
  ///         final messages = snapshot.data ?? <ZegoInRoomMessage>[];
  ///
  ///         return Container(
  ///           width: 200,
  ///           height: 200,
  ///           decoration: BoxDecoration(
  ///             color: Colors.white.withOpacity(0.2),
  ///           ),
  ///           child: ListView.builder(
  ///             itemCount: messages.length,
  ///             itemBuilder: (context, index) {
  ///               final message = messages[index];
  ///               return Text('${message.user.name}: ${message.message}');
  ///             },
  ///           ),
  ///         );
  ///       },
  ///     ),
  ///   )
  /// ```
  Stream<List<ZegoInRoomMessage>> stream({
    ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage,
  }) {
    return ZegoUIKit().getInRoomMessageListStream(type: type);
  }

  /// clear local message and remote message
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
      type: type,
      clearRemote: clearRemote,
    );
  }
}
