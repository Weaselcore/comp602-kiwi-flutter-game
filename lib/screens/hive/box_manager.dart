import 'package:hive/hive.dart';

class BoxManager {
  Future<void> initBox(String boxName, Map<String, dynamic> map) async {
    if (!(await Hive.boxExists(boxName))) {
      // box has not exists yet. create a box.
      print(boxName + "is not set up yet");
      var box = await Hive.openBox(boxName);
      map.forEach((key, value) {
        box.put(key, value);
      });
    } else {
      // box exists. just open a box.
      print(boxName + "exists");
      await Hive.openBox(boxName);
    }
  }
}
