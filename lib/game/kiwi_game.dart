import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter_game/game/widgets/kiwi.dart';

import 'game_size_aware.dart';

class KiwiGame extends BaseGame with MultiTouchTapDetector {
  bool _isAlreadyLoaded = false;
  bool _leftDirectionPressed = false;
  bool _rightDirectionPressed = false;
  late Kiwi _kiwi;

  @override
  Future<void> onLoad() async {
    if (!_isAlreadyLoaded) {
      _kiwi = Kiwi(
        sprite: await Sprite.load('kiwi_sprite.jpg'),
        size: Vector2(100, 100),
        position: Vector2(viewport.canvasSize.x / 2, viewport.canvasSize.y / 3),
      );
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

    // If both left and right are pressed down.
    if (_isBothPressed()) {
      _kiwi.stop();
    }
    // If right are pressed down.
    else if (_rightDirectionPressed && !_leftDirectionPressed) {
      _kiwi.goRight();
    }
    // If left are pressed down.
    else if (_leftDirectionPressed && !_rightDirectionPressed) {
      _kiwi.goLeft();
    }
    // If no buttons are pressed.
    else {
      _kiwi.stop();
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo event) {
    if (_tapIsLeft(event) && !_tapIsRight(event)) {
      _leftDirectionPressed = true;
    } else if (_tapIsRight(event) && !_tapIsLeft(event)) {
      _rightDirectionPressed = true;
    } else if (!(_isBothPressed())) {
      _leftDirectionPressed = false;
      _rightDirectionPressed = false;
    }
  }

  @override
  void onTapUp(int pointerId, TapUpInfo event) {
    // If both left and right taps have been lifted.
    if (_tapIsLeft(event) && _tapIsRight(event)) {
      _leftDirectionPressed = false;
      _rightDirectionPressed = false;
      // If left tap has been lifted.
    } else if (_tapIsLeft(event) && !_tapIsRight(event)) {
      _leftDirectionPressed = false;
      // If right tap has been lifted.
    } else if (_tapIsRight(event) && !_tapIsLeft(event)) {
      _rightDirectionPressed = false;
    }
  }

  double _getMiddlePoint() => viewport.canvasSize.x / 2;

  bool _tapIsLeft(PositionInfo event) =>
      event.eventPosition.game.x < _getMiddlePoint();

  bool _tapIsRight(PositionInfo event) =>
      event.eventPosition.game.x > _getMiddlePoint();

  bool _isBothPressed() => (_rightDirectionPressed && _leftDirectionPressed);
}
