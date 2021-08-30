import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

import 'kiwi.dart';

class EnemyTracker extends BaseComponent {
  late List _enemyList;
  late Kiwi _kiwi;

  int _score = 0;

  bool _isSlowed = false;

  EnemyTracker(Kiwi _kiwi) {
    this._kiwi = _kiwi;
    _enemyList = <Enemy>[];
  }

  void addEnemy(Enemy enemy) {
    _enemyList.add(enemy);
  }

  void removeEnemy(int id) {
    _enemyList.remove(id);
  }

  void reset() {
    _enemyList.clear();
    _score = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_enemyList.isEmpty) {
      for (Enemy enemy in _enemyList) {
        if (!enemy.passedKiwi) {
          if (_kiwi.getYPosition() > enemy.getYPosition()) {
            enemy.passedKiwi = true;
            _score += 1;
            print("Score: $_score");
          }
        } else if (_isSlowed) {
          for (Enemy enemy in _enemyList) {
            if (!enemy.isSlowed() && _isSlowed) {
              enemy.halfSpeed();
            }
          }
        }
      }
    }
  }

  void slowEnemies() {
    for (Enemy enemy in _enemyList) {
      if (!enemy.isSlowed()) {
        enemy.halfSpeed();
        _isSlowed = true;
      }
    }
  }

  void restoreEnemy() {
    for (Enemy enemy in _enemyList) {
      if (enemy.isSlowed()) {
        enemy.restoreSpeed();
        _isSlowed = false;
      }
    }
  }

  int getScore() => _score;
}
