import 'package:hive/hive.dart';

part 'quest.g.dart';

// model class for daily quest
@HiveType(typeId: 1)
class Quest extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String questType;

  @HiveField(2)
  String desc;

  @HiveField(3)
  String rewardType;

  @HiveField(4)
  int rewardAmount;

  @HiveField(5)
  int counter;

  Quest(this.id, this.questType, this.desc, this.rewardType,
      this.rewardAmount, this.counter);
}
