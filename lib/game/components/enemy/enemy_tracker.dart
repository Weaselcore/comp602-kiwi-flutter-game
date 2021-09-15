import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import '../kiwi.dart';

class EnemyTracker extends BaseComponent with HasGameRef<KiwiGame> {
  late List _enemyList;
  late Kiwi _kiwi;

  bool _isSlowed = false;

  EnemyTracker() {
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
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_enemyList.isEmpty) {
      for (Enemy enemy in _enemyList) {
        if (!enemy.passedKiwi) {
          if (_kiwi.getYPosition() > enemy.getYPosition()) {
            enemy.passedKiwi = true;
            gameRef.score += 1;
            print("Score: $gameRef.score");
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

  void registerKiwi(Kiwi kiwi) {
    _kiwi = kiwi;
  }
}
