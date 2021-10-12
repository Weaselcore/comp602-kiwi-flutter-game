import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/overlay/pause_button.dart';

import '../kiwi_game.dart';

class TutorialSlides extends StatefulWidget {
  static const String ID = "tutorial";
  final KiwiGame gameRef;

  TutorialSlides({required this.gameRef});

  @override
  State<StatefulWidget> createState() {
    return _TutorialSlidesState(gameRef: gameRef);
  }
}

class _TutorialSlidesState extends State<TutorialSlides> {
  KiwiGame gameRef;
  int _index = 0;
  late PageController _pageController;

  _TutorialSlidesState({required KiwiGame this.gameRef});

  @override
  void initState() {
    super.initState();
    //init pagecontroller with config
    _pageController =
        PageController(initialPage: _index, viewportFraction: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    List<SliderModel> slides = getSlides();

    return Center(
      child: SizedBox(
        height: 400,
        child: PageView.builder(
          itemCount: slides.length,
          controller: _pageController,
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            var entry = slides[i];
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: Card(
                color: Colors.white.withOpacity(.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(entry.title, style: TextStyle(fontSize: 30)),
                    Image.asset(entry.imagePath),
                    Text(
                      entry.desc,
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    i < slides.length - 1
                        ? TextButton(
                            child: Text("Next"),
                            onPressed: () {
                              _pageController.animateToPage(++_index,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.linear);
                            })
                        : TextButton(
                            child: Text("Start Game"),
                            onPressed: () {
                              gameRef.resumeEngine();
                              gameRef.overlays.remove(TutorialSlides.ID);
                              gameRef.overlays.add(PauseButton.ID);
                              gameRef.audioManager.resmueBgm();
                            }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<SliderModel> getSlides() {
    List<SliderModel> slides = [];
    SliderModel sliderModel = new SliderModel(
        title: 'Dodge Enemies',
        imagePath: 'assets/images/tutorial1.png',
        desc: 'tap/tilt to right and left to dodge enemies!');
    slides.add(sliderModel);

    sliderModel = new SliderModel(
        title: 'Get Coins',
        imagePath: 'assets/images/tutorial2.png',
        desc: 'Collecting coins for buying new skins!');
    slides.add(sliderModel);

    sliderModel = new SliderModel(
        title: 'Get Powerups',
        imagePath: 'assets/images/tutorial3.png',
        desc: 'You can use many powerup items!');
    slides.add(sliderModel);

    return slides;
  }
}

class SliderModel {
  late String title;
  late String imagePath;
  late String desc;

  SliderModel(
      {required this.title, required this.imagePath, required this.desc});
}
