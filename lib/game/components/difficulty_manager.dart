import 'package:flame/components.dart';

class DifficultyManager extends BaseComponent {
  final double baseDifficulty = 1;
  late double currentDifficulty;
  double difficultyMultiplier = 1.25;
  int baseScoreMultiplier = 1;
  late int currentScoreMultiplier;

  DifficultyManager() {
    currentDifficulty = baseDifficulty;
    currentScoreMultiplier = baseScoreMultiplier;
  }

  void reset() {
    currentDifficulty = baseDifficulty;
    currentScoreMultiplier = baseScoreMultiplier;
  }

  void increaseDifficulty() {
    currentDifficulty = currentDifficulty * difficultyMultiplier;
    currentScoreMultiplier = currentScoreMultiplier * 2;
  }

  double getCurrentDifficulty() => currentDifficulty;

  int getScoreDifficulty() => currentScoreMultiplier;
}
