import 'package:flame/components.dart';
import 'dart:ui';

import 'scrolling_sprite.dart';

class ScrollingSpriteComponent extends BaseComponent {
  late ScrollingSprite scrollingSprite;

  bool isLoaded = false;

  double x;
  double y;
  Vector2 canvasSize;

  ScrollingSpriteComponent(
      {required this.x, required this.y, required this.canvasSize});

  @override
  Future<void> onLoad() async {
    scrollingSprite = ScrollingSprite(
      spritePath: 'front_screen_1.png',
      spriteWidth: 400.0,
      spriteHeight: 800.0,
      spriteDestWidth: this.canvasSize.x,
      spriteDestHeight: this.canvasSize.y,
      width: this.canvasSize.x,
      height: this.canvasSize.y,
    );
    this.addChild(scrollingSprite);

    isLoaded = true;
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void update(double dt) {
    if (isLoaded) {
      super.update(dt);
      scrollingSprite.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (isLoaded) {
      scrollingSprite.renderAt(x, y, canvas);
    }
  }
}
