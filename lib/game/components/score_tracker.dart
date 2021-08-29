import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

import 'kiwi.dart';

class ScoreTracker extends BaseComponent {
  late List _enemyList;
  int _score = 0;
  late Kiwi _kiwi;

  ScoreTracker(Kiwi _kiwi) {
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
        }
      }
    }
  }

  int getScore() => _score;
}
