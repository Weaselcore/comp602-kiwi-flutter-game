import 'package:hive/hive.dart';

class BoxManager {
  Future<void> initBox(String boxName, Map<String, dynamic> map) async {
    if (!(await Hive.boxExists(boxName))) {
      // box has not exists yet. create a box.
      var box = await Hive.openBox(boxName);
      map.forEach((key, value) {
        box.put(key, value);
      });
    } else if ((await Hive.openBox("config")).length != map.length) {
      //update Hive
      // add new config to hive
      var box = await Hive.openBox(boxName);
      for (var key in map.keys) {
        if (!box.containsKey(key)) {
          box.put(key, map[key]);
        }
      }
    }else {
      // box exists. just open a box.
      print(boxName + "exists");
      await Hive.openBox(boxName);
    }
  }
}
