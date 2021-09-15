import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import '../kiwi.dart';

class EnemyTracker extends BaseComponent with HasGameRef<KiwiGame> {
  // A list to contain enemy objects.
  late List _enemyList;
  // A reference to the kiwi object.
  late Kiwi _kiwi;

  // Flag that shows if the slow effect is in effect.
  bool _isSlowed = false;

  EnemyTracker() {
    // Initialise an empty list that can contain only enemy objects.
    _enemyList = <Enemy>[];
  }

  /// Adds [enemy] to the list to keep track of.
  void addEnemy(Enemy enemy) {
    _enemyList.add(enemy);
  }

  /// Removes enemy that is being tracked using the [id].
  void removeEnemy(int id) {
    _enemyList.remove(id);
  }

  /// Clears the enemy list ready for a new game.
  void reset() {
    _enemyList.clear();
  }

  /// The update functions checks if enemies have passed the kiwi if so,
  /// incrementing the score.
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
        }
        // If the game is in the state of slow, future enemies will be spawned
        // respecting the slow condition.
        else if (_isSlowed) {
          for (Enemy enemy in _enemyList) {
            if (!enemy.isSlowed() && _isSlowed) {
              enemy.halfSpeed();
            }
          }
        }
      }
    }
  }

  /// Slows all enemies that is contained in the [_enemyList].
  void slowEnemies() {
    for (Enemy enemy in _enemyList) {
      if (!enemy.isSlowed()) {
        enemy.halfSpeed();
        _isSlowed = true;
      }
    }
  }

  /// Restores all enemies speed that is contained in the [_enemyList].
  void restoreEnemy() {
    for (Enemy enemy in _enemyList) {
      if (enemy.isSlowed()) {
        enemy.restoreSpeed();
        _isSlowed = false;
      }
    }
  }

  /// Passes a reference to the kiwi when initialising the [kiwi].
  void registerKiwi(Kiwi kiwi) {
    _kiwi = kiwi;
  }
}
