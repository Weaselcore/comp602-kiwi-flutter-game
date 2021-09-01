import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class InfoTicker extends TextComponent {
  late String initialText;
  late Vector2 initialPos;

  InfoTicker({required this.initialText, required this.initialPos})
      : super('') {
    this.text = initialText;
    this.position = initialPos;
    this.textRenderer = TextPaint(
      config: TextPaintConfig(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'BungeeInline',
      ),
    );
  }
}
