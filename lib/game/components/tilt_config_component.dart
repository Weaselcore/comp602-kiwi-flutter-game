import 'package:flame/components.dart';
//import 'package:sensors_plus/sensors_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box configBox;
late bool isTiltOn;

class TiltController extends Component with HasGameRef {
  @override
  Future<void>? onLoad() async {
    configBox = Hive.box("config");

    return super.onLoad();
  }

  void fetchSettings() {
    isTiltOn = configBox.get("isTiltOn");
  }

  bool getConfig() {
    return isTiltOn;
  }
}
