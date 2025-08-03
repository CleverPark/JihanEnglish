# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
English Hero is a fully implemented gamified English learning app for children, optimized for Galaxy Tab 12.4 inch (1024x768). The app uses Flutter with GetX state management and includes a complete level system with character evolution.

## Development Commands

### Essential Commands
```bash
# Test the app in release mode (critical for UI/font consistency)
flutter run --release

# Standard development run
flutter run

# Clean and rebuild (when facing UI issues)
flutter clean && flutter pub get && flutter run --release

# Analyze code for issues
flutter analyze

# Build for production
flutter build apk --release
```

## Architecture Overview

### Current Implementation
The app follows GetX MVC pattern with complete implementation:

**Core Structure:**
- **Controllers**: Handle business logic, state management, and data persistence
- **Views**: UI screens with responsive design using ScreenUtil (1024x768 base)
- **Bindings**: Dependency injection for each module
- **Models**: UserModel (with completion tracking), BookModel, CharacterModel
- **Storage**: GetStorage for persistent user data and game progress

### Critical Files and Patterns

**Main Configuration:**
- `/lib/main.dart`: ScreenUtilInit with `useInheritedMediaQuery: true` for consistent UI rendering
- `/lib/app/core/values/app_spacing.dart`: Responsive spacing using getter methods (not static)
- `/lib/app/core/theme/app_text_styles.dart`: Google Fonts implementation with getter methods

**Data Models:**
- `/lib/app/data/models/user_model.dart`: Complete user state with `completionCounts` tracking
- `/lib/bookData/bookData.dart`: Static book content data (4 books currently)

**Game Flow:**
1. **Welcome**: User registration with name input
2. **Home**: Character display, level progress, book grid (4 columns), navigation drawer
3. **Game Menu**: Shows 3 games with completion counts and EXP values  
4. **Games**: Three types with different mechanics and EXP rewards

### Level System Implementation
- **Character Evolution**: 5 stages based on level ranges (견습 용사 → 전설의 영웅)
- **EXP Calculation**: level × 100 required EXP per level
- **Completion Tracking**: Per-book, per-game completion counts stored in UserModel
- **Progress Persistence**: All data saved via GetStorage, persists across app restarts

## Game Mechanics

### Three Game Types
1. **Word Game** (`/lib/app/modules/word_game/`): Read words aloud - 5 EXP per word
2. **Sentence Game** (`/lib/app/modules/sentence_game/`): Read sentences aloud - 10 EXP per sentence
3. **Order Game** (`/lib/app/modules/order_game/`): Arrange sentences in order - 30 EXP per completion

### UI/UX Patterns
- **Responsive Design**: All spacing and fonts use ScreenUtil (.w, .h, .sp extensions)
- **SafeArea**: Applied to all screens to handle device notches/status bars
- **Navigation**: GetX routing with parameter passing (bookNum for games)
- **Error Handling**: Overflow prevention with SingleChildScrollView where needed

## Critical Implementation Notes

### UI Rendering Consistency
**Problem**: UI and fonts render differently between debug and release modes
**Solution**: 
- Use Google Fonts instead of static font declarations
- Convert static spacing values to getter methods for proper ScreenUtil integration
- Add `useInheritedMediaQuery: true` to ScreenUtilInit

### Data Persistence Architecture
```dart
// UserModel structure with completion tracking
Map<String, Map<String, int>> completionCounts = {
  "book_1": {"game1": 3, "game2": 1, "game3": 0},
  "book_2": {"game1": 2, "game2": 2, "game3": 1}
};
```

### Navigation Drawer Features
- Level guide showing character evolution stages
- User statistics (total completions, current level/EXP)
- Data reset with password protection (880119)
- App information

## Book Content Management
Books are stored in `/lib/bookData/bookData.dart` as static data. To add books:
1. Add new book object to bookData array with BookNum, Title, Words, Sentences
2. Update any hardcoded book count references
3. Ensure UI scales properly for additional books (currently 4-column grid)

## Dependency Management
All required dependencies are installed in pubspec.yaml:
- `get: ^4.6.6` - State management
- `get_storage: ^2.1.1` - Local storage  
- `flutter_screenutil: ^5.9.3` - Responsive design
- `google_fonts: ^6.2.1` - Font consistency
- `flutter_animate: ^4.5.0` - Animations
- `lottie: ^3.1.2` - Vector animations