import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/components/boss/wizard_lighting.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/boss_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/laser_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/shield_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/slomo_powerup.dart';
import 'package:flutter_game/game/game_size_aware.dart';
import 'package:flutter_game/game/kiwi_game.dart';
import 'package:flutter_game/game/overlay/end_game_menu.dart';
import 'package:flutter_game/game/overlay/pause_button.dart';

import 'package:flutter_game/screens/dailyQuest/quest_manager.dart';
import 'package:flutter_game/screens/score_item.dart';

import 'enemy/enemy.dart';
import 'boss/boss.dart';
import 'boss/ufo_bullet.dart';

class Kiwi extends SpriteComponent
    with
        GameSizeAware,
        Hitbox,
        Collidable,
        HasGameRef<KiwiGame>,
        JoystickListener {
  // The kiwi is initialised in the center with no motion.
  Vector2 _kiwiDirection = Vector2.zero();
  double _kiwiSpeed = 200;

  bool _spriteOrientationDefault = false;
  bool isLoaded = false;
  int _shieldCount = 0;

  bool hasLaser = false;
  bool godMode = false;

  Queue powerUpQueue = Queue();

  late Sprite _kiwiSprite;
  late Sprite _kiwiWeakShieldSprite;
  late Sprite _kiwiMediumShieldSprite;
  late Sprite _kiwiStrongShieldSprite;

  Kiwi({Sprite? sprite, Vector2? position, Vector2? size, bool godMode = false})
      : super(sprite: sprite, position: position, size: size) {
    _kiwiSprite = sprite!;
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

    isLoaded = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += _kiwiDirection.normalized() * _kiwiSpeed * dt;

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

  void reset() {
    this.position = Vector2(gameSize.x / 2, gameSize.y / 3);
    resetPowerUp();
    if (hasLaser) {
      removeLaser();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is ShieldPowerUp ||
        other is SlomoPowerUp ||
        other is LaserPowerUp ||
        other is BossPowerUp) {
      addPowerUp(other as PowerUp);
      other.remove();
    } else if (other is Enemy && !godMode) {
      // If enemy has not been nullified by shield.
      if (other.canDamage()) {
        if (_shieldCount == 0 && other.canDamage()) {
          die();
        } else if (_shieldCount > 0 && other.canDamage()) {
          other.toggleDamage();
          removeShield();
        }
      }
    }
    if (other is Boss && !godMode) {
      // If enemy has not been nullified by shield.
      if (other.canDamage()) {
        if (_shieldCount == 0 && other.canDamage()) {
          die();
        } else if (_shieldCount > 0 && other.canDamage()) {
          other.toggleDamage();
          removeShield();
        }
      }
    }
    if (other is UfoBullet && !godMode) {
      // If enemy has not been nullified by shield.
      if (other.canDamage()) {
        if (_shieldCount == 0 && other.canDamage()) {
          die();
        } else if (_shieldCount > 0 && other.canDamage()) {
          other.toggleDamage();
          removeShield();
        }
      }
    }
    if (other is WizardLightning && !godMode) {
      // If enemy has not been nullified by shield.
      die();
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
    gameRef.audioManager.playSfx('death.mp3');
    gameRef.audioManager.stopBgm();
    gameRef.pauseEngine();
    gameRef.overlays.remove(PauseButton.ID);
    gameRef.overlays.add(EndGameMenu.ID);
    _shieldCount = 0;
    hasLaser = false;
    QuestManager.checkQuestCompletion(gameRef.coin, gameRef.score,
        gameRef.usedItem, gameRef.beatenEnemy, gameRef.beatenBoss);
    gameRef.localScoreDao.register(ScoreItem('user', gameRef.score));
    gameRef.remoteScoreDao.register();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  int getShieldCount() => _shieldCount;

  void setHorizontalSpeed(double speed) {
    _kiwiSpeed = speed;
  }

  bool hasShield() {
    if (_shieldCount > 0) {
      return true;
    } else {
      return false;
    }
  }

  void goRight() {
    _kiwiDirection = Vector2(1, 0);
    _spriteOrientationDefault = true;
  }

  void goLeft() {
    _kiwiDirection = Vector2(-1, 0);
    _spriteOrientationDefault = false;
  }

  void goUp() {
    _kiwiDirection = Vector2(1, 0);
    _spriteOrientationDefault = true;
  }

  void goDown() {
    _kiwiDirection = Vector2(-1, 0);
    _spriteOrientationDefault = false;
  }

  void stop() {
    _kiwiDirection = Vector2.zero();
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (powerUpQueue.isNotEmpty && event.event == ActionEvent.down) {
      removePowerUp();
    }
  }

  void setMoveDirection(Vector2 newKiwiDirection) {
    _kiwiDirection = newKiwiDirection;
  }

  Queue getPowerUpQueue() => powerUpQueue;

  void resetPowerUp() {
    powerUpQueue.clear();
  }

  void addPowerUp(PowerUp powerUp) {
    if (!(powerUpQueue.length >= 2)) {
      powerUpQueue.add(powerUp);
    }
  }

  void removePowerUp() {
    PowerUp powerUp = powerUpQueue.first;
    if (powerUp is LaserPowerUp) {
      useLaser();
    } else if (powerUp is ShieldPowerUp) {
      useShield();
    } else if (powerUp is SlomoPowerUp) {
      useSlomo();
    } else if (powerUp is BossPowerUp) {
      useBossSpawn();
    }
    powerUpQueue.remove(powerUp);
    gameRef.usedItem += 1;
  }

  void useShield() {
    gameRef.audioManager.playSfx('armour.wav');
    addShield();
  }

  void useSlomo() {
    gameRef.audioManager.playSfx('slow_time.wav');
    gameRef.halfEnemySpeed();
  }

  void useLaser() {
    if (!hasLaser) {
      fireLaser();
      gameRef.audioManager.playSfx('laser.mp3');
    }
  }

  void useBossSpawn() {
    gameRef.powerUpManager.switchToShield();
    gameRef.enemyManager.stop();
    gameRef.bossManager.spawnBoss();
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    switch (event.directional) {
      case JoystickMoveDirectional.moveUp:
        this.setMoveDirection(Vector2(0, -1));
        break;
      case JoystickMoveDirectional.moveUpLeft:
        this.setMoveDirection(Vector2(-1, -1));
        break;
      case JoystickMoveDirectional.moveUpRight:
        this.setMoveDirection(Vector2(1, -1));
        break;
      case JoystickMoveDirectional.moveRight:
        this.setMoveDirection(Vector2(1, 0));
        break;
      case JoystickMoveDirectional.moveDown:
        this.setMoveDirection(Vector2(0, 1));
        break;
      case JoystickMoveDirectional.moveDownRight:
        this.setMoveDirection(Vector2(1, 1));
        break;
      case JoystickMoveDirectional.moveDownLeft:
        this.setMoveDirection(Vector2(-1, 1));
        break;
      case JoystickMoveDirectional.moveLeft:
        this.setMoveDirection(Vector2(-1, 0));
        break;
      case JoystickMoveDirectional.idle:
        this.setMoveDirection(Vector2.zero());
        break;
    }
  }
}
