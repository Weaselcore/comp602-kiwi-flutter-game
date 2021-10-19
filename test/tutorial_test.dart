import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/audio_manager_component.dart';
import 'package:flutter_game/game/kiwi_game.dart';
import 'package:flutter_game/game/overlay/tutorial_slides.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([KiwiGame, AudioManagerComponent])
void main() {
  setUp(() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    var audioBox = await Hive.openBox("config");
    audioBox.put("firstPlay", true);
  });

  group("tutorial test", () {
    testWidgets("tutorial flag setting test", (WidgetTester tester) async {
      //mock KiwiGame
      var kiwiGame = KiwiGame();
      //mock AudioManagerComponent
      kiwiGame.audioManager = AudioManagerComponent();
      //open a hive box(data store)
      Box config = Hive.box("config");

      //build tutorial slides logically.
      await tester.pumpWidget(MaterialApp(
        home: TutorialSlides(gameRef: kiwiGame),
      ));

      //tap a textbuttn to swipe a slide.
      await tester.tap(find.text("Next", skipOffstage: false).first);
      await tester.pumpAndSettle();
      //tap a textbuttn to swipe a slide.
      await tester.tap(find.text("Next", skipOffstage: false).at(1));
      await tester.pumpAndSettle();
      //tap a textbutton to swipe a slide
      await tester.tap(find.text("Next", skipOffstage: false).last);
      await tester.pumpAndSettle();
      //tap a textbuttn to finish tutorial.
      await tester.tap(find.text("Start Game", skipOffstage: false).first);
      //check if the firstplay flag becomes false after tutorial finished.
      expect(config.get("firstPlay"), false);
    });

  });
}