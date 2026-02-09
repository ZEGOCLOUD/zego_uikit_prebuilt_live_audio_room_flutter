# APIs

- [ZegoUIKitPrebuiltLiveAudioRoomController](#zegouikitprebuiltliveaudioroomcontroller)
  - [seat](#seat)
    - [host](#host)
      - [open](#open)
      - [close](#close)
      - [removeSpeaker](#removespeaker)
      - [acceptTakingRequest](#accepttakingrequest)
      - [rejectTakingRequest](#rejecttakingrequest)
      - [inviteToTake](#invitetotake)
      - [mute](#mute)
      - [muteByUserID](#mutebyuserid)
      - [assignCoHost](#assigncohost)
    - [audience](#audience)
      - [take](#take)
      - [applyToTake](#applytotake)
      - [cancelTakingRequest](#canceltakingrequest)
      - [acceptTakingInvitation](#accepttakinginvitation)
    - [speaker](#speaker)
      - [leave](#leave)
    - [userMapNotifier](#usermapnotifier)
    - [localIsHost](#localishost)
    - [localIsAudience](#localisaudience)
    - [localIsSpeaker](#localisspeaker)
    - [localIsCoHost](#localiscohost)
    - [localHasHostPermissions](#localhashostpermissions)
    - [isRoomSeatLocked](#isroomseatlocked)
    - [getUserByIndex](#getuserbyindex)
    - [getSeatIndexByUserID](#getseatindexbyuserid)
    - [isAHostSeatIndex](#isahostseatindex)
    - [getEmptySeats](#getemptyseats)
    - [muteStateNotifier](#mutestatenotifier)
    - [muteLocally](#mutelocally)
    - [muteLocallyByUserID](#mutelocallybyuserid)
  - [audioVideo](#audiovideo)
    - [microphone](#microphone)
      - [localState](#localstate)
      - [localStateNotifier](#localstatenotifier)
      - [state](#state)
      - [stateNotifier](#statenotifier)
      - [turnOn](#turnon)
      - [switchState](#switchstate)
    - [audioOutput](#audiooutput)
      - [localNotifier](#localnotifier)
      - [notifier](#notifier)
      - [switchToSpeaker](#switchtospeaker)
    - [seiStream](#seistream)
    - [sendSEI](#sendsei)
  - [message](#message)
    - [send](#send)
    - [list](#list)
    - [stream](#stream)
    - [clear](#clear)
  - [user](#user)
    - [remove](#remove)
  - [room](#room)
    - [updateProperty](#updateproperty)
    - [updateProperties](#updateproperties)
    - [deleteProperties](#deleteproperties)
    - [queryProperties](#queryproperties)
    - [propertiesStream](#propertiesstream)
    - [sendCommand](#sendcommand)
    - [commandReceivedStream](#commandreceivedstream)
    - [removeUser](#removeuser)
    - [renewToken](#renewtoken)
  - [minimize](#minimize)
    - [state](#state-1)
    - [isMinimizing](#isminimizing)
    - [isMinimizingNotifier](#isminimizingnotifier)
    - [restore](#restore)
    - [minimize](#minimize-1)
    - [hide](#hide)
  - [pip](#pip)
    - [status](#status)
    - [available](#available)
    - [enable](#enable)
    - [enableWhenBackground](#enablewhenbackground)
    - [cancelBackground](#cancelbackground)
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
    - [pause](#pause)
    - [resume](#resume)
    - [pickFile](#pickfile)
    - [muteLocal](#mutelocal)
    - [clear](#clear)

---

## ZegoUIKitPrebuiltLiveAudioRoomController

### leave

- **Description**
  - Ends the Live Audio Room.
- **Prototype**
  ```dart
  Future<bool> leave(BuildContext context, {bool showConfirmation = true})
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().leave(context);
  ```

### hideInMemberList

- **Description**
  - Hide some user in member list.
- **Prototype**
  ```dart
  void hideInMemberList(List<String> userIDs)
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().hideInMemberList(['userID']);
  ```

### seat

#### host

##### open

- **Description**
  - Opens (unlocks) the seat. Allows you to unlock all seats in the room at once, or only unlock specific seat by `targetIndex`. After opening (unlocks) the seat, all audience members can freely choose an empty seat to join and start chatting with others.

- **Prototype**
  ```dart
  Future<bool> open({int targetIndex = -1})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.open();
  ```

##### close

- **Description**
  - Closes (locks) the seat. Allows you to lock all seats in the room at once, or only lock specific seat by `targetIndex`. After closing (locks) the seat, audience members need to request permission from the host or be invited by the host to occupy the seat.

- **Prototype**
  ```dart
  Future<bool> close({int targetIndex = -1})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.close();
  ```

##### removeSpeaker

- **Description**
  - Removes the speaker with the user ID `userID` from the seat.

- **Prototype**
  ```dart
  Future<void> removeSpeaker(String userID, {bool showDialogConfirm = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.removeSpeaker('userID');
  ```

##### acceptTakingRequest

- **Description**
  - The host accepts the seat request from the audience with the ID `audienceUserID`.

- **Prototype**
  ```dart
  Future<bool> acceptTakingRequest(String audienceUserID)
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.acceptTakingRequest('audienceUserID');
  ```

##### rejectTakingRequest

- **Description**
  - The host rejects the seat request from the audience with the ID `audienceUserID`.

- **Prototype**
  ```dart
  Future<bool> rejectTakingRequest(String audienceUserID)
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.rejectTakingRequest('audienceUserID');
  ```

##### inviteToTake

- **Description**
  - Host invite the audience with id `userID` to take seat.

- **Prototype**
  ```dart
  Future<bool> inviteToTake(String userID)
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.inviteToTake('userID');
  ```

##### mute

- **Description**
  - Mute the user at the `targetIndex` seat. After mute, if you want to un-mute, you can set `muted` to false. And on side of the user at the `targetIndex` seat, return true/false in the callback of `ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation` to open microphone or not.

- **Prototype**
  ```dart
  Future<bool> mute({int targetIndex = -1, bool muted = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.mute(targetIndex: 0, muted: true);
  ```

##### muteByUserID

- **Description**
  - Mute the seat by `targetUserID`. After mute, if you want to un-mute, you can set `muted` to false. And on side of the user at the `targetIndex` seat, return true/false in the callback of `ZegoLiveAudioRoomAudioVideoEvents.onMicrophoneTurnOnByOthersConfirmation` to open microphone or not.

- **Prototype**
  ```dart
  Future<bool> muteByUserID(String targetUserID, {bool muted = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.muteByUserID('targetUserID', muted: true);
  ```

##### assignCoHost

- **Description**
  - Assign the target user as a co-host.

- **Prototype**
  ```dart
  Future<bool> assignCoHost({required String roomID, required ZegoUIKitUser targetUser})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.host.assignCoHost(roomID: 'roomID', targetUser: targetUser);
  ```

#### audience

##### take

- **Description**
  - Assigns the audience to the seat with the specified `index`, where the index represents the seat number starting from 0.

- **Prototype**
  ```dart
  Future<bool> take(int index, {bool isForce = false})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.audience.take(0);
  ```

##### applyToTake

- **Description**
  - The audience actively requests to occupy a seat.

- **Prototype**
  ```dart
  Future<bool> applyToTake()
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.audience.applyToTake();
  ```

##### cancelTakingRequest

- **Description**
  - The audience cancels the request to occupy a seat.

- **Prototype**
  ```dart
  Future<bool> cancelTakingRequest()
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.audience.cancelTakingRequest();
  ```

##### acceptTakingInvitation

- **Description**
  - Accept the seat invitation from the host.

- **Prototype**
  ```dart
  Future<bool> acceptTakingInvitation({required BuildContext context, bool rootNavigator = false})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.audience.acceptTakingInvitation(context: context);
  ```

#### speaker

##### leave

- **Description**
  - The speaker can use this method to leave the seat. If the `showDialog` parameter is set to true, a confirmation dialog will be displayed before leaving the seat.

- **Prototype**
  ```dart
  Future<bool> leave({bool showDialog = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.speaker.leave();
  ```

#### userMapNotifier

- **Description**
  - The seat user map of the current live audio room.

- **Prototype**
  ```dart
  ValueNotifier<Map<String, String>>? get userMapNotifier
  ```

- **Example**
  ```dart
  ValueListenableBuilder<Map<String, String>>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().seat.userMapNotifier!,
    builder: (context, userMap, _) {
      return Text('Seat Users: $userMap');
    },
  );
  ```

#### localIsHost

- **Description**
  - Check if the local user is a host.

- **Prototype**
  ```dart
  bool get localIsHost
  ```

- **Example**
  ```dart
  bool isHost = ZegoUIKitPrebuiltLiveAudioRoomController().seat.localIsHost;
  ```

#### localIsAudience

- **Description**
  - Check if the local user is an audience.

- **Prototype**
  ```dart
  bool get localIsAudience
  ```

- **Example**
  ```dart
  bool isAudience = ZegoUIKitPrebuiltLiveAudioRoomController().seat.localIsAudience;
  ```

#### localIsSpeaker

- **Description**
  - Check if the local user is a speaker.

- **Prototype**
  ```dart
  bool get localIsSpeaker
  ```

- **Example**
  ```dart
  bool isSpeaker = ZegoUIKitPrebuiltLiveAudioRoomController().seat.localIsSpeaker;
  ```

#### localIsCoHost

- **Description**
  - Check if the local user is a co-host.

- **Prototype**
  ```dart
  bool get localIsCoHost
  ```

- **Example**
  ```dart
  bool isCoHost = ZegoUIKitPrebuiltLiveAudioRoomController().seat.localIsCoHost;
  ```

#### localHasHostPermissions

- **Description**
  - Check if the local user has host permissions. Co-hosts have the same permissions as hosts if host is not exist.

- **Prototype**
  ```dart
  bool get localHasHostPermissions
  ```

- **Example**
  ```dart
  bool hasPermission = ZegoUIKitPrebuiltLiveAudioRoomController().seat.localHasHostPermissions;
  ```

#### isRoomSeatLocked

- **Description**
  - Check if the room seat is locked.

- **Prototype**
  ```dart
  bool get isRoomSeatLocked
  ```

- **Example**
  ```dart
  bool isLocked = ZegoUIKitPrebuiltLiveAudioRoomController().seat.isRoomSeatLocked;
  ```

#### getUserByIndex

- **Description**
  - Get the user who is on the target seat index.

- **Prototype**
  ```dart
  ZegoUIKitUser? getUserByIndex(int targetIndex)
  ```

- **Example**
  ```dart
  ZegoUIKitUser? user = ZegoUIKitPrebuiltLiveAudioRoomController().seat.getUserByIndex(0);
  ```

#### getSeatIndexByUserID

- **Description**
  - Get the seat index of the target user.

- **Prototype**
  ```dart
  int getSeatIndexByUserID(String targetUserID)
  ```

- **Example**
  ```dart
  int index = ZegoUIKitPrebuiltLiveAudioRoomController().seat.getSeatIndexByUserID('userID');
  ```

#### isAHostSeatIndex

- **Description**
  - Check if the seat index is a host seat index.

- **Prototype**
  ```dart
  bool isAHostSeatIndex(int seatIndex)
  ```

- **Example**
  ```dart
  bool isHostSeat = ZegoUIKitPrebuiltLiveAudioRoomController().seat.isAHostSeatIndex(0);
  ```

#### getEmptySeats

- **Description**
  - Get the currently empty seats. Set `includeHostSeats` to true if `ZegoLiveAudioRoomSeatConfig.hostIndexes` is included, default does not include.

- **Prototype**
  ```dart
  List<int> getEmptySeats({bool includeHostSeats = false})
  ```

- **Example**
  ```dart
  List<int> emptySeats = ZegoUIKitPrebuiltLiveAudioRoomController().seat.getEmptySeats();
  ```

#### muteStateNotifier

- **Description**
  - Is the current seat muted or not. Set `isLocally` to true to find out if it is muted locally.

- **Prototype**
  ```dart
  ValueNotifier<bool> muteStateNotifier(int targetIndex, {bool isLocally = false})
  ```

- **Example**
  ```dart
  ValueListenableBuilder<bool>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().seat.muteStateNotifier(0),
    builder: (context, isMuted, _) {
      return Icon(isMuted ? Icons.volume_mute : Icons.volume_up);
    },
  );
  ```

#### muteLocally

- **Description**
  - Mute the user at the `targetIndex` seat **locally**. After mute, if you want to un-mute, you can set `muted` to false.

- **Prototype**
  ```dart
  Future<bool> muteLocally({int targetIndex = -1, bool muted = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.muteLocally(targetIndex: 0, muted: true);
  ```

#### muteLocallyByUserID

- **Description**
  - Mute the seat by `targetUserID` **locally**. After mute, if you want to un-mute, you can set `muted` to false.

- **Prototype**
  ```dart
  Future<bool> muteLocallyByUserID(String targetUserID, {bool muted = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().seat.muteLocallyByUserID('userID', muted: true);
  ```

### audioVideo

#### microphone

##### localState

- **Description**
  - Microphone state of local user.

- **Prototype**
  ```dart
  bool get localState
  ```

- **Example**
  ```dart
  bool isMicOn = ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.microphone.localState;
  ```

##### localStateNotifier

- **Description**
  - Microphone state notifier of local user.

- **Prototype**
  ```dart
  ValueNotifier<bool> get localStateNotifier
  ```

- **Example**
  ```dart
  ValueListenableBuilder<bool>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.microphone.localStateNotifier,
    builder: (context, isMicOn, _) {
      return Icon(isMicOn ? Icons.mic : Icons.mic_off);
    },
  );
  ```

##### state

- **Description**
  - Microphone state of `userID`.

- **Prototype**
  ```dart
  bool state(String userID)
  ```

- **Example**
  ```dart
  bool isMicOn = ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.microphone.state('userID');
  ```

##### stateNotifier

- **Description**
  - Microphone state notifier of `userID`.

- **Prototype**
  ```dart
  ValueNotifier<bool> stateNotifier(String userID)
  ```

- **Example**
  ```dart
  ValueListenableBuilder<bool>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.microphone.stateNotifier('userID'),
    builder: (context, isMicOn, _) {
      return Icon(isMicOn ? Icons.mic : Icons.mic_off);
    },
  );
  ```

##### turnOn

- **Description**
  - Turn on/off `userID` microphone, if `userID` is empty, then it refers to local user.

- **Prototype**
  ```dart
  Future<void> turnOn(bool isOn, {String? userID, bool muteMode = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.microphone.turnOn(true);
  ```

##### switchState

- **Description**
  - Switch `userID` microphone state, if `userID` is empty, then it refers to local user.

- **Prototype**
  ```dart
  void switchState({String? userID})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.microphone.switchState();
  ```

#### audioOutput

##### localNotifier

- **Description**
  - Local audio output device notifier.

- **Prototype**
  ```dart
  ValueNotifier<ZegoUIKitAudioRoute> get localNotifier
  ```

- **Example**
  ```dart
  ValueListenableBuilder<ZegoUIKitAudioRoute>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.audioOutput.localNotifier,
    builder: (context, route, _) {
      return Text('Audio Route: $route');
    },
  );
  ```

##### notifier

- **Description**
  - Get audio output device notifier for `userID`.

- **Prototype**
  ```dart
  ValueNotifier<ZegoUIKitAudioRoute> notifier(String userID)
  ```

- **Example**
  ```dart
  ValueListenableBuilder<ZegoUIKitAudioRoute>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.audioOutput.notifier('userID'),
    builder: (context, route, _) {
      return Text('Audio Route: $route');
    },
  );
  ```

##### switchToSpeaker

- **Description**
  - Set audio output to speaker or earpiece (telephone receiver).

- **Prototype**
  ```dart
  void switchToSpeaker(bool isSpeaker)
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.audioOutput.switchToSpeaker(true);
  ```

#### seiStream

- **Description**
  - Stream of SEI (Supplemental Enhancement Information).

- **Prototype**
  ```dart
  Stream<ZegoUIKitReceiveSEIEvent> seiStream()
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.seiStream().listen((event) {
    print('Received SEI: ${event.data}');
  });
  ```

#### sendSEI

- **Description**
  - Send SEI (Supplemental Enhancement Information).

- **Prototype**
  ```dart
  Future<bool> sendSEI(Map<String, dynamic> seiData, {ZegoStreamType streamType = ZegoStreamType.main})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().audioVideo.sendSEI({'key': 'value'});
  ```

### message

#### send

- **Description**
  - Sends the chat message.

- **Prototype**
  ```dart
  Future<bool> send(String message, {ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().message.send('Hello');
  ```

#### list

- **Description**
  - Retrieves a list of chat messages that already exist in the room.

- **Prototype**
  ```dart
  List<ZegoInRoomMessage> list({ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage})
  ```

- **Example**
  ```dart
  List<ZegoInRoomMessage> messages = ZegoUIKitPrebuiltLiveAudioRoomController().message.list();
  ```

#### stream

- **Description**
  - Retrieves a list stream of chat messages that already exist in the room.

- **Prototype**
  ```dart
  Stream<List<ZegoInRoomMessage>> stream({ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage})
  ```

- **Example**
  ```dart
  StreamBuilder<List<ZegoInRoomMessage>>(
    stream: ZegoUIKitPrebuiltLiveAudioRoomController().message.stream(),
    builder: (context, snapshot) {
      return ListView(children: snapshot.data?.map((e) => Text(e.message)).toList() ?? []);
    },
  );
  ```

#### clear

- **Description**
  - Clear local message and remote message.

- **Prototype**
  ```dart
  Future<bool> clear({ZegoInRoomMessageType type = ZegoInRoomMessageType.broadcastMessage, bool clearRemote = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().message.clear();
  ```

### user

#### remove

- **Description**
  - Remove user from live, kick out.

- **Prototype**
  ```dart
  Future<bool> remove(List<String> userIDs)
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().user.remove(['userID1', 'userID2']);
  ```

### room

#### updateProperty

- **Description**
  - Set/update room property.

- **Prototype**
  ```dart
  Future<bool> updateProperty({required String key, required String value, bool isForce = false, bool isDeleteAfterOwnerLeft = false, bool isUpdateOwner = false})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.updateProperty(key: 'key', value: 'value');
  ```

#### updateProperties

- **Description**
  - Set/update room properties.

- **Prototype**
  ```dart
  Future<bool> updateProperties({required String roomID, required Map<String, String> roomProperties, bool isForce = false, bool isDeleteAfterOwnerLeft = false, bool isUpdateOwner = false})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.updateProperties(roomID: 'roomID', roomProperties: {'key': 'value'});
  ```

#### deleteProperties

- **Description**
  - Delete room properties.

- **Prototype**
  ```dart
  Future<bool> deleteProperties({required String roomID, required List<String> keys, bool isForce = false})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.deleteProperties(roomID: 'roomID', keys: ['key']);
  ```

#### queryProperties

- **Description**
  - Query room properties.

- **Prototype**
  ```dart
  Future<Map<String, String>> queryProperties({required String roomID})
  ```

- **Example**
  ```dart
  Map<String, String> properties = await ZegoUIKitPrebuiltLiveAudioRoomController().room.queryProperties(roomID: 'roomID');
  ```

#### propertiesStream

- **Description**
  - Room properties stream notify.

- **Prototype**
  ```dart
  Stream<ZegoSignalingPluginRoomPropertiesUpdatedEvent> propertiesStream()
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.propertiesStream().listen((event) {
    print('Properties updated: ${event.setProperties}');
  });
  ```

#### sendCommand

- **Description**
  - Send room command.

- **Prototype**
  ```dart
  Future<bool> sendCommand({required String roomID, required Uint8List command})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.sendCommand(roomID: 'roomID', command: Uint8List.fromList(utf8.encode('command')));
  ```

#### commandReceivedStream

- **Description**
  - Room command stream notify.

- **Prototype**
  ```dart
  Stream<ZegoSignalingPluginInRoomCommandMessageReceivedEvent> commandReceivedStream()
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.commandReceivedStream().listen((event) {
    print('Command received: ${event.message}');
  });
  ```

#### removeUser

- **Description**
  - Remove user from live, kick out.

- **Prototype**
  ```dart
  Future<bool> removeUser(List<String> userIDs)
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.removeUser(['userID']);
  ```

#### renewToken

- **Description**
  - Renew token.

- **Prototype**
  ```dart
  Future<void> renewToken(String token)
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().room.renewToken('newToken');
  ```

### minimize

#### state

- **Description**
  - Current minimize state.

- **Prototype**
  ```dart
  ZegoLiveAudioRoomMiniOverlayPageState get state
  ```

- **Example**
  ```dart
  ZegoLiveAudioRoomMiniOverlayPageState state = ZegoUIKitPrebuiltLiveAudioRoomController().minimize.state;
  ```

#### isMinimizing

- **Description**
  - Is it currently in the minimized state or not.

- **Prototype**
  ```dart
  bool get isMinimizing
  ```

- **Example**
  ```dart
  bool isMinimizing = ZegoUIKitPrebuiltLiveAudioRoomController().minimize.isMinimizing;
  ```

#### isMinimizingNotifier

- **Description**
  - Notifier for the minimizing state.

- **Prototype**
  ```dart
  ValueNotifier<bool> get isMinimizingNotifier
  ```

- **Example**
  ```dart
  ValueListenableBuilder<bool>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().minimize.isMinimizingNotifier,
    builder: (context, isMinimizing, _) {
      return Text(isMinimizing ? 'Minimizing' : 'Not Minimizing');
    },
  );
  ```

#### restore

- **Description**
  - Restore the `ZegoUIKitPrebuiltLiveAudioRoom` from minimize.

- **Prototype**
  ```dart
  bool restore(BuildContext context, {bool rootNavigator = true, bool withSafeArea = false})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().minimize.restore(context);
  ```

#### minimize

- **Description**
  - Minimize the `ZegoUIKitPrebuiltLiveAudioRoom`.

- **Prototype**
  ```dart
  bool minimize(BuildContext context, {bool rootNavigator = true})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().minimize.minimize(context);
  ```

#### hide

- **Description**
  - If audio room ended in minimizing state, not need to navigate, just hide the minimize widget.

- **Prototype**
  ```dart
  void hide()
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().minimize.hide();
  ```

### pip

#### status

- **Description**
  - Get PIP status.

- **Prototype**
  ```dart
  Future<ZegoPiPStatus> get status
  ```

- **Example**
  ```dart
  ZegoPiPStatus status = await ZegoUIKitPrebuiltLiveAudioRoomController().pip.status;
  ```

#### available

- **Description**
  - Check if PIP is available.

- **Prototype**
  ```dart
  Future<bool> get available
  ```

- **Example**
  ```dart
  bool available = await ZegoUIKitPrebuiltLiveAudioRoomController().pip.available;
  ```

#### enable

- **Description**
  - Enable PIP.

- **Prototype**
  ```dart
  Future<ZegoPiPStatus> enable({int aspectWidth = 1, int aspectHeight = 1})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().pip.enable();
  ```

#### enableWhenBackground

- **Description**
  - Enable PIP when background.

- **Prototype**
  ```dart
  Future<ZegoPiPStatus> enableWhenBackground({int aspectWidth = 1, int aspectHeight = 1})
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().pip.enableWhenBackground();
  ```

#### cancelBackground

- **Description**
  - Cancel background PIP.

- **Prototype**
  ```dart
  Future<void> cancelBackground()
  ```

- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().pip.cancelBackground();
  ```

### media

#### volume

- **Description**
  - Volume of current media.
- **Prototype**
  ```dart
  int get volume
  ```
- **Example**
  ```dart
  int vol = ZegoUIKitPrebuiltLiveAudioRoomController().media.volume;
  ```

#### totalDuration

- **Description**
  - The total progress(millisecond) of current media resources.
- **Prototype**
  ```dart
  int get totalDuration
  ```
- **Example**
  ```dart
  int duration = ZegoUIKitPrebuiltLiveAudioRoomController().media.totalDuration;
  ```

#### currentProgress

- **Description**
  - Current playing progress of current media.
- **Prototype**
  ```dart
  int get currentProgress
  ```
- **Example**
  ```dart
  int progress = ZegoUIKitPrebuiltLiveAudioRoomController().media.currentProgress;
  ```

#### type

- **Description**
  - Media type of current media.
- **Prototype**
  ```dart
  ZegoUIKitMediaType get type
  ```
- **Example**
  ```dart
  ZegoUIKitMediaType mediaType = ZegoUIKitPrebuiltLiveAudioRoomController().media.type;
  ```

#### volumeNotifier

- **Description**
  - Volume notifier of current media.
- **Prototype**
  ```dart
  ValueNotifier<int> get volumeNotifier
  ```
- **Example**
  ```dart
  ValueListenableBuilder<int>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().media.volumeNotifier,
    builder: (context, volume, _) {
      return Text('Volume: $volume');
    },
  );
  ```

#### currentProgressNotifier

- **Description**
  - Current progress notifier of current media.
- **Prototype**
  ```dart
  ValueNotifier<int> get currentProgressNotifier
  ```
- **Example**
  ```dart
  ValueListenableBuilder<int>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().media.currentProgressNotifier,
    builder: (context, progress, _) {
      return Text('Progress: $progress');
    },
  );
  ```

#### playStateNotifier

- **Description**
  - Play state notifier of current media.
- **Prototype**
  ```dart
  ValueNotifier<ZegoUIKitMediaPlayState> get playStateNotifier
  ```
- **Example**
  ```dart
  ValueListenableBuilder<ZegoUIKitMediaPlayState>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().media.playStateNotifier,
    builder: (context, state, _) {
      return Text('State: $state');
    },
  );
  ```

#### typeNotifier

- **Description**
  - Type notifier of current media.
- **Prototype**
  ```dart
  ValueNotifier<ZegoUIKitMediaType> get typeNotifier
  ```
- **Example**
  ```dart
  ValueListenableBuilder<ZegoUIKitMediaType>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().media.typeNotifier,
    builder: (context, type, _) {
      return Text('Type: $type');
    },
  );
  ```

#### muteNotifier

- **Description**
  - Mute state notifier of current media.
- **Prototype**
  ```dart
  ValueNotifier<bool> get muteNotifier
  ```
- **Example**
  ```dart
  ValueListenableBuilder<bool>(
    valueListenable: ZegoUIKitPrebuiltLiveAudioRoomController().media.muteNotifier,
    builder: (context, isMuted, _) {
      return Icon(isMuted ? Icons.volume_off : Icons.volume_up);
    },
  );
  ```

#### info

- **Description**
  - Info of current media.
- **Prototype**
  ```dart
  ZegoUIKitMediaInfo get info
  ```
- **Example**
  ```dart
  ZegoUIKitMediaInfo mediaInfo = ZegoUIKitPrebuiltLiveAudioRoomController().media.info;
  ```

#### play

- **Description**
  - Start play current media.
- **Prototype**
  ```dart
  Future<ZegoUIKitMediaPlayResult> play({required String filePathOrURL, bool enableRepeat = false, bool autoStart = true})
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.play(filePathOrURL: 'url');
  ```

#### stop

- **Description**
  - Stop play current media.
- **Prototype**
  ```dart
  Future<void> stop()
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.stop();
  ```

#### destroy

- **Description**
  - Destroy current media.
- **Prototype**
  ```dart
  Future<void> destroy()
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.destroy();
  ```

#### pause

- **Description**
  - Pause current media.
- **Prototype**
  ```dart
  Future<void> pause()
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.pause();
  ```

#### resume

- **Description**
  - Resume current media.
- **Prototype**
  ```dart
  Future<void> resume()
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.resume();
  ```

#### seekTo

- **Description**
  - Set the current media playback progress.
- **Prototype**
  ```dart
  Future<ZegoUIKitMediaSeekToResult> seekTo(int millisecond)
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.seekTo(1000);
  ```

#### setVolume

- **Description**
  - Set media player volume.
- **Prototype**
  ```dart
  Future<void> setVolume(int volume, {bool isSyncToRemote = false})
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.setVolume(50);
  ```

#### muteLocal

- **Description**
  - Mute current media locally.
- **Prototype**
  ```dart
  Future<void> muteLocal(bool mute)
  ```
- **Example**
  ```dart
  ZegoUIKitPrebuiltLiveAudioRoomController().media.muteLocal(true);
  ```

#### pickPureAudioFile

- **Description**
  - Pick pure audio media file.
- **Prototype**
  ```dart
  Future<List<ZegoUIKitPlatformFile>> pickPureAudioFile()
  ```
- **Example**
  ```dart
  List<ZegoUIKitPlatformFile> files = await ZegoUIKitPrebuiltLiveAudioRoomController().media.pickPureAudioFile();
  ```

#### pickVideoFile

- **Description**
  - Pick video media file.
- **Prototype**
  ```dart
  Future<List<ZegoUIKitPlatformFile>> pickVideoFile()
  ```
- **Example**
  ```dart
  List<ZegoUIKitPlatformFile> files = await ZegoUIKitPrebuiltLiveAudioRoomController().media.pickVideoFile();
  ```

#### pickFile

- **Description**
  - Pick media file with allowed extensions.
- **Prototype**
  ```dart
  Future<List<ZegoUIKitPlatformFile>> pickFile({List<String>? allowedExtensions})
  ```
- **Example**
  ```dart
  List<ZegoUIKitPlatformFile> files = await ZegoUIKitPrebuiltLiveAudioRoomController().media.pickFile(allowedExtensions: ['mp3', 'mp4']);
  ```
