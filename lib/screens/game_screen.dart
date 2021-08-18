import 'package:flame/game/embedded_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/kiwi_game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmbeddedGameWidget(KiwiGame());
  }
}
