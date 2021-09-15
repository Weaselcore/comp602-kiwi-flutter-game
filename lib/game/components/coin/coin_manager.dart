import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/coin/coin.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class CoinManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  // A timer that causes spawns to occur.
  late Timer _timer;
  // A time that cause a small freeze when the game engine pauses.
  late Timer _freezeTimer;
  // Coin manager keeps track of coin instances and assigns them unique IDs.
  int _idCount = 0;

  // A randomiser for the type of enemy to spawn.
  Random random = Random();

  CoinManager() : super() {
    _timer = Timer(1.5, callback: _spawnCoin, repeat: true);
    _freezeTimer = Timer(2.0, callback: () {
      _timer.start();
    });
  }

  /// This spawns coin objects when the timer triggers.
  void _spawnCoin() {
    // Adds a 60% chance to spawn.
    if (random.nextDouble() > 0.4) {
      if (gameRef.buildContext != null) {
        // Increment count by one per spawn.
        _idCount += 1;
        // Add coin to the game.
        gameRef.add(Coin(_idCount));
      }
    }
  }

  /// Start timer when the widget gets mounted.
  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

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

  /// Freeze the timers when the game engine is pausing.
  void freeze() {
    _timer.stop;
    _freezeTimer.stop;
    _freezeTimer.start();
  }
}
