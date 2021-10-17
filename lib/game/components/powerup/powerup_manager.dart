import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_factory.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class PowerUpManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  late Timer _timer;
  late Timer _freezeTimer;
  int _idCount = 0;

  Random random = Random();

  //, 'LASER', 'SLOMO', 'SHIELD'
  var powerUpType = ['LASER', 'SLOMO', 'SHIELD'];

  PowerUpManager() : super() {
    _timer = Timer(1.0, callback: _spawnPowerUp, repeat: true);
    _freezeTimer = Timer(1.0, callback: () {
      _timer.start();
    });
  }

  void _spawnPowerUp() {
    if (gameRef.buildContext != null) {
      _idCount += 1;
      int randomPowerUp = random.nextInt(powerUpType.length);

      PowerUpFactory factory = new PowerUpFactory();

      PowerUp powerup =
          factory.getPowerUpType(powerUpType[randomPowerUp], _idCount);

      gameRef.powerUpTracker.addPowerUp(powerup);
      gameRef.add(powerup);
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
