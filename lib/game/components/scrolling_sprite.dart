import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:meta/meta.dart';
import 'dart:ui';

/// Describes a Sprite image that will animate on a axis resembling scroll moviment
class ScrollingSprite extends SpriteComponent {
  late Sprite _sprite;
  late double _width = 400;
  late double _height = 800;
  late double _spriteWidth = 400.0;
  late double _spriteHeight = 800.0;
  final double verticalSpeed;
  final double horizontalSpeed;
  bool isLoaded = false;

  ///
  final bool clipToDimensions;

  List<Rect> _chunks = [];

  /// Constructs a [ScrollingSprite] with the following params:
  ///
  /// [spritePath] - Resource path of the sprite
  /// [spriteX] and [spriteY] - X and Y coordinate do be used to map the sprite
  /// [spriteWidth] and [spriteHeight] - Width and height of the mapped sprite
  /// [spriteDestWidth] and [spriteDestHeight] - Destination width and height of the sprite, in case you want to scale its original size
  /// [width] and [height] - Width and height of the total area where the sprites will scroll
  /// [verticalSpeed] and [horizontalSpeed] - Vertical and horizontal speed of the scrolling speed in pixels per second
  /// [clipToDimensions] - Since the sprites are scrolling on an endless manner, the sprite can be draw outside of its
  /// area, by default, the package already clips the area to prevent it from showing, use this flag to change
  /// this behaviour
  ScrollingSprite({
    double spriteX = 0.0,
    double spriteY = 0.0,
    required String spritePath,
    required double spriteWidth,
    required double spriteHeight,
    required double spriteDestWidth,
    required double spriteDestHeight,
    required double width,
    required double height,
    this.verticalSpeed = -100.0,
    this.horizontalSpeed = 0.0,
    this.clipToDimensions = true,
  });

  @override
  Future<void> onLoad() async {
    _sprite = await Sprite.load('cliff_parallax_1.png');
    _calculate();
    isLoaded = true;
    print(_sprite.toString());
  }

  set width(double w) {
    _width = w;
    _calculate();
  }

  double get width => _width;

  set height(double h) {
    _height = h;
    _calculate();
  }

  double get height => _height;

  void _calculate() {
    _chunks = [];
    final columns = (_width / _spriteWidth).ceil() + 1;
    final rows = (_height / _spriteHeight).ceil() + 1;

    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < columns; x++) {
        _chunks.add(Rect.fromLTWH(
          x * _spriteWidth,
          y * _spriteHeight,
          _spriteWidth,
          _spriteHeight,
        ));
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var i = 0; i < _chunks.length; i++) {
      Rect _c = _chunks[i];

      if (_c.top > _height && verticalSpeed > 0) {
        _c = _chunks[i] = _c.translate(0, -(height + _spriteHeight));
      } else if (_c.bottom < 0 && verticalSpeed < 0) {
        _c = _chunks[i] = _c.translate(0, height + _spriteHeight);
      }

      if (_c.left > _width && horizontalSpeed > 0) {
        _c = _chunks[i] = _c.translate(-(_width + _spriteWidth), 0);
      } else if (_c.right < 0 && horizontalSpeed < 0) {
        _c = _chunks[i] = _c.translate(_width + _spriteWidth, 0);
      }

      _c = _chunks[i] = _c.translate(horizontalSpeed * dt, verticalSpeed * dt);
    }
  }

  void renderAt(double x, double y, Canvas canvas) {
    // if (isLoaded) {
    if (clipToDimensions) {
      canvas.save();
      canvas.translate(x, y);
      canvas.clipRect(Rect.fromLTWH(0, 0, _width, _height));
    }
    _chunks.forEach((rect) {
      _sprite.renderRect(canvas, rect);
    });
    if (clipToDimensions) {
      canvas.restore();
    }
    // }
  }
}
