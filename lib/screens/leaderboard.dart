import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/dao/local_score_dao.dart';
import 'package:flutter_game/screens/dao/remote_score_dao.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LeaderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeaderScreenState();
  }
}

class _LeaderScreenState extends State<LeaderScreen> {
  late LocalScoreDao scoreDao;
  static const _iconColors = [
    Colors.amberAccent,
    Colors.blueGrey,
    Colors.brown
  ];
  bool debug = false;

  @override
  void initState() {
    super.initState();

    scoreDao = new LocalScoreDao();

    //TODO remove this data population before launching the app

    if (debug) {
      print("isEmptyCheck");

      if (!scoreDao.getAll().isEmpty) {
        print("Clear all");
        scoreDao.deleteAll();
      }

      print("populate");
      for (int i = 1; i <= 10; i++) {
        print("$i times");
        ScoreItem item = new ScoreItem("user", (10 - i) * 1000);
        scoreDao.register(item);
      }

      //test data registeration
      scoreDao.register(new ScoreItem("try5 user", 29999999));
      var remoteDao = new RemoteScoreDao();
      remoteDao.register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ranking"),
      ),
      body: ValueListenableBuilder(
        valueListenable: scoreDao.box.listenable(),
        builder: (BuildContext context, value, Widget? child) {
          var scores = scoreDao.getAll();

          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: scores.length,
                  itemBuilder: (BuildContext context, int index) {
                    var entry = scores[index];
                    return ListTile(
                      leading: index <= 2
                          ? Icon(
                              Icons.emoji_events,
                              color: _iconColors[index],
                            )
                          : Text((index + 1).toString()),
                      title: Text(entry.userNm),
                      trailing: Text(entry.score.toString()),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: Text("Go back")),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
