import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/boss/boss_factory.dart';
import 'package:flutter_game/game/components/boss/boss_falcon.dart';
import 'package:flutter_game/game/components/boss/boss_ufo.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';
import 'boss.dart';
import 'boss_wizard.dart';

class BossManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  // A timer that causes spawns to occur.
  late Timer _falconTimer;
  late Timer _ufoTimer;
  late Timer _wizardTimer;
  // Flags to keep track of running boss timers.
  bool isFalconRunning = false;
  bool isUfoRunning = false;
  bool isWizardRunning = false;
  // Enemy manager keeps track of enemy instances and assigns them unique IDs.
  int _idCount = 0;
  // Counter for win condition to remove boss.
  int conditionCount = 0;
  static const int _winCondition = 3;

  BossFactory _bossFactory = BossFactory();

  // A randomiser for the type of enemy to spawn.
  Random random = Random();

  int _bossCount = 0;
  var _bossTypes = ["wizard", "ufo", "wizard"];

  BossManager() : super() {
    // Enemies spawn every 2 seconds.
    _falconTimer = Timer(2, callback: spawnBoss, repeat: true);
    _ufoTimer = Timer(5, callback: spawnBoss, repeat: true);
    _wizardTimer = Timer(6, callback: spawnBoss, repeat: true);
  }

  /// This spawns enemy objects when the timer triggers.
  void spawnBoss() {
    if (conditionCount <= _winCondition) {
      _idCount += 1;
      Boss newBoss = _bossFactory.getBossType(_bossTypes[_bossCount], _idCount);
      start(newBoss);
      gameRef.bossTracker.addBoss(newBoss);
      gameRef.add(newBoss);
    } else {
      stop();
      gameRef.powerUpManager.switchToDefault();
      gameRef.enemyManager.start();
      conditionCount = 0;
      _bossCount += 1;
    }
  }

  /// Stop timer when the widget is removed.
  @override
  void onRemove() {
    super.onRemove();
    stop();
  }

  /// Update the timers when the game engine is running.
  @override
  void update(double dt) {
    super.update(dt);
    _falconTimer.update(dt);
    _ufoTimer.update(dt);
    _wizardTimer.update(dt);
  }

  /// Reset the timers and IDs when the game engine resets.
  void reset() {
    stop();
    _idCount = 0;
  }

  void stop() {
    if (_falconTimer.isRunning()) {
      _falconTimer.stop();
      isFalconRunning = false;
    }
    if (_ufoTimer.isRunning()) {
      _ufoTimer.stop();
      isUfoRunning = false;
    }
    if (_wizardTimer.isRunning()) {
      _wizardTimer.stop();
      isWizardRunning = false;
    }
  }

  void start(Boss boss) {
    if (boss is FalconBoss &&
        !_falconTimer.isRunning() &&
        !_wizardTimer.isRunning()) {
      _falconTimer.start();
      isFalconRunning = true;
    }
    if (boss is UfoBoss &&
        !_ufoTimer.isRunning() &&
        !_wizardTimer.isRunning()) {
      _ufoTimer.start();
      isUfoRunning = true;
    }
    if (boss is WizardBoss &&
        !_falconTimer.isRunning() &&
        !_ufoTimer.isRunning()) {
      _wizardTimer.start();
      isWizardRunning = true;
    }
  }

  void incrementWinCondition() {
    conditionCount += 1;
  }
}
