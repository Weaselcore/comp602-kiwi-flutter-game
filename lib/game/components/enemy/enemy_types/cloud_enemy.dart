import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/game_size_aware.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

class CloudEnemy extends Enemy with GameSizeAware, Hitbox, Collidable {
  late Vector2 startingPosition;

  Random random = Random();

  CloudEnemy(int idCount) : super(idCount);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('thunder_cloud_sprite.png');
    size = Vector2(150, 150);
    position = this.getPosition() - size;

    final hitboxShape = HitboxCircle(definition: 0.8);
    addShape(hitboxShape);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  Vector2 getPosition() {
    // Vector2 initialSize = Vector2(64, 64);

    Vector2 position =
        Vector2(random.nextDouble() * gameSize.x, gameSize.y + 100);

    position.clamp(
      Vector2.zero() + Vector2(150, 0),
      gameSize + Vector2(150, 0),
    );

    print("Spawning thundercloud at $position");

    return position;
  }
}
