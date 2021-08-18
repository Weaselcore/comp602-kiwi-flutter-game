import 'package:flame/game/embedded_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/kiwi_game.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmbeddedGameWidget(
                      KiwiGame(),
                    ),
                  ),
                );
              },
              child: Text("New Game"),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(onPressed: null, child: Text("Shop")),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(onPressed: null, child: Text("Settings")),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(onPressed: null, child: Text("Leaderboard")),
          ),
        ],
      ),
    );
  }
}
