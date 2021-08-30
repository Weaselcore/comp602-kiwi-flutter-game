import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/game_size_aware.dart';

class ShieldPowerUp extends PowerUp with GameSizeAware {
  late Vector2 startingPosition;

  Random random = Random();

  ShieldPowerUp(int idCount) : super(idCount);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('shield_powerup_sprite.png');
    size = Vector2(150, 150);
    position = this.getPosition() - size;

    final hitboxShape = HitboxCircle(definition: 0.5);
    addShape(hitboxShape);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  Vector2 getPosition() {
    // Vector2 initialSize = Vector2(64, 64);

    double randomPositionMultiplier = random.nextDouble();

    Vector2 position =
        Vector2(randomPositionMultiplier * gameSize.x, gameSize.y + 150);

    position.clamp(
      Vector2.zero() + Vector2(150, 0),
      gameSize + Vector2(150, 0),
    );

    print("Spawning shield power up at $position");

    return position;
  }
}
