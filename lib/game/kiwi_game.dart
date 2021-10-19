import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/audio_manager_component.dart';
import 'package:flutter_game/game/components/boss/wizard_lighting.dart';
import 'package:flutter_game/game/components/boss/wizard_prep_lightning.dart';
import 'package:flutter_game/game/components/coin/coin.dart';
import 'package:flutter_game/game/components/coin/coin_manager.dart';
import 'package:flutter_game/game/components/coin/coin_tracker.dart';
import 'package:flutter_game/game/components/controls/tilt_controls.dart';
import 'package:flutter_game/game/components/difficulty_manager.dart';
import 'package:flutter_game/game/components/enemy/enemy_manager.dart';
import 'package:flutter_game/game/components/kiwi.dart';
import 'package:flutter_game/screens/notification/notification.dart' as notif;
import 'package:hive/hive.dart';

import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/components/powerup/component/laser_beam.dart';
import 'package:flutter_game/game/components/powerup/powerup_tracker.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_manager.dart';
import 'package:flutter_game/game/components/enemy/enemy_tracker.dart';
import 'package:flutter_game/screens/dao/local_score_dao.dart';
import 'package:flutter_game/screens/dao/remote_score_dao.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'components/boss/boss.dart';
import 'components/boss/boss_manager.dart';
import 'components/boss/boss_tracker.dart';
import 'components/boss/ufo_bullet.dart';
import 'components/background.dart';
import 'components/tilt_config_component.dart';
import 'components/transition.dart';
import 'game_size_aware.dart';
import 'overlay/hud.dart';
import 'overlay/pause_button.dart';
import 'overlay/pause_menu.dart';
import 'overlay/tutorial_slides.dart';

class KiwiGame extends BaseGame with HasCollidables, HasDraggableComponents {
  bool isAlreadyLoaded = false;
  bool gameEnded = false;
  bool _isSlowed = false;
  bool _isGodMode = false;

  bool isLocalScoreDaoLoaded = false;
  bool isRemoteScoreDaoLoaded = false;
  late LocalScoreDao localScoreDao;
  late RemoteScoreDao remoteScoreDao;

  bool isNotificationLoaded = false;
  late notif.Notification notification;

  bool isAudioManagerLoaded = false;
  bool isTiltConfigLoaded = false;
  TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();

  int score = 0;
  int coin = 0;
  int usedItem = 0;
  int beatenEnemy = 0;
  int beatenBoss = 0;

  late Kiwi _kiwi;

  late AudioManagerComponent audioManager;
  late Box configBox;

  late TiltConfig tiltConfigManager;
  late bool isTiltControls;
  double tiltXVelocity = 0.0;
  double tiltYVelocity = 0.0;

  late EnemyTracker enemyTracker;
  late EnemyManager enemyManager;
  late PowerUpTracker powerUpTracker;
  late PowerUpManager powerUpManager;
  late CoinManager _coinManager;
  late CoinTracker coinTracker;
  late BossManager bossManager;
  late BossTracker bossTracker;

  late DifficultyManager difficultyManager;

  late JoystickComponent joystick;

  late Hud hud;

  late Timer _slowTimer;
  late Timer _laserTimer;

  late LaserBeam _laserBeam;
  int highScore = 0;
  bool isNotified = false;
  late bool firstPlay;

  late Transition transitionComponent = Transition();

  String kiwiSkin = "kiwi_sprite.png";

  KiwiGame({isGodmode}) {
    this._isGodMode = _isGodMode;
    _slowTimer = Timer(5, callback: _restoreEnemySpeed, repeat: false);
    _laserTimer = Timer(5, callback: removeLaser, repeat: false);
  }

  /// Loads everything asynchronously before the game starts.
  @override
  Future<void> onLoad() async {
    if (!isLocalScoreDaoLoaded) {
      localScoreDao = LocalScoreDao();
      isLocalScoreDaoLoaded = true;
      highScore = localScoreDao.getHighestScore();
    }

    if (!isRemoteScoreDaoLoaded) {
      remoteScoreDao = RemoteScoreDao();
      isRemoteScoreDaoLoaded = true;
    }

    if (!isNotificationLoaded) {
      notification = notif.Notification();
      isNotificationLoaded = true;
    }

    if (!isAudioManagerLoaded) {
      audioManager = AudioManagerComponent();
      add(audioManager);
      isAudioManagerLoaded = true;
    }

    configBox = await Hive.openBox("config");
    kiwiSkin = configBox.get("skin");
    firstPlay = configBox.get("firstPlay");

    if (!isTiltConfigLoaded) {
      tiltConfigManager = TiltConfig();
      add(tiltConfigManager);
    }

    difficultyManager = DifficultyManager();

    tiltConfigManager.fetchSettings();
    isTiltControls = tiltConfigManager.getConfig();

    audioManager.fetchSettings();
    audioManager.playBgm('background.mp3');

    _kiwi = Kiwi(
      sprite: await Sprite.load(kiwiSkin),
      size: Vector2(122, 76),
      position: Vector2(viewport.canvasSize.x / 2, viewport.canvasSize.y / 3),
    );
    _kiwi.anchor = Anchor.center;
    add(_kiwi);

    joystick = JoystickComponent(
      gameRef: this,
      directional: JoystickDirectional(
          size: 100, margin: EdgeInsets.only(left: 100, bottom: 100)),
      actions: [
        JoystickAction(
          actionId: 0,
          size: 60,
          margin: const EdgeInsets.all(
            50,
          ),
        ),
      ],
    );

    joystick.addObserver(_kiwi);
    add(joystick);
    joystick.priority = 1;

    if (!isAlreadyLoaded) {
      add(Background());

      hud = Hud(_kiwi);
      add(hud);
      enemyManager = EnemyManager(difficultyManager);
      add(enemyManager);
      enemyTracker = EnemyTracker();
      add(enemyTracker);
      bossManager = BossManager();
      add(bossManager);
      bossTracker = BossTracker();
      add(bossTracker);
      powerUpManager = PowerUpManager();
      add(powerUpManager);
      powerUpTracker = PowerUpTracker();
      add(powerUpTracker);
      _coinManager = CoinManager();
      add(_coinManager);
      coinTracker = CoinTracker();
      add(coinTracker);

      // Register reference of Kiwi once to improve performance.
      enemyTracker.registerKiwi(_kiwi);
      bossTracker.registerKiwi(_kiwi);

      isAlreadyLoaded = true;
      add(transitionComponent);
    }
  }

  @override
  void onResize(Vector2 canvasSize) {
    super.onResize(canvasSize);

    // Loop over all the components of type KnowsGameSize and resize then as well.
    // Will be useful when playing on web version.
    this.components.whereType<GameSizeAware>().forEach((component) {
      component.onResize(this.size);
    });
  }

  @override
  void prepare(Component c) {
    super.prepare(c);

    // If the component being prepared is of type KnowsGameSize,
    // call onResize() on it so that it stores the current game screen size.
    if (c is GameSizeAware) {
      c.onResize(this.size);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  /// Controls are being detected here and propagates the updates to child
  /// components. Also tickers are being updated as the game progresses.
  @override
  void update(double dt) {
    super.update(dt);
    _kiwi.update(dt);
    _slowTimer.update(dt);
    _laserTimer.update(dt);
    hud.update(dt);

    if (_kiwi.hasLaser) {
      _laserBeam.position = _kiwi.position;
    }

    if (isTiltControls) {
      tiltMovement();
    }

    //check if a player beats her/his high score
    if (highScore != 0 && !isNotified && highScore < score) {
      isNotified = true;
      notification.sendNotification();
    }

    if (firstPlay) {
      //show tutorial slides
      this.pauseEngine();
      this.overlays.remove(PauseButton.ID);
      this.overlays.add(TutorialSlides.ID);
      firstPlay = !firstPlay;
    }
  }

  /// Slows the enemies speed as long as [_slowTimer] is running.
  void halfEnemySpeed() {
    if (!_isSlowed) {
      _slowTimer.start();
      enemyTracker.slowEnemies();
      _isSlowed = true;
    }
  }

  /// Restores the enemies speed when [_slowTimer] has stopped running.
  void _restoreEnemySpeed() {
    enemyTracker.restoreEnemy();
    _isSlowed = false;
  }

  /// Fires a laser beam when the powerup has been collected and [_laserTimer]
  /// is still running.
  void fireLaser() {
    _laserBeam = LaserBeam();
    add(_laserBeam);
    _laserBeam.anchor = Anchor.topCenter;
    _laserBeam.position = Vector2(55, 50);
    _kiwi.hasLaser = true;
    _laserTimer.start();
  }

  /// Remove the laser beam when [_laserTimer] has stopped.
  void removeLaser() {
    _kiwi.hasLaser = false;
    _laserBeam.remove();
  }

  /// Increment [score] by [scoreToAdd].
  void incrementScore(int scoreToAdd) {
    score += scoreToAdd;
  }

  /// Returns a reference to the kiwi.
  Kiwi getKiwi() => _kiwi;

  /// Controls what happens when the app state changes.
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!gameEnded) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
      case AppLifecycleState.inactive:
        if (!gameEnded) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
      case AppLifecycleState.paused:
        if (!gameEnded) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
      case AppLifecycleState.detached:
        if (gameEnded && score > 0) {
          localScoreDao.register(ScoreItem('user', score));
          remoteScoreDao.register();
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
          _kiwi.remove();
        }
        break;
    }
  }

  /// When restarting, it resets managers, timers and position of the kiwi.
  void reset() {
    // Resetting id counts.
    enemyManager.reset();
    powerUpManager.reset();
    bossManager.reset();
    _coinManager.reset();
    _kiwi.reset();

    // Clearing the entity list.
    bossTracker.reset();
    enemyTracker.reset();
    powerUpTracker.reset();
    coinTracker.reset();

    difficultyManager.reset();

    _laserTimer.stop();
    _slowTimer.stop();

    score = 0;
    coin = 0;
    isNotified = false;
    highScore = localScoreDao.getHighestScore();
    beatenBoss = 0;
    beatenEnemy = 0;
    usedItem = 0;

    components.whereType<Enemy>().forEach((enemy) {
      enemy.remove();
    });

    components.whereType<PowerUp>().forEach((powerUp) {
      powerUp.remove();
    });

    components.whereType<Coin>().forEach((coin) {
      coin.remove();
    });

    components.whereType<Boss>().forEach((boss) {
      boss.remove();
    });

    components.whereType<UfoBullet>().forEach((bullet) {
      bullet.remove();
    });

    components.whereType<WizardLightning>().forEach((lightning) {
      lightning.remove();
    });

    components.whereType<PrepLightning>().forEach((lightning) {
      lightning.remove();
    });
  }

  /// Used to apply movement using the [TiltMoveDirectional] enum from the
  /// [tiltDirectionalEvent] class. Inputs are taken from the
  /// [AccelerometerEvent] package.
  void tiltMovement() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      this.tiltXVelocity = event.x;
      this.tiltYVelocity = event.y;
    });

    TiltMoveDirectional tiltDirection = this
        .tiltDirectionalEvent
        .calculate(this.tiltXVelocity, this.tiltYVelocity);

    switch (tiltDirection) {
      case TiltMoveDirectional.moveUp:
        _kiwi.setMoveDirection(Vector2(0, -1));
        break;
      case TiltMoveDirectional.moveUpLeft:
        _kiwi.setMoveDirection(Vector2(-1, -1));
        break;
      case TiltMoveDirectional.moveUpRight:
        _kiwi.setMoveDirection(Vector2(1, -1));
        break;
      case TiltMoveDirectional.moveRight:
        _kiwi.setMoveDirection(Vector2(1, 0));
        break;
      case TiltMoveDirectional.moveDown:
        _kiwi.setMoveDirection(Vector2(0, 1));
        break;
      case TiltMoveDirectional.moveDownRight:
        _kiwi.setMoveDirection(Vector2(1, 1));
        break;
      case TiltMoveDirectional.moveDownLeft:
        _kiwi.setMoveDirection(Vector2(-1, 1));
        break;
      case TiltMoveDirectional.moveLeft:
        _kiwi.setMoveDirection(Vector2(-1, 0));
        break;
      case TiltMoveDirectional.idle:
        _kiwi.setMoveDirection(Vector2.zero());
        break;
    }
  }

  void startTransition() {
    add(transitionComponent);
  }
}
