import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/kiwi.dart';
import 'package:flutter_game/game/components/powerup/component/laser_beam.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import 'package:flame_audio/flame_audio.dart';

class Enemy extends SpriteComponent
    with HasGameRef<KiwiGame>, Hitbox, Collidable {
  // Every enemy gets assigned a unique ID so it can be tracked and removed.
  late int id;
  // A flag to check if the enemy has passed the kiwi so scoring can be tracked.
  late bool passedKiwi = false;
  late final double originalSpeed;
  late final double slowSpeed;
  late double enemySpeed;

  // A randomiser object is used to calculate random particles.
  Random _random = Random();

  // A flag for shield interaction, if the kiwi has collided with the shield,
  // the enemy should not be able collide with the kiwi on subsequent updates.
  bool _canDamage = true;
  // A flag to toggle slow state when the kiwi has picked up the slow powerup.
  bool _isSlowed = false;

  Enemy({required this.id, required this.enemySpeed}) {
    this.originalSpeed = enemySpeed;
    slowSpeed = enemySpeed * 0.50;
  }

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
  void update(double dt) {
    super.update(dt);

    // Enemies are constantly moving upwards.
    this.position += Vector2(0, -1).normalized() * enemySpeed * dt;

    // The enemies get destroyed off screen using their unique ID.
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
      // Getting hit by the laser beam will kill the enemy object.
      die();
    }
  }

  /// Disables the ability to damage the kiwi.
  void toggleDamage() {
    _canDamage = false;
    die();
  }

  /// Returns if the enemy object can damage.
  bool canDamage() => _canDamage;

  /// Returns y position.
  double getYPosition() => this.position.y;

  /// Triggers the slow speeds when kiwi picks up slow powerup.
  void halfSpeed() {
    enemySpeed = slowSpeed;
    _isSlowed = true;
  }

  /// Gives back original speed when slow powerup ends.
  void restoreSpeed() {
    enemySpeed = originalSpeed;
    _isSlowed = false;
  }

  /// Returns if the enemy object is slowed.
  bool isSlowed() => _isSlowed;

  /// Destroys the enemy object and removes the component from the game with style.
  void die() {
    // Removes enemy object from base game.
    this.remove();
    gameRef.audioManager.playSfx('pop.wav');
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

    // Add particle where the enemy object has been removed.
    gameRef.add(particleComponent);

    // Disposes and removes reference of the enemy from the tracker.
    gameRef.enemyTracker.removeEnemy(id);
  }
}
