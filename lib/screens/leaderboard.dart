import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderScreen extends StatelessWidget {
  const LeaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _iconColors = [Colors.amberAccent, Colors.blueGrey, Colors.brown];
    List<listItem> items = populateData();

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: index <= 2 ? Icon(Icons.emoji_events, color: _iconColors[index],) : Text((index + 1).toString()),
                    title: Text(items[index]._userNm),
                    trailing: Text(items[index]._score.toString()),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text("Go back")
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<listItem> populateData() {
    final List<listItem> items  = <listItem>[];
    for (int i = 1; i <= 10; i++) {
      listItem item = new listItem("user$i", (10-i)*1000);
      items.add(item);
    }
    return items;
  }
}

class listItem {
  String _userNm;
  int _score;

  listItem(this._userNm, this._score);

  //getter
  String get name => _userNm;
  int get score => _score;
}