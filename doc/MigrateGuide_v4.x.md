> This document aims to help users understand the APIs changes and feature improvements, and provide a migration guide for the upgrade process.
>
> It is an `incompatible change` if marked with `breaking changes`.
> You can run this command in `the root directory of your project` to output warnings and partial error prompts to assist you in finding deprecated parameters/functions or errors after upgrading.
> 
> ```shell
> dart analyze | grep zego
> ```
>
> 
> Versions
> - 4.0.0  (💥 breaking changes)
>
> 
> # 4.0.0
> ---
>
> # Introduction
>
> 4.0 aligns with `zego_uikit 3.0`, removes 3.x deprecated APIs, consolidates controller/config namespaces, and refactors seat-related options.
>
> # Major Interface Changes
>
> - Dependencies
>   - require `zego_uikit: ^3.0.0`
>
> - Controller namespace consolidation
>   - use `ZegoUIKitPrebuiltLiveAudioRoomController()` singleton
>   - audio/video: `controller.audioVideo`
>   - seat management: `controller.seat.*` (host/audience/co-host checks and operations)
>
> - Config updates
>   - `topMenuBar`: type changed from `ZegoTopMenuBarConfig` to `ZegoLiveAudioRoomTopMenuBarConfig`
>   - `bottomMenuBar`: type changed from `ZegoBottomMenuBarConfig` to `ZegoLiveAudioRoomBottomMenuBarConfig`
>   - `inRoomMessage`: type changed from `ZegoInRoomMessageConfig` to `ZegoLiveAudioRoomInRoomMessageConfig`
>   - `memberList`: type changed from `ZegoMemberListConfig` to `ZegoLiveAudioRoomMemberListConfig`
>   - `audioEffect`: type changed from `ZegoAudioEffectConfig` to `ZegoLiveAudioRoomAudioEffectConfig`
>   - `duration`: type changed from `ZegoLiveDurationConfig` to `ZegoLiveAudioRoomDurationConfig`
>   - `mediaPlayer`: type changed from `ZegoMediaPlayerConfig` to `ZegoLiveAudioRoomMediaPlayerConfig`
>   - `backgroundMedia`: type changed from `ZegoBackgroundMediaConfig` to `ZegoLiveAudioRoomBackgroundMediaConfig`
>   - Seat:
>     - `seatConfig` → `seat`
>     - `layoutConfig` → `seat.layout`
>     - `takeSeatIndexWhenJoining` → `seat.takeIndexWhenJoining`
>     - `closeSeatsWhenJoining` → `seat.closeWhenJoining`
>     - `hostSeatIndexes` → `seat.hostIndexes`
>
> ## Deprecated → New API Mapping (from 3.x)
> - typedefs:
>   - ZegoLiveAudioRoomController → ZegoUIKitPrebuiltLiveAudioRoomController
>   - ZegoTopMenuBarConfig → ZegoLiveAudioRoomTopMenuBarConfig
>   - ZegoBottomMenuBarConfig → ZegoLiveAudioRoomBottomMenuBarConfig
>   - ZegoInRoomMessageConfig → ZegoLiveAudioRoomInRoomMessageConfig
>   - ZegoMemberListConfig → ZegoLiveAudioRoomMemberListConfig
>   - ZegoAudioEffectConfig → ZegoLiveAudioRoomAudioEffectConfig
>   - ZegoLiveDurationConfig → ZegoLiveAudioRoomLiveDurationConfig
>   - ZegoMediaPlayerConfig → ZegoLiveAudioRoomMediaPlayerConfig
>   - ZegoBackgroundMediaConfig → ZegoLiveAudioRoomBackgroundMediaConfig
>
> - controller extensions:
>   - `turnMicrophoneOn(isOn, userID)` → `audioVideo.microphone.turnOn(isOn, userID: ...)`
>   - `localIsAHost / localIsAAudience / localIsCoHost` → `seat.localIsHost / seat.localIsAudience / seat.localIsCoHost`
>   - `localHasHostPermissions` → `seat.localHasHostPermissions`
>   - `getSeatsUserMapNotifier()` → `seat.userMapNotifier`
>   - `openSeats(targetIndex)` → `seat.host.open(targetIndex: ...)`
>   - `closeSeats(targetIndex)` → `seat.host.close(targetIndex: ...)`
>
> ### Migration Guide
>
> 3.x Version Code:
> ```dart
> config
>   ..topMenuBarConfig = ZegoTopMenuBarConfig()
>   ..memberListConfig = ZegoMemberListConfig()
>   ..seatConfig = ZegoLiveAudioRoomSeatConfig();
> 
> final controller = ZegoUIKitPrebuiltLiveAudioRoomController();
> controller.turnMicrophoneOn(true);
> final isHost = controller.localIsAHost;
> controller.openSeats();
> ```
>
> 4.0.0 Version Code:
> ```dart
> config
>   ..topMenuBar = ZegoLiveAudioRoomTopMenuBarConfig()
>   ..memberList = ZegoLiveAudioRoomMemberListConfig()
>   ..seat = ZegoLiveAudioRoomSeatConfig();
> 
> final controller = ZegoUIKitPrebuiltLiveAudioRoomController();
> controller.audioVideo.microphone.turnOn(true);
> final isHost = controller.seat.localIsHost;
> await controller.seat.host.open();
> ```
>
> ### Compatibility Notes
> - All 3.x `@Deprecated` symbols are removed in 4.0.
> - If analyzer still reports errors, run:
> ```shell
> dart analyze | grep zego
> ```
>
