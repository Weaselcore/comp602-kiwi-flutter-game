import 'package:flame/components.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';

class PowerUpTracker extends BaseComponent {
  late List _powerUpList;

  PowerUpTracker() {
    _powerUpList = <PowerUp>[];
  }

  void addPowerUp(PowerUp powerup) {
    _powerUpList.add(powerup);
  }

  void removePowerUp(int id) {
    _powerUpList.remove(id);
  }

  void reset() {
    _powerUpList.clear();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
