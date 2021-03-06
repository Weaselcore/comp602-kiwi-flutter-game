import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/dailyQuest/quest.dart';
import 'package:flutter_game/screens/dailyQuest/quest_manager.dart';
import 'package:flutter_game/screens/dailyQuest/quest_status.dart';
import 'package:flutter_game/screens/hive/box_manager.dart';
import 'package:flutter_game/screens/main_menu.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

//import 'package:rive/rive.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter(ScoreItemAdapter());
  Hive.openBox<ScoreItem>("leaderboard");
  //register QuestAdapter to handle Quest model
  Hive.registerAdapter(QuestAdapter());
  //open data store for quest
  Hive.openBox<Quest>("quest");
  //register QuestStatusAdapter to handle QuestStatus model
  Hive.registerAdapter(QuestStatusAdapter());

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
    "firstPlay": true,
    "dailyQuests": [],
    "lastLogin": DateTime.now(),
    "isAdsShown": false,
  };

  await boxManager.initBox("config", configMap);

  //setup quest data
  QuestManager.init();

  Flame.device.fullScreen();
  //initialize ads SDK
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Kiwi Fall',
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/mm.png"),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              // appBar: AppBar(
              //   title: const Text('Kiwi Fall'),
              // ),
              body: const MainMenu()),
        ));
  }
}
