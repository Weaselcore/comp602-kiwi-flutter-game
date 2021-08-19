import 'package:flame/components.dart';
import 'package:flutter_game/game/game_size_aware.dart';

class Kiwi extends SpriteComponent with GameSizeAware {
  // The kiwi is initialised in the center with no motion.
  Vector2 _horizontalMoveDirection = Vector2.zero();
  double _horizontalSpeed = 100;

  Kiwi({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.position +=
        _horizontalMoveDirection.normalized() * _horizontalSpeed * dt;

    this.position.clamp(
          Vector2.zero() + this.size / 2,
          gameSize - this.size / 2,
        );
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _horizontalMoveDirection = newMoveDirection;
  }
}
