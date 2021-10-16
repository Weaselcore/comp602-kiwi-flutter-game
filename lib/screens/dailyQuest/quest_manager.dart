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

    //reason why updating lastlogin here: Since I could not update lastLogin in constructor of main menu
    //this method runs when the app is launched. Thus, not different from updating lastLogin in constructor of main menu.
    _configBox.put("lastLogin", DateTime.now());
    //populate quets data if it is necessary.
    prepareQuestData();

    //if daily quests are not registered (this happens when the app is lunched for the very first time)
    List dailyQuests = _configBox.get("dailyQuests");
    if (dailyQuests.isEmpty) {
      //initialize daily quest
      generateRandomDailyQuests();
    }
  }

  /**
   * populate data
   * if there is no quest data registered
   *    or new quest data is added or deleted
   */
  static void prepareQuestData() {
    LocalQuestDao dao = new LocalQuestDao();
    //get quest data to be registered
    List<Quest> questData = generateQuestData();

    //if there is no quest data registered in data store
    //or new quest data is added or deleted
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
    DateTime lastLogin = _configBox.get("lastLogin");
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
    List dailyQuests = _configBox.get("dailyQuests");
    LocalQuestDao dao = new LocalQuestDao();
    int dataSize = dao.getSize();
    Iterable<Quest>? questData = dao.getAll();

    //step1. randomly select quest id
    Set newQuestIds = <int>{};
    while (newQuestIds.length < NUMQUESTS) {
      int questId = Random().nextInt(dataSize);
      newQuestIds.add(questId);
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
   * numCoins: the number of coins player gets
   * score: the score a player earns
   * usedItems: the number of power-up items used
   * numEnemies: the number of enemies passed
   * numBosses: the number of bosses a player defeat
   */
  static void checkQuestCompletion(int numCoins, int score, int usedItems, int numEnemies , int numBosses) async {
    //get daily quests
    List<QuestStatus> dailyQuests = _configBox.get("dailyQuests");
    for (QuestStatus questSatatus in dailyQuests) {

      //check game status only if it is not completed yet.
      if (!questSatatus.isSatisfied) {
        //check conditions corresponding to quest type
        switch (questSatatus.quest.questType) {
          case "coin":
            if (questSatatus.quest.counter <= numCoins) {
              makeStatusComplete(questSatatus);
            }
            break;
          case "score":
            if (questSatatus.quest.counter <= score) {
              makeStatusComplete(questSatatus);
            }
            break;
          case "item":
            if (questSatatus.quest.counter <= usedItems) {
              makeStatusComplete(questSatatus);
            }
            break;
          case "enemy":
            if (questSatatus.quest.counter <= numEnemies) {
              makeStatusComplete(questSatatus);
            }
            break;
          case "boss":
            if (questSatatus.quest.counter <= numBosses) {
              makeStatusComplete(questSatatus);
            }
            break;
        }
      }
    }
  }

  /**
   * make daily quest status completed
   */
  static void makeStatusComplete(QuestStatus questStatus) {
    questStatus.isSatisfied = true;
  }

  /**
   * This function returns a list of quest data to be registered.
   */
  static List<Quest> generateQuestData() {
    List<Quest> quests = [];

    Quest quest0 =
        new Quest(0, "coin", "Get coins more than 10", "coin", 5, 10);
    quests.add(quest0);

    Quest quest1 =
        new Quest(1, "enemy", "Break enemies more than 5", "coin", 10, 5);
    quests.add(quest1);

    Quest quest2 =
        new Quest(2, "score", "Earn score more than 20", "coin", 15, 20);
    quests.add(quest2);

    Quest quest3 = new Quest(3, "item", "Use 3 items", "coin", 20, 3);
    quests.add(quest3);

    Quest quest4 = new Quest(4, "boss", "Defeat a boss", "coin", 25, 1);
    quests.add(quest4);

    return quests;
  }
}
