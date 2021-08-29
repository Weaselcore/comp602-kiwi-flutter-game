import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/enemy/enemy_manager.dart';
import 'package:flutter_game/game/components/kiwi.dart';

import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/components/powerup_tracker.dart';
import 'package:flutter_game/game/components/powerups/powerup.dart';
import 'package:flutter_game/game/components/powerups/powerup_manager.dart';
import 'package:flutter_game/game/components/score_tracker.dart';
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

  late Kiwi _kiwi;
  late ScoreTracker scoreTracker;
  late EnemyManager _enemyManager;
  late TextComponent _scoreTicker;
  late PowerUpTracker powerUpTracker;
  late PowerUpManager _powerUpManager;

  late TextComponent _shieldTicker;

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
      scoreTracker = ScoreTracker(_kiwi);
      add(scoreTracker);
      powerUpTracker = PowerUpTracker();
      add(powerUpTracker);
      _powerUpManager = PowerUpManager();
      add(_powerUpManager);

      _scoreTicker = TextComponent(
        'Score: 0',
        position: Vector2(10, 10),
        textRenderer: TextPaint(
          config: TextPaintConfig(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'BungeeInline',
          ),
        ),
      );

      _shieldTicker = TextComponent(
        'Shield: 0',
        position: Vector2(10, 25),
        textRenderer: TextPaint(
          config: TextPaintConfig(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'BungeeInline',
          ),
        ),
      );

      _scoreTicker.isHud = true;
      add(_scoreTicker);
      _shieldTicker.isHud = true;
      add(_shieldTicker);

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

    _scoreTicker.text = 'Score: ' + scoreTracker.getScore().toString();
    _shieldTicker.text = 'Shield: ' + _kiwi.getShieldCount().toString();
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
        if (!gameEnded) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
      case AppLifecycleState.inactive:
        if (!gameEnded) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
      case AppLifecycleState.paused:
        if (!gameEnded) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
      case AppLifecycleState.detached:
        if (scoreTracker.getScore() > 0) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
    }
  }

  void reset() {
    _enemyManager.reset();
    scoreTracker.reset();
    powerUpTracker.reset();

    components.whereType<Enemy>().forEach((enemy) {
      enemy.remove();
    });

    components.whereType<PowerUp>().forEach((powerUp) {
      powerUp.remove();
    });
  }
}
