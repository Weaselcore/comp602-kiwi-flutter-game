import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

import 'kiwi.dart';

class ScoreTracker extends BaseComponent {
  late Queue _enemyQueue;
  int _score = 0;
  late Kiwi _kiwi;

  ScoreTracker(Kiwi _kiwi) {
    this._kiwi = _kiwi;
    _enemyQueue = Queue<Enemy>();
  }

  void addEnemy(
    Enemy enemy,
  ) {
    _enemyQueue.addFirst(enemy);
  }

  void removeEnemy() {
    _enemyQueue.removeLast();
  }

  void reset() {
    _enemyQueue.clear();
    _score = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_enemyQueue.isEmpty) {
      for (Enemy enemy in _enemyQueue) {
        if (!enemy.passedKiwi) {
          if (_kiwi.getYPosition() > enemy.getYPosition()) {
            enemy.passedKiwi = true;
            _score += 1;
            print("Score: $_score");
          }
        }
      }
    }
  }

  int getScore() => _score;
}
