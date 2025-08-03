class AppConstants {
  // Experience points
  static const int wordGameExp = 5;
  static const int sentenceGameExp = 10;
  static const int orderGameExp = 30;

  // Level system
  static const int maxLevel = 100;
  static const int levelEvolutionInterval = 20;

  // Storage keys
  static const String userStorageKey = 'user_data';
  static const String bookStorageKey = 'book_data';
  static const String firstRunKey = 'first_run';

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Game constants
  static const double swipeThreshold = 50.0;
}