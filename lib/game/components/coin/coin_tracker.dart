import 'package:flame/components.dart';

import 'coin.dart';

class CoinTracker extends BaseComponent {
  // A list to contain coin objects.
  late List _coinList;

  CoinTracker() {
    // Initialise an empty list that can contain only coin objects.
    _coinList = <Coin>[];
  }

  /// Adds [coin] to the list to keep track of.
  void addCoin(Coin coin) {
    _coinList.add(Coin);
  }

  /// Removes coin that is being tracked using the [id].
  void removeCoin(int id) {
    _coinList.remove(id);
  }

  /// Clears the coin list ready for a new game.
  void reset() {
    _coinList.clear();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
