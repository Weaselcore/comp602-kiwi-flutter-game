import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter_game/game/widgets/kiwi.dart';

import 'game_size_aware.dart';

class KiwiGame extends BaseGame with PanDetector {
  bool _isAlreadyLoaded = false;

  @override
  Future<void> onLoad() async {
    if (!_isAlreadyLoaded) {
      Kiwi kiwi = Kiwi(
        sprite: await Sprite.load('kiwi_sprite.jpg'),
        size: Vector2(100, 100),
        position: viewport.canvasSize / 2,
      );
      kiwi.anchor = Anchor.center;
      add(kiwi);
      _isAlreadyLoaded = true;
    }
  }

  @override
  void onResize(Vector2 canvasSize) {
    super.onResize(canvasSize);

    // Loop over all the components of type KnowsGameSize and resize then as well.
    this.components.whereType<GameSizeAware>().forEach((component) {
      component.onResize(this.size);
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
