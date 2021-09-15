import 'package:flutter/material.dart';
import 'package:flutter_game/screens/Auth/google_auth.dart';

import 'Auth/auth_inf.dart';

class SettingScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _settingState();
}

class _settingState extends State<SettingScreen> {

  bool _musicMute = false;
  bool _sfxMute = false;
  bool _logedin = false;
  late AuthInf _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = new GoogleAuth();
    if (_auth.isSignedIn() == true) {
      _logedin = true;
    }
  }
  void _changeMusicState () {
    setState(() {
      _musicMute = !_musicMute;
    });
  }

  void _changeSfxState() {
    setState(() {
      _sfxMute = !_sfxMute;
    });
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
                          child: _musicMute ? Icon(IconData(59076, fontFamily: 'MaterialIcons'), size: 50) : Icon(IconData(0xe6c3, fontFamily: 'MaterialIcons'), size: 50),
                          onTap: _changeMusicState,
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
                        Text("sfx",style: TextStyle(fontSize: 30)),
                        new GestureDetector(
                          child: _sfxMute ? Icon(IconData(59076, fontFamily: 'MaterialIcons'), size: 50,) : Icon(IconData(0xe6c3, fontFamily: 'MaterialIcons'),size: 50),
                          onTap: _changeSfxState,
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
                        Text("Sign in", style: TextStyle(fontSize: 30),),
                        _logedin ? ElevatedButton(onPressed: _logout, child: Text("Sign out", style: TextStyle(fontSize: 20))) :  ElevatedButton(onPressed: _login, child: Text("Sign in with Google", style: TextStyle(fontSize: 20))),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () => {Navigator.of(context).pop()}, child: Text("Go back")),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }

}