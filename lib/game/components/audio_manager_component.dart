import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AudioManagerComponent extends Component with HasGameRef {
  late bool isBgmMute;
  late bool isSfxMute;
  late Box configBox;

  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    configBox = Hive.box("config");

    //loads audio files to cache for faster loading
    await FlameAudio.audioCache.loadAll([
      'armour.wav',
      'background.mp3',
      'coin.wav',
      'death.mp3',
      'laser.mp3',
      'pop.wav',
      'slow_time.wav'
    ]);

    return super.onLoad();
  }

  //play audio background music
  void playBgm(String audioFile) {
    if (isBgmMute) {
      FlameAudio.bgm.play(audioFile);
    }
  }

  //play audio sound effects music
  void playSfx(String audioFile) {
    if (isSfxMute) {
      FlameAudio.play(audioFile);
    }
  }

  //stop background music
  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  //pause background music
  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  //resume background music
  void resmueBgm() {
    FlameAudio.bgm.resume();
  }

  void resetBgm(String audioFile) {
    FlameAudio.bgm.stop();
    playBgm(audioFile);
  }

  //fetch audio config toggle settings
  void fetchSettings() {
    isBgmMute = configBox.get("isBgmMute");
    isSfxMute = configBox.get("isSfxMute");
  }
}
