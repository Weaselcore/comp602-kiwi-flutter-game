import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_factory.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class PowerUpManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  late Timer _powerUpTimer;
  late Timer _freezeTimer;
  int _idCount = 0;

  PowerUpFactory factory = new PowerUpFactory();

  Random random = Random();

  // 'LASER', 'SLOMO', 'SHIELD'
  var powerUpType = ['LASER', 'SLOMO', 'SHIELD'];

  PowerUpManager() : super() {
    _powerUpTimer = Timer(5.0, callback: _spawnPowerUp, repeat: true);
    _freezeTimer = Timer(1.0, callback: () {
      _powerUpTimer.start();
    });
  }

  void _spawnPowerUp() {
    if (gameRef.buildContext != null) {
      if (_idCount % 2 == 0) {
        spawnBossPowerUp();
      } else {
        incrementCount();
        int randomPowerUp = random.nextInt(powerUpType.length);
        PowerUp powerUp =
            factory.getPowerUpType(powerUpType[randomPowerUp], _idCount);
        gameRef.powerUpTracker.addPowerUp(powerUp);
        gameRef.add(powerUp);
      }
    }
  }

  void spawnBossPowerUp() {
    if (gameRef.buildContext != null) {
      incrementCount();
      PowerUp powerUp = factory.getPowerUpType("BOSS", getCount());
      gameRef.powerUpTracker.addPowerUp(powerUp);
      gameRef.add(powerUp);
    }
  }

  void spawnShieldPowerUp() {
    if (gameRef.buildContext != null) {
      incrementCount();
      PowerUp powerUp = factory.getPowerUpType("SHIELD", getCount());
      gameRef.powerUpTracker.addPowerUp(powerUp);
      gameRef.add(powerUp);
    }
  }

  void switchToShield() {
    _powerUpTimer.callback = spawnShieldPowerUp;
  }

  void switchToDefault() {
    _powerUpTimer.callback = _spawnPowerUp;
  }

  void incrementCount() {
    _idCount += 1;
  }

  int getCount() => _idCount;

  @override
  void onMount() {
    super.onMount();
    _powerUpTimer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _powerUpTimer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _powerUpTimer.update(dt);
    _freezeTimer.update(dt);
  }

  void reset() {
    _powerUpTimer.stop();
    _powerUpTimer.start();
    switchToDefault();
    _idCount = 0;
  }

  void freeze() {
    _powerUpTimer.stop;
    _freezeTimer.stop;
    _freezeTimer.start();
  }
}
