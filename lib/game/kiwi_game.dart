import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/audio_manager_component.dart';
import 'package:flutter_game/game/components/coin/coin.dart';
import 'package:flutter_game/game/components/coin/coin_manager.dart';
import 'package:flutter_game/game/components/coin/coin_tracker.dart';
import 'package:flutter_game/game/components/controls/tilt_controls.dart';
import 'package:flutter_game/game/components/enemy/enemy_manager.dart';
import 'package:flutter_game/game/components/kiwi.dart';
import 'package:hive/hive.dart';

import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter_game/game/components/enemy/enemy.dart';
import 'package:flutter_game/game/components/powerup/component/laser_beam.dart';
import 'package:flutter_game/game/components/powerup/powerup_tracker.dart';
import 'package:flutter_game/game/components/powerup/powerup.dart';
import 'package:flutter_game/game/components/powerup/powerup_manager.dart';
import 'package:flutter_game/game/components/enemy/enemy_tracker.dart';
import 'package:flutter_game/game/components/ticker/info_ticker.dart';
import 'package:flutter_game/screens/dao/local_score_dao.dart';
import 'package:flutter_game/screens/dao/remote_score_dao.dart';
import 'package:flutter_game/screens/score_item.dart';
import 'components/tilt_config_component.dart';
import 'game_size_aware.dart';
import 'overlay/pause_button.dart';
import 'overlay/pause_menu.dart';

class KiwiGame extends BaseGame with HasCollidables, HasDraggableComponents {
  bool isAlreadyLoaded = false;
  bool _leftDirectionPressed = false;
  bool _rightDirectionPressed = false;
  bool _upDirectionPressed = false;
  bool _downDirectionPressed = false;
  bool gameEnded = false;
  bool _isSlowed = false;
  bool _isGodMode = false;

  bool isLocalScoreDaoLoaded = false;
  bool isRemoteScoreDaoLoaded = false;
  late LocalScoreDao localScoreDao;
  late RemoteScoreDao remoteScoreDao;

  bool isAudioManagerLoaded = false;
  bool isTiltConfigLoaded = false;
  TiltDirectionalEvent tiltDirectionalEvent = TiltDirectionalEvent();

  // These variables are to track multi-gesture taps.
  int _rightPointerId = -1;
  int _leftPointerId = -1;
  int _upPointerId = -1;
  int _downPointerId = -1;

  int score = 0;
  int coin = 0;

  late Kiwi _kiwi;

  late AudioManagerComponent audioManager;
  late Box configBox;

  late TiltConfig tiltConfigManager;
  late bool isTiltControls;
  double tiltXVelocity = 0.0;
  double tiltYVelocity = 0.0;

  late EnemyTracker enemyTracker;
  late EnemyManager _enemyManager;
  late PowerUpTracker powerUpTracker;
  late PowerUpManager _powerUpManager;
  late CoinManager _coinManager;
  late CoinTracker coinTracker;

  late TextComponent _scoreTicker;
  late TextComponent _coinTicker;
  late TextComponent _shieldTicker;
  late TextComponent _slowTicker;
  late TextComponent _laserTicker;

  late Timer _slowTimer;
  late Timer _laserTimer;

  late LaserBeam _laserBeam;

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
    }

    if (!isRemoteScoreDaoLoaded) {
      remoteScoreDao = RemoteScoreDao();
      isRemoteScoreDaoLoaded = true;
    }

    if (!isAudioManagerLoaded) {
      audioManager = AudioManagerComponent();
      add(audioManager);
      isAudioManagerLoaded = true;
    }

    configBox = await Hive.openBox("config");
    kiwiSkin = configBox.get("skin");

    _kiwi = Kiwi(
      sprite: await Sprite.load(kiwiSkin),
      size: Vector2(122, 76),
      position: Vector2(viewport.canvasSize.x / 2, viewport.canvasSize.y / 3),
    );
    _kiwi.anchor = Anchor.center;
    add(_kiwi);

    if (!isTiltConfigLoaded) {
      tiltConfigManager = TiltConfig();
      add(tiltConfigManager);
    }

    tiltConfigManager.fetchSettings();
    isTiltControls = tiltConfigManager.getConfig();

    audioManager.fetchSettings();
    audioManager.playBgm('background.mp3');

    if (!isAlreadyLoaded) {
      // final parallaxComponent = await loadParallaxComponent([
      //   //ParallaxImageData('pix_sky1.png'),
      //   ParallaxImageData('pixsky.png'),
      //   ParallaxImageData('po2.png'),
      //   ParallaxImageData('pixbg.png'),
      //   //ParallaxImageData('C02.png'),
      //   ParallaxImageData('po1.png'),
      //   ParallaxImageData('p03.png'),
      //   ParallaxImageData('po4.png'),
      //   //ParallaxImageData('birrd01.png'),
      //   //ParallaxImageData('birdnob.gif'),
      // ],
      //     baseVelocity: Vector2(0, 50),
      //     velocityMultiplierDelta: Vector2(1.8, 1.0),
      //     repeat: ImageRepeat.repeatY,
      //     fill: LayerFill.width);
      // add(parallaxComponent);

      _enemyManager = EnemyManager();
      add(_enemyManager);

      enemyTracker = EnemyTracker();
      add(enemyTracker);

      _powerUpManager = PowerUpManager();
      add(_powerUpManager);
      powerUpTracker = PowerUpTracker();
      add(powerUpTracker);
      _coinManager = CoinManager();
      add(_coinManager);
      coinTracker = CoinTracker();
      add(coinTracker);

      // Register reference of Kiwi once to improve performance.
      enemyTracker.registerKiwi(_kiwi);

      // Below are tickers that display information.
      _scoreTicker =
          InfoTicker(initialText: 'Score: 0', initialPos: Vector2(10, 10));

      _coinTicker =
          InfoTicker(initialText: 'Coins: 0', initialPos: Vector2(10, 25));

      _shieldTicker =
          InfoTicker(initialText: 'Shield: 0', initialPos: Vector2(10, 40));

      _slowTicker =
          InfoTicker(initialText: 'SlowTimer: 0', initialPos: Vector2(10, 55));

      _laserTicker =
          InfoTicker(initialText: 'LaserTimer: 0', initialPos: Vector2(10, 70));

      // Set the tickers to HUD components.
      _scoreTicker.isHud = true;
      add(_scoreTicker);
      _coinTicker.isHud = true;
      add(_coinTicker);
      _shieldTicker.isHud = true;
      add(_shieldTicker);
      _slowTicker.isHud = true;
      add(_slowTicker);
      _laserTicker.isHud = true;
      add(_laserTicker);

      final joystick = JoystickComponent(
        gameRef: this,
        directional: JoystickDirectional(
            size: 100, margin: EdgeInsets.only(left: 100, bottom: 100)),
      );

      //joystick.addObserver(_kiwi);
      //add(joystick);

      isAlreadyLoaded = true;
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

    if (_kiwi.hasLaser) {
      _laserBeam.position = _kiwi.position;
    }

    // if (isTiltControls) {
    tiltMovement();
    // }

    _scoreTicker.text = 'Score: ' + score.toString();
    _coinTicker.text = 'Coins: ' + coin.toString();
    _shieldTicker.text = 'Shield: ' + _kiwi.getShieldCount().toString();
    _slowTicker.text = 'Slow Timer: ' + _slowTimer.current.toString();
    _laserTicker.text = 'Laser Timer: ' + _laserTimer.current.toString();
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
    _enemyManager.reset();
    _powerUpManager.reset();
    _coinManager.reset();
    _kiwi.reset();

    // Clearing the entity list.
    enemyTracker.reset();
    powerUpTracker.reset();
    coinTracker.reset();

    _laserTimer.stop();
    _slowTimer.stop();

    score = 0;
    coin = 0;

    components.whereType<Enemy>().forEach((enemy) {
      enemy.remove();
    });

    components.whereType<PowerUp>().forEach((powerUp) {
      powerUp.remove();
    });

    components.whereType<Coin>().forEach((coin) {
      coin.remove();
    });
  }

  /// Used to check for tilt movement to move the Kiwi.
  void tiltMovement() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      this.tiltXVelocity = event.x;
      this.tiltYVelocity = event.y;
    });

    TiltMoveDirectional tiltDirection = this
        .tiltDirectionalEvent
        .calculate(this.tiltXVelocity, this.tiltYVelocity);

    print(
        "X: ${this.tiltXVelocity.toString()}, Y: ${this.tiltYVelocity.toString()}");
    print(tiltDirection);

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
}
