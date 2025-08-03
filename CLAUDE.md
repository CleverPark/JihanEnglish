# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
English Hero is a gamified English learning app for children, optimized for Galaxy Tab 12.4 inch. The app uses Flutter with GetX state management (planned, not yet implemented).

## Development Commands

### Flutter Commands
```bash
# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>

# Build APK
flutter build apk

# Build App Bundle
flutter build appbundle

# Analyze code
flutter analyze

# Run tests
flutter test

# Clean build
flutter clean
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade
```

## Architecture Overview

### Current State
The project is currently using Flutter's default boilerplate code. The planned architecture (from initialDev.md) follows GetX pattern with:
- **Controllers**: Business logic and state management
- **Views**: UI components
- **Bindings**: Dependency injection
- **Models**: Data structures
- **Routes**: Navigation management

### Key Files
- `/lib/main.dart`: Entry point (currently default Flutter counter app)
- `/lib/bookData/bookData.dart`: Contains book content data structure
- `/lib/assets/worriorImg/tempWorrior.png`: Character asset
- `/initialDev.md`: Comprehensive development plan and specifications

### Planned Structure (from initialDev.md)
```
lib/
├── app/
│   ├── core/
│   │   ├── theme/        # Design system implementation
│   │   ├── values/       # Constants and spacing
│   │   └── utils/        # Level system, storage service
│   ├── data/
│   │   ├── models/       # Book, User, Character models
│   │   └── providers/    # Data providers
│   ├── modules/          # Feature modules (GetX pattern)
│   │   ├── welcome/      # User registration
│   │   ├── home/         # Main screen
│   │   ├── game_menu/    # Game selection
│   │   ├── word_game/    # Word reading game
│   │   ├── sentence_game/# Sentence reading game
│   │   └── order_game/   # Sentence ordering game
│   ├── routes/           # Navigation
│   └── widgets/          # Reusable components
```

## Game Features
1. **Word Reading Game**: 5 EXP per word
2. **Sentence Reading Game**: 10 EXP per sentence  
3. **Sentence Ordering Game**: 30 EXP per completion

## Level System
- Levels 1-100
- Character evolution every 20 levels
- Required EXP per level: level × 100

## Design System Colors
- Primary: `#5B9EF7` (Sky blue)
- Secondary: `#FF8C42` (Warm orange)
- Success: `#4CAF50` (Green)
- Background: `#F5F7FB`, `#FFFFFF`
- Text: `#2D3748`, `#718096`

## Required Dependencies (Not Yet Added)
The following dependencies need to be added to pubspec.yaml:
```yaml
get: ^4.6.6
get_storage: ^2.1.1
lottie: ^2.7.0
flutter_animate: ^4.3.0
flutter_screenutil: ^5.9.0
google_fonts: ^6.1.0
flutter_draggable_gridview: ^0.0.7
```

## Data Storage
Local storage using GetStorage for:
- User profile and progress
- Game completion states
- Level and experience points