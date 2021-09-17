import 'package:flutter/material.dart';
import 'package:flutter_game/screens/Auth/google_auth.dart';
import 'package:hive/hive.dart';
import 'Auth/auth_inf.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _settingState();
}

class _settingState extends State<SettingScreen> {
  late bool _isBgmMute;
  late bool _isSfxMute;
  late bool _isTiltOn;
  late Box _configBox;
  bool _logedin = false;
  late AuthInf _auth;

  @override
  void initState() {
    super.initState();
    //check login state
    _auth = new GoogleAuth();
    if (_auth.isSignedIn() == true) {
      _logedin = true;
    }

    //check user config
    _configBox = Hive.box("config");
    _isBgmMute = _configBox.get("isBgmMute");
    _isSfxMute = _configBox.get("isSfxMute");
    _isTiltOn = _configBox.get("isTiltOn");
  }

  void _changeTiltState() {
    setState(() {
      _isTiltOn = !_isTiltOn;
    });
  }

  void _updateTiltConfig() async {
    //update Tilt config in hive
    await _configBox.put("isTiltOn", !_isBgmMute);
    _changeTiltState();
  }

  void _changeMusicState() {
    setState(() {
      _isBgmMute = !_isBgmMute;
    });
  }

  void _upadteBGMConfig() async {
    //update BGM config in hive
    await _configBox.put("isBgmMute", !_isBgmMute);
    _changeMusicState();
  }

  void _changeSfxState() {
    setState(() {
      _isSfxMute = !_isSfxMute;
    });
  }

  void _upadteSfxConfig() async {
    //update SFX config in hive
    await _configBox.put("isSfxMute", !_isSfxMute);
    _changeSfxState();
  }

  void _login() {
    // await _auth.googleSignIn().then((value) => changeState());
    _auth.googleSignIn().then((value) => changeState());
  }

  void changeState() {
    setState(() {
      if (_auth.isSignedIn() == true) {
        _logedin = true;
      } else {
        _logedin = false;
      }
    });
  }

  void _logout() {
    _auth.googleSignOut().then((value) => changeState());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Center(
          child: Container(
        // color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              width: size.width * 0.9,
              height: 100,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("music", style: TextStyle(fontSize: 30)),
                    new GestureDetector(
                      child: _isBgmMute
                          ? Icon(IconData(0xe6c3, fontFamily: 'MaterialIcons'),
                              size: 50)
                          : Icon(IconData(59076, fontFamily: 'MaterialIcons'),
                              size: 50),
                      onTap: _upadteBGMConfig,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              height: 100,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("sfx", style: TextStyle(fontSize: 30)),
                    new GestureDetector(
                      child: _isSfxMute
                          ? Icon(
                              IconData(0xe6c3, fontFamily: 'MaterialIcons'),
                              size: 50,
                            )
                          : Icon(IconData(59076, fontFamily: 'MaterialIcons'),
                              size: 50),
                      onTap: _upadteSfxConfig,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              height: 100,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Tilt Controls", style: TextStyle(fontSize: 30)),
                    new GestureDetector(
                      child: _isTiltOn
                          ? Icon(
                              IconData(57687, fontFamily: 'MaterialIcons'),
                              size: 50,
                            )
                          : Icon(IconData(57688, fontFamily: 'MaterialIcons'),
                              size: 50),
                      onTap: _updateTiltConfig,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              height: 100,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign in",
                      style: TextStyle(fontSize: 30),
                    ),
                    _logedin
                        ? ElevatedButton(
                            onPressed: _logout,
                            child: Text("Sign out",
                                style: TextStyle(fontSize: 20)))
                        : ElevatedButton(
                            onPressed: _login,
                            child: Text("Sign in with Google",
                                style: TextStyle(fontSize: 20))),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("Go back")),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
