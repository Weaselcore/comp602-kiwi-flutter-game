import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/laser_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/shield_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/slomo_powerup.dart';
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

  bool hasLaser = false;
  bool godMode = false;

  late Sprite _kiwiSprite;
  late Sprite _kiwiWeakShieldSprite;
  late Sprite _kiwiMediumShieldSprite;
  late Sprite _kiwiStrongShieldSprite;

  Kiwi({
    sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    _kiwiSprite = sprite;
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  Future<void> onLoad() async {
    Image _weakShieldImage = await Flame.images.load("weak_shield_sprite.png");
    Image _mediumShieldImage =
        await Flame.images.load("medium_shield_sprite.png");
    Image _strongShieldImage =
        await Flame.images.load("strong_shield_sprite.png");

    _kiwiWeakShieldSprite = Sprite(_weakShieldImage);
    _kiwiMediumShieldSprite = Sprite(_mediumShieldImage);
    _kiwiStrongShieldSprite = Sprite(_strongShieldImage);

    final hitBoxShape = HitboxCircle(definition: 0.6);
    addShape(hitBoxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position +=
        _horizontalMoveDirection.normalized() * _horizontalSpeed * dt;

    switch (_shieldCount) {
      case 0:
        this.sprite = _kiwiSprite;
        break;
      case 1:
        this.sprite = _kiwiWeakShieldSprite;
        break;
      case 2:
        this.sprite = _kiwiMediumShieldSprite;
        break;
      case 3:
        this.sprite = _kiwiStrongShieldSprite;
        break;
    }

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

    if (other is Enemy && !godMode) {
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
    } else if (other is SlomoPowerUp) {
      other.remove();
      gameRef.halfEnemySpeed();
    } else if (other is LaserPowerUp) {
      other.remove();
      if (!hasLaser) {
        fireLaser();
      }
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

  void fireLaser() {
    if (!hasLaser) {
      hasLaser = true;
      gameRef.fireLaser();
    }
  }

  void removeLaser() {
    hasLaser = false;
    gameRef.removeLaser();
  }

  void die() {
    gameRef.gameEnded = true;
    gameRef.pauseEngine();
    gameRef.overlays.remove(PauseButton.ID);
    gameRef.overlays.add(EndGameMenu.ID);
    _shieldCount = 0;
    this.removeLaser();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  int getShieldCount() => _shieldCount;

  bool hasShield() {
    if (_shieldCount > 0) {
      return true;
    } else {
      return false;
    }
  }
}
