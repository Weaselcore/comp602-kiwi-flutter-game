import 'package:flame/components.dart';
import 'package:flutter_game/game/game_size_aware.dart';

class Kiwi extends SpriteComponent with GameSizeAware {
  // The kiwi is initialised in the center with no motion.
  Vector2 _horizontalMoveDirection = Vector2.zero();
  double _horizontalSpeed = 200;

  Kiwi({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  // TODO add hitbox component in this method to register collision.
  @override
  void onMount() {
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.position +=
        _horizontalMoveDirection.normalized() * _horizontalSpeed * dt;

    if (_horizontalMoveDirection.x < 0) {
      this.renderFlipX = false;
    } else {
      this.renderFlipX = true;
    }
    // This keeps the kiwi on the screen.
    this.position.clamp(
          Vector2.zero() + this.size / 3,
          gameSize - this.size / 3,
        );
  }

  void goRight() {
    _horizontalMoveDirection = Vector2(1, 0);
    print("Kiwi going right.");
  }

  void goLeft() {
    _horizontalMoveDirection = Vector2(-1, 0);
    print("Kiwi going left.");
  }

  void stop() {
    _horizontalMoveDirection = Vector2.zero();
    print("Kiwi is stopping.");
  }
}
