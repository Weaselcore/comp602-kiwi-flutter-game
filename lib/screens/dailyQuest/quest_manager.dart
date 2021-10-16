import 'package:flutter_game/screens/dailyQuest/quest.dart';
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
    //populate quets data if it is necessary.
    prepareQuestData();
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

    //if there is no quest data registered
    //or new quest data is added or deleted
    if (dao.getSize() == 0 || questData.length != dao.getSize()) {
      //replace old quest data with new quest data
      dao.replaceAll(questData);
    }
  }

  /**
   * This function returns a list of quest data to be registered.
   */
  static List<Quest> generateQuestData() {
    List<Quest> quests = [];

    Quest quest0 =
        new Quest(0, "coin", "get coins more than 10", "coin", 5, 10);
    quests.add(quest0);

    Quest quest1 =
        new Quest(1, "enemy", "break enemies more than 5", "coin", 10, 5);
    quests.add(quest1);

    Quest quest2 =
        new Quest(2, "score", "earn score more than 30", "coin", 15, 30);
    quests.add(quest2);

    Quest quest3 = new Quest(3, "item", "use 3 items", "coin", 20, 3);
    quests.add(quest3);

    Quest quest4 = new Quest(4, "boss", "beat a boss", "coin", 25, 1);
    quests.add(quest4);

    return quests;
  }
}
