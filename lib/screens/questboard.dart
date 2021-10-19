import 'package:flutter/material.dart';
import 'package:flutter_game/screens/dailyQuest/quest_status.dart';
import 'package:hive/hive.dart';

import 'dailyQuest/quest_manager.dart';

class QuestBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestBoardState();
  }

}

class _QuestBoardState extends State<QuestBoard> {

  late List<dynamic> _dailyQuests = [];
  late Box _configBox;
  // final ValueNotifier<List<QuestStatus>> dailyQuestNotifier = ValueNotifier(_dailyQuests);

  @override
  void initState() {
    super.initState();
    _configBox = Hive.box("config");
    _dailyQuests = [];
    initDailyQuest();
  }

  void initDailyQuest() async {
    // if one day has passed since last login. generate new daily quests
    if (QuestManager.oneDayPassed(DateTime.now())) {
      //generate daily quests and register then in user config
      await QuestManager.generateRandomDailyQuests();
      //update last login
      _configBox.put("lastLogin", DateTime.now());

    }

    //notify that _dailyQuests is initialized.
    setState(() {
      //get daily quests from user config
      _dailyQuests = _configBox.get("dailyQuests");
    });
  }

  void _giveRewards(QuestStatus questStatus) {
    int coin = _configBox.get("coin");
    setState(() {
      _configBox.put(questStatus.quest.rewardType, coin + questStatus.quest.rewardAmount);
      questStatus.isRewardCollected = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Quests"),
        leading: Icon(Icons.calendar_today),
        backgroundColor: Colors.brown,
      ),
      body: (_dailyQuests.isEmpty) ?
      //if _dailyQuests has not been initialized yet, show loading message
      Center(
        child: Text("Loading"),
      ) :
      //if _dailyQuests is initialized, show list view
      Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount:  _dailyQuests.length,
              itemBuilder: (BuildContext context, int index) {
                var entry = _dailyQuests[index];
                return ListTile(
                  title: Text(entry.quest.desc),
                  trailing: (entry.isRewardCollected) ?
                  //if reward is collected, show "collected" disable button
                  ElevatedButton(
                    child: Text("Collected"),
                    onPressed: null,
                  ) :
                  (entry.isSatisfied) ?
                  //if quest is completed and reward is not collected, show "collect" button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text("Collect " + entry.quest.rewardAmount.toString() + " " +entry.quest.rewardType.toString()),
                    onPressed: () => _giveRewards(entry),
                  ) :
                  //if quest is not colpmeted, show disable button
                  ElevatedButton(
                    child: Text("Not completed"),
                    onPressed: null,
                  ),
                );
              }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () => {Navigator.of(context).pop()},
                  child: Text("Go back"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown,
                    onPrimary: Colors.orangeAccent,
                    side: BorderSide(color: Colors.black, width: 2),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

}