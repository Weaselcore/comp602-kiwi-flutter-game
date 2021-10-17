
import 'package:flutter_game/screens/notification/notification.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'package:hive/hive.dart';


class LocalScoreDao {

  late Box<ScoreItem>  _scoreBox;
  final String BOXNAME = "leaderboard";
  final int MAXIMUM = 10;

  LocalScoreDao() {
    _scoreBox = Hive.box<ScoreItem>(BOXNAME);
  }

  void register (ScoreItem newScoreItem) {
    List<ScoreItem> scores = getAll();

    if (scores.length >= MAXIMUM) {
      //records are more than 10
      if (_isRankedIn(scores,newScoreItem)) {
        //new score is ranked in
        _scoreBox.add(newScoreItem);
        //remove the lowesy socre in the ranking
        scores.last.delete();
      }
    } else {
      //records are less than 10
      _scoreBox.add(newScoreItem);
    }
  }

  /**
   * check is new score should be registered or not
   */
  bool _isRankedIn(List<ScoreItem> scores, ScoreItem newScoreItem) {
    bool isRanked = false;

    for (ScoreItem item in scores) {
      if (newScoreItem.score > item.score) {
        isRanked = true;
      }
    }

    return isRanked;
  }

  List<ScoreItem> getAll() {
    List<ScoreItem> scores = _scoreBox.values.toList().cast<ScoreItem>();
    //sort the list: higher score is listed in the higher rank.
    scores.sort((a,b) => b.score.compareTo(a.score));
    return scores;
  }

  /**
   * return highest score.
   */
  int getHighestScore() {
    List<ScoreItem> scores = getAll();
    if (scores.isEmpty) {
      return 0;
    } else {
      return scores.first.score;
    }
  }

  //TODO this might be used only for testcode in leaderboard.dart. check if we need to remove it or not.
  void deleteAll() {
    _scoreBox.deleteAll(_scoreBox.keys);
  }

  Box<ScoreItem> get box => _scoreBox;

}