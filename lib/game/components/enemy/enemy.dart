import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game/game/kiwi_game.dart';

class Enemy extends SpriteComponent
    with HasGameRef<KiwiGame>, Hitbox, Collidable {
  late int id;
  late bool passedKiwi = false;
  static const double enemySpeed = 200;
  bool _canDamage = true;

  Enemy(this.id);

  void render(Canvas canvas);

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, -1).normalized() * enemySpeed * dt;

    // The enemies get destroyed off screen.
    if (this.position.y < -100) {
      gameRef.scoreTracker.removeEnemy(id);
      print("Removing enemy with ID($id)");
      remove();
    }
  }

  void toggleDamage() {
    _canDamage = false;
  }

  bool canDamage() => _canDamage;

  double getYPosition() => this.position.y;
}
