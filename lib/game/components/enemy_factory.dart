import 'package:flame/components.dart';
import 'package:flutter_game/game/components/crate_enemy.dart';
import 'package:flutter_game/game/components/imaginary.dart';
import 'cloud_enemy.dart';
import 'enemy.dart';

class EnemyFactory extends BaseComponent {
  
  Enemy getEnemyType(String type) {

    if(type == "CRATE"){
      print("Making Crate");
      return new CrateEnemy();
    }
    else if(type == "CLOUD"){
      print("Making Cloud");
      return new CloudEnemy();
    }
    else{
      print("Making Nothing");
      return new Imaginary();
    }

  }

}