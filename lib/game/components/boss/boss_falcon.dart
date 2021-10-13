import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';

import 'boss.dart';

class FalconBoss extends Boss {
  late Vector2 startingPosition;
  late Timer _swoopTimer;
  double swoopRightVector = 1.0;
  double swoopLeftVector = -1.0;
  late double direction;

  bool _spriteOrientationDefault = false;
  bool isSwoopDown = true;

  Random random = Random();

  FalconBoss(int idCount) : super(id: idCount, enemySpeed: 400) {
    bool swoopRight = directionRandomiser();
    direction = swoopRight ? swoopRightVector : swoopLeftVector;
    _swoopTimer = Timer(1.0, callback: swoopToggle, repeat: true);
    _swoopTimer.start();
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('boss_falcon.png');
    size = Vector2(400, 400);
    position = this.getPosition() - size / 2;

    final hitboxShape = HitboxCircle(definition: 0.6);
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _swoopTimer.update(dt);
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
    Vector2 position;

    double randomPositionMultiplier = random.nextDouble();

    if (direction == 1.0) {
      position = Vector2(
          -150, randomPositionMultiplier * gameRef.viewport.canvasSize.y);
    } else {
      position = Vector2(gameRef.canvasSize.x + 100,
          randomPositionMultiplier * gameRef.viewport.canvasSize.y);
      print(gameRef.canvasSize.x);
      spriteFlipOrientation();
    }

    print("Spawning BossFalcon at $position");

    return position;
  }

  void spriteFlipOrientation() {
    _spriteOrientationDefault = !_spriteOrientationDefault;
    this.renderFlipX = _spriteOrientationDefault == !renderFlipX ? true : false;
  }

  void swoopToggle() {
    isSwoopDown = !isSwoopDown;
  }

  Vector2 swoopDown() => Vector2(direction, 0.5);

  Vector2 swoopUp() => Vector2(direction, -0.5);

  @override
  void die() {
    super.die();
    gameRef.bossManager.incrementWinCondition();
  }

  bool directionRandomiser() {
    return this.random.nextDouble() > 0.5 ? true : false;
  }
}
