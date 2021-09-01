import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/main_menu.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {

  if(!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter(ScoreItemAdapter());
  Hive.openBox<ScoreItem>("leaderboard");

  runApp(MyApp());
}

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
