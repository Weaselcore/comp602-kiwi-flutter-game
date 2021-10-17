import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/boss/wizard_lighting.dart';
import 'package:flutter_game/game/components/boss/wizard_prep_lightning.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import 'boss.dart';

class WizardBoss extends Boss with GameSizeAware {
  late Timer _prepBoltTimer;
  late Timer _cycleTimer;
  late Timer _boltTimer;

  late int spawnPosition;

  late PrepLightning _prepLightning;
  late WizardLightning _wizardLightning;

  Random random = Random();

  WizardBoss(int idCount) : super(id: idCount, enemySpeed: 400) {
    _prepBoltTimer = Timer(1, callback: prepareBolt);
    _cycleTimer = Timer(5.5, callback: despawn);
    _boltTimer = Timer(2, callback: summonBolt);
    _prepBoltTimer.start();
    _cycleTimer.start();

    setRandomSpawn();
  }

  @override
  Future<void> onLoad() async {
    List<double> startingPosition = [
      0.0,
      gameSize.x - 2 * (gameSize.x / 3),
      gameSize.x - 1 * (gameSize.x / 3)
    ];

    sprite = await Sprite.load('wizard.png');
    size = Vector2(gameSize.x / 3, gameSize.x / 3);
    position = Vector2(startingPosition[spawnPosition], size.y);

    final hitboxShape = HitboxCircle(definition: 0.6);
    addShape(hitboxShape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _prepBoltTimer.update(dt);
    _cycleTimer.update(dt);
    _boltTimer.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  // Vector2 getPosition() {
  //   // Vector2 initialSize = Vector2(64, 64);
  //   Vector2 position;

  //   double randomPositionMultiplier = random.nextDouble();

  //   print("Spawning BossFalcon at $position");

  //   return position;
  // }

  @override
  void die() {
    super.die();
    gameRef.bossManager.incrementWinCondition();
  }

  void prepareBolt() {
    List<double> startingPosition = [
      0.0,
      gameSize.x - 2 * (gameSize.x / 3),
      gameSize.x - 1 * (gameSize.x / 3)
    ];

    for (var i = 0; i < 3; i++) {
      if (i != spawnPosition) {
        _prepLightning = PrepLightning(Vector2(startingPosition[i], 0.0));
        gameRef.add(_prepLightning);
      }
    }
    _boltTimer.start();
  }

  void summonBolt() {
    List<double> startingPosition = [
      0.0,
      gameSize.x - 2 * (gameSize.x / 3),
      gameSize.x - 1 * (gameSize.x / 3)
    ];

    for (var i = 0; i < 3; i++) {
      if (i != spawnPosition) {
        _wizardLightning = WizardLightning(Vector2(startingPosition[i], 0.0));
        gameRef.add(_wizardLightning);
      }
    }
    setRandomSpawn();
  }

  void setRandomSpawn() {
    spawnPosition = random.nextInt(3);
  }

  void despawn() {
    remove();
  }
}
