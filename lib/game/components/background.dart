import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

import '../kiwi_game.dart';

class Background extends ParallaxComponent with HasGameRef<KiwiGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax([
      ParallaxImageData('pixbs.png'),
      ParallaxImageData('smallclouds.png'),
      ParallaxImageData('side1.png'),
      ParallaxImageData('bigclouds.png'),
    ],
        baseVelocity: Vector2(0, 5),
        velocityMultiplierDelta: Vector2(0, 2.0),
        repeat: ImageRepeat.repeatY,
        fill: LayerFill.width);
  }

  // Parallax getParallaxComponent() {
  //   return parallax;
  // }
}
