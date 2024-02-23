- [ZegoUIKitPrebuiltLiveAudioRoom](#zegouikitprebuiltliveaudioroom)
- [ZegoUIKitPrebuiltLiveAudioRoomConfig](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/zego_uikit_prebuilt_live_audio_room/ZegoUIKitPrebuiltLiveAudioRoomConfig-class.html)
- [ZegoUIKitPrebuiltLiveAudioRoomController](#zegouikitprebuiltliveaudioroomcontroller)
    - [leave](#leave)
    - [hideInMemberList](#hideinmemberlist)
    - [media](#media)
        - [volume](#volume)
        - [totalDuration](#totalduration)
        - [currentProgress](#currentprogress)
        - [type](#type)
        - [volumeNotifier](#volumenotifier)
        - [currentProgressNotifier](#currentprogressnotifier)
        - [playStateNotifier](#playstatenotifier)
        - [typeNotifier](#typenotifier)
        - [muteNotifier](#mutenotifier)
        - [info](#info)
        - [play](#play)
        - [stop](#stop)
        - [destroy](#destroy)
        - [pause](#pause)
        - [resume](#resume)
        - [seekTo](#seekto)
        - [setVolume](#setvolume)
        - [muteLocal](#mutelocal)
        - [pickPureAudioFile](#pickpureaudiofile)
        - [pickVideoFile](#pickvideofile)
        - [pickFile](#pickfile)
    - [message](#message)
        - [send](#send)
        - [list](#list)
        - [stream](#stream)
    - [minimizing](#minimizing)
        - [state](#state)
        - [isMinimizing](#isminimizing)
        - [restore](#restore)
        - [minimize](#minimize)
        - [hide](#hide)
    - [seat](#seat)
        - [userMapNotifier](#usermapnotifier)
        - [localIsHost](#localishost)
        - [localIsAudience](#localisaudience)
        - [localIsSpeaker](#localisspeaker)
        - [localIsCoHost](#localiscohost)
        - [localHasHostPermissions](#localhashostpermissions)
        - [getUserByIndex](#getuserbyindex)
        - [muteStateNotifier](#mutestatenotifier)
        - [muteLocally](#mutelocally)
        - [muteLocallyByUserID](#mutelocallybyuserid)
        - [host](#host)
            - [open](#open)
            - [close](#close)
            - [removeSpeaker](#removespeaker)
            - [acceptTakingRequest](#accepttakingrequest)
            - [rejectTakingRequest](#rejecttakingrequest)
            - [inviteToTake](#invitetotake)
            - [mute](#mute)
            - [muteByUserID](#mutebyuserid)
        - [audience](#audience)
            - [take](#take)
            - [applyToTake](#applytotake)
            - [cancelTakingRequest](#canceltakingrequest)
            - [acceptTakingInvitation](#accepttakinginvitation)
        - [speaker](#speaker)
            - [leave](#leave-2)
    - [audioVideo](#audiovideo)
        - [seiStream](#seistream)
        - [sendSEI](#sendsei)
        - [microphone](#microphone)
            - [localState](#localstate)
            - [localStateNotifier](#localstatenotifier)
            - [state](#state)
            - [stateNotifier](#statenotifier)
            - [turnOn](#turnon)
            - [switchState](#switchstate)
    - [room](#room)
        - [property](#property)
            - [updateProperty/updateProperties](#updatepropertyupdateproperties)
            - [deleteProperties](#deleteproperties)
            - [queryProperties](#queryproperties)
            - [propertiesStream](#propertiesstream)
        - [command](#command)
            - [sendCommand](#sendcommand)
            - [commandReceivedStream](#commandreceivedstream)

---

# ZegoUIKitPrebuiltLiveAudioRoom

>
>
> Live Audio Room Widget.
> You can embed this widget into any page of your project to integrate the functionality of a audio chat room.
> You can refer to our [documentation](https://docs.zegocloud.com/article/15079),
> or our [sample code](https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_live_audio_room_example_flutter/tree/master/live_audio_room).
>
> - function prototype:
>
> ```dart
>class ZegoUIKitPrebuiltLiveAudioRoom extends StatefulWidget {
>  const ZegoUIKitPrebuiltLiveAudioRoom({
>    Key? key,
>    required this.appID,
>    required this.appSign,
>    required this.userID,
>    required this.userName,
>    required this.roomID,
>    required this.config,
>    required this.events,
>  }) : super(key: key);
>
>  /// You can create a project and obtain an appID from the [ZEGOCLOUD Admin >Console](https://console.zegocloud.com).
>  final int appID;
>
>  /// You can create a project and obtain an appSign from the [ZEGOCLOUD Admin >Console](https://console.zegocloud.com).
>  final String appSign;
>
>  /// The ID of the currently logged-in user.
>  /// It can be any valid string.
>  /// Typically, you would use the ID from your own user system, such as Firebase.
>  final String userID;
>
>  /// The name of the currently logged-in user.
>  /// It can be any valid string.
>  /// Typically, you would use the name from your own user system, such as Firebase.
>  final String userName;
>
>  /// The ID of the audio chat room.
>  /// This ID serves as a unique identifier for the room, so you need to ensure its uniqueness.
>  /// It can be any valid string.
>  /// Users who enter the same [roomID] will be logged into the same room to chat or listen to others.
>  final String roomID;
>
>  /// Initialize the configuration for the voice chat room.
>  final ZegoUIKitPrebuiltLiveAudioRoomConfig config;
>
>  /// Initialize the event for the voice chat room.
>  final ZegoUIKitPrebuiltLiveAudioRoomEvents events;q
>}
> ```

# ZegoUIKitPrebuiltLiveAudioRoomController

## leave

>
>

> This function is used to end the Live Audio Room.
>
> You can pass the context [context] for any necessary pop-ups or page transitions.
> By using the [showConfirmation] parameter, you can control whether to display a confirmation dialog to confirm ending the Live Audio Room.
>
> This function behaves the same as the close button in the calling interface's top right corner, and it is also affected by the [ZegoUIKitPrebuiltLiveAudioRoomEvents.onLeaveConfirmation]
> and [ZegoUIKitPrebuiltLiveAudioRoomEvents.onEnded] settings in the config.
>
> - function prototype:
>
> ```dart
> Future<bool> leave(
>   BuildContext context, {
>   bool showConfirmation = true,
> }) async
> ```

## hideInMemberList

>
> hide some user in member list
>
> - function prototype:
>
> ```dart
> void hideInMemberList(List<String> userIDs)
> ```

## media

media series API

### volume

>
> volume of current media
>
> - function prototype:
>
> ```dart
> int get volume
> ```

### totalDuration

>
> the total progress(millisecond) of current media resources
>
> - function prototype:
>
> ```dart
> int get totalDuration
> ```

### currentProgress

>
> current playing progress of current media
>
> - function prototype:
>
> ```dart
> int get currentProgress
> ```

### type

>
> type of current media
>
> - function prototype:
>
> ```dart
> ZegoUIKitMediaType get type
>
> enum ZegoUIKitMediaType {
>   pureAudio,
>   video,
>   unknown,
> }
> ```

### volumeNotifier

>
> volume notifier of current media
>
> - function prototype:
>
> ```dart
> ValueNotifier<int> get volumeNotifier
> ```

### currentProgressNotifier

>
> current progress notifier of current media
>
> - function prototype:
>
> ```dart
> ValueNotifier<int> get currentProgressNotifier
> ```

### playStateNotifier

>
> play state notifier of current media
>
> - function prototype:
>
> ```dart
> ValueNotifier<ZegoUIKitMediaPlayState> get playStateNotifier
> 
> /// media play state
> enum ZegoUIKitMediaPlayState {
>   /// Not playing
>   noPlay,
> 
>   /// not start yet
>   loadReady,
> 
>   /// Playing
>   playing,
> 
>   /// Pausing 
>   pausing,
> 
>   /// End of play
>   playEnded
> }
> ```

### typeNotifier

>
> type notifier of current media
>
> - function prototype:
>
> ```dart
> ValueNotifier<ZegoUIKitMediaType> get typeNotifier
> 
> /// media type
> enum ZegoUIKitMediaType {
>   pureAudio,
>   video,
>   unknown,
> }
> ```

### muteNotifier

>
> mute state notifier of current media
>
> - function prototype:
>
> ```dart
> ValueNotifier<bool> get muteNotifier
> ```

### info

>
> info of current media
>
> - function prototype:
>
> ```dart
> ZegoUIKitMediaInfo get info
> 
> /// Media Infomration of media file.
> ///
> /// Meida information such as video resolution of media file.
> class ZegoUIKitMediaInfo {
>   /// Video resolution width.
>   int width;
> 
>   /// Video resolution height.
>   int height;
> 
>   /// Video frame rate.
>   int frameRate;
> }
> ```

### play

>
> start play current media
>
> - function prototype:
>
> ```dart
> Future<ZegoUIKitMediaPlayResult> play({
>   required String filePathOrURL,
>   bool enableRepeat = false,
> }) async
>
> /// media play result
> class ZegoUIKitMediaPlayResult {
>   int errorCode;
>   String message;
> }
> ```

### stop

>
> stop play current media
>
> - function prototype:
>
> ```dart
> Future<void> stop() async
> ```

### destroy

>
> destroy current media
>
> - function prototype:
>
> ```dart
> Future<void> destroy() async
> ```

### pause

>
> pause current media
>
> - function prototype:
>
> ```dart
> Future<void> pause() async
> ```

### resume

>
> resume current media
>
> - function prototype:
>
> ```dart
> Future<void> resume() async
> ```

### seekTo

>
> set the current media playback progress
>
> - function prototype:
>
> ```dart
> Future<ZegoUIKitMediaSeekToResult> seekTo(int millisecond)
> 
> class ZegoUIKitMediaSeekToResult {
>   int errorCode;
>   String message;
> }
> ```

### setVolume

>
> set media player volume. Both the local play volume and the publish volume are set.
> the range is 0 ~ 100. The default is 30.
>
> - function prototype:
>
> ```dart
> Future<void> setVolume(int volume) async
> ```

### muteLocal

>
> mute current media
>
> - function prototype:
>
> ```dart
> Future<void> muteLocal(bool mute) async
> ```

### pickPureAudioFile

>
> pick pure audio media file
>
> - function prototype:
>
> ```dart
> Future<List<PlatformFile>> pickPureAudioFile() async
> ```

### pickVideoFile

>
> pick video media file
>
> - function prototype:
>
> ```dart
> Future<List<PlatformFile>> pickVideoFile() async
> ```

### pickFile

>
> If you want to specify the allowed formats, you can set them using [allowedExtensions].
> Currently, for video, we support "avi", "flv", "mkv", "mov", "mp4", "mpeg", "webm", "wmv".
> For audio, we support "aac", "midi", "mp3", "ogg", "wav".
>
> - function prototype:
>
> ```dart
> Future<List<PlatformFile>> pickFile({
>   List<String>? allowedExtensions = const [
>     /// video
>     "avi",
>     "flv",
>     "mkv",
>     "mov",
>     "mp4",
>     "mpeg",
>     "webm",
>     "wmv",
>
>     /// audio
>     "aac",
>     "midi",
>     "mp3",
>     "ogg",
>     "wav",
>   ],
> }) async
> ```

## message

> media series API
>
>
> - function prototype:
>
> ```dart
>/// in-room message
>class ZegoInRoomMessage {
>  /// If the local message sending fails, then the message ID at this time is unreliable, and is a negative sequential value.
>  int messageID;
>
>  /// message sender.
>  ZegoUIKitUser user;
>
>  /// message content.
>  String message;
>
>  /// message attributes
>  Map<String, String> attributes;
>
>  /// The timestamp at which the message was sent.
>  /// You can format the timestamp, which is in milliseconds since epoch, using DateTime.fromMillisecondsSinceEpoch(timestamp).
>  int timestamp;
>
>  ///
>  var state = ValueNotifier<ZegoInRoomMessageState>(ZegoInRoomMessageState.success);
>}
>
> 
> /// in-room message send state
> enum ZegoInRoomMessageState {
>   idle,
>   sending,
>   success,
>   failed,
> }
> ```

### send

>
> sends the chat message, @return Error code, please refer to the error codes document https://docs.zegocloud.com/en/5548.html for details.
>
> - function prototype:
>
> ```dart
> Future<bool> send(String message) async
> ```

### list

> retrieves a list of chat messages that already exist in the room
>
> return a `List` of `ZegoInRoomMessage` objects representing the chat messages that already exist in the room.
>
>
> - function prototype:
>
> ```dart
> List<ZegoInRoomMessage> list()
> ```

### stream

>
>
> retrieves a list stream of chat messages that already exist in the room.
>
> the stream will dynamically update when new chat messages are received, and you can use a `StreamBuilder` to listen to it and update the UI in real time.
>
> return a `List` of `ZegoInRoomMessage` objects representing the chat messages that already exist in the room.
>
> Example:
>
> ```dart
> ..foreground = Positioned(
>     left: 10,
>     bottom: 50,
>     child: StreamBuilder<List<ZegoInRoomMessage>>(
>       stream: liveController.message.stream(),
>       builder: (context, snapshot) {
>         final messages = snapshot.data ?? <ZegoInRoomMessage>[];
>
>         return Container(
>           width: 200,
>           height: 200,
>           decoration: BoxDecoration(
>             color: Colors.white.withOpacity(0.2),
>           ),
>           child: ListView.builder(
>             itemCount: messages.length,
>             itemBuilder: (context, index) {
>               final message = messages[index];
>               return Text('${message.user.name}: ${message.message}');
>             },
>           ),
>         );
>       },
>     ),
>   )
> ```
>
> - function prototype:
>
> ```dart
> Stream<List<ZegoInRoomMessage>> stream()
> ```

## minimizing

the APIs related to minimizing.

### state

>
> current minimize state
>
> - function prototype:
>
> ```dart
> ZegoLiveAudioRoomMiniOverlayPageState get state
> 
> /// page state of current minimize page
> enum ZegoLiveAudioRoomMiniOverlayPageState {
>   idle,
>   inAudioRoom,
>   minimizing,
> }
> 
> ```

### isMinimizing

>
> is it currently in the minimized state or not
>
> - function prototype:
>
> ```dart
> bool get isMinimizing
> ```

### restore

>
> restore the `ZegoUIKitPrebuiltLiveAudioRoom` from minimize
>
> - function prototype:
>
> ```dart
> bool restore(
>   BuildContext context, {
>   bool rootNavigator = true,
>   bool withSafeArea = false,
> })
> ```

### minimize

>
> minimize the `ZegoUIKitPrebuiltLiveAudioRoom`
>
> - function prototype:
>
> ```dart
> bool minimize(
>   BuildContext context, {
>   bool rootNavigator = true,
> })
> ```

### hide

>
> if audio room ended in minimizing state, not need to navigate, just hide the minimize widget.
>
> - function prototype:
>
> ```dart
> void hide()
> ```

## seat

### userMapNotifier

>
> the seat user map of the current live audio room.
>
> - function prototype:
>
> ```dart
> ValueNotifier<Map<String, String>>? get userMapNotifier
> ```

### localIsHost

>
> local user is host or not
>
> - function prototype:
>
> ```dart
> bool get localIsHost
> ```

### localIsAudience

>
> local user is audience or not
>
> - function prototype:
>
> ```dart
> bool get localIsAudience
> ```

### localIsSpeaker

>
> local user is speaker or not
>
> - function prototype:
>
> ```dart
> bool get localIsSpeaker
> ```

### localIsCoHost

>
> local user is co-host or not
>
> co-host have the same permissions as hosts if host is not exist
>
> - function prototype:
>
> ```dart
> bool get localIsCoHost
> ```

### localHasHostPermissions

>
> local user has host permission or not
>
> co-host have the same permissions as hosts if host is not exist
>
> - function prototype:
>
> ```dart
> bool get localHasHostPermissions
> ```

### getUserByIndex

>
> get user who on the target seat index
>
> - function prototype:
>
> ```dart
> ZegoUIKitUser? getUserByIndex(int targetIndex)
> ```

### muteStateNotifier

>
> Is the current seat muted or not.
> Set `isLocally` to true to find out if it is muted locally.
>
> - function prototype:
>
> ```dart
> ValueNotifier<bool> muteStateNotifier(
>   int targetIndex, {
>   bool isLocally = false,
> })
> ```

### muteLocally

>
>
> Mute the user at the `targetIndex` seat **locally**.
> After mute, if you want to un-mute, you can set `muted` to false.
>
> And on side of the user at the `targetIndex` seat, return true/false in
> the callback
> of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Events-topic.html#onmicrophoneturnonbyothersconfirmation)
> to open microphone or not.
>
> - function prototype:
>
> ```dart
> Future<bool> muteLocally({
>   int targetIndex = -1,
>   bool muted = true,
> }) async
> ```

### muteLocallyByUserID

>
> Mute the seat by `targetUserID` **locally**.
> After mute, if you want to un-mute, you can set `muted` to false.
>
> And on side of the user at the `targetIndex` seat, return true/false in
> the callback
> of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Events-topic.html#onmicrophoneturnonbyothersconfirmation)
> to open microphone or not.
>
> - function prototype:
>
> ```dart
> Future<bool> muteLocallyByUserID(
>   String targetUserID, {
>   bool muted = true,
> }) async
> ```

### host

> APIs of host

#### open

>
> Opens (unlocks) the seat.
> allows you to unlock all seats in the room at once, or only unlock specific seat by [targetIndex].
>
> After opening(locks) the seat, all audience members can freely choose an empty seat to join and start chatting with others.
>
> - function prototype:
>
> ```dart
> Future<bool> open({
>   int targetIndex = -1,
> }) async
> ```

#### close

>
> Closes (locks) the seat.
> allows you to lock all seats in the room at once, or only lock specific seat by [targetIndex].
>
> After closing(locks) the seat, audience members need to request permission from the host or be invited by the host to occupy the seat.
>
> - function prototype:
>
> ```dart
> Future<bool> close({
>   int targetIndex = -1,
> }) async 
> ```

#### removeSpeaker

>
> Removes the speaker with the user ID `userID` from the seat.
>
> - function prototype:
>
> ```dart
> Future<void> removeSpeaker(String userID) async
> ```

#### acceptTakingRequest

>
> The host accepts the seat request from the audience with the ID [audienceUserID].
>
> - function prototype:
>
> ```dart
> Future<bool> acceptTakingRequest(String audienceUserID) async
> ```

#### rejectTakingRequest

>
> The host rejects the seat request from the audience with the ID [audienceUserID].
>
> - function prototype:
>
> ```dart
> Future<bool> rejectTakingRequest(String audienceUserID) async
> ```

#### inviteToTake

>
> Host invite the audience with id [userID] to take seat
>
> - function prototype:
>
> ```dart
> Future<bool> inviteToTake(String userID) async
> ```

#### mute

>
> Mute the user at the `targetIndex` seat
>
> After mute, if you want to un-mute, you can set `muted` to true.
>
> And on side of the user at the `targetIndex` seat, return true/false in
> the callback
> of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Events-topic.html#onmicrophoneturnonbyothersconfirmation)
> to open microphone or not.
>
> - function prototype:
>
> ```dart
> Future<bool> mute({
>   int targetIndex = -1,
>   bool muted = true,
> }) async
> ```

#### muteByUserID

>
>  Mute the user on seat by `userID`
>
> After mute, if you want to un-mute, you can set `muted` to true.
>
> And on side of the user at the `targetIndex` seat, return true/false in
> the callback
> of [ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation](https://pub.dev/documentation/zego_uikit_prebuilt_live_audio_room/latest/topics/Events-topic.html#onmicrophoneturnonbyothersconfirmation)
> to open microphone or not.
>
> - function prototype:
>
> ```dart
> Future<bool> muteByUserID(
>   String userID, {
>   bool muted = true,
> }) async
> ```

### audience

> APIs of audience

#### take

>
> Assigns the audience to the seat with the specified `index`, where the index represents the seat number starting from 0.
>
> - function prototype:
>
> ```dart
> Future<bool> take(int index) async
> ```

#### applyToTake

>
> The audience actively requests to occupy a seat.
>
> - function prototype:
>
> ```dart
> Future<bool> applyToTake() async
> ```

#### cancelTakingRequest

>
> The audience cancels the request to occupy a seat.
>
> - function prototype:
>
> ```dart
> Future<bool> cancelTakingRequest() async
> ```

#### acceptTakingInvitation

>
> Accept the seat invitation from the host. The [context] parameter represents the Flutter context object.
>
> - function prototype:
>
> ```dart
>  Future<bool> acceptTakingInvitation({
>    required BuildContext context,
>    bool rootNavigator = false,
>  }) async
> ```

### speaker

> APIs of speaker

#### leave

>
> The speaker can use this method to leave the seat. If the showDialog parameter is set to true, a confirmation dialog will be displayed before leaving the seat.
>
> - function prototype:
>
> ```dart
> Future<bool> leave({bool showDialog = true}) async
> ```

## audio video

> APIs related to audio video

### microphone

> microphone series APIs

#### localState

>
> microphone state of local user
>
> - function prototype:
>
> ```dart
> bool get localState
> ```

#### localStateNotifier

>
> microphone state notifier of local user
>
> - function prototype:
>
> ```dart
> ValueNotifier<bool> get localStateNotifier
> ```

#### state

>
> microphone state of `userID`
>
> - function prototype:
>
> ```dart
> bool state(String userID)
> ```

#### stateNotifier

>
> microphone state notifier of `userID`
>
> - function prototype:
>
> ```dart
> ValueNotifier<bool> stateNotifier(String userID)
> ```

#### turnOn

>
> turn on/off `userID` microphone, if `userID` is empty, then it refers to local user
>
> - function prototype:
>
> ```dart
> void turnOn(bool isOn, {String? userID})
> ```

#### switchState

>
> switch `userID` microphone state, if `userID` is empty, then it refers to local user
>
> - function prototype:
>
> ```dart
> void switchState({String? userID})
> ```

### seiStream

>
> stream of SEI(Supplemental Enhancement Information)
>
> - function prototype:
>
> ```dart
> Stream<ZegoUIKitReceiveSEIEvent> seiStream()
>
>class ZegoUIKitReceiveSEIEvent {
>  final String typeIdentifier;
>
>  final String senderID;
>  final Map<String, dynamic> sei;
>
>  final String streamID;
>  final ZegoStreamType streamType;
>}
> ```

### sendSEI

>
> if you want synchronize some other additional information by audio-video,
> send SEI(Supplemental Enhancement Information) with it.
>
> - function prototype:
>
> ```dart
> Future<bool> sendSEI(
>   Map<String, dynamic> seiData, {
>   ZegoStreamType streamType = ZegoStreamType.main,
> })
> ```

## room

### property

#### updateProperty/updateProperties

>
> add/update room properties
>
> - function prototype:
>
> ```dart
> Future<bool> updateProperty({
>   required String roomID,
>   required String key,
>   required String value,
>   bool isForce = false,
>   bool isDeleteAfterOwnerLeft = false,
>   bool isUpdateOwner = false,
> }) async
>
> Future<bool> updateProperties({
>  required String roomID,
>  required Map<String, String> roomProperties,
>  bool isForce = false,
>  bool isDeleteAfterOwnerLeft = false,
>  bool isUpdateOwner = false,
>}) async
> ```

#### deleteProperties

>
> delete room properties
>
> - function prototype:
>
> ```dart
> Future<bool> deleteProperties({
>   required String roomID,
>   required List<String> keys,
>   bool isForce = false,
> }) async
> ```

#### queryProperties

>
> query room properties
>
> - function prototype:
>
> ```dart
> Future<Map<String, String>> queryProperties({
>   required String roomID,
> }) async
> ```

#### propertiesStream

>
> room properties stream notify
>
> - function prototype:
>
> ```dart
> Stream<ZegoSignalingPluginRoomPropertiesUpdatedEvent> propertiesStream()
> 
> class ZegoSignalingPluginRoomPropertiesUpdatedEvent {
>   final String roomID;
>   final Map<String, String> setProperties;
>   final Map<String, String> deleteProperties;
> }
> ```

### command

#### sendCommand

>
> send room command

>
>
>
> - function prototype:
>
> ```dart
>  Future<bool> sendCommand({
>    required String roomID,
>    required Uint8List command,
>  }) async
> ```

#### commandReceivedStream

>
> room command stream notify
>
> - function prototype:
>
> ```dart
> Stream<ZegoSignalingPluginInRoomCommandMessageReceivedEvent> commandReceivedStream()
>
>
> class ZegoSignalingPluginInRoomCommandMessageReceivedEvent {
>   final List<ZegoSignalingPluginInRoomCommandMessage> messages;
>   final String roomID;
> }
> 
> class ZegoSignalingPluginInRoomCommandMessage {
>   /// If you have a string encoded in UTF-8 and want to convert a Uint8List
>   /// to that string, you can use the following method:
>   ///
>   /// import 'dart:convert';
>   /// import 'dart:typed_data';
>   ///
>   /// String result = utf8.decode(commandMessage.message); // Convert the Uint8List to a string
>   ///
>   final Uint8List message;
> 
>   final String senderUserID;
>   final int timestamp;
>   final int orderKey;
> }
> ```
