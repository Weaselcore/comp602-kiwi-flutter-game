import 'package:flame/components.dart';
import 'package:flutter_game/game/components/boss/boss_falcon.dart';
import 'boss.dart';

/// A class that returns enemy objects or a dummy Imaginary object.
class BossFactory extends BaseComponent {
  Boss getBossType(String type, int idCount) {
    if (type == "falcon") {
      print("Making Crate");
      return new FalconBoss(idCount);
      // } else if (type == "CLOUD") {
      //   print("Making Cloud");
      //   return new CloudEnemy(idCount);
      // } else if (type == "FERRET") {
      //   print("Making Ferret");
      //   return new FerretEnemy(idCount);
      // } else if (type == "IMAGINARY") {
      //   print("Making Nothing");
      //   return new Imaginary(idCount);
    } else {
      throw Error();
    }
  }
}
