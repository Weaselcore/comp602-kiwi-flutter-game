import 'package:flutter/material.dart';
import 'package:flutter_game/game/overlay/pause_button.dart';

import '../kiwi_game.dart';

class EndGameMenu extends StatelessWidget {
  final KiwiGame gameRef;

  const EndGameMenu({Key? key, required this.gameRef}) : super(key: key);
  static const String ID = 'EndGameMenu';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                'GAME OVER',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Restart button.
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () {
                      gameRef.overlays.remove(EndGameMenu.ID);
                      gameRef.overlays.add(PauseButton.ID);
                      gameRef.reset();
                      gameRef.resumeEngine();
                      gameRef.audioManager.playBgm('background.mp3');
                    },
                    child: Text('Restart'),
                  ),
                ),

                // Exit button.
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      gameRef.overlays.remove(EndGameMenu.ID);
                      gameRef.getKiwi().remove();
                      gameRef.reset();
                    },
                    child: Text('Exit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
