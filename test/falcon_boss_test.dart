import 'package:flame/components.dart';
import 'package:flutter_game/game/components/boss/boss_falcon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Ensures that the assets can be used for the sprite components.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Falcon boss movement test', () {
    test('Falcon boss moves left', () {
      FalconBoss falcon = new FalconBoss(0);

      falcon.direction = -1.0;

      falcon.gameSize = Vector2(200, 200);

      falcon.update(3);

      expect(falcon.position.x, lessThan(falcon.gameSize.x));
    });
    test('Falcon boss moves right', () {
      FalconBoss falcon = new FalconBoss(0);

      falcon.direction = 1.0;

      falcon.gameSize = Vector2(200, 200);

      falcon.update(3);

      expect(falcon.position.x, greaterThan(0));
    });
    test('Falcon boss swoops down after spawning', () {
      FalconBoss falcon = new FalconBoss(0);

      falcon.direction = -1.0;

      falcon.gameSize = Vector2(200, 200);

      double previousPosition = falcon.position.y;

      falcon.update(1);

      expect(falcon.position.y < previousPosition, true);
    });
    test('Falcon boss swoops swoops up after swooping down', () {
      FalconBoss falcon = new FalconBoss(0);

      falcon.direction = -1.0;

      falcon.gameSize = Vector2(200, 200);

      double previousPosition = falcon.position.y;

      falcon.update(2);

      expect(falcon.position.y > previousPosition, true);
    });
  });
}
