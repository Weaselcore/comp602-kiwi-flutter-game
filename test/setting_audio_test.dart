import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  setUp(() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    var audioBox = await Hive.openBox("audio");
    audioBox.put("isBgmMute", false);
    audioBox.put("isSfxMute", false);
  });

  group("audio on setting screen test", () {
    testWidgets("Mute audio setting", (WidgetTester tester) async {
      Box audioBox = Hive.box("audio");

      Widget testWidget = new MediaQuery(
          data: new MediaQueryData(),
          child: new MaterialApp(home: new SettingScreen()));
      await tester.pumpWidget(testWidget);
      //Bofore mute BGM, BGM setting should be unmuted.
      expect(audioBox.get("isBgmMute"), false);
      await tester.tap(
          find.byIcon(IconData(0xe6c3, fontFamily: 'MaterialIcons')).first);
      //after tapping BGM mute button, BGM setting should be muted.
      expect(audioBox.get("isBgmMute"), true);
    });

    testWidgets("Mute SFX setting", (WidgetTester tester) async {
      Box audioBox = Hive.box("audio");

      Widget testWidget = new MediaQuery(
          data: new MediaQueryData(),
          child: new MaterialApp(home: new SettingScreen()));
      await tester.pumpWidget(testWidget);
      //Bofore mute SFX, SFX setting should be unmuted.
      expect(audioBox.get("isSfxMute"), false);
      await tester
          .tap(find.byIcon(IconData(0xe6c3, fontFamily: 'MaterialIcons')).last);
      //after tapping SFX mute button, SFX setting should be muted.
      expect(audioBox.get("isSfxMute"), true);
    });
  });
}
