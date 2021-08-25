import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter_game/game/components/enemy/enemy_manager.dart';
import 'package:flutter_game/game/components/kiwi.dart';

import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'game_size_aware.dart';
import 'overlay/pause_button.dart';
import 'overlay/pause_menu.dart';

class KiwiGame extends BaseGame with MultiTouchTapDetector, HasCollidables {
  bool _isAlreadyLoaded = false;
  bool _leftDirectionPressed = false;
  bool _rightDirectionPressed = false;
  bool gameEnded = false;

  // These variables are to track multi-gesture taps.
  int _rightPointerId = -1;
  int _leftPointerId = -1;

  int _score = 0;

  late Kiwi _kiwi;
  late EnemyManager _enemyManager;

  @override
  Future<void> onLoad() async {
    if (!_isAlreadyLoaded) {
      _kiwi = Kiwi(
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(viewport.canvasSize.x / 2, viewport.canvasSize.y / 3),
      );
      _kiwi.anchor = Anchor.center;
      add(_kiwi);
      _enemyManager = EnemyManager();
      add(_enemyManager);
      _isAlreadyLoaded = true;
    }
  }

  @override
  void onResize(Vector2 canvasSize) {
    super.onResize(canvasSize);

    // Loop over all the components of type KnowsGameSize and resize then as well.
    // Will be useful when playing on web version.
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

    print(_leftPointerId);
    print(_rightPointerId);

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
      _leftPointerId = pointerId;
    } else if (_tapIsRight(event) && !_tapIsLeft(event)) {
      _rightDirectionPressed = true;
      _rightPointerId = pointerId;
    } else if (!(_isBothPressed())) {
      _leftDirectionPressed = false;
      _leftPointerId = -1;
      _rightDirectionPressed = false;
      _rightPointerId = -1;
    }
  }

  @override
  void onTapUp(int pointerId, TapUpInfo event) {
    // If both left and right taps have been lifted.
    if (_tapIsLeft(event) && _tapIsRight(event)) {
      _leftDirectionPressed = false;
      _leftPointerId = -1;
      _rightDirectionPressed = false;
      _rightPointerId = -1;
      // If left tap has been lifted.
    } else if (_tapIsLeft(event) && !_tapIsRight(event)) {
      _leftDirectionPressed = false;
      _leftPointerId = -1;
      // If right tap has been lifted.
    } else if (_tapIsRight(event) && !_tapIsLeft(event)) {
      _rightDirectionPressed = false;
      _rightPointerId = -1;
    }
  }

  // Since onTapCancel doesn't pass TapInfo, pointerId have to be tracked.
  // So if the finger slides off the sides instead of lifting it up, it will not bug out.
  @override
  void onTapCancel(int pointerId) {
    if (_rightPointerId == pointerId) {
      _rightPointerId = -1;
      _rightDirectionPressed = false;
    } else if (_leftPointerId == pointerId) {
      _leftPointerId = -1;
      _leftDirectionPressed = false;
    }
  }

  double _getMiddlePoint() => viewport.canvasSize.x / 2;

  bool _tapIsLeft(PositionInfo event) =>
      event.eventPosition.game.x < _getMiddlePoint();

  bool _tapIsRight(PositionInfo event) =>
      event.eventPosition.game.x > _getMiddlePoint();

  bool _isBothPressed() => (_rightDirectionPressed && _leftDirectionPressed);

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (!gameEnded) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
      case AppLifecycleState.detached:
        if (this._score > 0) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
    }
  }

  void reset() {
    _enemyManager.reset();

    components.whereType<Enemy>().forEach((enemy) {
      enemy.remove();
    });
  }
}
