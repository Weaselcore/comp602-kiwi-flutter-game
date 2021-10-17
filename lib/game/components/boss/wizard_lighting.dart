import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class WizardLightning extends SpriteComponent
    with GameSizeAware, HasGameRef<KiwiGame>, Hitbox, Collidable {
  late Vector2 _startingPosition;

  late Timer _fadeTimer;

  bool _canDamage = true;

  WizardLightning(Vector2 startingPosition) {
    _startingPosition = startingPosition;
    _fadeTimer = Timer(2, callback: despawn);
    _fadeTimer.start();
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('pixsky.png');
    size = Vector2(gameSize.x / 3, gameSize.y);
    position = _startingPosition;

    final hitboxShape = HitboxRectangle();
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _fadeTimer.update(dt);
  }

  /// Returns if the enemy object can damage.
  bool canDamage() => _canDamage;

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
  }

  void despawn() {
    remove();
  }
}
