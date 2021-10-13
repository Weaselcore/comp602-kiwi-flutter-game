import 'package:flame/components.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/boss_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/laser_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/shield_powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_types/slomo_powerup.dart';

class PowerUpFactory extends BaseComponent {
  PowerUp getPowerUpType(String type, int idCount) {
    if (type == "SHIELD") {
      print("Making shield powerup");
      return new ShieldPowerUp(idCount);
    } else if (type == "LASER") {
      print("Making laser powerUp");
      return new LaserPowerUp(idCount);
    } else if (type == "SLOMO") {
      print("Making slomo powerup");
      return new SlomoPowerUp(idCount);
    } else if (type == "BOSS") {
      print("Making boss powerup");
      return new BossPowerUp(idCount);
    } else {
      throw Error();
    }
  }
}
