import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManagerComponent extends Component with HasGameRef {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

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
    FlameAudio.bgm.play(audioFile);
  }

  void playSfx(String audioFile) {
    FlameAudio.play(audioFile);
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
    FlameAudio.bgm.play(audioFile);
  }
}
