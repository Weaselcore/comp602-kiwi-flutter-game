import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/game_size_aware.dart';

class CrateEnemy extends SpriteComponent with GameSizeAware {
  static const double enemySpeed = 400;
  late Vector2 startingPosition;

  CrateEnemy(this.startingPosition);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('crate_sprite.png');
    size = Vector2(180, 104);
    position = startingPosition - size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, -1).normalized() * enemySpeed * dt;
  }
}
