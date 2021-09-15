import 'package:flame/components.dart';
import 'package:flutter_game/game/components/enemy/enemy_types/crate_enemy.dart';
import 'package:flutter_game/game/components/enemy/enemy_types/ferret_enemy.dart';
import 'package:flutter_game/game/components/enemy/enemy_types/imaginary.dart';
import 'enemy_types/cloud_enemy.dart';
import 'package:flutter_game/game/components/enemy/enemy.dart';

/// A class that returns enemy objects or a dummy Imaginary object.
class EnemyFactory extends BaseComponent {
  Enemy getEnemyType(String type, int idCount) {
    if (type == "CRATE") {
      print("Making Crate");
      return new CrateEnemy(idCount);
    } else if (type == "CLOUD") {
      print("Making Cloud");
      return new CloudEnemy(idCount);
    } else if (type == "FERRET") {
      print("Making Ferret");
      return new FerretEnemy(idCount);
    } else if (type == "IMAGINARY") {
      print("Making Nothing");
      return new Imaginary(idCount);
    } else {
      throw Error();
    }
  }
}
