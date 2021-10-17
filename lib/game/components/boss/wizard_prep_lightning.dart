import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class PrepLightning extends SpriteComponent
    with GameSizeAware, HasGameRef<KiwiGame> {
  late Vector2 _startingPosition;

  late Timer _fadeTimer;

  PrepLightning(Vector2 startingPosition) {
    _startingPosition = startingPosition;
    _fadeTimer = Timer(2, callback: despawn);
    _fadeTimer.start();
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('white.png');
    size = Vector2(gameSize.x / 3, gameSize.y);
    position = _startingPosition;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _fadeTimer.update(dt);
  }

  void despawn() {
    remove();
  }
}
