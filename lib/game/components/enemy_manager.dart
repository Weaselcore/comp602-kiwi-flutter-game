import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../kiwi_game.dart';

class EnemyManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  late Timer _timer;
  late Timer _freezeTimer;

  Random random = Random();

  EnemyManager() : super() {
    _timer = Timer(1, callback: _spawnEnemy, repeat: true);
    _freezeTimer = Timer(5, callback: () {
      _timer.start();
    });
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64, 64);

    Vector2 position = Vector2(random.nextDouble() * gameSize.x, 5000);

    position.clamp(
        Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    if (gameRef.buildContext != null) {
      Enemy enemy = Enemy(position);
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
  }

  void freeze() {
    _timer.stop;
    _freezeTimer.stop;
    _freezeTimer.start();
  }
}
