import 'package:flutter/material.dart';
import 'package:flutter_game/screens/leaderboard.dart';
import 'package:flutter_game/screens/setting.dart';
import 'package:flutter_game/screens/shop.dart';
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
            child: ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopScreen()
                  ));
            },
                child: Text("Shop")),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingScreen()
                  ));
            },
                child: Text("Settings")),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaderScreen()
                  ));
            },
                child: Text("Leaderboard")),
          ),
        ],
      ),
    );
  }
}
