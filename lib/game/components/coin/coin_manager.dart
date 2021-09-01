import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/game/components/coin/coin.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class CoinManager extends BaseComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  late Timer _timer;
  late Timer _freezeTimer;
  int _idCount = 0;

  Random random = Random();

  CoinManager() : super() {
    _timer = Timer(1.5, callback: _spawnCoin, repeat: true);
    _freezeTimer = Timer(2.0, callback: () {
      _timer.start();
    });
  }

  void _spawnCoin() {
    if (random.nextDouble() > 0.4) {
      if (gameRef.buildContext != null) {
        _idCount += 1;
        gameRef.add(Coin(_idCount));
      }
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
