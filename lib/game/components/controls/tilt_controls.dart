enum TiltMoveDirectional {
  moveUp,
  moveUpLeft,
  moveUpRight,
  moveRight,
  moveDown,
  moveDownRight,
  moveDownLeft,
  moveLeft,
  idle,
}

class TiltDirectionalEvent {
  /// The direction the knob was moved towards, converted to a set of 8
  /// cardinal directions.

  TiltMoveDirectional calculate(double tiltXValue, double tiltYValue) {
    if (isXIdle(tiltXValue) && isYIdle(tiltYValue)) {
      return TiltMoveDirectional.moveRight;
    } else if (isDown(tiltYValue) && isRight(tiltYValue)) {
      return TiltMoveDirectional.moveDownRight;
    } else if (isDown(tiltYValue) && isXIdle(tiltXValue)) {
      return TiltMoveDirectional.moveDown;
    } else if (isDown(tiltYValue) && isLeft(tiltXValue)) {
      return TiltMoveDirectional.moveDownLeft;
    } else if (isLeft(tiltXValue) && isYIdle(tiltYValue)) {
      return TiltMoveDirectional.moveLeft;
    } else if (isUp(tiltYValue) && isLeft(tiltXValue)) {
      return TiltMoveDirectional.moveUpLeft;
    } else if (isXIdle(tiltXValue) && isUp(tiltYValue)) {
      return TiltMoveDirectional.moveUp;
    } else if (isUp(tiltYValue) && isRight(tiltXValue)) {
      return TiltMoveDirectional.moveUpRight;
    } else {
      return TiltMoveDirectional.idle;
    }
  }

  bool isXIdle(double tiltXValue) => (tiltXValue < 1.0 && tiltXValue > -1.0);

  bool isYIdle(double tiltYValue) => (tiltYValue < 1.0 && tiltYValue > -1.0);

  bool isRight(double tiltXValue) => tiltXValue > 1.0;

  bool isLeft(double tiltXValue) => tiltXValue < -1.0;

  bool isUp(double tiltYValue) => tiltYValue < 1.0;

  bool isDown(double tiltYValue) => tiltYValue < -1.0;
}
