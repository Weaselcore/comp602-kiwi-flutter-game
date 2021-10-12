import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';

import 'boss.dart';

class FalconBoss extends Boss {
  late Vector2 startingPosition;
  late Timer _swoopTimer;
  Vector2 swoopRightVector = Vector2(1.0, 0.0);
  Vector2 swoopLeftVector = Vector2(-1.0, 0.0);
  late Vector2 direction;

  bool _spriteOrientationDefault = false;
  bool isSwoopDown = true;

  Random random = Random();

  FalconBoss(int idCount, bool swoopRight)
      : super(id: idCount, enemySpeed: 150) {
    direction = swoopRight ? swoopRightVector : swoopLeftVector;
    _swoopTimer = Timer(3, callback: swoopUp, repeat: true);
    _swoopTimer.start();
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('boss_falcon.png');
    size = Vector2(150, 150);
    position = this.getPosition() - size;

    final hitboxShape = HitboxCircle(definition: 0.6);
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isSwoopDown) {
      this.position += swoopDown().normalized() * enemySpeed * dt;
    } else {
      this.position += swoopUp().normalized() * enemySpeed * dt;
    }
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

    print("Spawning boss falcon at $position");

    return position;
  }

  void spriteFlipOrientation() {
    _spriteOrientationDefault = !_spriteOrientationDefault;
  }

  Vector2 swoopDown() => direction + Vector2(0.0, 1.0);

  Vector2 swoopUp() => direction + Vector2(0.0, -1.0);
}
