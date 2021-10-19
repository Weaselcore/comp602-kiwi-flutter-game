import 'dart:math';

import 'package:flutter_game/screens/dailyQuest/quest.dart';
import 'package:flutter_game/screens/dailyQuest/quest_status.dart';
import 'package:flutter_game/screens/dao/local_quest_dao.dart';
import 'package:hive/hive.dart';

class QuestManager {
  static final String CONFIGBOXNAME = "config";
  static late Box<Quest> _questBox;
  static late Box _configBox;
  //quantity of daily quests *NUMQUETST should be smaller than the nunmber of daily quests registered*
  static final int NUMQUESTS = 3;

  static init() async {
    //make config box available from other methods in this class
    _configBox = await Hive.openBox(CONFIGBOXNAME);

    //populate quest data if it is necessary.
    _prepareQuestData();

    List dailyQuests = _configBox.get("dailyQuests");
    //if daily quests are not registered (this happens when the app is lunched for the very first time)
    if (dailyQuests.isEmpty) {
      //initialize daily quest
      generateRandomDailyQuests();
    }

    //for updating daily quests under the following condition
    //a player launches the app for the first time in a day/ some days.
    if (oneDayPassed(DateTime.now())) {
      generateRandomDailyQuests();
      //if the date changes, a player can watch a reward Ad once a day.
      _configBox.put("isAdsShown", false);
    }

    //reason why updating lastlogin here: Since I could not update lastLogin in constructor of main menu
    //this method runs when the app is launched. Thus, not different from updating lastLogin in constructor of main menu.
    _configBox.put("lastLogin", DateTime.now());
  }

  /**
   * populate data
   * if there is no quest data registered in data store
   *    or new quest data is added or deleted and the length is different from the ones in data store
   */
  static void _prepareQuestData() {
    LocalQuestDao dao = new LocalQuestDao();
    //get quest data to be registered
    List<Quest> questData = _generateQuestData();

    //if there is no quest data registered in data store
    //or the length of new quest data is different from the one's in data store
    if (dao.getSize() == 0 || questData.length != dao.getSize()) {
      //replace old quest data with new quest data
      dao.replaceAll(questData);
    }
  }

  /**
   * Check if updating daily quests is needed or not.
   * return true if more than one day has passed since last login
   */
  static bool oneDayPassed(DateTime targetDate) {
    //get last login
    dynamic lastLogin = _configBox.get("lastLogin");
    //check if one day has passed since last login
    return targetDate.difference(lastLogin).inDays >= 1;
  }

  /**
   * generate new daily quests
   *  step1. randomly select quest id
   *  step2. retrieve quests info that corresponds to selected ids
   *  step3. register quests retrieved in step2 as daily quests
   */
  static generateRandomDailyQuests() async {
    LocalQuestDao dao = new LocalQuestDao();
    int biggestId = dao.getBiggestId();
    Iterable<Quest>? questData = dao.getAll();

    //step1. randomly select quest id
    Set newQuestIds = <int>{};
    while (newQuestIds.length < NUMQUESTS) {
      int questId = Random().nextInt(biggestId);
      //check if there is a quest that maches randomely selected id in data store.
      if (questData!.where((item) => item.id == questId).isNotEmpty) {
        newQuestIds.add(questId);
      }
    }

    //a list od quest data for daily quests
    List<QuestStatus> newDailyQuests = [];
    for (int id in newQuestIds) {
      //step2. retrieve quest info that corresponds to selected ids.
      Quest quest = questData!.where((item) => item.id == id).first;
      newDailyQuests.add(new QuestStatus(quest, false, false));
    }

    //step3. register quests retrieved in step2 as daily quests
    _configBox.put("dailyQuests", newDailyQuests);
  }

  /**
   * judge if the game result satisfies daily quests.
   * parameters
   * numCoins: the number of coins a player gets
   * score: the score a player earns
   * usedItems: the number of power-up items a player uses
   * numEnemies: the number of enemies a player breaks
   * numBosses: the number of bosses a player defeats
   */
  static void checkQuestCompletion(int numCoins, int score, int usedItems,
      int numEnemies, int numBosses) async {
    //get daily quests

    List<dynamic> dailyQuests = _configBox.get("dailyQuests");
    for (QuestStatus questSatatus in dailyQuests) {
      //check quest completion only if it is not completed yet.
      if (!questStatus.isSatisfied) {
        //check conditions corresponding to quest type
        switch (questStatus.quest.questType) {
          case "coin":
            if (questStatus.quest.counter <= numCoins) {
              _makeStatusComplete(questStatus);
            }
            break;
          case "score":
            if (questStatus.quest.counter <= score) {
              _makeStatusComplete(questStatus);
            }
            break;
          case "item":
            if (questStatus.quest.counter <= usedItems) {
              _makeStatusComplete(questStatus);
            }
            break;
          case "enemy":
            if (questStatus.quest.counter <= numEnemies) {
              _makeStatusComplete(questStatus);
            }
            break;
          case "boss":
            if (questStatus.quest.counter <= numBosses) {
              _makeStatusComplete(questStatus);
            }
            break;
        }
      }
    }
  }

  /**
   * make daily quest status completed
   */
  static void _makeStatusComplete(QuestStatus questStatus) {
    questStatus.isSatisfied = true;
  }

  /**
   * This function returns a list of quest data to be registered.
   */
  static List<Quest> _generateQuestData() {
    List<Quest> quests = [];

    Quest quest0 = new Quest(0, "coin", "Get 10 coins", "coin", 5, 10);
    quests.add(quest0);

    Quest quest1 = new Quest(1, "enemy", "Break 5 enemies", "coin", 10, 5);
    quests.add(quest1);

    Quest quest2 = new Quest(2, "score", "Score 20 points", "coin", 15, 20);
    quests.add(quest2);

    Quest quest3 = new Quest(3, "item", "Use 3 items", "coin", 20, 3);
    quests.add(quest3);

    Quest quest4 = new Quest(4, "boss", "Defeat a boss", "coin", 25, 1);
    quests.add(quest4);

    return quests;
  }
}
