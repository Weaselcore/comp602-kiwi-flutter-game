import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_game/game/components/powerups/powerup_types/shield_powerup.dart';
import 'package:flutter_game/game/game_size_aware.dart';
import 'package:flutter_game/game/kiwi_game.dart';
import 'package:flutter_game/game/overlay/end_game_menu.dart';
import 'package:flutter_game/game/overlay/pause_button.dart';

import 'package:flutter_game/game/components/enemy/enemy.dart';

class Kiwi extends SpriteComponent
    with GameSizeAware, Hitbox, Collidable, HasGameRef<KiwiGame> {
  // The kiwi is initialised in the center with no motion.
  Vector2 _horizontalMoveDirection = Vector2.zero();
  double _horizontalSpeed = 200;
  bool _spriteOrientationDefault = false;
  int _shieldCount = 0;

  Kiwi({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  @override
  void onMount() {
    super.onMount();

    final hitboxShape = HitboxCircle(definition: 0.6);
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.position +=
        _horizontalMoveDirection.normalized() * _horizontalSpeed * dt;

    if (_spriteOrientationDefault) {
      this.renderFlipX = true;
    } else {
      this.renderFlipX = false;
    }

    // This keeps the kiwi on the screen.
    this.position.clamp(
          Vector2.zero() + this.size / 3,
          gameSize - this.size / 3,
        );
  }

  void goRight() {
    _horizontalMoveDirection = Vector2(1, 0);
    _spriteOrientationDefault = true;
  }

  void goLeft() {
    _horizontalMoveDirection = Vector2(-1, 0);
    _spriteOrientationDefault = false;
  }

  void stop() {
    _horizontalMoveDirection = Vector2.zero();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      // If enemy has not been nullified by shield.
      if (other.canDamage()) {
        if (_shieldCount == 0 && other.canDamage()) {
          die();
        } else if (_shieldCount > 0 && other.canDamage()) {
          other.toggleDamage();
          removeShield();
        }
      }
    } else if (other is ShieldPowerUp) {
      other.remove();
      addShield();
    }
  }

  double getYPosition() => this.position.y;

  void addShield() {
    if (_shieldCount < 3) {
      _shieldCount += 1;
    }
  }

  void removeShield() {
    if (_shieldCount > 0) {
      _shieldCount -= 1;
    }
  }

  void die() {
    gameRef.gameEnded = true;
    gameRef.pauseEngine();
    gameRef.overlays.remove(PauseButton.ID);
    gameRef.overlays.add(EndGameMenu.ID);
  }

  int getShieldCount() => _shieldCount;
}
