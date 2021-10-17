import 'package:flame/components.dart';
import 'package:flutter_game/game/components/boss/boss_falcon.dart';
import 'package:flutter_game/game/components/boss/boss_ufo.dart';
import 'boss.dart';
import 'boss_wizard.dart';

/// A class that returns enemy objects or a dummy Imaginary object.
class BossFactory extends BaseComponent {
  Boss getBossType(String type, int idCount) {
    if (type == "falcon") {
      print("Making Crate");
      return new FalconBoss(idCount);
    } else if (type == "ufo") {
      print("Making Cloud");
      return new UfoBoss(idCount);
    } else if (type == "wizard") {
      print("Making Ferret");
      return new WizardBoss(idCount);
    } else {
      throw Error();
    }
  }
}
