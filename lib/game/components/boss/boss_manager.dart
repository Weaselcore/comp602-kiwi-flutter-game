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
  late Timer _timer;
  // A time that cause a small freeze when the game engine pauses.
  late Timer _freezeTimer;
  // Enemy manager keeps track of enemy instances and assigns them unique IDs.
  int _idCount = 0;
  // Counter for win condition to remove boss.
  int conditionCount = 0;
  static const int _winCondition = 3;

  BossFactory _bossFactory = BossFactory();

  // A randomiser for the type of enemy to spawn.
  Random random = Random();

  int _bossCount = 0;
  var _bossTypes = ["falcon", "placeholder1", "placeholder2"];

  BossManager() : super() {
    // Enemies spawn every 2 seconds.
    _timer = Timer(2, callback: _spawnBoss, repeat: true);
    // There is a 1 second pause after the game resumes.
    _freezeTimer = Timer(5, callback: () {
      _timer.start();
    });
  }

  /// This spawns enemy objects when the timer triggers.
  void _spawnBoss() {
    if (conditionCount < _winCondition) {
      _idCount += 1;
      Boss newBoss = _bossFactory.getBossType(_bossTypes[_bossCount], _idCount);
      gameRef.bossTracker.addBoss(newBoss);
      gameRef.add(newBoss);
    } else {
      _timer.stop();
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
    _timer.stop();
  }

  /// Update the timers when the game engine is running.
  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    _freezeTimer.update(dt);
  }

  /// Reset the timers and IDs when the game engine resets.
  void reset() {
    _timer.stop();
    _timer.start();
    _idCount = 0;
  }

  void stop() {
    _timer.stop();
  }

  void start() {
    _timer.start();
  }

  /// Freeze the timers when the game engine is pausing.
  void freeze() {
    _timer.stop;
    _freezeTimer.stop;
    _freezeTimer.start();
  }

  void incrementWinCondition() {
    conditionCount += 1;
  }
}
