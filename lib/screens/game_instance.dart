// Creating this as a file private object so as to
// avoid unwanted rebuilds of the whole game object.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/kiwi_game.dart';
import 'package:flutter_game/game/overlay/pause_button.dart';
import 'package:flutter_game/game/overlay/pause_menu.dart';

KiwiGame _kiwiGame = KiwiGame();

// This class represents the actual game screen
// where all the action happens.
class GameInstance extends StatelessWidget {
  const GameInstance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WillPopScope provides us a way to decide if
      // this widget should be popped or not when user
      // presses the back button.
      body: WillPopScope(
        onWillPop: () async => false,
        // GameWidget is useful to inject the underlying
        // widget of any class extending from Flame's Game class.
        child: GameWidget(
          game: _kiwiGame,
          // Initially only pause button overlay will be visible.
          initialActiveOverlays: [PauseButton.ID],
          overlayBuilderMap: {
            PauseButton.ID: (BuildContext context, KiwiGame gameRef) =>
                PauseButton(
                  gameRef: gameRef,
                ),
            PauseMenu.ID: (BuildContext context, KiwiGame gameRef) => PauseMenu(
                  gameRef: gameRef,
                ),
            // GameOverMenu.ID: (BuildContext context, KiwiGame gameRef) =>
            //     GameOverMenu(
            //       gameRef: gameRef,
            //     ),
          },
        ),
      ),
    );
  }
}
