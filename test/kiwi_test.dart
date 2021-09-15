import 'package:flame/components.dart';
import 'package:flutter_game/game/components/kiwi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Ensures that the assets can be used for the sprite components.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Kiwi movement Test', () {
    test(
        'Kiwi should go right when goRight method is invoked before 0.1 second update.',
        () async {
      Kiwi kiwi = await Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      kiwi.gameSize = Vector2(100, 100);

      kiwi.goRight();

      kiwi.update(0.1);

      expect(kiwi.position.x, greaterThan(50));
    });

    test(
        'Kiwi should fail to go right when goLeft method is invoked before 0.1 second update.',
        () async {
      Kiwi kiwi = await Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      kiwi.gameSize = Vector2(100, 100);

      kiwi.goLeft();

      kiwi.update(0.1);

      expect(kiwi.position.x, lessThan(50));
    });

    test(
        'Kiwi should go left when goLeft() method is invoked before 0.1 second update.',
        () async {
      Kiwi kiwi = await Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      kiwi.gameSize = Vector2(100, 100);

      kiwi.goLeft();
      kiwi.update(0.1);

      expect(kiwi.position.x, lessThan(50));
    });

    test(
        'Kiwi should fail to go left when goRight method is invoked before 0.1 second update.',
        () async {
      Kiwi kiwi = await Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      kiwi.gameSize = Vector2(100, 100);

      kiwi.goRight();
      kiwi.update(0.1);

      expect(kiwi.position.x, greaterThan(50));
    });

    test(
        'Kiwi should stay still when stop() is invoked before 0.1 second update.',
        () async {
      Vector2 startingPosition = Vector2(50, 50);
      Kiwi kiwi = await Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      kiwi.gameSize = Vector2(100, 100);

      kiwi.stop();
      kiwi.update(0.1);

      expect(kiwi.position, startingPosition);
    });

    test(
        'Kiwi should fail to stay still when goRight() is invoked before 0.1 second update.',
        () async {
      Vector2 startingPosition = Vector2(50, 50);
      Kiwi kiwi = await Kiwi(
        godMode: true,
        sprite: await Sprite.load('kiwi_sprite.png'),
        size: Vector2(122, 76),
        position: Vector2(50, 50),
      );

      kiwi.gameSize = Vector2(100, 100);

      kiwi.goRight();
      kiwi.update(0.1);

      expect(kiwi.position.x == startingPosition.x, false);
    });
  });
}
