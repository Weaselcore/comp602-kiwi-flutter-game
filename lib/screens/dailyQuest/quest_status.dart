import 'package:hive/hive.dart';
import 'quest.dart';

part 'quest_status.g.dart';

// model class for daily quest
@HiveType(typeId: 2)
class QuestStatus {
  @HiveField(0)
  Quest _quest;

  @HiveField(1)
  bool _isSatisfied;

  @HiveField(2)
  bool _isRewardCollected;

  QuestStatus(this._quest, this._isSatisfied, this._isRewardCollected);

  //getter
  Quest get quest => _quest;
  bool get isSatisfied => _isSatisfied;
  bool get isRewardCollected => _isRewardCollected;

  //setter
  set isSatisfied(value) {
    _isSatisfied = value;
  }

  set isRewardCollected(value) {
    _isRewardCollected = value;
  }
}
