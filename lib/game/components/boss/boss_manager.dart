import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/boss/boss_factory.dart';
import 'package:flutter_game/game/components/boss/boss_falcon.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';
import 'boss.dart';

class BossManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  // A timer that causes spawns to occur.
  late Timer _falconTimer;
  late Timer _ufoTimer;
  // A time that cause a small freeze when the game engine pauses.
  late Timer _falconFreezeTimer;
  late Timer _ufoFreezeTimer;

  bool isFalconRunning = false;
  bool isUfoRunning = false;
  // Enemy manager keeps track of enemy instances and assigns them unique IDs.
  int _idCount = 0;
  // Counter for win condition to remove boss.
  int conditionCount = 0;
  static const int _winCondition = 3;

  BossFactory _bossFactory = BossFactory();

  // A randomiser for the type of enemy to spawn.
  Random random = Random();

  int _bossCount = 0;
  var _bossTypes = ["falcon", "ufo", "placeholder2"];

  BossManager() : super() {
    // Enemies spawn every 2 seconds.
    _falconTimer = Timer(2, callback: _spawnBoss, repeat: true);
    _ufoTimer = Timer(3, callback: _spawnBoss, repeat: true);

    // There is a 1 second pause after the game resumes.
    _falconFreezeTimer = Timer(5, callback: () {
      _falconTimer.start();
    });
    _ufoFreezeTimer = Timer(5, callback: () {
      _ufoTimer.start();
    });
  }

  /// This spawns enemy objects when the timer triggers.
  void _spawnBoss() {
    print(conditionCount);
    if (conditionCount <= _winCondition) {
      _idCount += 1;
      Boss newBoss = _bossFactory.getBossType(_bossTypes[_bossCount], _idCount);
      gameRef.bossTracker.addBoss(newBoss);
      gameRef.add(newBoss);
    } else {
      bossStop();
      gameRef.powerUpManager.switchToDefault();
      gameRef.enemyManager.start();
      conditionCount = 0;
      _bossCount += 1;
    }
  }

  // /// Start timer when the widget gets mounted.
  // @override
  // void onMount() {
  //   super.onMount();
  //   _timer.start();
  // }

  /// Stop timer when the widget is removed.
  @override
  void onRemove() {
    super.onRemove();
    bossStop();
  }

  /// Update the timers when the game engine is running.
  @override
  void update(double dt) {
    super.update(dt);
    _falconTimer.update(dt);
    _ufoTimer.update(dt);
    _falconFreezeTimer.update(dt);
    _ufoFreezeTimer.update(dt);
  }

  /// Reset the timers and IDs when the game engine resets.
  void reset() {
    bossStop();
    _idCount = 0;
  }

  void stop() {
    bossStop();
  }

  void start() {
    _timer.start();
  }

  /// Freeze the timers when the game engine is pausing.
  void freeze() {
    bossStop();
    bossFreezeTimer();
  }

  void incrementWinCondition() {
    conditionCount += 1;
  }

  void bossStop() {
    if (_falconTimer.isRunning()) {
      _falconTimer.stop();
    }
    if (_ufoTimer.isRunning()) {
      _ufoTimer.stop();
    }
  }

  void bossFreezeTimer() {
    if (isFalconRunning) {
      _falconFreezeTimer.stop;
      _falconFreezeTimer.start();
    }
    if (isUfoRunning) {
      _ufoFreezeTimer.stop;
      _ufoFreezeTimer.start();
    }
  }
}
