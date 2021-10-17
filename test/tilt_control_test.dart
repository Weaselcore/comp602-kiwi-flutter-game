import 'package:flutter_game/game/components/controls/tilt_controls.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tilt Control should return correct TiltMoveDirection', () {
    test('Kiwi should go up.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0, 4.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveUp);
    });

    test('Kiwi should go up left.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.6, 4.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveUpLeft);
    });

    test('Kiwi should go up right.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(-0.6, 4.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveUpRight);
    });

    test('Kiwi should go right.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(-0.6, 6.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveRight);
    });

    test('Kiwi should go left.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.6, 6.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveLeft);
    });

    test('Kiwi should go down.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.0, 8.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveDown);
    });

    test('Kiwi should go down left.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.6, 8.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveDownLeft);
    });

    test('Kiwi should go down right.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(-0.6, 8.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.moveDownRight);
    });

    test('Kiwi should go idle.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.0, 6.0);
      expect(tiltMoveDirectional, TiltMoveDirectional.idle);
    });
  });

  group('Tilt Control false inputs', () {
    test('Kiwi should not go up.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0, 8.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveUp));
    });

    test('Kiwi should not go up left.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(-0.6, 4.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveUpLeft));
    });

    test('Kiwi should not go up right.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(-0.6, 6.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveUpRight));
    });

    test('Kiwi should not go right.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.6, 6.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveRight));
    });

    test('Kiwi should not go left.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(-0.6, 6.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveLeft));
    });

    test('Kiwi should not go down.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.0, -8.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveDown));
    });

    test('Kiwi should not go down left.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.6, -8.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveDownLeft));
    });

    test('Kiwi should not go down right.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(0.6, 8.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.moveDownRight));
    });

    test('Kiwi should not go idle.', () {
      TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();
      TiltMoveDirectional tiltMoveDirectional =
          tiltDirectionalEvent.calculate(6.0, 6.0);
      expect(tiltMoveDirectional, isNot(TiltMoveDirectional.idle));
    });
  });
}
