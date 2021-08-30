import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/game_size_aware.dart';

class FerretEnemy extends Enemy with GameSizeAware {
  late Vector2 startingPosition;
  bool _movingLeft = false;

  Random random = Random();

  late Vector2 _leftMove = Vector2(-1, 0);
  late Vector2 _rightMove = Vector2(1, 0);
  late Vector2 _toMove;

  late Timer _swayTimer;

  FerretEnemy(int idCount) : super(idCount, 70) {
    _swayTimer = Timer(3, callback: _switchHorizontalDirection, repeat: true);
    _swayTimer.start();
    _toMove = _rightMove;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('ferret_sprite.png');
    size = Vector2(60, 136);
    position = this.getPosition() - size;

    final hitboxShape = HitboxCircle(definition: 1);
    addShape(hitboxShape);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _swayTimer.update(dt);
    _toMove = !_movingLeft ? _rightMove : _leftMove;
    this.position += (Vector2(0, 0) + _toMove) * enemySpeed * dt;
  }

  Vector2 getPosition() {
    // Vector2 initialSize = Vector2(64, 64);

    double randomPositionMultiplier = random.nextDouble();

    Vector2 position =
        Vector2(randomPositionMultiplier * gameSize.x, gameSize.y + 100);

    position.clamp(
      Vector2.zero() + Vector2(150, 0),
      gameSize + Vector2(150, 0),
    );

    print("Spawning ferret at $position");

    return position;
  }

  void _switchHorizontalDirection() {
    // Flips horizontal vector 180 degrees.
    _movingLeft = !_movingLeft;
  }

  // Needed to start timer when added to the widget tree.
  @override
  void onMount() {
    super.onMount();
    _swayTimer.start();
  }
}
