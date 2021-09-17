import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/hive/box_manager.dart';
import 'package:flutter_game/screens/main_menu.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter(ScoreItemAdapter());
  Hive.openBox<ScoreItem>("leaderboard");

  await Firebase.initializeApp();
  //need to save documentID for a user to register his/her game score to firebase.
  BoxManager boxManager = new BoxManager();

  var document = FirebaseFirestore.instance.collection('leaderboards').doc();

  //init a box for config
  Map<String, dynamic> configMap = {
    "isTiltOn": false,
    "isBgmMute": false,
    "isSfxMute": false,
    "documentID": document.id,
    "coin": 10,
    "skin": "kiwi_sprite.png",
  };

  // TODO add an update function for BoxManager
  if (!(await Hive.boxExists("config"))) {
    await boxManager.initBox("config", configMap);
  } else if ((await Hive.openBox("config")
        ..length) !=
      configMap.length) {
    await Hive.deleteBoxFromDisk("config");
    await boxManager.initBox("config", configMap);
  }

  Flame.device.fullScreen();
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
