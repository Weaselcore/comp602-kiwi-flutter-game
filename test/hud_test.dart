import 'package:flame/components.dart';
import 'package:flutter_game/game/components/kiwi.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/shield_powerup.dart';
import 'package:flutter_game/game/overlay/hud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Ensures that the assets can be used for the sprite components.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HUD text components', () {
    test('Hud should show "Coins: 50" as the outcome.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      Hud hud = Hud(kiwi);
      hud.updateText(coinText: '50', scoreText: '70');
      expect(hud.getCoinText(), equals('Coins: 50'));
    });

    test('Hud should show "Score: 50" as the outcome.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      Hud hud = Hud(kiwi);
      hud.updateText(coinText: '70', scoreText: '50');
      expect(hud.getScoreText(), equals('Score: 50'));
    });

    test('Hud should not show "Coins: 50" as the outcome.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      Hud hud = Hud(kiwi);
      hud.updateText(coinText: '100', scoreText: '100');
      expect(hud.getCoinText(), isNot('Coins: 50'));
    });

    test('Hud should not show "Score: 50" as the outcome.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      Hud hud = Hud(kiwi);
      hud.updateText(coinText: '50', scoreText: '70');
      expect(hud.getScoreText(), isNot('Score: 50'));
    });
  });
  group('HUD power ups', () {
    test('Hud should show one powerup.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );
      Hud hud = Hud(kiwi);

      ShieldPowerUp shieldPowerUp = ShieldPowerUp(1);
      kiwi.addPowerUp(shieldPowerUp);

      expect(hud.getPowerUpQueueLength(), equals(1));
    });

    test('Hud should show two powerup.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );
      Hud hud = Hud(kiwi);

      ShieldPowerUp shieldPowerUp = ShieldPowerUp(1);
      ShieldPowerUp shieldPowerUp2 = ShieldPowerUp(2);
      kiwi.addPowerUp(shieldPowerUp);
      kiwi.addPowerUp(shieldPowerUp2);

      expect(hud.getPowerUpQueueLength(), equals(2));
    });

    test('Hud should show two powerup with 3 powerups added.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );
      Hud hud = Hud(kiwi);

      ShieldPowerUp shieldPowerUp = ShieldPowerUp(1);
      ShieldPowerUp shieldPowerUp2 = ShieldPowerUp(2);
      ShieldPowerUp shieldPowerUp3 = ShieldPowerUp(3);
      kiwi.addPowerUp(shieldPowerUp);
      kiwi.addPowerUp(shieldPowerUp2);
      kiwi.addPowerUp(shieldPowerUp3);

      expect(hud.getPowerUpQueueLength(), equals(2));
    });

    test('Hud should show two powerup.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );
      Hud hud = Hud(kiwi);

      ShieldPowerUp shieldPowerUp = ShieldPowerUp(1);
      ShieldPowerUp shieldPowerUp2 = ShieldPowerUp(2);
      kiwi.addPowerUp(shieldPowerUp);
      kiwi.addPowerUp(shieldPowerUp2);

      expect(hud.getPowerUpQueueLength(), isNot(1));
    });

    test('Hud should show one powerup.', () async {
      Kiwi kiwi = Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );
      Hud hud = Hud(kiwi);

      ShieldPowerUp shieldPowerUp = ShieldPowerUp(1);
      kiwi.addPowerUp(shieldPowerUp);

      expect(hud.getPowerUpQueueLength(), isNot(2));
    });

    group('HUD reset', () {
      test('Hud should show zero powerup after reset.', () async {
        Kiwi kiwi = Kiwi(
          godMode: true,
          sprite: await Sprite.load('kiwi_sprite.png'),
          size: Vector2(122, 76),
          position: Vector2(50, 50),
        );
        Hud hud = Hud(kiwi);

        ShieldPowerUp shieldPowerUp = ShieldPowerUp(1);
        kiwi.addPowerUp(shieldPowerUp);
        kiwi.resetPowerUp();
        expect(hud.getPowerUpQueueLength(), equals(0));
      });

      test('Hud should show one powerup after reset.', () async {
        Kiwi kiwi = Kiwi(
          godMode: true,
          sprite: await Sprite.load('kiwi_sprite.png'),
          size: Vector2(122, 76),
          position: Vector2(50, 50),
        );
        Hud hud = Hud(kiwi);
        kiwi.resetPowerUp();
        ShieldPowerUp shieldPowerUp = ShieldPowerUp(1);
        kiwi.addPowerUp(shieldPowerUp);

        expect(hud.getPowerUpQueueLength(), isNot(0));
      });
    });
  });
}
