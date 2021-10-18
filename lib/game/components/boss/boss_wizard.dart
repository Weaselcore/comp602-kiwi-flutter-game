import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/boss/wizard_lighting.dart';
import 'package:flutter_game/game/components/boss/wizard_prep_lightning.dart';
import 'package:flutter_game/game/game_size_aware.dart';

import 'boss.dart';

class WizardBoss extends Boss with GameSizeAware {
  //timers for spawning lightning bolts and prep zones
  late Timer _prepBoltTimer;
  late Timer _boltTimer;
  //timer for despawning boss
  late Timer _cycleTimer;

  //variable for initial boss spawn
  late int spawnPosition;

  //lightning bolt components
  late PrepLightning _prepLightning;
  late WizardLightning _wizardLightning;

  Random random = Random();

  WizardBoss(int idCount) : super(id: idCount, enemySpeed: 0) {
    _prepBoltTimer = Timer(1, callback: prepareBolt);
    _cycleTimer = Timer(4, callback: despawn);
    _boltTimer = Timer(0.5, callback: summonBolt);
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

  //when player kills the boss progress boss fight win condition
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

    //spawn lightning in every spot that isn't where the boss is spawning
    for (var i = 0; i < 3; i++) {
      if (i != spawnPosition) {
        _prepLightning = PrepLightning(Vector2(startingPosition[i], 0.0));
        gameRef.add(_prepLightning);
      }
    }
    //start lighting bolt timer
    _boltTimer.start();
  }

  void summonBolt() {
    List<double> startingPosition = [
      0.0,
      gameSize.x - 2 * (gameSize.x / 3),
      gameSize.x - 1 * (gameSize.x / 3)
    ];

    //spawn lightning in every spot that isn't where the boss is spawning
    for (var i = 0; i < 3; i++) {
      if (i != spawnPosition) {
        _wizardLightning = WizardLightning(Vector2(startingPosition[i], 0.0));
        gameRef.add(_wizardLightning);
      }
    }
    setRandomSpawn();
  }

  //set random spawn location for boss
  void setRandomSpawn() {
    spawnPosition = random.nextInt(3);
  }

  //remove boss component from game
  void despawn() {
    remove();
  }
}
