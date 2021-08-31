import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class LaserBeam extends SpriteComponent with Hitbox, Collidable {
  @override
  Future<void> onLoad() async {
    Sprite laserSprite = await Sprite.load("laser_beam_sprite.png");
    this.sprite = laserSprite;
    this.size = Vector2(162, 578);

    Vector2 hitBoxDimensions = Vector2(1, 1);
    final hitBoxShape = HitboxRectangle(relation: hitBoxDimensions);
    addShape(hitBoxShape);
  }
}
