import 'package:flutter/material.dart';
import 'package:flutter_game/game/kiwi_game.dart';

import 'pause_button.dart';

// This class represents the pause menu overlay.
class PauseMenu extends StatelessWidget {
  static const String ID = 'PauseMenu';
  final KiwiGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause menu title.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Paused',
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),

          // Resume button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.audioManager.resmueBgm();
              },
              child: Text('Resume'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),

          // Restart button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.reset();
                gameRef.resumeEngine();
                gameRef.audioManager.resetBgm('background.mp3');
              },
              child: Text('Restart'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),

          // Exit button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.reset();
                gameRef.audioManager.stopBgm();
                gameRef.getKiwi().remove();
                Navigator.of(context).pop();
              },
              child: Text('Exit'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
