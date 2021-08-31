import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import '../../game_size_aware.dart';

class PowerUp extends SpriteComponent
    with HasGameRef<KiwiGame>, GameSizeAware, Hitbox, Collidable {
  late int id;
  static const double powerupSpeed = 100;

  late Vector2 _leftMove = Vector2(-1, 0);
  late Vector2 _rightMove = Vector2(1, 0);
  late Vector2 _toMove;
  late bool _movingLeft;

  PowerUp(this.id) {
    Random randomDirection = Random();
    if (randomDirection.nextDouble() < 0.5) {
      _toMove = _rightMove;
      _movingLeft = false;
    } else {
      _toMove = _leftMove;
      _movingLeft = true;
    }
  }

  void render(Canvas canvas);

  @override
  void update(double dt) {
    super.update(dt);

    // If the power up touches the edge of the screen, change directions.
    if (_movingLeft && (position.x < 50)) {
      _switchHorizontalDirection();
    } else if (!_movingLeft && (position.x > gameSize.x - 50)) {
      _switchHorizontalDirection();
    }

    _toMove = !_movingLeft ? _rightMove : _leftMove;

    this.position += (Vector2(0, -1) + _toMove) * powerupSpeed * dt;

    // The crates get destroyed off screen.
    if (this.position.y < -100) {
      gameRef.powerUpTracker.removePowerUp(id);
    }
  }

  double getYPosition() => this.position.y;

  void _switchHorizontalDirection() {
    // Flips horizontal vector 180 degrees.
    _movingLeft = !_movingLeft;
  }
}
