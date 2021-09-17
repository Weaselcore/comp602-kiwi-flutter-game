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

  void playBgm(String audioFile) {
    if (isBgmMute) {
      FlameAudio.bgm.play(audioFile);
    }
  }

  void playSfx(String audioFile) {
    if (isSfxMute) {
      FlameAudio.play(audioFile);
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  void resmueBgm() {
    FlameAudio.bgm.resume();
  }

  void resetBgm(String audioFile) {
    FlameAudio.bgm.stop();
    playBgm(audioFile);
  }

  void fetchSettings() {
    isBgmMute = configBox.get("isBgmMute");
    isSfxMute = configBox.get("isSfxMute");
  }
}
