import 'package:flame/components.dart';

import 'coin.dart';

class CoinTracker extends BaseComponent {
  late List _coinList;

  CoinTracker() {
    _coinList = <Coin>[];
  }

  void addCoin(Coin coin) {
    _coinList.add(Coin);
  }

  void removeCoin(int id) {
    _coinList.remove(id);
  }

  void reset() {
    _coinList.clear();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
