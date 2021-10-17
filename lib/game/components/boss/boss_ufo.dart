import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/game_size_aware.dart';
import 'package:flutter_game/game/components/boss/ufo_bullet.dart';

import 'boss.dart';

class UfoBoss extends Boss with GameSizeAware {
  late Vector2 startingPosition;

  late UfoBullet _fireBullet;
  late Timer _bulletTimer;

  Random random = Random();

  UfoBoss(int idCount) : super(id: idCount, enemySpeed: 100) {
    _bulletTimer = Timer(0.7, callback: fireBullet, repeat: true);
    _bulletTimer.start();
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('ufo_boss.png');
    size = Vector2(100, 100);
    position = this.getPosition() - size / 2;

    final hitboxShape = HitboxCircle(definition: 0.6);
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _bulletTimer.update(dt);

    this.position += Vector2(1, 0).normalized() * enemySpeed * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  Vector2 getPosition() {
    // Vector2 initialSize = Vector2(64, 64);
    Vector2 position;

    position = Vector2(0, 0 + size.y);

    print("Spawning BossFalcon at $position");

    return position;
  }

  @override
  void die() {
    super.die();
    gameRef.bossManager.incrementWinCondition();
  }

  void fireBullet() {
    _fireBullet = UfoBullet(position + Vector2(0, size.y / 2));
    //_fireBullet.anchor = Anchor.bottomCenter;
    gameRef.add(_fireBullet);
  }
}
