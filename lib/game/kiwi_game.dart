import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter_game/game/widgets/kiwi.dart';

import 'game_size_aware.dart';

class KiwiGame extends BaseGame with TapDetector {
  bool _isAlreadyLoaded = false;
  bool _bothDirectionsPressed = false;
  bool _leftDirectionPressed = false;
  bool _rightDirectionPressed = false;
  late Kiwi _kiwi;

  @override
  Future<void> onLoad() async {
    if (!_isAlreadyLoaded) {
      _kiwi = Kiwi(
          sprite: await Sprite.load('kiwi_sprite.jpg'),
          size: Vector2(100, 100),
          position:
              Vector2(viewport.canvasSize.x / 2, viewport.canvasSize.y / 3));
      _kiwi.anchor = Anchor.center;
      add(_kiwi);
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
  void prepare(Component c) {
    super.prepare(c);

    // If the component being prepared is of type KnowsGameSize,
    // call onResize() on it so that it stores the current game screen size.
    if (c is GameSizeAware) {
      c.onResize(this.size);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _kiwi.update(dt);
  }

  @override
  void onTapDown(TapDownInfo event) {
    print("Player tap down on ${event.eventPosition.game.x}");
    if (!(_rightDirectionPressed && _leftDirectionPressed)) {
      if (event.eventPosition.game.x < getMiddlePoint()) {
        print("Kiwi going left.");
        _kiwi.setMoveDirection(Vector2(-1, 0));
      } else if ((event.eventPosition.game.x > getMiddlePoint()) &&
          !_leftDirectionPressed) {
        print("Kiwi going right.");
        _kiwi.setMoveDirection(Vector2(1, 0));
      }
    }
  }

  @override
  void onTapUp(TapUpInfo event) {
    _kiwi.setMoveDirection(Vector2.zero());
    _leftDirectionPressed = false;
    _rightDirectionPressed = false;
    _bothDirectionsPressed = false;
  }

  @override
  void onTapCancel() {
    _kiwi.setMoveDirection(Vector2.zero());
    _leftDirectionPressed = false;
    _rightDirectionPressed = false;
    _bothDirectionsPressed = false;
  }

  double getMiddlePoint() => viewport.canvasSize.x / 2;
}
