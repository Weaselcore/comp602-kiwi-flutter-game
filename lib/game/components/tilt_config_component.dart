import 'package:flame/components.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box configBox;
late bool isTiltOn;

class TiltConfig extends Component with HasGameRef {
  //loads hive box
  @override
  Future<void>? onLoad() async {
    configBox = Hive.box("config");

    return super.onLoad();
  }

  //fetches settings from hive box to recieve toggle boolean
  void fetchSettings() {
    isTiltOn = configBox.get("isTiltOn");
  }

  //returns tilt configuration
  bool getConfig() {
    return isTiltOn;
  }
}
