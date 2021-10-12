import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';

import 'boss.dart';

class FalconBoss extends Boss {
  late Vector2 startingPosition;

  Random random = Random();

  FalconBoss(int idCount) : super(id: idCount, enemySpeed: 150);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('boss_falcon.png');
    size = Vector2(150, 150);
    position = this.getPosition() - size;

    final hitboxShape = HitboxCircle(definition: 0.6);
    addShape(hitboxShape);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  Vector2 getPosition() {
    // Vector2 initialSize = Vector2(64, 64);

    double randomPositionMultiplier = random.nextDouble();

    Vector2 position = Vector2(randomPositionMultiplier * gameRef.canvasSize.x,
        gameRef.canvasSize.y + 100);

    position.clamp(
      Vector2.zero() + Vector2(150, 0),
      gameRef.canvasSize + Vector2(150, 0),
    );

    print("Spawning thundercloud at $position");

    return position;
  }
}
