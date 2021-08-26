import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy_factory.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

class EnemyManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  late Timer _timer;
  late Timer _freezeTimer;
  int _idCount = 0;

  Random random = Random();

  var enemyType = ['CRATE', 'CLOUD'];

  EnemyManager() : super() {
    _timer = Timer(0.5, callback: _spawnEnemy, repeat: true);
    _freezeTimer = Timer(0.5, callback: () {
      _timer.start();
    });
  }

  void _spawnEnemy() {
    if (gameRef.buildContext != null) {
      _idCount += 1;
      int randomEnemy = random.nextInt(enemyType.length);

      EnemyFactory factory = new EnemyFactory();

      Enemy enemy = factory.getEnemyType(enemyType[randomEnemy], _idCount);
      gameRef.scoreTracker.addEnemy(enemy);
      gameRef.add(enemy);
    }
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    _freezeTimer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
    _idCount = 0;
  }

  void freeze() {
    _timer.stop;
    _freezeTimer.stop;
    _freezeTimer.start();
  }
}
