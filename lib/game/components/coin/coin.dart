import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_game/game/game_size_aware.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import '../kiwi.dart';

class Coin extends SpriteAnimationComponent
    with HasGameRef<KiwiGame>, Hitbox, Collidable, GameSizeAware {
  late int id;
  // Value that stores the speed of the coin.
  double coinSpeed = 75;
  // A value that dictates the scoring when collecting coin.
  int _scoreWorth = 5;
  // Add randomiser for spawn.
  Random _random = Random();

  Coin(this.id) : super();

  @override
  Future<void> onLoad() async {
    // Loads the 6 sprites that make up the animation,
    final coinSprite =
        [1, 2, 3, 4, 5, 6].map((e) => Sprite.load('coin_$e.png'));

    // Create animation with step timing for 0.4 second per sprite.
    final coinAnimation = SpriteAnimation.spriteList(
        await Future.wait(coinSprite),
        stepTime: 0.4);

    this.animation = coinAnimation;
    this.size = Vector2(64, 64);
    position = this.getPosition() - size;

    // Add hitbox to the coin.
    final hitBoxShape = HitboxCircle(definition: 0.6);
    addShape(hitBoxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Moves the coin upwards per update.
    this.position += Vector2(0, -1).normalized() * coinSpeed * dt;

    // When the coin moves out of view it is then removed.
    if (this.position.y < -100) {
      gameRef.powerUpTracker.removePowerUp(id);
    }
  }

  /// Returns the position of the coin to be spawned.
  Vector2 getPosition() {
    // Randomised double between 0.0 to 1.0 is created.
    double randomPositionMultiplier = _random.nextDouble();

    Vector2 position =
        // The randomised number is multiplied with the screen size so it spawns
        // on screen.
        Vector2(randomPositionMultiplier * gameSize.x, gameSize.y + 100);

    // The coin will be clamped into position if there are plans for moving
    // coins.
    position.clamp(
      Vector2.zero() + Vector2(64, 0),
      gameSize + Vector2(64, 0),
    );

    print("Spawning coin at $position");
    return position;
  }

  /// Dictates what happens when the coin collides with another collidable.
  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    // When colliding with Kiwi, increment score and coins collected.
    if (other is Kiwi) {
      gameRef.incrementScore(_scoreWorth);
      gameRef.coin += 1;
      gameRef.coinTracker.removeCoin(id);
      // Remove from the game.
      this.remove();
    }
  }
}
