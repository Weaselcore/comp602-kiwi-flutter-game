import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/kiwi.dart';
import 'package:flutter_game/game/components/powerup/component/laser_beam.dart';
import 'package:flutter_game/game/kiwi_game.dart';

class Enemy extends SpriteComponent
    with HasGameRef<KiwiGame>, Hitbox, Collidable {
  late int id;
  late bool passedKiwi = false;
  late final double originalSpeed;
  late final double slowSpeed;
  late double enemySpeed;

  Random _random = Random();

  bool _canDamage = true;
  bool _isSlowed = false;

  Enemy({required this.id, required this.enemySpeed}) {
    this.originalSpeed = enemySpeed;
    slowSpeed = enemySpeed * 0.50;
  }

  // This method generates a random vector with its angle
  // between from 0 and 360 degrees.
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  // Returns a random direction vector with slight angle to +ve y axis.
  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, -1).normalized() * enemySpeed * dt;

    // The enemies get destroyed off screen.
    if (this.position.y < -100) {
      gameRef.enemyTracker.removeEnemy(id);
      print("Removing enemy with ID($id)");
      remove();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Kiwi) {
      if (other.hasShield()) {
        die();
      }
    } else if (other is LaserBeam) {
      die();
    }
  }

  void toggleDamage() {
    _canDamage = false;
    die();
  }

  bool canDamage() => _canDamage;

  double getYPosition() => this.position.y;

  void halfSpeed() {
    enemySpeed = slowSpeed;
    _isSlowed = true;
  }

  void restoreSpeed() {
    enemySpeed = originalSpeed;
    _isSlowed = false;
  }

  bool isSlowed() => _isSlowed;

  void die() {
    this.remove();
    print("Removing enemy with ID($id)");
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

    gameRef.add(particleComponent);
    gameRef.enemyTracker.removeEnemy(id);
  }
}
