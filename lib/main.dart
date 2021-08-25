import 'package:flutter/material.dart';
import 'package:flutter_game/screens/main_menu.dart';

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
        body: const MainMenu(),
      ),
    );
  }
}
