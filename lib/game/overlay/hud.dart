import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/kiwi.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/laser_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/shield_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/slomo_powerup.dart';
import 'package:flutter_game/game/kiwi_game.dart';

class Hud extends SpriteComponent with HasGameRef<KiwiGame> {
  late final Vector2 firstSpritePosition;
  late final Vector2 secondSpritePosition;
  late Queue kiwiPowerUpQueue;

  late Sprite laserSprite;
  late Sprite slomoSprite;
  late Sprite shieldSprite;

  final Vector2 firstSize = Vector2(50, 50);
  final Vector2 secondSize = Vector2(25, 25);

  final Vector2 scoreTickerPosition = Vector2(50, 50);
  final Vector2 coinTickerPosition = Vector2(200, 50);
  final Vector2 scoreTickerSize = Vector2(25, 25);
  final Vector2 coinTickerSize = Vector2(25, 25);
  TextComponent scoreTicker = TextComponent('0');
  TextComponent coinTicker = TextComponent('0');

  Hud(Kiwi kiwi) {
    kiwiPowerUpQueue = kiwi.getPowerUpQueue();
    this.position = Vector2(0, 0);
    scoreTicker.position = scoreTickerPosition;
    coinTicker.position = coinTickerPosition;

    scoreTicker.textRenderer = TextPaint(
      config: TextPaintConfig(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'BungeeInline',
      ),
    );

    coinTicker.textRenderer = TextPaint(
      config: TextPaintConfig(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'BungeeInline',
      ),
    );

    addChild(scoreTicker);
    addChild(coinTicker);
  }

  @override
  Future<void> onLoad() async {
    firstSpritePosition = Vector2(gameRef.canvasSize.x - 100, 50);
    secondSpritePosition = Vector2(gameRef.canvasSize.x - 50, 50);
    this.size = Vector2(gameRef.canvasSize.x, 100);

    laserSprite = await Sprite.load("laser_powerup_sprite.png");
    slomoSprite = await Sprite.load("slomo_powerup_sprite.png");
    shieldSprite = await Sprite.load("shield_powerup_sprite.png");
  }

  @override
  void update(double dt) {
    children.whereType<SpriteComponent>().forEach((element) {
      element.remove();
    });

    updateText(
        scoreText: gameRef.score.toString(), coinText: gameRef.coin.toString());

    if (kiwiPowerUpQueue.length == 1) {
      display(kiwiPowerUpQueue.first, 1);
    } else if (kiwiPowerUpQueue.length == 2) {
      display(kiwiPowerUpQueue.last, 2);
      display(kiwiPowerUpQueue.first, 1);
    }
    super.update(dt);
  }

  void display(PowerUp powerUp, int priority) {
    Sprite spriteToUse = getSprite(powerUp);

    Vector2 spriteSize = priority == 1 ? firstSize : secondSize;
    Vector2 spritePosition =
        priority == 1 ? firstSpritePosition : secondSpritePosition;

    SpriteComponent spriteComponent = SpriteComponent(
        size: spriteSize, sprite: spriteToUse, position: spritePosition);

    addChild(spriteComponent);
  }

  Sprite getSprite(PowerUp powerUp) {
    if (powerUp is LaserPowerUp) {
      return laserSprite;
    } else if (powerUp is SlomoPowerUp) {
      return slomoSprite;
    } else if (powerUp is ShieldPowerUp) {
      return shieldSprite;
    } else {
      throw Error();
    }
  }

  void updateText({required String scoreText, required String coinText}) {
    scoreTicker.text = "Score: " + scoreText;
    coinTicker.text = "Coins: " + coinText;
  }

  String getCoinText() => coinTicker.text;

  String getScoreText() => scoreTicker.text;

  int getPowerUpQueueLength() => kiwiPowerUpQueue.length;
}
