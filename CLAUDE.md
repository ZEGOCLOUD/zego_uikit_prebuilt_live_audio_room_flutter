# CLAUDE.md

> **Note**: This library is part of the `zego_uikits` monorepo. See the root [CLAUDE.md](https://github.com/your-org/zego_uikits/blob/main/CLAUDE.md) for cross-library dependencies and architecture overview.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Workflow Orchestration

### 1. Plan Node Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One tack per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimat Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

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
