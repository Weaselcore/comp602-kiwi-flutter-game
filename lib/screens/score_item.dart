import 'package:hive/hive.dart';

part "score_item.g.dart";

// model class for score
@HiveType(typeId: 0)
class ScoreItem extends HiveObject {
  @HiveField(1)
  String userNm;

  @HiveField(2)
  int score;

  ScoreItem(this.userNm, this.score);
}
