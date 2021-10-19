import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/game_size_aware.dart';

class CrateEnemy extends Enemy with GameSizeAware {
  late Vector2 startingPosition;

  Random random = Random();

  CrateEnemy(int idCount) : super(id: idCount, currentSpeed: 200);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('rock_sprite.png');
    size = Vector2(90, 90);
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

    this.position += Vector2(0, -1).normalized() * this.currentSpeed * dt;
  }

  Vector2 getPosition() {
    // TODO create a class attribute that uses this Vector.
    //Vector2 initialSize = Vector2(64, 64);

    double randomPositionMultiplier = random.nextDouble();

    Vector2 position =
        Vector2(randomPositionMultiplier * gameSize.x, gameSize.y + 200);

    position.clamp(
      Vector2.zero() + Vector2(150, 0),
      gameSize + Vector2(150, 150),
    );

    print("Spawning thundercloud at $position");

    return position;
  }
}
