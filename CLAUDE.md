# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter plugin** (prebuilt Live Audio Room SDK) by ZegoCloud. It provides a complete, customizable live audio room component with business logic and UI bundled together.

## Commands

```bash
# Run linter and analyzer
flutter analyze

# Format imports (requires manual run)
flutter pub run import_sorter:main

# Run tests
flutter test

# Run example app
cd example && flutter run
```

## Architecture

### Directory Structure

```
lib/
├── zego_uikit_prebuilt_live_audio_room.dart   # Main entry point
├── live_audio_room.dart                        # Main widget
├── config.dart                                 # Configuration builder
├── events.dart                                 # Event callbacks
├── controller.dart                             # Singleton controller
├── style.dart, inner_text.dart                 # Styling
├── defines.dart                                # Shared enums/typedefs
├── api/                                        # API documentation
└── src/
    ├── core/                                   # Business logic managers
    │   ├── connect/                            # Connect manager & buttons
    │   ├── seat/                               # Seat management
    │   ├── core_managers.dart                  # Singleton container
    │   └── live_duration_manager.dart
    ├── components/                             # UI widgets
    │   ├── audio_video/                        # Seat layout, background
    │   ├── member/                             # Member list & buttons
    │   ├── message/                            # Chat input & display
    │   ├── effects/                            # Sound effects
    │   └── dialogs.dart, top_bar.dart, bottom_bar.dart
    ├── controller/                             # Public & private APIs
    │   ├── audio_video.dart, seat.dart, room.dart  # Public
    │   ├── private/                            # Internal APIs
    │   └── controller.dart                     # Main singleton
    ├── minimizing/                             # PiP/overlay management
    └── deprecated/                             # Legacy API migrations
```

### Key Architectural Patterns

1. **Singleton Controller Pattern**
   - `ZegoUIKitPrebuiltLiveAudioRoomController` - main singleton for all room operations
   - `ZegoLiveAudioRoomManagers` - container for core sub-managers

2. **Manager Pattern** (`core_managers.dart`)
   - `ZegoLiveAudioRoomPlugins` - plugin initialization
   - `ZegoLiveAudioRoomSeatManager` - handles host/co-host/audience roles
   - `ZegoLiveAudioRoomConnectManager` - handles user connections
   - `ZegoLiveAudioRoomPopUpManager` - dialog/popup management

3. **Public/Private API Split**
   - Public APIs: `controller/audio_video.dart`, `controller/seat.dart`, `controller/room.dart`
   - Internal APIs: `controller/private/` (prefixed with `.private`)
   - Mixins: `ZegoLiveAudioRoomControllerPrivate`, `ZegoLiveAudioRoomControllerSeat`, etc.

4. **Config-Event-Controller Architecture**
   - `ZegoUIKitPrebuiltLiveAudioRoomConfig` - builder pattern for UI customization
   - `ZegoUIKitPrebuiltLiveAudioRoomEvents` - callback events
   - `ZegoUIKitPrebuiltLiveAudioRoomController` - programmatic control

5. **State Management**
   - `ValueNotifier` for reactive state
   - Stream subscriptions for real-time events
   - Uses `zego_uikit` package for core RTC functionality

### Configuration

Set up the SDK by configuring `ZegoUIKitPrebuiltLiveAudioRoomConfig` and `ZegoUIKitPrebuiltLiveAudioRoomEvents`, then pass them to the `ZegoUIKitPrebuiltLiveAudioRoom` widget.

## Documentation

- [APIs](doc/apis.md) - API reference
- [Events](doc/events.md) - Event callbacks
- [Configs](doc/configs.md) - Configuration options
- [Components](doc/components.md) - UI components
- [Migration Guide](doc/MigrateGuide_v3.x.md) - v3.x migration
- Online: https://docs.zegocloud.com/article/15079

## Dependencies

Key dependencies to understand:
- `zego_uikit: ^3.0.0` - Core UI kit
- `zego_uikit_signaling_plugin: ^2.8.20` - Signaling
- `zego_plugin_adapter: ^2.14.2` - Plugin abstraction
