import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

import '../kiwi_game.dart';

class Transition extends ParallaxComponent with HasGameRef<KiwiGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('transition.png'),
      ],
      baseVelocity: Vector2(0, 250),
      fill: LayerFill.width,
    );
  }
}
