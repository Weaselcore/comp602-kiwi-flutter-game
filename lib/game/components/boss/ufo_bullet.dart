import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import '../../kiwi_game.dart';

class UfoBullet extends SpriteComponent
    with GameSizeAware, HasGameRef<KiwiGame>, Hitbox, Collidable {
  double _speed = 200;
  late Vector2 startingPosition;

  // A randomiser object is used to calculate random particles.
  Random _random = Random();

  bool _canDamage = true;

  UfoBullet(Vector2 startingPosition) {
    this.startingPosition = startingPosition;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('laser_bullet.png');
    size = Vector2(100, 100);
    position = startingPosition;

    final hitboxShape = HitboxCircle(definition: 0.6);
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, 1) * this._speed * dt;

    if (this.position.y > (gameSize.y + 100)) {
      remove();
    }
  }

  /// Disables the ability to damage the kiwi.
  void toggleDamage() {
    _canDamage = false;
    die();
  }

  /// Returns if the enemy object can damage.
  bool canDamage() => _canDamage;

  /// This method generates a random vector with its angle
  /// between from 0 and 360 degrees.
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  /// Returns a random direction vector with slight angle to positive y axis.
  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    // if (other is Kiwi) {
    //   if (other.hasShield()) {
    //     die();
    //   }
    // }
  }

  /// Destroys the enemy object and removes the component from the game with style.
  void die() {
    // Removes enemy object from base game.
    this.remove();
    gameRef.audioManager.playSfx('pop.wav');
    gameRef.camera.shake(intensity: 5);

    // Generate 25 white circle particles with random speed and acceleration,
    // at current position of this enemy. Each particles lives for exactly
    // 0.3 seconds and will get removed from the game world after that.
    final particleComponent = ParticleComponent(
      particle: Particle.generate(
        count: 25,
        lifespan: 0.3,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: this.position.clone() + Vector2(75, 75),
          child: CircleParticle(
            radius: 3,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );

    // Add particle where the enemy object has been removed.
    gameRef.add(particleComponent);
  }
}
