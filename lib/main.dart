import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiwi Fall',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kiwi Fall'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: null, child: Text("New Game")),
              ElevatedButton(onPressed: null, child: Text("Shop")),
              ElevatedButton(onPressed: null, child: Text("Settings")),
              ElevatedButton(onPressed: null, child: Text("Leaderboard")),
            ],
          ),
        ),
      ),
    );
  }
}
