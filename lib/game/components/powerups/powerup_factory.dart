import 'package:flame/components.dart';
import 'package:flutter_game/game/components/powerups/powerup.dart';
import 'package:flutter_game/game/components/powerups/powerup_types/shield_powerup.dart';
import 'package:flutter_game/game/components/powerups/powerup_types/slomo_powerup.dart';

class PowerUpFactory extends BaseComponent {
  PowerUp getPowerUpType(String type, int idCount) {
    if (type == "SHIELD") {
      print("Making shield powerup");
      return new ShieldPowerUp(idCount);
      // } else if (type == "CLOUD") {
      //   print("Making Cloud");
      //   return new LaserPowerUp(idCount);
    } else if (type == "SLOMO") {
      print("Making slomo powerup");
      return new SlomoPowerUp(idCount);
    } else {
      throw Error();
    }
  }
}
