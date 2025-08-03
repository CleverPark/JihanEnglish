import '../values/app_constants.dart';

class LevelSystem {
  static int calculateRequiredExp(int level) {
    return level * 100;
  }

  static bool canLevelUp(int currentExp, int requiredExp) {
    return currentExp >= requiredExp;
  }

  static LevelUpResult processExp(int currentLevel, int currentExp, int expToAdd) {
    int totalExp = currentExp + expToAdd;
    int newLevel = currentLevel;
    int newCurrentExp = totalExp;
    int newRequiredExp = calculateRequiredExp(currentLevel);
    bool didLevelUp = false;

    while (newCurrentExp >= newRequiredExp && newLevel < AppConstants.maxLevel) {
      newCurrentExp -= newRequiredExp;
      newLevel++;
      newRequiredExp = calculateRequiredExp(newLevel);
      didLevelUp = true;
    }

    return LevelUpResult(
      newLevel: newLevel,
      currentExp: newCurrentExp,
      requiredExp: newRequiredExp,
      didLevelUp: didLevelUp,
      levelsGained: newLevel - currentLevel,
    );
  }

  static double getProgressPercentage(int currentExp, int requiredExp) {
    if (requiredExp == 0) return 0.0;
    return (currentExp / requiredExp).clamp(0.0, 1.0);
  }

  static String getCharacterTitle(int level) {
    if (level <= 20) return '견습 용사';
    if (level <= 40) return '초급 기사';
    if (level <= 60) return '중급 전사';
    if (level <= 80) return '상급 마법사';
    return '전설의 영웅';
  }

  static bool shouldEvolve(int oldLevel, int newLevel) {
    final oldEvolution = (oldLevel - 1) ~/ AppConstants.levelEvolutionInterval;
    final newEvolution = (newLevel - 1) ~/ AppConstants.levelEvolutionInterval;
    return newEvolution > oldEvolution;
  }
}

class LevelUpResult {
  final int newLevel;
  final int currentExp;
  final int requiredExp;
  final bool didLevelUp;
  final int levelsGained;

  LevelUpResult({
    required this.newLevel,
    required this.currentExp,
    required this.requiredExp,
    required this.didLevelUp,
    required this.levelsGained,
  });
}