import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class WizardLightning extends SpriteComponent
    with GameSizeAware, HasGameRef<KiwiGame>, Hitbox, Collidable {
  //spawn position of component
  late Vector2 _startingPosition;

  //timer to remove component from game
  late Timer _fadeTimer;

  WizardLightning(Vector2 startingPosition) {
    _startingPosition = startingPosition;
    _fadeTimer = Timer(2, callback: despawn);
    _fadeTimer.start();
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('lightning.png');
    size = Vector2(gameSize.x / 3, gameSize.y);
    position = _startingPosition;

    //hit box for lightning bolt
    final hitboxShape = HitboxRectangle();
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _fadeTimer.update(dt);
  }

  //allow collisions with player
  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
  }

  //remove component from the game
  void despawn() {
    remove();
  }
}
