import 'package:flutter/material.dart';
import 'package:flutter_game/screens/leaderboard.dart';
import 'package:flutter_game/screens/questboard.dart';
import 'package:flutter_game/screens/setting.dart';
import 'package:flutter_game/screens/shop.dart';
import 'package:flutter_game/screens/game_instance.dart';
import 'package:hive/hive.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, //mainAxisAlignment: MainAxisAlignment.spaceEvenly
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    )).then((value) => _setLoginDate());
              },
              child: Text("New Game"),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          SizedBox(height: 110.0),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShopScreen())).then((value) => _setLoginDate());
                },
                child: Text("Shop"),
                style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
                ),
            ),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen())).then((value) => _setLoginDate());
                },
                child: Text("Settings"),
                style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LeaderScreen())).then((value) => _setLoginDate());
                },
                child: Text("Leaderboard"),
                style: ElevatedButton.styleFrom(
                primary: Colors.brown[500],
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuestBoard())).then((value) => _setLoginDate());
              },
              child: Text("Questboard"),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown[500],
                onPrimary: Colors.orangeAccent,
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  /**
   * set current time to last login
   */
  void _setLoginDate() {
    Hive.box("config").put("lastLogin", DateTime.now());
  }
}
