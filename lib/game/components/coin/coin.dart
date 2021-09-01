import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_game/game/game_size_aware.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import '../kiwi.dart';

class Coin extends SpriteAnimationComponent
    with HasGameRef<KiwiGame>, Hitbox, Collidable, GameSizeAware {
  late int id;
  double coinSpeed = 75;
  int _scoreWorth = 5;
  Random _random = Random();

  Coin(this.id) : super();

  @override
  Future<void> onLoad() async {
    final coinSprite =
        [1, 2, 3, 4, 5, 6].map((e) => Sprite.load('coin_$e.png'));

    final coinAnimation = SpriteAnimation.spriteList(
        await Future.wait(coinSprite),
        stepTime: 0.4);

    this.animation = coinAnimation;
    this.size = Vector2(64, 64);
    position = this.getPosition() - size;

    final hitBoxShape = HitboxCircle(definition: 0.6);
    addShape(hitBoxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, -1).normalized() * coinSpeed * dt;

    if (this.position.y < -100) {
      gameRef.powerUpTracker.removePowerUp(id);
    }
  }

  Vector2 getPosition() {
    double randomPositionMultiplier = _random.nextDouble();

    Vector2 position =
        Vector2(randomPositionMultiplier * gameSize.x, gameSize.y + 100);

    position.clamp(
      Vector2.zero() + Vector2(64, 0),
      gameSize + Vector2(64, 0),
    );

    print("Spawning coin at $position");
    return position;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Kiwi) {
      gameRef.incrementScore(_scoreWorth);
      gameRef.coin += 1;
      gameRef.coinTracker.removeCoin(id);
      this.remove();
    }
  }
}
