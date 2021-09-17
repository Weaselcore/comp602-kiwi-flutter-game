import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flame/flame.dart';
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

  await Firebase.initializeApp();
  //need to save documentID for a user to register his/her game score to firebase.
  if (!(await Hive.boxExists("documentID"))) {
    print("No docID registered");
    //there is not documentID registered.
    //cretate new documentID and register it to Hive(local)
    var box = await Hive.openBox("documentID");
    var document = FirebaseFirestore.instance
        .collection('leaderboards').doc();
    box.put('documentID', document.id);
  } else {
    // documentID already registered. just open a box.
    await Hive.openBox("documentID");
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
