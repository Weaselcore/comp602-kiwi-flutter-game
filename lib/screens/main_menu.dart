import 'package:flutter/material.dart';
import 'package:flutter_game/screens/game_instance.dart';

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
                      // No need to add a GameScreen in the screen folder.
                      builder: (context) => GameInstance(),
                    ));
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
