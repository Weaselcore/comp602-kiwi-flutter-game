import 'package:flame/components.dart';

class DifficultyManager extends BaseComponent {
  final double baseDifficulty = 1;
  late double currentDifficulty;
  double multiplier = 1.25;

  DifficultyManager() {
    currentDifficulty = baseDifficulty;
  }

  void reset() {
    currentDifficulty = baseDifficulty;
  }

  void increaseDifficulty() {
    currentDifficulty = currentDifficulty * multiplier;
  }

  double getDifficulty() => currentDifficulty;
}
