import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/crate_enemy.dart';
import 'package:flutter_game/game/components/enemy/imaginary.dart';
import 'cloud_enemy.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

class EnemyFactory extends BaseComponent {
  Enemy getEnemyType(String type, int idCount) {
    if (type == "CRATE") {
      print("Making Crate");
      return new CrateEnemy(idCount);
    } else if (type == "CLOUD") {
      print("Making Cloud");
      return new CloudEnemy(idCount);
    } else {
      print("Making Nothing");
      return new Imaginary(idCount);
    }
  }
}
