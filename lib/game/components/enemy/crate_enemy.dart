import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/game_size_aware.dart';

class CrateEnemy extends Enemy with GameSizeAware, Hitbox, Collidable {
  static const double enemySpeed = 400;
  late Vector2 startingPosition;

  Random random = Random();

  CrateEnemy();

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('crate_sprite.png');
    size = Vector2(160, 84);
    position = this.getPosition() - size;

    final hitboxShape = HitboxCircle(definition: 0.8);
    addShape(hitboxShape);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, -1).normalized() * enemySpeed * dt;

    // The crates get destroyed off screen.
    if (this.position.y < -100) {
      remove();
    }
  }

  Vector2 getPosition() {
    Vector2 initialSize = Vector2(64, 64);

    random.nextDouble();
    random.nextDouble();
    random.nextDouble();

    Vector2 position =
        Vector2(random.nextDouble() * gameSize.x, gameSize.y + 100);

    position.clamp(
      Vector2.zero() + initialSize / 2,
      gameSize + initialSize,
    );

    return position;
  }
}
