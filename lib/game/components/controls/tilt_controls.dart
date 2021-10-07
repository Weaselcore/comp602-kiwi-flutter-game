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
  double yOffset = 5.0;
  double yLowerBound = -1.0;
  double yUpperBound = 1.0;
  double xOffset = 0.0;
  double xLowerBound = -1.0;
  double xUpperBound = 1.0;

  TiltMoveDirectional calculate(double tiltXValue, double tiltYValue) {
    if (isUp(tiltYValue)) {
      if (isUp(tiltYValue) && isLeft(tiltXValue)) {
        return TiltMoveDirectional.moveUpLeft;
      } else if (isUp(tiltYValue) && isRight(tiltXValue)) {
        return TiltMoveDirectional.moveUpRight;
      } else {
        return TiltMoveDirectional.moveUp;
      }
    } else if (isDown(tiltYValue)) {
      if (isDown(tiltYValue) && isRight(tiltXValue)) {
        return TiltMoveDirectional.moveDownRight;
      } else if (isDown(tiltYValue) && isLeft(tiltXValue)) {
        return TiltMoveDirectional.moveDownLeft;
      } else {
        return TiltMoveDirectional.moveDown;
      }
    } else if (isRight(tiltXValue)) {
      return TiltMoveDirectional.moveRight;
    } else if (isLeft(tiltXValue)) {
      return TiltMoveDirectional.moveLeft;
    } else {
      return TiltMoveDirectional.idle;
    }
  }

  bool isXIdle(double tiltXValue) => (tiltXValue < xUpperBound + xUpperBound &&
      tiltXValue > xUpperBound + xLowerBound);

  bool isYIdle(double tiltYValue) => (tiltYValue < yOffset + yUpperBound &&
      tiltYValue > yOffset + yLowerBound);

  bool isRight(double tiltXValue) => tiltXValue < xOffset + xLowerBound;

  bool isLeft(double tiltXValue) => tiltXValue > xOffset + xUpperBound;

  bool isUp(double tiltYValue) => tiltYValue < yOffset + yLowerBound;

  bool isDown(double tiltYValue) => tiltYValue > yOffset + yUpperBound;
}
