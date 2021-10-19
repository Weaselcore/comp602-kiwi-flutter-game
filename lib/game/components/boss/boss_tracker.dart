import 'package:flame/components.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import '../kiwi.dart';
import 'boss.dart';

class BossTracker extends BaseComponent with HasGameRef<KiwiGame> {
  // A list to contain enemy objects.
  late List _bossList;
  // A reference to the kiwi object.

  BossTracker() {
    // Initialise an empty list that can contain only enemy objects.
    _bossList = <Boss>[];
  }

  /// Adds [enemy] to the list to keep track of.
  void addBoss(Boss boss) {
    _bossList.add(boss);
  }

  /// Removes boss that is being tracked using the [id].
  void removeBoss(int id) {
    _bossList.remove(id);
  }

  /// Clears the boss list ready for a new game.
  void reset() {
    _bossList.clear();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  /// Passes a reference to the kiwi when initialising the [kiwi].
  void registerKiwi(Kiwi kiwi) {}
}
