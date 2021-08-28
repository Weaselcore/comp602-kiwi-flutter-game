import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy_factory.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

class PowerUpManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  late Timer _timer;
  late Timer _freezeTimer;
  int _idCount = 0;

  Random random = Random();

  var powerUpType = ['SHIELD', 'LASER', 'SLOWMO'];

  PowerUpManager() : super() {
    _timer = Timer(15.0, callback: _spawnPowerUp, repeat: true);
    _freezeTimer = Timer(5.0, callback: () {
      _timer.start();
    });
  }

  void _spawnPowerUp() {
    if (gameRef.buildContext != null) {
      _idCount += 1;
      int randomPowerUp = random.nextInt(powerUpType.length);

      EnemyFactory factory = new EnemyFactory();

      Enemy enemy = factory.getEnemyType(powerUpType[randomPowerUp], _idCount);
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
