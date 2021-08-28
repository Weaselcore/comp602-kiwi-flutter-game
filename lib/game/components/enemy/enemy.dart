import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game/game/kiwi_game.dart';

class Enemy extends SpriteComponent with HasGameRef<KiwiGame> {
  late int id;
  late bool passedKiwi = false;
  static const double enemySpeed = 200;

  Enemy(this.id);

  void render(Canvas canvas);

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, -1).normalized() * enemySpeed * dt;

    // The crates get destroyed off screen.
    if (this.position.y < -100) {
      gameRef.scoreTracker.removeEnemy();
      print("Removing enemy with ID($id)");
      remove();
    }
  }

  double getYPosition() => this.position.y;
}
