
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';

class Enemy extends SpriteComponent {

  static final squarePaint = BasicPalette.white.paint();
  static const int squareSpeed = 400;
  late Rect enemyPos;
  late Vector2 startingPos;

  Enemy(this.startingPos);

  @override
  Future<void> onLoad() async {
    enemyPos = Rect.fromLTWH(startingPos.x, startingPos.y, 100, 100);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(enemyPos, squarePaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    enemyPos = enemyPos.translate(0, -(squareSpeed * dt));
  }
}
