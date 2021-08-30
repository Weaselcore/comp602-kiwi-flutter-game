import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game/game/kiwi_game.dart';

class Enemy extends SpriteComponent
    with HasGameRef<KiwiGame>, Hitbox, Collidable {
  late int id;
  late bool passedKiwi = false;
  late final double originalSpeed;
  late final double slowSpeed;
  late double enemySpeed;
  bool _canDamage = true;
  bool _isSlowed = false;

  Enemy(this.id, double enemySpeed) {
    this.enemySpeed = enemySpeed;
    this.originalSpeed = enemySpeed;
    slowSpeed = enemySpeed * 0.50;
  }

  void render(Canvas canvas);

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

  void toggleDamage() {
    _canDamage = false;
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
}
