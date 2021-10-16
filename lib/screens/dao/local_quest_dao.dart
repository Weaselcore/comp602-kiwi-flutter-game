import 'package:flutter_game/screens/dailyQuest/quest.dart';
import 'package:hive/hive.dart';

/**
 * This is for accessing datas tore of quest
 */
class LocalQuestDao {

  late Box<Quest> _questBox;
  final String BOXNAME = "quest";

  LocalQuestDao() {
    _questBox = Hive.box<Quest>(BOXNAME);
  }

  /**
   * return all the stored quest data
   */
  Iterable<Quest>? getAll() {
    return _questBox.values;
  }

  /**
   * return the quentity of registed quest data
   */
  int getSize() {
    return _questBox.length;
  }

  /**
   * replace exiting quest data with passed quest data
   */
  void replaceAll(List<Quest> quests) {
    if (getSize() != 0) {
      _questBox.clear();
    }

    _questBox.addAll(quests);
  }
}