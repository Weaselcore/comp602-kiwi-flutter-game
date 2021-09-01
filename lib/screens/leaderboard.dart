import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LeaderScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LeaderScreenState();
  }
}

class _LeaderScreenState extends State<LeaderScreen> {

  late Box<ScoreItem>  scoreBox;
  final String BOXNAME = "leaderboard";
  static const _iconColors = [Colors.amberAccent, Colors.blueGrey, Colors.brown];

  @override
  void initState() {
    super.initState();

    scoreBox = Hive.box<ScoreItem>(BOXNAME);

    //TODO remove this data population before launching the app
    bool debug = true;
    if (debug) {
      print("isEmptyCheck");

      if (!scoreBox.isEmpty) {
        print("Clear all");
        scoreBox.deleteAll(scoreBox.keys);
      }

      print("populate");
      for (int i = 1; i <= 10; i++) {
        print("$i times");
        ScoreItem item = new ScoreItem(i-1, "user$i", (10-i)*1000);
        scoreBox.add(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
        body: ValueListenableBuilder(
          valueListenable: scoreBox.listenable(),
          builder: (BuildContext context, value, Widget? child) {
            var scores = scoreBox.values.toList().cast<ScoreItem>();
            scores.sort((a,b) => a.rank.compareTo(b.rank));
            int len = scoreBox.length;
            print("length $len");

            return
              Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: scores.length,
                        itemBuilder: (BuildContext context, int index) {
                          var entry = scores[index];
                          return ListTile(
                            leading: index <= 2 ? Icon(Icons.emoji_events, color: _iconColors[index],) : Text((index + 1).toString()),
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
                            child: Text("Go back")
                        ),
                      ],
                    ),
                  ],
                );
          },
        ),
      );
  }

}


